import MetalKit

final class ParticlesSystemsController: IParticlesSystemsController {
    private(set) var systems: [IParticlesSystem] = []
    private(set) var rules: [ParticalSystemGRule] = []

    func addRule(_ rule: ParticalSystemGRule) throws {
        guard
            systems.contains(where: { $0 === rule.system1 }) ||
            systems.contains(where: { $0 === rule.system2 })
        else {
            throw ParticlesSystemError.base("system not found")
        }
        rules.append(rule)
    }

    func removeRule(_ rule: ParticalSystemGRule) throws {
        guard
            rules.contains(where: { $0 === rule })
        else {
            throw ParticlesSystemError.base("rule not found")
        }
        rules.removeAll(where: { $0 === rule })
    }

    func addSystem(_ system: IParticlesSystem) throws {
        guard !systems.contains(where: { $0 === system }) else {
            throw ParticlesSystemError.base("system already added")
        }
        systems.append(system)
    }

    func removeSystem(_ system: IParticlesSystem) throws {
        guard systems.contains(where: { $0 === system }) else {
            throw ParticlesSystemError.base("system not found")
        }
        systems.removeAll(where: { $0 === system })
        rules.removeAll(where: { $0.system1 === system || $0.system2 === system })
    }
}


final class LoopController {
    var controller: IParticlesSystemsController?

    private let handler: ParticalSystemGPUHandler
    private let device: MTLDevice
    private let queue: MTLCommandQueue

    init() throws {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw GPUHandlerError.message("error get device")
        }
        guard let queue = device.makeCommandQueue() else {
            throw GPUHandlerError.message("error get queue")
        }
        self.device = device
        self.queue = queue
        self.handler = try .init(device: device)
    }

    func loop(
        in rect: ParticlesSystemRect,
        time: ParticlesSystemFloat,
        descriptor: MTLRenderPassDescriptor?,
        drawable: CAMetalDrawable?
    ) throws {
        guard let commandBuffer = queue.makeCommandBuffer() else {
            throw GPUHandlerError.message("not create command buffer")
        }
        guard let encoder = commandBuffer.makeComputeCommandEncoder() else {
            throw GPUHandlerError.message("not makeComputeCommandEncoder")
        }

        var openError: Error? = nil
        do {
            try calculate(in: rect, time: time, encoder: encoder)
        } catch {
            openError = error
        }
        encoder.endEncoding()

        do {
            try render(in: rect, commandBuffer: commandBuffer, descriptor: descriptor, drawable: drawable)
        } catch {
            openError = error
        }

        commandBuffer.commit()

        commandBuffer.waitUntilCompleted()

        if let error = openError {
            throw error
        }
    }

    private func render(
        in rect: ParticlesSystemRect,
        commandBuffer: MTLCommandBuffer,
        descriptor: MTLRenderPassDescriptor?,
        drawable: CAMetalDrawable?
    ) throws {
        guard
            let descriptor = descriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else
        {
            return
        }
        var openError: Error? = nil

        for system in controller?.systems ?? [] {
            do {
                try handler.render(
                    in: system.container,
                    model: .init(color: system.color.value),
                    size: rect.size,
                    encoder: renderEncoder
                )
            }
            catch {
                openError = error
            }
        }
        renderEncoder.endEncoding()

        drawable.flatMap { commandBuffer.present($0) }

        if let error = openError {
            throw error
        }
    }

    private func calculate(
        in rect: ParticlesSystemRect,
        time: ParticlesSystemFloat,
        encoder: MTLComputeCommandEncoder
    ) throws {
        for system in controller?.systems ?? [] {
            try handler.clearAccelerations(in: system.container, encoder: encoder)
        }
        for rule in controller?.rules ?? [] {
            try handler.runRule(
                rule: .init(g: rule.g, maxDistanse: rule.maxDistanse),
                changeable: rule.system1.container,
                target: rule.system2.container,
                time: time,
                encoder: encoder
            )
        }
        for system in controller?.systems ?? [] {
            try handler.applyAccelerations(
                in: system.container,
                model: .init(resistance: system.resistance),
                time: time,
                size: rect.size,
                encoder: encoder
            )
        }
    }
}

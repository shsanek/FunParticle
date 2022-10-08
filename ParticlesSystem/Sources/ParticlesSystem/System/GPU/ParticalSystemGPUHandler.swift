import MetalKit
import Foundation
import simd

final class ParticalSystemGPUHandler {
    let device: MTLDevice
    let defaultLibrary: MTLLibrary

    let clearAccelerationsPipeline: MTLComputePipelineState
    let runRulePipeline: MTLComputePipelineState
    let applyAccelerationsPipeline: MTLComputePipelineState

    let render: MetalRenderFunction

    init(device: MTLDevice) throws {
        let defaultLibrary = try device.makeDefaultLibrary(bundle: .module)

        self.clearAccelerationsPipeline = try Self.makeComputePipeline("clearAccelerations", device: device, defaultLibrary: defaultLibrary)
        self.runRulePipeline = try Self.makeComputePipeline("runRule", device: device, defaultLibrary: defaultLibrary)
        self.applyAccelerationsPipeline = try Self.makeComputePipeline("applyAccelerations", device: device, defaultLibrary: defaultLibrary)
        self.device = device
        self.defaultLibrary = defaultLibrary
        self.render = try MetalRenderFunction(
            device: device,
            function: .init(
                bundle: .module,
                vertexFunction: "particleVertexShader",
                fragmentFunction: "particleFragmentShader"
            )
        )
    }

    func clearAccelerations(
        in container: ParticalSystemContainer,
        encoder: MTLComputeCommandEncoder
    ) throws {
        guard container.particles.count > 0 else {
            return
        }
        encoder.setComputePipelineState(clearAccelerationsPipeline)

        encoder.setBuffer(try container.accelerations.getBuffer(with: device), offset: 0, index: 0)

        let gridSize = MTLSize(width: container.accelerations.count, height: 1, depth: 1)
        var threadGroupSize = clearAccelerationsPipeline.maxTotalThreadsPerThreadgroup
        if threadGroupSize > container.accelerations.count {
            threadGroupSize = container.accelerations.count
        }
        let threadgroupSize = MTLSize(width: threadGroupSize, height: 1, depth: 1)

        encoder.dispatchThreads(gridSize, threadsPerThreadgroup: threadgroupSize)
    }

    func runRule(
        rule: ParticleSystemRuleModel,
        changeable: ParticalSystemContainer,
        target: ParticalSystemContainer,
        time: ParticlesSystemFloat,
        encoder: MTLComputeCommandEncoder
    ) throws {
        guard changeable.particles.count > 0 else {
            return
        }
        encoder.setComputePipelineState(runRulePipeline)

        encoder.setBuffer(try changeable.particles.getBuffer(with: device), offset: 0, index: 0)
        encoder.setBuffer(try changeable.accelerations.getBuffer(with: device), offset: 0, index: 1)

        encoder.setBuffer(try target.particles.getBuffer(with: device), offset: 0, index: 2)

        var rule = rule
        encoder.setBytes(&rule, length: MemoryLayout<ParticleSystemRuleModel>.stride, index: 3)

        var time = time
        encoder.setBytes(&time, length: MemoryLayout<ParticlesSystemFloat>.stride, index: 4)

        var count = Int32(target.particles.count)
        encoder.setBytes(&count, length: MemoryLayout<Int32>.stride, index: 5)


        let gridSize = MTLSize(width: changeable.accelerations.count, height: 1, depth: 1)
        var threadGroupSize = clearAccelerationsPipeline.maxTotalThreadsPerThreadgroup
        if threadGroupSize > changeable.accelerations.count {
            threadGroupSize = changeable.accelerations.count
        }
        let threadgroupSize = MTLSize(width: threadGroupSize, height: 1, depth: 1)

        encoder.dispatchThreads(gridSize, threadsPerThreadgroup: threadgroupSize)
    }

    func applyAccelerations(
        in container: ParticalSystemContainer,
        model: ParticleSystemModel,
        time: ParticlesSystemFloat,
        size: ParticlesSystemSize,
        encoder: MTLComputeCommandEncoder
    ) throws {
        guard container.particles.count > 0 else {
            return
        }
        encoder.setComputePipelineState(applyAccelerationsPipeline)

        encoder.setBuffer(try container.particles.getBuffer(with: device), offset: 0, index: 0)
        encoder.setBuffer(try container.accelerations.getBuffer(with: device), offset: 0, index: 1)

        var model = model
        encoder.setBytes(&model, length: MemoryLayout<ParticleSystemModel>.stride, index: 2)

        var time = time
        encoder.setBytes(&time, length: MemoryLayout<ParticlesSystemFloat>.stride, index: 3)

        var size = size
        encoder.setBytes(&size, length: MemoryLayout<ParticlesSystemSize>.stride, index: 4)

        let gridSize = MTLSize(width: container.accelerations.count, height: 1, depth: 1)
        var threadGroupSize = clearAccelerationsPipeline.maxTotalThreadsPerThreadgroup
        if threadGroupSize > container.accelerations.count {
            threadGroupSize = container.accelerations.count
        }
        let threadgroupSize = MTLSize(width: threadGroupSize, height: 1, depth: 1)

        encoder.dispatchThreads(gridSize, threadsPerThreadgroup: threadgroupSize)
    }

    func render(
        in container: ParticalSystemContainer,
        model: ParticleSystemModel,
        size: ParticlesSystemSize,
        encoder: MTLRenderCommandEncoder
    ) throws {
        guard container.particles.count > 0 else {
            return
        }
        try render.start(encoder: encoder)

        var size = size
        encoder.setVertexBytes(&size, length: MemoryLayout<ParticlesSystemSize>.stride, index: 0)
        encoder.setVertexBuffer(try container.particles.getBuffer(with: device), offset: 0, index: 1)

        var scale: ParticlesSystemFloat = 3
        encoder.setVertexBytes(&scale, length: MemoryLayout<ParticlesSystemFloat>.stride, index: 2)

        var model = model
        encoder.setFragmentBytes(&model, length: MemoryLayout<ParticleSystemModel>.stride, index: 0)

        encoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: container.particles.count)
    }

    static func makeComputePipeline(_ name: String, device: MTLDevice, defaultLibrary: MTLLibrary) throws -> MTLComputePipelineState {
        guard let function = defaultLibrary.makeFunction(name: name) else {
            throw GPUHandlerError.message("not load function '\(name)'")
        }
        return try device.makeComputePipelineState(function: function)
    }
}

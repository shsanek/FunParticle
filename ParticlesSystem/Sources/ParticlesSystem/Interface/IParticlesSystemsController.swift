import MetalKit

protocol IParticlesSystemsController {
    var systems: [IParticlesSystem] { get }
    var rules: [ParticalSystemGRule] { get }

    func addRule(_ rule: ParticalSystemGRule) throws
    func removeRule(_ rule: ParticalSystemGRule) throws
    func addSystem(_ system: IParticlesSystem) throws
    func removeSystem(_ system: IParticlesSystem) throws
}

final class ParticlesSystemsControllerMock: IParticlesSystemsController {
    var systems: [IParticlesSystem] = []
    var rules: [ParticalSystemGRule] = []

    init() {}

    func addRule(_ rule: ParticalSystemGRule) throws { rules.append(rule) }
    func removeRule(_ rule: ParticalSystemGRule) throws { rules.removeAll(where: { $0 === rule })}
    func addSystem(_ system: IParticlesSystem) throws { systems.append(system) }
    func removeSystem(_ system: IParticlesSystem) throws { systems.removeAll(where: { $0 === system })}

    func loop(
        in rect: ParticlesSystemRect,
        time: ParticlesSystemFloat,
        descriptor: MTLRenderPassDescriptor?,
        drawable: CAMetalDrawable?
    ) throws {}
}

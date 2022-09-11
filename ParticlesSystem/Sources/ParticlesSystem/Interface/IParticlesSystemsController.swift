protocol IParticlesSystemsController {
    var systems: [IParticlesSystem] { get }
    var rules: [IParticalSystemRule] { get }

    func addRule(_ rule: IParticalSystemRule) throws
    func removeRule(_ rule: IParticalSystemRule) throws
    func addSystem(_ system: IParticlesSystem) throws
    func removeSystem(_ system: IParticlesSystem) throws

    func loop(in rect: ParticlesSystemRect, time: ParticlesSystemFloat)
}

final class ParticlesSystemsControllerMock: IParticlesSystemsController {
    var systems: [IParticlesSystem] = []
    var rules: [IParticalSystemRule] = []

    init() {}

    func addRule(_ rule: IParticalSystemRule) throws { rules.append(rule) }
    func removeRule(_ rule: IParticalSystemRule) throws { rules.removeAll(where: { $0 === rule })}
    func addSystem(_ system: IParticlesSystem) throws { systems.append(system) }
    func removeSystem(_ system: IParticlesSystem) throws { systems.removeAll(where: { $0 === system })}

    func loop(in rect: ParticlesSystemRect, time: ParticlesSystemFloat) {}
}

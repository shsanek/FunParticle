protocol IParticalSystemRule: AnyObject {
    var g: ParticlesSystemFloat { get set }
    var maxDistanse: ParticlesSystemFloat { get set }
    var system1: IParticlesSystem { get set }
    var system2: IParticlesSystem { get set }

    func calculateAcceleration(_ a: Particle, _ b: Particle) -> ParticlesSystemPoint
}

final class ParticalSystemRuleMock: IParticalSystemRule {
    var g: ParticlesSystemFloat = 1
    var maxDistanse: ParticlesSystemFloat = 60
    var system1: IParticlesSystem = ParticlesSystemMock()
    var system2: IParticlesSystem = ParticlesSystemMock()

    init() {}

    func calculateAcceleration(_ a: Particle, _ b: Particle) -> ParticlesSystemPoint { return .zero }
}

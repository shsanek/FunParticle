protocol IParticlesSystem: AnyObject {
    var color: Color { get set }
    var resistance: ParticlesSystemFloat { get set }

    var particles: [Particle] { get }

    func generate(in rect: ParticlesSystemRect, count: Int)
    func calculatePosition(in rect: ParticlesSystemRect, time: ParticlesSystemFloat)
}

final class ParticlesSystemMock: IParticlesSystem {
    var color: Color = .init(r: 0, g: 0, b: 0)
    var particles: [Particle] = []
    var resistance: ParticlesSystemFloat = 0

    init() { }

    func generate(in rect: ParticlesSystemRect, count: Int) { }
    func calculatePosition(in rect: ParticlesSystemRect, time: ParticlesSystemFloat) { }
}

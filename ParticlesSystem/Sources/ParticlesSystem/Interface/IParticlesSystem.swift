protocol IParticlesSystem: AnyObject {
    var color: Color { get set }
    var resistance: ParticlesSystemFloat { get set }
    var container: ParticalSystemContainer { get }

    func generate(in rect: ParticlesSystemRect, count: Int)
}

final class ParticlesSystemMock: IParticlesSystem {
    var color: Color = .init(r: 0, g: 0, b: 0)
    var resistance: ParticlesSystemFloat = 0

    var container: ParticalSystemContainer = .init()

    init() { }

    func generate(in rect: ParticlesSystemRect, count: Int) { }
}

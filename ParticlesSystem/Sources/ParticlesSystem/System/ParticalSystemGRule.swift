

final class ParticalSystemGRule: IParticalSystemRule {
    var system1: IParticlesSystem
    var system2: IParticlesSystem

    var g: ParticlesSystemFloat
    var maxDistanse: ParticlesSystemFloat = 60

    init(system1: IParticlesSystem, system2: IParticlesSystem, g: ParticlesSystemFloat) {
        self.system1 = system1
        self.system2 = system2
        self.g = g
    }

    func calculateAcceleration(_ a: Particle, _ b: Particle) -> ParticlesSystemPoint {
        let dx = a.position.x - b.position.x
        let dy = a.position.y - b.position.y
        let distance = ParticlesSystemPoint(x: dx, y: dy).distance
        guard distance > 0 && distance < maxDistanse else {
            return .zero
        }
        let f = g * (a.mass * b.mass) / (distance)
        return .init(x: dx * f, y: dy * f)
    }
}


import Foundation

final class ParticlesSystem: IParticlesSystem {
    var color: Color
    var resistance: ParticlesSystemFloat = 0

    let container = ParticalSystemContainer()

    private let speed1: ParticlesSystemFloat = 100
    private let speed2: ParticlesSystemFloat = 150

    init(color: Color) {
        self.color = color
    }

    func generate(in rect: ParticlesSystemRect, count: Int) {
        var particles = [ParticleModel]()
        for _ in 0..<count {
            var particle = ParticleModel()
            let shift: ParticlesSystemFloat = 1000
            particle.velocity = .zero
            particle.mass = 1
            particle.position.x = ParticlesSystemFloat.random(in: 0...rect.size.width * shift) / shift + rect.origin.x
            particle.position.y = ParticlesSystemFloat.random(in: 0...rect.size.height * shift) / shift + rect.origin.y
            particles.append(particle)
        }
        container.particles.values = particles
        container.accelerations.values = Array(repeating: .zero, count: count)
    }
}

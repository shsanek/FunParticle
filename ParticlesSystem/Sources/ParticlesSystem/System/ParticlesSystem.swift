
import Foundation

final class ParticlesSystem: IParticlesSystem {

    var color: Color
    var resistance: ParticlesSystemFloat = 0
    private(set) var particles: [Particle] = []

    private let speed1: ParticlesSystemFloat = 100
    private let speed2: ParticlesSystemFloat = 150

    init(color: Color) {
        self.color = color
    }

    func generate(in rect: ParticlesSystemRect, count: Int) {
        particles = []
        for _ in 0..<count {
            let particle = Particle()
            let shift: ParticlesSystemFloat = 1000
            particle.position.x = ParticlesSystemFloat.random(in: 0...rect.size.width * shift) / shift + rect.origin.x
            particle.position.y = ParticlesSystemFloat.random(in: 0...rect.size.height * shift) / shift + rect.origin.y
            particles.append(particle)
        }
    }

    func calculatePosition(in rect: ParticlesSystemRect, time: ParticlesSystemFloat) {
        for particle in particles {
            updateSpeed(particle, time: time)
            updatePosition(particle, in: rect, time: time)
        }
    }

    private func updatePosition(_ particle: Particle, in rect: ParticlesSystemRect, time: ParticlesSystemFloat) {
        var x = particle.position.x + (particle.velocity.x * time)
        if isOutrangeValue(x, max: rect.maxX, min: rect.minX) {
            x = normalizeValue(x, max: rect.maxX, min: rect.minX)
            particle.velocity.x *= -1
        }

        var y = particle.position.y + (particle.velocity.y * time)
        if isOutrangeValue(y, max: rect.maxY, min: rect.minY) {
            y = normalizeValue(y, max: rect.maxY, min: rect.minY)
            particle.velocity.y *= -1
        }

        particle.position.x = x
        particle.position.y = y
    }

    private func updateSpeed(_ particle: Particle, time: ParticlesSystemFloat) {
        let dv = particle.velocity.distance
        var delta: ParticlesSystemFloat = 1
        if dv > 0 {
            let dv2 = (dv * resistance) * time
            delta = (dv - dv2) / dv

            particle.velocity.x *= delta
            particle.velocity.y *= delta
        }
    }

    private func isOutrangeValue(_ value: ParticlesSystemFloat, max: ParticlesSystemFloat, min: ParticlesSystemFloat) -> Bool {
        value < min || value > max
    }

    private func normalizeValue(_ value: ParticlesSystemFloat, max: ParticlesSystemFloat, min: ParticlesSystemFloat) -> ParticlesSystemFloat {
        if value < min {
            return min + (min - value)
        }
        if value > max {
            return max - (value - max)
        }
        return value
    }
}

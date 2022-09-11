

final class ParticlesSystemsController: IParticlesSystemsController {
    private(set) var systems: [IParticlesSystem] = []
    private(set) var rules: [IParticalSystemRule] = []

    init() {
    }

    func addRule(_ rule: IParticalSystemRule) throws {
        guard
            systems.contains(where: { $0 === rule.system1 }) ||
            systems.contains(where: { $0 === rule.system2 })
        else {
            throw ParticlesSystemError.base("system not found")
        }
        rules.append(rule)
    }

    func removeRule(_ rule: IParticalSystemRule) throws {
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

    func loop(in rect: ParticlesSystemRect, time: ParticlesSystemFloat) {
        for rule in rules {
            for a in rule.system1.particles {
                for b in rule.system2.particles {
                    guard a !== b else {
                        continue
                    }
                    let acceleration = rule.calculateAcceleration(a, b)
                    a.velocity.x += acceleration.x * time
                    a.velocity.y += acceleration.y * time
                }
            }
        }

        for system in systems {
            system.calculatePosition(in: rect, time: time)
        }
    }
}


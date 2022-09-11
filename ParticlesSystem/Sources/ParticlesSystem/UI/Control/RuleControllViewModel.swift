import Combine
import SwiftUI


final class RuleControllViewModel: Identifiable, ObservableObject {
    var id: ObjectIdentifier {
        ObjectIdentifier(rule)
    }

    @Published var value: CGFloat {
        didSet {
            rule.g = value
        }
    }

    @Published var max: CGFloat {
        didSet {
            rule.maxDistanse = max
        }
    }

    @Published var system1Container: Container {
        didSet {
            rule.system1 = system1Container.system
        }
    }
    @Published var system2Container: Container {
        didSet {
            rule.system2 = system2Container.system
        }
    }

    @Published var systems: [Container] = []

    let rule: IParticalSystemRule
    private let removeHandler: () -> Void
    private let nameManager: NameManger
    private var cancellables: [AnyCancellable] = []
    private var controller: IParticlesSystemsController

    init(rule: IParticalSystemRule, nameManager: NameManger, controller: IParticlesSystemsController, removeHandler: @escaping () -> Void) {
        self.rule = rule
        self.nameManager = nameManager
        self.removeHandler = removeHandler
        self.controller = controller
        self.value = rule.g
        self.max = rule.maxDistanse
        self.system1Container = .init(name: "", system: rule.system1)
        self.system2Container = .init(name: "", system: rule.system2)
        update()
    }

    func removeRule() {
        removeHandler()
    }

    func update() {
        cancellables.forEach { $0.cancel() }
        cancellables = []
        var systems: [Container] = []
        for system in controller.systems {
            systems.append(.init(name: "", system: system))
        }
        self.systems = systems
        for container in controller.systems.enumerated() {
            nameManager.getName(for: container.element).sink { [weak self] text in
                self?.systems[container.offset].name = text ?? ""
            }.store(in: &cancellables)
            if container.element === rule.system1 {
                system1Container = self.systems[container.offset]
            }
            if container.element === rule.system2 {
                system2Container = self.systems[container.offset]
            }
        }
    }
}


final class Container: Hashable, Identifiable {
    var id: ObjectIdentifier {
        ObjectIdentifier(system)
    }

    var name: String
    let system: IParticlesSystem

    init(name: String, system: IParticlesSystem) {
        self.name = name
        self.system = system
    }

    static func == (lhs: Container, rhs: Container) -> Bool {
        lhs.system === rhs.system
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(system))
    }
}

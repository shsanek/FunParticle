import Combine
import SwiftUI

final class ControllPanelViewModel: ObservableObject {
    @Published var ruleViewModels: [RuleControllViewModel] = []
    @Published var systemViewModels: [SystemControllViewModel] = []

    private let controller: IParticlesSystemsController
    private let nameManger: NameManger
    private let sizeManager: SizeManger

    init(
        controller: IParticlesSystemsController,
        nameManger: NameManger,
        sizeManager: SizeManger
    ) {
        self.controller = controller
        self.nameManger = nameManger
        self.sizeManager = sizeManager
    }

    func addRule() {
        guard let system = controller.systems.first else { return }
        let rule = ParticalSystemGRule(
            system1: system,
            system2: system,
            g: 0
        )
        try? controller.addRule(rule)
        let vm = RuleControllViewModel(
            rule: rule,
            nameManager: nameManger,
            controller: controller
        ) { [weak self] in
            self?.ruleViewModels.removeAll(where: { $0.rule === rule })
            try? self?.controller.removeRule(rule)
        }
        ruleViewModels.append(vm)
    }

    func addSystem() {
        let system = ParticlesSystem(color: .init(r: 255, g: 0, b: 0))
        try? controller.addSystem(system)
        nameManger.setName(nameManger.nextSystemName(), for: system)
        let vm = SystemControllViewModel(
            system: system,
            nameManager: nameManger,
            sizeManger: sizeManager
        ) { [weak self] in
            self?.ruleViewModels.removeAll(where: {
                $0.rule.system1 === system || $0.rule.system2 === system
            })
            self?.systemViewModels.removeAll(where: {
                $0.system === system
            })
            try? self?.controller.removeSystem(system)
            self?.ruleViewModels.forEach { $0.update() }
        }
        systemViewModels.append(vm)
        self.ruleViewModels.forEach { $0.update() }
    }
}

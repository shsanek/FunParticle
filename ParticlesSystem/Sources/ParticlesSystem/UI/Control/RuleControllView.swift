import SwiftUI


struct RuleControllView: View {
    @ObservedObject var viewModel: RuleControllViewModel

    init(viewModel: RuleControllViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Spacer(minLength: 10)
            VStack {
                Spacer().frame(height: 4)
                HStack {
                    VStack {
                        HStack {
                            Picker("", selection: $viewModel.system1Container) {
                                ForEach($viewModel.systems) { container in
                                    Text(container.name.wrappedValue)
                                        .tag(container.wrappedValue)
                                }
                            }
                            Spacer()
                        }
                        HStack {
                            Picker("", selection: $viewModel.system2Container) {
                                ForEach($viewModel.systems) { container in
                                    Text(container.name.wrappedValue)
                                        .tag(container.wrappedValue)
                                }
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                    VStack {
                        Button {
                            viewModel.removeRule()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
                Slider(
                    value: $viewModel.value,
                    in: -10...10,
                    onEditingChanged: { _ in }
                )
                Slider(
                    value: $viewModel.max,
                    in: 0...1000,
                    onEditingChanged: { _ in }
                )
                HStack {
                    Text("\(viewModel.value)")
                    Spacer()
                    Text("\(viewModel.max)")
                }
                Spacer().frame(height: 4)
            }
            Spacer(minLength: 10)
        }
    }
}

struct RuleControllView_Previews: PreviewProvider {
    static var previews: some View {
        let rule = ParticalSystemRuleMock()
        let nameManager = NameManger()
        nameManager.setName("System1", for: rule.system1)
        nameManager.setName("System2", for: rule.system2)
        let controller = ParticlesSystemsControllerMock()
        try? controller.addSystem(rule.system1)
        try? controller.addSystem(rule.system2)
        let viewModel = RuleControllViewModel(
            rule: rule,
            nameManager: nameManager,
            controller: controller,
            removeHandler: { }
        )
        return RuleControllView(viewModel: viewModel)
    }
}

import SwiftUI

struct ControllPanelView: View {
    @ObservedObject var viewModel: ControllPanelViewModel

    var body: some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 8)
                HStack {
                    Text("System:")
                    Spacer()
                }
                ForEach($viewModel.systemViewModels) {
                    SystemControllView(viewModel: $0.wrappedValue)
                }
                Button {
                    viewModel.addSystem()
                } label: {
                    Image(systemName: "plus.circle")
                }
                Divider()
                HStack {
                    Text("Rule:")
                    Spacer()
                }
                ForEach($viewModel.ruleViewModels) {
                    RuleControllView(viewModel: $0.wrappedValue)
                }
                Button {
                    viewModel.addRule()
                } label: {
                    Image(systemName: "minus.plus.batteryblock")
                }
                Spacer().frame(height: 8)
            }
        }
    }

    init(viewModel: ControllPanelViewModel) {
        self.viewModel = viewModel
    }
}


struct ControllPanelView_Previews: PreviewProvider {
    static var previews: some View {
        let nameManager = NameManger()
        let sizeManager = SizeManger()
        let controller = try! ParticlesSystemsController()
        let vm = ControllPanelViewModel(
            controller: controller,
            nameManger: nameManager,
            sizeManager: sizeManager
        )
        return ControllPanelView(viewModel: vm)
    }
}

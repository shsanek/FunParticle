import SwiftUI


struct SystemControllView: View {
    @ObservedObject var viewModel: SystemControllViewModel

    @State var value: CGFloat

    init(viewModel: SystemControllViewModel) {
        self.viewModel = viewModel
        self.value = CGFloat(viewModel.count)
    }

    var body: some View {
        HStack {
            Spacer(minLength: 10)
            VStack {
                Spacer().frame(height: 4)
                HStack {
                    VStack {
                        HStack {
                            TextField(
                                "name",
                                text: $viewModel.systemName
                            )
                            Spacer()
                        }
                        HStack {
                            TextField(
                                "color",
                                text: $viewModel.colorHex
                            )
                            Spacer()
                        }
                    }
                    Spacer()
                    Button {
                        viewModel.removeSystem()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
                Slider(
                    value: $value,
                    in: 0...1000,
                    onEditingChanged: { editing in
                        if !editing {
                            viewModel.count = Int(value)
                        }
                    }
                )
                Slider(
                    value: $viewModel.resistance,
                    in: 0...0.5,
                    onEditingChanged: { _ in }
                )
                HStack {
                    Text("\(Int(self.value))")
                    Spacer()
                    Text("\(viewModel.resistance)")
                }
                Spacer().frame(height: 4)
            }
            Spacer(minLength: 10)
        }
    }
}

struct SystemControllView_Previews: PreviewProvider {
    static var previews: some View {
        let system = ParticlesSystemMock()
        let nameManager = NameManger()
        nameManager.setName("System1", for: system)
        let viewModel = SystemControllViewModel(
            system: system,
            nameManager: nameManager,
            sizeManger: SizeManger(),
            removeHandler: { }
        )
        return SystemControllView(viewModel: viewModel)
    }
} 

import SwiftUI

public struct MainView: View {
    private let dependency: Dependency

    private let particlesSystemViewModel: ParticlesSystemViewModel
    private let controllPanelViewModel: ControllPanelViewModel

    public init(dependency: Dependency) {
        self.dependency = dependency
        self.particlesSystemViewModel = ParticlesSystemViewModel(
            controller: dependency.controller,
            sizeManager: dependency.sizeManager
        )
        self.controllPanelViewModel = ControllPanelViewModel(
            controller: dependency.controller,
            nameManger: dependency.nameManager,
            sizeManager: dependency.sizeManager
        )
    }

    public var body: some View {
        GeometryReader { (geometry) in
            self.makeView(geometry)
        }
        .frame(minWidth: 300, minHeight: 300)
    }

    func makeView(_ geometry: GeometryProxy) -> some View {
        Group {
            if geometry.size.width > geometry.size.height * 1.3 {
                HStack {
                    ParticlesSystemView(
                        viewModel: self.particlesSystemViewModel
                    )
                    ControllPanelView(
                        viewModel: self.controllPanelViewModel
                    )
                    .frame(maxWidth: 300)
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    ParticlesSystemView(
                        viewModel: self.particlesSystemViewModel
                    )
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    ControllPanelView(
                        viewModel: self.controllPanelViewModel
                    )
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        return MainView(dependency: try! Dependency())
    }
}

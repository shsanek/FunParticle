import SwiftUI

struct ParticlesSystemView: View {
    let viewModel: ParticlesSystemViewModel

    var body: some View {
        GeometryReader { (geometry) in
            self.makeView(geometry)
        }
    }

    init(viewModel: ParticlesSystemViewModel) {
        self.viewModel = viewModel
    }

    func makeView(_ geometry: GeometryProxy) -> some View {
        viewModel.update(with: geometry.size)
        return ParticlesSystemContentView(viewModel: viewModel)
    }
}

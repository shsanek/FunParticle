import SwiftUI

struct ParticlesSystemView: View {
    let viewModel: ParticlesSystemViewModel

    var body: some View {
        SwiftUIView {
            viewModel.metalView
        }
    }

    init(viewModel: ParticlesSystemViewModel) {
        self.viewModel = viewModel
    }
}

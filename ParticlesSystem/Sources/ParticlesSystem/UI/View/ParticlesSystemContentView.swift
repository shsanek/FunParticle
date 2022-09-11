import SwiftUI

struct ParticlesSystemContentView: View {

    @ObservedObject var viewModel: ParticlesSystemViewModel

    var body: some View {
        ZStack {
            Group {
                if let image = viewModel.image {
                    Image(decorative: image, scale: 1)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("\(viewModel.fps)")
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer()
                Slider(value: $viewModel.step, in: 0.01...4, onEditingChanged: { _ in } )
            }
        }
    }
}

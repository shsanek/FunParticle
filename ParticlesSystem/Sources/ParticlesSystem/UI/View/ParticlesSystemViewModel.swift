import SwiftUI
import MetalKit

final class ParticlesSystemViewModel: ObservableObject {
    let metalView = MetalView()

    private let controller: IParticlesSystemsController
    private let sizeManager: SizeManger
    private var size: CGSize? = nil

    init(controller: IParticlesSystemsController, sizeManager: SizeManger) {
        self.controller = controller
        self.sizeManager = sizeManager

        self.metalView.controller?.controller = controller
        self.metalView.viewModel = self
    }

    func update(with size: CGSize) {
        self.sizeManager.updateSize(size)
        guard size != self.size else { return }
        self.size = size
    }
}

import SwiftUI


final class ParticlesSystemViewModel: ObservableObject {
    @Published private(set) var image: CGImage?
    @Published var step: CGFloat = 1
    var fps: CGFloat {
        fpsCalculator.fps
    }

    private let controller: IParticlesSystemsController
    private let render = ParticlesSystemRender()
    private var size: CGSize = .init(width: 100, height: 100)
    private var timer: Timer? = nil
    private var lastTime: CFTimeInterval
    private let fpsCalculator = FPSCalculator()
    private let sizeManager: SizeManger

    init(controller: IParticlesSystemsController, sizeManager: SizeManger) {
        self.controller = controller
        self.lastTime = CACurrentMediaTime()
        self.sizeManager = sizeManager
        start()
    }

    func update(with size: CGSize) {
        self.sizeManager.updateSize(size)
        guard size != self.size else { return }
        self.size = size
    }

    private func start() {
        fpsCalculator.restart()
        lastTime = CACurrentMediaTime()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.loop()
        }
    }

    private func loop() {
        let time = CACurrentMediaTime()
        //let delta = time - lastTime
        lastTime = time
        controller.loop(
            in: .init(origin: .zero, size: size),
            time: step
        )
        image = render.getImage(
            size: size,
            scale: 0.5,
            particlesSystemsController: controller
        )
        fpsCalculator.tick()
    }
}

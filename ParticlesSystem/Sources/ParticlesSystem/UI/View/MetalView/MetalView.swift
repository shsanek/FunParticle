import MetalKit

#if canImport(UIKit)
import UIKit

class MetalView: MTKView, MTKViewDelegate {

    var controller: LoopController?
    weak var viewModel: ParticlesSystemViewModel?

    private var size: CGSize = .init(width: 100, height: 100)
    private var lastTime: Double? = nil

    public init() {
        super.init(frame: .zero, device: MTLCreateSystemDefaultDevice())

        self.controller = try? LoopController()

        colorPixelFormat = .bgra8Unorm_srgb
        depthStencilPixelFormat = .depth32Float
        clearDepth = 1
        self.delegate = self
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.size = size
        viewModel?.update(with: size)
    }

    func draw(in view: MTKView) {
        do {
            let time = CACurrentMediaTime()
            let delta = lastTime.flatMap { time - $0 } ?? 0
            lastTime = time
            let size = ParticlesSystemSize(width: ParticlesSystemFloat(size.width), height: ParticlesSystemFloat(size.height))
            guard
                let descriptor = view.currentRenderPassDescriptor,
                let drawable = view.currentDrawable
            else {
                return
            }
            try controller?.loop(
                in: .init(origin: .zero, size: size),
                time: ParticlesSystemFloat(min(delta, 1.0 / 15.0)),
                descriptor: descriptor,
                drawable: drawable
            )
        }
        catch {
            assertionFailure("\(error)")
        }
    }
}

#endif

#if canImport(Cocoa)
import Cocoa

class MetalView: MTKView, MTKViewDelegate {

    var controller: LoopController?
    weak var viewModel: ParticlesSystemViewModel?

    private var size: CGSize = .init(width: 100, height: 100)
    private var lastTime: Double? = nil

    init() {
        super.init(frame: .zero, device: MTLCreateSystemDefaultDevice())

        self.controller = try? LoopController()

        colorPixelFormat = .bgra8Unorm_srgb
        depthStencilPixelFormat = .depth32Float
        clearDepth = 1
        self.delegate = self
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.size = size
        viewModel?.update(with: size)
    }

    func draw(in view: MTKView) {
        do {
            let time = CACurrentMediaTime()
            let delta = lastTime.flatMap { time - $0 } ?? 0
            lastTime = time
            let size = ParticlesSystemSize(width: ParticlesSystemFloat(size.width), height: ParticlesSystemFloat(size.height))
            guard
                let descriptor = view.currentRenderPassDescriptor,
                let drawable = view.currentDrawable
            else {
                return
            }
            try controller?.loop(
                in: .init(origin: .zero, size: size),
                time: ParticlesSystemFloat(min(delta, 1.0 / 15.0)),
                descriptor: descriptor,
                drawable: drawable
            )
        }
        catch {
            assertionFailure("\(error)")
        }
    }
}
#endif


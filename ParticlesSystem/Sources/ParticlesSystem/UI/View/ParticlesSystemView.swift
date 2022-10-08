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


import MetalKit

#if canImport(UIKit)
import UIKit

public class MetalView: MTKView, MTKViewDelegate {

    public let controller: LoopController
    private var size: CGSize = .init(width: 100, height: 100)
    private var lastTime: Double? = nil

    public init() {
        super.init(frame: .zero, device: MTLCreateSystemDefaultDevice())
        guard let defaultDevice = device else {
            fatalError("Device loading error")
        }
        self.controller = try LoopController()
        colorPixelFormat = .bgra8Unorm_srgb
        depthStencilPixelFormat = .depth32Float
        clearDepth = 1
        self.delegate = self
    }

    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.size = size
    }

    public func draw(in view: MTKView) {
        do {
            let time = CACurrentMediaTime()
            let delta = lastTime.flatMap { time - $0 } ?? 0
            lastTime = time
            let size = Size(width: GEFloat(size.width), height: GEFloat(size.height))
            try controller?.loop(screenSize: size, time: time)
            guard
                let descriptor = view.currentRenderPassDescriptor,
                let drawable = view.currentDrawable
            else {
                return
            }
            try controller?.metalRender(descriptor: descriptor, drawable: drawable, size: size)
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

    public init() {
        super.init(frame: .zero, device: MTLCreateSystemDefaultDevice())

        self.controller = try? LoopController()

        colorPixelFormat = .bgra8Unorm_srgb
        depthStencilPixelFormat = .depth32Float
        clearDepth = 1
        self.delegate = self
    }

    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.size = size
        viewModel?.update(with: size)
    }

    public func draw(in view: MTKView) {
        do {
            let time = CACurrentMediaTime()
            let size = ParticlesSystemSize(width: ParticlesSystemFloat(size.width), height: ParticlesSystemFloat(size.height))
            guard
                let descriptor = view.currentRenderPassDescriptor,
                let drawable = view.currentDrawable
            else {
                return
            }
            try controller?.loop(
                in: .init(origin: .zero, size: size),
                time: 1,
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

import SwiftUI

#if canImport(UIKit)
import UIKit

@available(iOS 13.0, *)
public struct SwiftUIView: UIViewRepresentable {
    public var wrappedView: UIView

    private var handleUpdateUIView: ((UIView, Context) -> Void)?
    private var handleMakeUIView: ((Context) -> UIView)?

    public init(closure: () -> UIView) {
        wrappedView = closure()
    }

    public func makeUIView(context: Context) -> UIView {
        guard let handler = handleMakeUIView else {
            return wrappedView
        }

        return handler(context)
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        handleUpdateUIView?(uiView, context)
    }
}

@available(iOS 13.0, *)
public extension SwiftUIView {
    mutating func setMakeUIView(handler: @escaping (Context) -> UIView) -> Self {
        handleMakeUIView = handler
        return self
    }

    mutating func setUpdateUIView(handler: @escaping (UIView, Context) -> Void) -> Self {
        handleUpdateUIView = handler
        return self
    }
}

#endif


#if canImport(Cocoa)
import Cocoa

public struct SwiftUIView: NSViewRepresentable {
    public var wrappedView: NSView

    private var handleUpdateUIView: ((NSView, Context) -> Void)?
    private var handleMakeUIView: ((Context) -> NSView)?

    public init(closure: () -> NSView) {
        wrappedView = closure()
    }

    public func makeNSView(context: Context) -> NSView {
        guard let handler = handleMakeUIView else {
            return wrappedView
        }

        return handler(context)
    }

    public func updateNSView(_ uiView: NSView, context: Context) {
        handleUpdateUIView?(uiView, context)
    }
}

public extension SwiftUIView {
    mutating func setMakeUIView(handler: @escaping (Context) -> NSView) -> Self {
        handleMakeUIView = handler
        return self
    }

    mutating func setUpdateUIView(handler: @escaping (NSView, Context) -> Void) -> Self {
        handleUpdateUIView = handler
        return self
    }
}

#endif

import MetalKit
import Foundation
import simd

final class MetalRenderFunction {
    private let device: MTLDevice
    private let renderState: MTLRenderPipelineState

    init(
        device: MTLDevice,
        function: MetalRenderFunctionName,
        pixelFormat: MTLPixelFormat = .bgra8Unorm_srgb
    ) throws {
        self.device = device
        let library = try device.makeDefaultLibrary(bundle: .module)

        guard let vertexFunction = library.makeFunction(name: function.vertexFunction) else {
            throw GPUHandlerError.message("error load Vertex Function")
        }
        guard let fragmentFunction = library.makeFunction(name: function.fragmentFunction) else {
            throw GPUHandlerError.message("error load Fragment Function")
        }
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = function.name
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.fragmentFunction = fragmentFunction
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float

        renderState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }

    func start(
        encoder: MTLRenderCommandEncoder
    ) throws {
        encoder.setRenderPipelineState(renderState)
    }
}


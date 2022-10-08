import MetalKit
import Foundation
import simd

struct MetalRenderFunctionName: Hashable {
    let bundle: Bundle
    let vertexFunction: String
    let fragmentFunction: String

    var name: String {
        return "\(bundle).\(vertexFunction).\(fragmentFunction)"
    }

    init(
        bundle: Bundle = .module,
        vertexFunction: String,
        fragmentFunction: String
    ) {
        self.bundle = bundle
        self.vertexFunction = vertexFunction
        self.fragmentFunction = fragmentFunction
    }
}

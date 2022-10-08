import simd
import MetalKit
import Foundation

struct ParticleModel: RawEncodable {
    var mass: ParticlesSystemFloat = 1
    var position: vector_float2 = .zero
    var velocity: vector_float2 = .zero
}

struct ParticleSystemModel: RawEncodable {
    var resistance: ParticlesSystemFloat = 0
    var color: vector_float4 = .zero
}

struct ParticleSystemRuleModel: RawEncodable {
    var g: ParticlesSystemFloat = 0
    var maxDistanse: ParticlesSystemFloat = 0
}


struct ParticalSystemContainer {
    let particles = BufferContainer<ParticleModel>()
    let accelerations = BufferContainer<vector_float2>()
}

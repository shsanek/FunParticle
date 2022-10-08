struct Color {
    let r: UInt8
    let g: UInt8
    let b: UInt8

    init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }

    init(value: UInt32) {
        self.r = UInt8(value & 0xff)
        self.g = UInt8(value >> 8 & 0xff)
        self.b = UInt8(value >> 16 & 0xff)
    }

    var uint: UInt32 {
        let color: UInt32 = 0xff000000
        let r = UInt32(r)
        let g = UInt32(g) << 8
        let b = UInt32(b) << 16
        return color | r | g | b
    }
}

import simd

extension Color {
    var value: vector_float4 {
        let r = Float32(r) / 256
        let g = Float32(g) / 256
        let b = Float32(b) / 256
        return .init(r, g, b, 1)
    }
}

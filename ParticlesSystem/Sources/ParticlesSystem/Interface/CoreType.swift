import CoreGraphics


typealias ParticlesSystemFloat = Float32

struct ParticlesSystemSize: RawEncodable {
    var width: ParticlesSystemFloat
    var height: ParticlesSystemFloat
}

struct ParticlesSystemRect: RawEncodable {
    var origin: ParticlesSystemPoint
    var size: ParticlesSystemSize
}

struct ParticlesSystemPoint: RawEncodable {
    var x: ParticlesSystemFloat
    var y: ParticlesSystemFloat
}


extension ParticlesSystemPoint {
    static var zero: ParticlesSystemPoint {
        .init(x: 0, y: 0)
    }
}

extension CGSize {
    var psSize: ParticlesSystemSize {
        .init(
            width: ParticlesSystemFloat(width),
            height: ParticlesSystemFloat(height)
        )
    }
}

extension ParticlesSystemRect {
    var maxX: ParticlesSystemFloat {
        max(origin.x, origin.x + size.width)
    }

    var minX: ParticlesSystemFloat {
        min(origin.x, origin.x + size.width)
    }

    var maxY: ParticlesSystemFloat {
        max(origin.y, origin.y + size.height)
    }

    var minY: ParticlesSystemFloat {
        min(origin.y, origin.y + size.height)
    }
}

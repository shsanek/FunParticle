
import CoreGraphics

final class ParticlesSystemRender {
    private var size: CGSize = .init(width: 100, height: 100)
    private var scale: CGFloat = 1
    private var renderSize: CGSize = .init(width: 100, height: 100)

    private var context: CGContext? = nil
    private var data: [UInt32] = []

    func getImage(
        size: CGSize,
        scale: CGFloat,
        particlesSystemsController: IParticlesSystemsController
    ) -> CGImage? {
        self.size = size
        self.scale = scale
        let height = Int(size.height * scale)
        let widht = Int(size.width * scale)
        let newRenderSize = CGSize(width: widht, height: height)
        if newRenderSize != renderSize {
            self.context = nil
        }
        guard let context = getContext(), data.count > 0 else {
            return nil
        }
        let count = data.count
        context.setFillColor(CGColor(red: 0, green: 0, blue: 0, alpha: 1))
        context.fill([.init(origin: .zero, size: renderSize)])

        for system in particlesSystemsController.systems {
            let color = system.color.uint
            for particle in system.container.particles.values {
                let position = Int(particle.position.y * ParticlesSystemFloat(scale)) * widht + Int(particle.position.x * ParticlesSystemFloat(scale))
                if position > 0 {
                    data[position % count] = color
                }
            }
        }

        return context.makeImage()
    }

    private func getContext() -> CGContext? {
        if let context = context {
            return context
        }

        let height = Int(size.height * scale)
        let widht = Int(size.width * scale)

        let pixelCount = widht * height
        data = Array(repeating: 0xff000000, count: pixelCount)
        let mutBufPtr = UnsafeMutableBufferPointer(start: &data, count: pixelCount)

        renderSize = .init(width: widht, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let bitmapInfo =
            CGBitmapInfo.byteOrder32Big.rawValue |
            CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue

        let context = CGContext(
            data: mutBufPtr.baseAddress,
            width: widht,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: widht * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        )
        self.context = context
        return context
    }
}

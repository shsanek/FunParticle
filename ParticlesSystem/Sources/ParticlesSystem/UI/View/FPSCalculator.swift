import SwiftUI

final class FPSCalculator {
    var fps: CGFloat = 0

    private var container: [CGFloat] = []
    private var lastTime = CACurrentMediaTime()
    private let max: Int = 5

    func restart() {
        container = []
        fps = 0
    }

    @discardableResult
    func tick() -> CGFloat {
        let time = CACurrentMediaTime()
        let delta = time - lastTime
        lastTime = time
        container.append(delta)
        while container.count > max {
            container.removeFirst()
        }
        let avgDelta = container.reduce(0, { $0 + $1 }) / CGFloat(container.count)
        fps = 1.0 / avgDelta
        return fps
    }
}


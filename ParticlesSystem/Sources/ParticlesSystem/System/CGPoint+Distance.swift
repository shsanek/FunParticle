
import Foundation

extension ParticlesSystemPoint {
    var sqrDistance: ParticlesSystemFloat {
        x * x + y * y
    }

    var distance: ParticlesSystemFloat {
        sqrt(sqrDistance)
    }
}

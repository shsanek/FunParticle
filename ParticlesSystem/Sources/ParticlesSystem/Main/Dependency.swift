import MetalKit

public final class Dependency {
    let nameManager = NameManger()
    let sizeManager = SizeManger()
    let controller: IParticlesSystemsController


    public init() throws {
        self.controller = try ParticlesSystemsController()
    }
}

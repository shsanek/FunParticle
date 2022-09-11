public struct Dependency {
    let nameManager = NameManger()
    let sizeManager = SizeManger()
    let controller: IParticlesSystemsController = ParticlesSystemsController()

    public init() {}
}

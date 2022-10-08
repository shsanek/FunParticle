import Combine
import SwiftUI


final class SystemControllViewModel: Identifiable, ObservableObject {
    var id: ObjectIdentifier {
        ObjectIdentifier(system)
    }

    var count: Int {
        didSet {
            generate()
        }
    }

    @Published var resistance: CGFloat = 0 {
        didSet {
            system.resistance = ParticlesSystemFloat(resistance)
        }
    }
    @Published var systemName: String = "" {
        didSet {
            guard systemName != oldValue else { return }
            nameManager.setName(systemName, for: system)
        }
    }

    @Published var colorHex: String = "" {
        didSet {
            guard colorHex != oldValue else { return }
            let approveChars: [String] = "0123456789abcdef".map { "\($0)" }
            let value = colorHex.lowercased().map { "\($0)" }.filter { approveChars.contains($0) }.joined()
            guard colorHex == value else {
                colorHex = value
                return
            }
            guard let value = UInt32("ff" + colorHex.prefix(6).lowercased(), radix: 16) else {
                colorHex = String(String(format:"%02X", system.color.uint).suffix(6))
                return
            }
            system.color = Color(value: value)
        }
    }

    let system: IParticlesSystem
    private let removeHandler: () -> Void
    private let nameManager: NameManger
    private let sizeManger: SizeManger
    private var cancellables: [AnyCancellable] = []

    init(
        system: IParticlesSystem,
        nameManager: NameManger,
        sizeManger: SizeManger,
        removeHandler: @escaping () -> Void
    ) {
        self.system = system
        self.nameManager = nameManager
        self.removeHandler = removeHandler
        self.sizeManger = sizeManger
        self.count = system.container.particles.count
        self.colorHex = String(String(format:"%02X", system.color.uint).suffix(6))
        self.resistance = CGFloat(system.resistance)
        setHooks()
    }

    func removeSystem() {
        removeHandler()
    }

    private func generate() {
        system.generate(
            in: .init(
                origin: .zero,
                size: sizeManger.sizeSubject.value.psSize
            ),
            count: count
        )
    }

    private func setHooks() {
        nameManager.getName(for: system).sink { [weak self] text in
            self?.systemName = text ?? ""
        }.store(in: &cancellables)
    }
}

import Combine
import CoreGraphics

final class NameManger {

    private var names: [ObjectIdentifier: CurrentValueSubject<String?, Never>] = [:]

    init() {}

    func setName(_ name: String, for obj: AnyObject) {
        getSubject(for: obj).send(name)
    }

    func getName(for obj: AnyObject) -> AnyPublisher<String?, Never> {
        return getSubject(for: obj).eraseToAnyPublisher()
    }

    func nextSystemName() -> String {
        "System #\(names.count + 1)"
    }

    private func getSubject(for obj: AnyObject) -> CurrentValueSubject<String?, Never> {
        let subject = names[ObjectIdentifier(obj)] ?? CurrentValueSubject<String?, Never>(nil)
        names[ObjectIdentifier(obj)] = subject
        return subject
    }
}

final class SizeManger {
    let sizeSubject = CurrentValueSubject<CGSize, Never>(.zero)

    init() {}

    func updateSize(_ size: CGSize) {
        sizeSubject.send(size)
    }
}

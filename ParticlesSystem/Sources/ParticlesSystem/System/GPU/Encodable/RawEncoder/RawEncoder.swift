import Foundation

public protocol RawEncoder {
    func rawStore<T>(_ value: T)
    func store(_ object: RawEncodable)
}

final class UnsafePointerRawEncoder: RawEncoder {
    private var size: Int = 0
    private var saveHandelr: [(UnsafeMutableRawPointer, Int) -> Int] = []

    private init() {}

    static func encode(object: RawEncodable, block: (UnsafeRawPointer?) throws -> Void) throws {
        let encoder = UnsafePointerRawEncoder()
        encoder.store(object)
        guard encoder.size > 0 else {
            try block(nil)
            return
        }
        let result = UnsafeMutableRawPointer.allocate(byteCount: encoder.size, alignment: 4)
        var offset = 0
        encoder.saveHandelr.forEach {
            offset += $0(result, offset)
        }
        var inputError: Error? = nil
        do {
            try block(result)
        }
        catch {
            inputError = error
        }
        result.deallocate()
        if let error = inputError {
            throw error
        }
    }

    func rawStore<T>(_ value: T) {
        let memory = MemoryLayout<T>.stride
        size += memory
        saveHandelr.append { pointer, offset in
            pointer.storeBytes(of: value, toByteOffset: offset, as: T.self)
            return memory
        }
    }

    func store(_ object: RawEncodable) {
        object.rawEncode(self)
    }
}

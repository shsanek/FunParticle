import Foundation
import MetalKit

enum BufferError: Error {
    case message(_ message: String)
}

public final class BufferContainer<Element: RawEncodable> {
    public var values: [Element] = [] {
        didSet {
            buffer.setNeedUpdate()
        }
    }

    public var count: Int {
        values.count
    }

    // metal
    private let buffer = MetalBufferCache()

    func getBuffer(with device: MTLDevice) throws -> MTLBuffer {
        try buffer.getBuffer(values, device: device)
    }
}

public final class OptionalBufferContainer<Element: RawEncodable> {
    public var values: [Element]? = [] {
        didSet {
            buffer.setNeedUpdate()
        }
    }

    public var count: Int {
        values?.count ?? 0
    }

    private let empty: Element

    init(_ empty: Element) {
        self.empty = empty
    }

    // metal
    let buffer = MetalBufferCache()

    func getOptionalBuffer(with device: MTLDevice) throws -> MTLBuffer? {
        guard let values = values, !values.isEmpty else {
            return nil
        }
        return try buffer.getBuffer(values, device: device)
    }

    func getBuffer(with device: MTLDevice) throws -> MTLBuffer {
        guard let values = values, !values.isEmpty else {
            return try buffer.getBuffer([empty], device: device)
        }
        return try buffer.getBuffer(values, device: device)
    }
}

class MetalBufferCache {
    private var isNeedUpdate: Bool = true
    private var cache: MTLBuffer?

    func getBuffer<T: RawEncodable>(_ array: [T], device: MTLDevice) throws -> MTLBuffer {
        var buffer: MTLBuffer?
        if let buffer = cache, !isNeedUpdate {
            return buffer
        }
        try UnsafePointerRawEncoder.encode(object: array) { pointer in
            if let pointer = pointer {
                buffer = try getMTLBuffer(
                    bytes: pointer,
                    length: MemoryLayout<T>.stride * array.count,
                    device: device
                )
            }
        }
        guard let buffer = buffer else {
            throw BufferError.message("error with get buffer")
        }
        isNeedUpdate = false
        return buffer
    }

    func setNeedUpdate() {
        isNeedUpdate = true
    }

    func getMTLBuffer(bytes pointer: UnsafeRawPointer, length: Int, device: MTLDevice) throws -> MTLBuffer {
        if let cached = self.cache, cached.length == length {
            cached.contents().copyMemory(from: pointer, byteCount: length)
            return cached
        }
        guard let newBuff = device.makeBuffer(
            bytes: pointer,
            length: length,
            options: [MTLResourceOptions.storageModeShared]
        ) else {
            throw NSError(domain: #function, code: 1, userInfo: ["what": "can't create buffer"])
        }
        self.cache = newBuff
        return newBuff
    }
}


import simd

public protocol RawEncodable {
    func rawEncode(_ encoder: RawEncoder)
}

extension RawEncodable {
    public func rawEncode(_ encoder: RawEncoder) {
        encoder.rawStore(self)
    }
}

extension Array: RawEncodable where Element: RawEncodable {
    public func rawEncode(_ encoder: RawEncoder) {
        for obj in self {
            encoder.store(obj)
        }
    }
}

extension SIMD2: RawEncodable { }
extension SIMD3: RawEncodable { }
extension SIMD4: RawEncodable { }
extension simd_float4x4: RawEncodable { }
extension UInt32: RawEncodable{ }

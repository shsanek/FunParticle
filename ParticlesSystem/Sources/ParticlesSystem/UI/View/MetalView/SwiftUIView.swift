import SwiftUI

#if canImport(UIKit)
import UIKit

@available(iOS 13.0, *)
public struct SwiftUIView: UIViewRepresentable {
    public var wrappedView: UIView

    private var handleUpdateUIView: ((UIView, Context) -> Void)?
    private var handleMakeUIView: ((Context) -> UIView)?

    public init(closure: () -> UIView) {
        wrappedView = closure()
    }

    public func makeUIView(context: Context) -> UIView {
        guard let handler = handleMakeUIView else {
            return wrappedView
        }

        return handler(context)
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        handleUpdateUIView?(uiView, context)
    }
}

@available(iOS 13.0, *)
public extension SwiftUIView {
    mutating func setMakeUIView(handler: @escaping (Context) -> UIView) -> Self {
        handleMakeUIView = handler
        return self
    }

    mutating func setUpdateUIView(handler: @escaping (UIView, Context) -> Void) -> Self {
        handleUpdateUIView = handler
        return self
    }
}

#endif


#if canImport(Cocoa)
import Cocoa

public struct SwiftUIView: NSViewRepresentable {
    public var wrappedView: NSView

    private var handleUpdateUIView: ((NSView, Context) -> Void)?
    private var handleMakeUIView: ((Context) -> NSView)?

    public init(closure: () -> NSView) {
        wrappedView = closure()
    }

    public func makeNSView(context: Context) -> NSView {
        guard let handler = handleMakeUIView else {
            return wrappedView
        }

        return handler(context)
    }

    public func updateNSView(_ uiView: NSView, context: Context) {
        handleUpdateUIView?(uiView, context)
    }
}

public extension SwiftUIView {
    mutating func setMakeUIView(handler: @escaping (Context) -> NSView) -> Self {
        handleMakeUIView = handler
        return self
    }

    mutating func setUpdateUIView(handler: @escaping (NSView, Context) -> Void) -> Self {
        handleUpdateUIView = handler
        return self
    }
}

#endif


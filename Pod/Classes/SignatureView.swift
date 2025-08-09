//
//  SignatureView.swift
//  Pods
//
//  Created by Scott Symes on 09/08/25.
//

import Combine
import Foundation
import SwiftUI

@available(iOS 13, *)
@available(tvOS 13, *)
public struct SignatureView: UIViewRepresentable {
    public enum Action: Sendable {
        case clear
        case undo
        case redo
    }

    @State private var strokeColor: UIColor = .black
    @State private var strokeAlpha: CGFloat = 1.0
    @State private var scale: CGFloat = 10.0
    @State private var maximumStrokeWidth: CGFloat = 4
    @State private var minimumStrokeWidth: CGFloat = 1
    @State private var bgColor: UIColor = .clear

    private var signature: Binding<UIImage?>?
    private var isEmpty: Binding<Bool>?
    private var canUndo: Binding<Bool>?
    private var canRedo: Binding<Bool>?
    private var action: Binding<SignatureView.Action?>?
    private var croppedSignature: Binding<UIImage?>?
    private var didUpdate: (() -> Void)?

    public init(
        action: Binding<SignatureView.Action?>? = nil,
        isEmpty: Binding<Bool>? = nil,
        signature: Binding<UIImage?>? = nil,
        croppedSignature: Binding<UIImage?>? = nil,
        canUndo: Binding<Bool>? = nil,
        canRedo: Binding<Bool>? = nil,
        didUpdate: (() -> Void)? = nil
    ) {
        self.isEmpty = isEmpty
        self.signature = signature
        self.croppedSignature = croppedSignature
        self.action = action
        self.canUndo = canUndo
        self.canRedo = canRedo
        self.didUpdate = didUpdate
    }
}

// MARK: - UIViewRepresentable Conformance
@available(iOS 13, *)
@available(tvOS 13, *)
extension SignatureView {
    public func makeUIView(context: Context) -> SwiftSignatureView {
        let view = SwiftSignatureView()
        view.delegate = context.coordinator
        return view
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public func updateUIView(_ view: SwiftSignatureView, context: Context) {
        view.strokeColor = strokeColor
        view.strokeAlpha = strokeAlpha
        view.scale = scale
        view.maximumStrokeWidth = maximumStrokeWidth
        view.minimumStrokeWidth = minimumStrokeWidth

        if let actionUnwrapped = action?.wrappedValue {
            DispatchQueue.main.async {
                switch actionUnwrapped {
                case .clear:
                    view.clear()
                case .undo:
                    view.undo()
                case .redo:
                    view.redo()
                }
                self.canRedo?.wrappedValue = view.canRedo
                self.canUndo?.wrappedValue = view.canUndo
                self.isEmpty?.wrappedValue = view.isEmpty
                self.signature?.wrappedValue = view.signature
                self.croppedSignature?.wrappedValue = view.getCroppedSignature()
                self.didUpdate?()
                action?.wrappedValue = nil
            }
        }
    }

    public class Coordinator: SwiftSignatureViewDelegate {
        let parent: SignatureView

        init(parent: SignatureView) {
            self.parent = parent
        }

        public func swiftSignatureViewDidDrawGesture(_ view: any ISignatureView, _ tap: UIGestureRecognizer) {
            update(with: view)
        }

        public func swiftSignatureViewDidDraw(_ view: any ISignatureView) {
            update(with: view)
        }

        private func update(with view: any ISignatureView) {
            parent.isEmpty?.wrappedValue = false
            parent.signature?.wrappedValue = view.signature
            parent.croppedSignature?.wrappedValue = view.getCroppedSignature()
            parent.canUndo?.wrappedValue = true
            parent.canRedo?.wrappedValue = view.canRedo
            parent.didUpdate?()
        }
    }
}

// MARK: - View Modifiers
@available(iOS 13, *)
@available(tvOS 13, *)
public extension SignatureView {
    func strokeColor(_ color: UIColor) -> Self {
        var copy = self
        copy._strokeColor = State(initialValue: color)
        return copy
    }

    func strokeAlpha(_ alpha: CGFloat) -> Self {
        var copy = self
        copy._strokeAlpha = State(initialValue: alpha)
        return copy
    }

    func scale(_ scale: CGFloat) -> Self {
        var copy = self
        copy._scale = State(initialValue: scale)
        return copy
    }

    func maximumStrokeWidth(_ width: CGFloat) -> Self {
        var copy = self
        copy._maximumStrokeWidth = State(initialValue: width)
        return copy
    }

    func minimumStrokeWidth(_ width: CGFloat) -> Self {
        var copy = self
        copy._minimumStrokeWidth = State(initialValue: width)
        return copy
    }

    func background(color: UIColor) -> Self {
        var copy = self
        copy._bgColor = State(initialValue: color)
        return copy
    }
}

@available(iOS 17, *)
@available(tvOS 13, *)
#Preview {
    @Previewable @State var action: SignatureView.Action?
    @Previewable @State var canUndo: Bool = false
    @Previewable @State var canRedo: Bool = false
    @Previewable @State var signature: UIImage?
    @Previewable @State var isEmpty: Bool = true

    ScrollView {
        VStack(spacing: 4) {
            HStack {
                Button {
                    action = .undo
                } label: {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                        .foregroundStyle(canUndo ? .black : .gray)
                }

                Button {
                    action = .redo
                } label: {
                    Label("Redo", systemImage: "arrow.uturn.forward")
                        .foregroundStyle(canRedo ? .black : .gray)
                }

                Spacer()

                Button {
                    action = .clear
                } label: {
                    Label("Clear", systemImage: "xmark")
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal)

            SignatureView(
                action: $action,
                isEmpty: $isEmpty,
                croppedSignature: $signature,
                canUndo: $canUndo,
                canRedo: $canRedo
            )
            .frame(height: 350)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        .gray,
                        style: StrokeStyle(
                            lineWidth: 1.1,
                            lineCap: .butt,
                            lineJoin: .round,
                            miterLimit: 2,
                            dash: [5, 8]
                        )
                    )
            )
            .padding(20)

            VStack(spacing: 3) {
                Divider()
                Divider()
            }
            .padding(.bottom, 6)

            // OUTPUTS
            Text(isEmpty ? "Signature is empty" : "Signature is not empty")
                .padding(.bottom, 4)

            if let signature {
                Image(uiImage: signature)
            }

            Spacer()
        }
        .padding(.top, 80)
    }
}

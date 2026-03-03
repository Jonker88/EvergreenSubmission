//  HelloClipExperience.swift
//  ReactivChallengeKit
//
//  Copyright © 2025 Reactiv Technologies Inc. All rights reserved.
//

import SwiftUI

struct HelloClipExperience: ClipExperience {
    static let urlPattern = "example.com/hello/:name"
    static let clipName = "Hello Clip"
    static let clipDescription = "A minimal example showing how the protocol works."
    static let touchpoint: JourneyTouchpoint = .showDay
    static let invocationSource: InvocationSource = .qrCode

    let context: ClipContext

    private var name: String {
        context.pathParameters["name"] ?? "World"
    }

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "hand.wave.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.primary)

                    Text("Hello, \(name)!")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(.primary)
                }

                Spacer()

                GlassEffectContainer {
                    VStack(spacing: 8) {
                        InfoRow(label: "URL", value: context.invocationURL.absoluteString)

                        ForEach(context.pathParameters.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            InfoRow(label: ":\(key)", value: value)
                        }

                        ForEach(context.queryParameters.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            InfoRow(label: "?\(key)", value: value)
                        }
                    }
                }
                .padding(.horizontal, 20)

                Text("Replace this with your own clip experience.")
                    .font(.system(size: 13))
                    .foregroundStyle(.tertiary)

                Spacer().frame(height: 8)
            }
        }
    }
}

private struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 50, alignment: .trailing)
            Text(value)
                .font(.system(size: 13, design: .monospaced))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .truncationMode(.middle)
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 12))
    }
}

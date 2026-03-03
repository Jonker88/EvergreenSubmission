//  VenueMerchExperience.swift
//  ReactivChallengeKit
//
//  Copyright © 2025 Reactiv Technologies Inc. All rights reserved.
//

import SwiftUI

struct VenueMerchExperience: ClipExperience {
    static let urlPattern = "onelive.com/venue/:venueId/merch"
    static let clipName = "Venue Merch"
    static let clipDescription = "Scan at a merch booth to browse and buy — skip the line."
    static let touchpoint: JourneyTouchpoint = .showDay
    static let invocationSource: InvocationSource = .qrCode

    let context: ClipContext
    @State private var cart: [Product] = []
    @State private var purchased = false

    private var artist: Artist {
        OneLiveMockData.artists[0]
    }

    private var venueName: String {
        let venueId = context.pathParameters["venueId"] ?? ""
        return OneLiveMockData.venues.first { $0.name.lowercased().contains(venueId.lowercased()) }?.name
            ?? OneLiveMockData.venues[0].name
    }

    var body: some View {
        ZStack {
            if purchased {
                VStack(spacing: 20) {
                    Spacer()
                    ClipSuccessOverlay(
                        message: "Order confirmed!\nPick up at \(OneLiveMockData.venues[0].boothLocations[0])."
                    )
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ArtistBanner(artist: artist, venue: venueName)
                            .padding(.top, 8)

                        MerchGrid(products: OneLiveMockData.featuredProducts) { product in
                            cart.append(product)
                        }

                        if !cart.isEmpty {
                            CartSummary(items: cart) {
                                withAnimation(.spring(duration: 0.4)) {
                                    purchased = true
                                }
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .padding(.bottom, 16)
                }
                .scrollIndicators(.hidden)
                .animation(.spring(duration: 0.3), value: cart.count)
            }
        }
    }
}

//
//  RatingView.swift
//  VodApiExplorer
//
//  Created by KIRILL SIMAGIN on 25/04/2024.
//

import SwiftUI

struct RatingView: View {
    var rating: Float // Rating value from 0 to 5
    var maxRating: Int = 5 // Max. number of stars
    let starSize: CGFloat = 20
    var fullStar: some View {
        Image(systemName: "star.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.orange)
            .frame(width: starSize, height: starSize)
    }

    var emptyStar: some View {
        Image(systemName: "star")
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            .frame(width: starSize, height: starSize)
    }

    var body: some View {
        HStack {
            ForEach(0..<maxRating, id: \.self) { index in
                if index < Int(rating) {
                    fullStar
                } else if index < Int(ceil(rating)) {
                    halfStar(fraction: rating - Float(index))
                } else {
                    emptyStar
                }
            }
        }
    }
    func halfStar(fraction: Float) -> some View {
        ZStack {
            emptyStar
            fullStar
                .mask(
                    HStack(spacing: 0) {
                        Rectangle()
                            .frame(width: starSize * CGFloat(fraction))
                        Spacer()
                    }
                )
        }
    }
}

#Preview {
    RatingView(rating: 2.5)
}

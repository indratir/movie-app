//
//  MovieItemShimmerView.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

import SwiftUI

struct MovieItemShimmerView: View {
    var body: some View {
        HStack(alignment: .top) {
            ShimmerView()
                .frame(width: 90, height: 120)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 16) {
                ShimmerView()
                    .frame(width: 160, height: 16)
                    .cornerRadius(8)
                
                ShimmerView()
                    .frame(width: 120, height: 12)
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    MovieItemShimmerView()
}

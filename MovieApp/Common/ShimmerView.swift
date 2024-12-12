//
//  ShimmerView.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 10/12/24.
//

import SwiftUI

struct ShimmerView: View {
    
    @State private var startPoint: UnitPoint = .init(x: -1, y: 0.5)
    @State private var endPoint: UnitPoint = .init(x: 0, y: 0.5)
    
    private var gradientColors: [Color] = [.gray.opacity(0.4), .gray.opacity(0.2), .gray.opacity(0.4)]
    
    var body: some View {
        LinearGradient(colors: gradientColors, startPoint: startPoint, endPoint: endPoint)
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    startPoint = .init(x: 1, y: 0.5)
                    endPoint = .init(x: 2, y: 0.5)
                }
            }
    }
}

#Preview {
    ShimmerView()
}

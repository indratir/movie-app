//
//  MovieItemView.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

import SwiftUI

struct MovieItemView: View {
    @State var movie: MovieModel
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: .init(string: movie.poster)) { image in
                image.image?.resizable()
            }
                .frame(width: 90, height: 120)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                
                Text(movie.year)
                    .font(.subheadline)
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
            }
        }
    }
}

#Preview {
    MovieItemView(movie: .mock())
}

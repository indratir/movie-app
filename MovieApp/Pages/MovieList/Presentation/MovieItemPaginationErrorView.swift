//
//  MovieItemPaginationErrorView.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

import SwiftUI

struct MovieItemPaginationErrorView: View {
    var body: some View {
        HStack {
            Spacer()

            VStack {
                Text("An error occurred")

                Button {

                } label: {
                    Text("Try Again")
                        .underline()
                }
            }

            Spacer()
        }
    }
}

#Preview {
    MovieItemPaginationErrorView()
}

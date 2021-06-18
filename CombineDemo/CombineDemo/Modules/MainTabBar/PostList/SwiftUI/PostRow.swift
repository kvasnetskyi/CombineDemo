//
//  PostRow.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 07.06.2021.
//

import SwiftUI

struct PostRow: View {

    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(post.title.capitalized)
                .font(.system(size: 20))
                .fontWeight(.semibold)
            Text(post.body)
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundColor(Color.black.opacity(0.8))
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        PostRow(post: .init(id: 0, userId: 0, title: "TITLE", body: "Text Text Text Text Text Text Text Text Text Text "))
            .previewLayout(.fixed(width: 300, height: 100))
    }
}

//
//  PostListView.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 07.06.2021.
//

import SwiftUI

struct PostListView: View {

    @ObservedObject var viewModel: PostsListViewModel

    var body: some View {
        NavigationView {
            List(self.viewModel.posts, id: \.id) { post in
                PostRow(post: post)
            }
            .navigationBarTitle("SwiftUI posts",
                                displayMode: viewModel.isLargeTitle ? .large : .inline)
            .alert(isPresented: self.$viewModel.showErrorAlert) {
                Alert(title: Text("Error"),
                      message: Text(self.viewModel.errorMessage ?? "unknown error"))
            }
        }
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PostsListViewModel()
        return PostListView(viewModel: viewModel)
    }
}

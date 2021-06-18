//
//  PostsListViewModel.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 31.01.2021.
//

import Foundation
import Combine

class PostsListViewModel: ObservableObject {

    @Published var posts: [Post] = []
    @Published var errorMessage: String?
    @Published var showErrorAlert = false
    @Published var isLargeTitle: Bool = true

    private let postService: PostService
    private let settingsService: SettingsService

    private var cancellables = Set<AnyCancellable>()

    init(postService: PostService = PostServiceImpl(), settingsService: SettingsService = SettingsServiceImpl()) {
        self.postService = postService
        self.settingsService = settingsService
        
        setup()
    }

    private func setup() {
        postService.getAll()
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<[Post], Never> in
                self.showErrorAlert = true
                self.errorMessage = error.localizedDescription
                return Just<[Post]>([]).eraseToAnyPublisher()
            }
            .assign(to: \.posts, on: self)
            .store(in: &cancellables)

        settingsService.settingsPublisher
            .sink { [unowned self] settingsModel in
                isLargeTitle = settingsModel.largeTitleIsOn
            }
            .store(in: &cancellables)
    }
}

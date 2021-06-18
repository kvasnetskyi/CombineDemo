//
//  PostService.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 31.01.2021.
//

import Foundation
import Combine

protocol PostService {
    func getAll() -> AnyPublisher<[Post], Error>
}

class PostServiceImpl: PostService {
    func getAll() -> AnyPublisher<[Post], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

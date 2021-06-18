//
//  Post.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 08.06.2021.
//

import Foundation

struct Post: Decodable, Hashable, Identifiable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

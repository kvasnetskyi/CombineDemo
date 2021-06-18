//
//  PostTableViewCell.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 31.01.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"

    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with post: Post) {
        titleLabel.text = post.title.capitalized
        bodyLabel.text = post.body
    }

    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.numberOfLines = 0

        bodyLabel.font = .systemFont(ofSize: 14, weight: .medium)
        bodyLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        bodyLabel.numberOfLines = 0

        addSubview(titleLabel, constraints: [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
        addSubview(bodyLabel, constraints: [
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

}

import SwiftUI
struct PostTableViewCellPreview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable(PostTableViewCell()) {
            $0.setup(with: Post(id: 1,
                                userId: 1,
                                title: "Title",
                                body: "Body body body body body body body body body body body body body body body body"))
        }
        .previewLayout(.fixed(width: 400, height: 100))
    }
}

//
//  PostsListViewController.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 31.01.2021.
//

import UIKit
import Combine

class PostsListViewController: UIViewController {

    private let viewModel: PostsListViewModel

    private var cancellables = Set<AnyCancellable>()

    private let tableView = UITableView()
    private lazy var dataSource = makeDataSource()

    init(viewModel: PostsListViewModel = PostsListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUI()
        bind()
    }

    private func bind() {
        viewModel.$posts
            .sink { [unowned self] posts in
                var snapshot = NSDiffableDataSourceSnapshot<Int, Post>()
                snapshot.appendSections([0])
                snapshot.appendItems(posts)
                dataSource.apply(snapshot)
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .dropFirst()
            .sink { [unowned self] in showErrorAlert(errorMessage: $0 ?? "unknown error") }
            .store(in: &cancellables)

        viewModel.$isLargeTitle
            .sink { [unowned self] in navigationController?.navigationBar.prefersLargeTitles = $0 }
            .store(in: &cancellables)
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Int, Post> {
        UITableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
            cell.setup(with: model)
            return cell
        }
    }

    private func setupLayout() {
        view.addSubview(tableView, withEdgeInsets: .zero)
    }

    private func setupUI() {
        view.backgroundColor = .white
        self.title = "UIKit Posts"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
    }

}

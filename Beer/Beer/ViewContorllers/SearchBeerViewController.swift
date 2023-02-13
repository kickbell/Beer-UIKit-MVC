//
//  SearchViewController.swift
//  Beer
//
//  Created by jc.kim on 2/4/23.
//

import UIKit

class SearchBeerViewController: UIViewController {
    // MARK: Views
    
    let searchController = UISearchController(searchResultsController: nil)
    private lazy var tableView = UITableView()
    
    // MARK: Properties

    private(set) var movies: [Movie] = []
    private let service: MoviesServiceable

    // MARK: LifeCycle
    
    init(service: MoviesServiceable) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAttributes()
        addSubviews()
        addConstraints()
        loadTableView()
    }
    
    // MARK: Methods

    private func fetchData(completion: @escaping (Result<SearchMovieResult, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.search(query: searchController.searchBar.text ?? "")
            completion(result)
        }
    }
    
    func loadTableView(completion: (() -> Void)? = nil) {
        fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.movies = response.results
                self.tableView.reloadData()
                completion?()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
                completion?()
            }
        }
    }
    
    private func showModal(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    func addAttributes() {
        view.backgroundColor = .white

        title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self

        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifler)
    }

    func addSubviews() {
        view.addSubview(tableView)
    }

    func addConstraints() {

    }
}

// MARK: - TableView Methods

extension SearchBeerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifler, for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        let target = movies[indexPath.row]
        cell.configure(with: target)
        return cell
    }
}

extension SearchBeerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let target = movies[indexPath.row]
        let detailViewController = DetailViewController(with: target)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension SearchBeerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        loadTableView()
    }
}

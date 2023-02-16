//
//  SearchViewController.swift
//  Beer
//
//  Created by jc.kim on 2/4/23.
//

import UIKit

class SearchBeerViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: Views
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Properties
    
    private(set) var movies: [Movie] = []
    private let service: MoviesServiceable
    private var isPaging = false
    private var currentPage = 1
    
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
    }
    
    // MARK: Methods
    
    func fetch(query: String, page: Int, completion: @escaping (Result<SearchMovieResult, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.search(query: query, page: page)
            completion(result)
        }
    }
    
    func didScrollFetch() {
        isPaging = true
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        self.currentPage += 1
    }
    
    func loadTableView(query: String, page: Int, completion: (() -> Void)? = nil) {
        fetch(query: query, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if self.movies.count < response.totalResults {
                    self.movies.append(contentsOf: response.results)
                    self.isPaging = false
                    self.tableView.reloadData()
                    completion?()
                }
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
                completion?()
            }
        }
    }
    
    func addAttributes() {
        view.backgroundColor = .white
        
        title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        
        tableView.frame = view.bounds
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifler)
        tableView.register(SearchLoadingCell.self, forCellReuseIdentifier: SearchLoadingCell.reuseIdentifler)
    }
    
    // MARK: - SearchController Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            return
        }
        self.currentPage = 1
        self.movies = []
        
        loadTableView(query: searchBar.text ?? "", page: self.currentPage)
    }
    
    // MARK: - TableView Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return movies.count
        } else if section == 1 && isPaging == false && !movies.isEmpty {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifler, for: indexPath) as? SearchResultCell else {
                return UITableViewCell()
            }
            cell.configure(with: movies[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchLoadingCell.reuseIdentifler, for: indexPath) as? SearchLoadingCell else {
                return UITableViewCell()
            }
            cell.start()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let target = movies[indexPath.row]
        let detailViewController = DetailViewController(service: MoviesService(), with: target.id)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: - ScrollView Methods
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height * 3
        
        if offsetY > contentHeight - scrollViewHeight {
            if !isPaging && !movies.isEmpty  {
                didScrollFetch()
                loadTableView(query: searchController.searchBar.text ?? "", page: self.currentPage)
            }
        }
    }
}

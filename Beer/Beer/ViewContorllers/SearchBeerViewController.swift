//
//  SearchViewController.swift
//  Beer
//
//  Created by jc.kim on 2/4/23.
//

import UIKit

class SearchBeerViewController: UIViewController {
    let sections = Bundle.main.decode([Section].self, from: "appstore.json")
    let searchController = UISearchController(searchResultsController: nil)
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addAttributes()
        addSubviews()
        addConstraints()
    }
    
    func addAttributes() {
        view.backgroundColor = .white
        
        title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
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

extension SearchBeerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifler, for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        let target = sections[indexPath.row].items[indexPath.row]
        cell.configure(with: target)
        return cell
    }
}

extension SearchBeerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = self.sections[indexPath.section].items[indexPath.row]
        let detailViewController = DetailViewController(with: app)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

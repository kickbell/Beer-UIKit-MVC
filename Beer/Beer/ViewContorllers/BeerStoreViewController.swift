//
//  ViewController.swift
//  Beer
//
//  Created by jc.kim on 1/31/23.
//

import UIKit

class BeerStoreViewController: UIViewController {
    
    // MARK: Views

//    let sections = Bundle.main.decode([Section].self, from: "appstore.json")
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: Properties

    var dataSource: UICollectionViewDiffableDataSource<TopRated, Movie>?
    private(set) var sections: [TopRated] = []
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
        createDataSource()
        applyInitialSnapshot()
        
     loadTableView()
        
    }
    
    // MARK: Methods
    
    private func fetchData(completion: @escaping (Result<TopRated, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getTopRated()
            completion(result)
        }
    }
    
    func loadTableView(completion: (() -> Void)? = nil) {
        fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
//                self.movies = response.results
                self.sections = [response]
//                print(self.sections, "###")
                self.createDataSource()
                self.applyInitialSnapshot()
//                print(self.movies)
//                self.tableView.reloadData()
//                self.collectionView.reloadData()
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
        
        title = "스토어"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
    }
    
    func addSubviews() {
        view.addSubview(collectionView)
    }
    
    func cellRegistration<T: SelfConfigureCell> (_ cellType: T.Type) -> UICollectionView.CellRegistration<T, Movie>{
        return UICollectionView.CellRegistration<T, Movie> { (cell, indexPath, app) in cell.configure(with: app)
        }
    }
    
    func sectionHeaderRegistration<T: UICollectionReusableView>(_ viewType: T.Type) -> UICollectionView.SupplementaryRegistration<T>{
        return UICollectionView.SupplementaryRegistration<T>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView,elementKind,indexPath in }
    }
    
    func createDataSource() {
        let featuredCellRegistration = cellRegistration(FeaturedCell.self)
        let smallTableCellRegistration = cellRegistration(SmallTableCell.self)
        let mediumTableCellRegistration = cellRegistration(ThreeTableCell.self)
        let sectionHeaderRegistration = sectionHeaderRegistration(SectionHeader.self)
        
        dataSource = UICollectionViewDiffableDataSource<TopRated, Movie>(collectionView: collectionView) { collectionView, indexPath, app in
//            let section = self.sections[indexPath.section]
//            let section = self.sections[indexPath.section]
            
            
            switch indexPath.section {
            case 0:
                return collectionView.dequeueConfiguredReusableCell(using: mediumTableCellRegistration, for: indexPath, item: app)
            case 1:
                return collectionView.dequeueConfiguredReusableCell(using: smallTableCellRegistration, for: indexPath, item: app)
            case 2:
                return collectionView.dequeueConfiguredReusableCell(using: featuredCellRegistration, for: indexPath, item: app)
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let sectionHeader = collectionView.dequeueConfiguredReusableSupplementary(using: sectionHeaderRegistration, for: indexPath)
            
            guard let firstApp = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil }
//            if section.title.isEmpty { return nil }
            
            sectionHeader.title.text = "title"
            sectionHeader.subtitle.text = "subtitle"
            return sectionHeader
        }
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<TopRated, Movie>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.results, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
//            let section = self.movies[sectionIndex]
            
            switch sectionIndex {
            case 0:
                return self.createMediumTableSection()
            case 1:
                return self.createSmallTableSection()
            default:
                return self.createFeaturedSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        return layoutSection
    }
    
    func createMediumTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.33))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(0.55))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    
    func createSmallTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(200))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        
        return layoutSection
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return layoutSectionHeader
    }
}


extension BeerStoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let app = self.dataSource?.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        let detailViewController = DetailViewController(with: app)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

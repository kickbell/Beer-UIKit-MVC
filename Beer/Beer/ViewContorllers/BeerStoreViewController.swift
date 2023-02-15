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
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
//    private(set) var populars: [Movie] = []
//    private(set) var topRateds: [Movie] = []
//    private(set) var genres: [Genre] = []
    
    private(set) var fetchResult: FetchResult?
    
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
        
        loadTableView {
            self.createDataSource()
            self.applyInitialSnapshot()
        }
        
    }
    
    // MARK: Methods
    
    struct FetchResult {
        let topRated: TopRatedResult
        let popular: PopularMovieResult
        let genre: GenreMovieResult
        let upcoming: UpcomingMovieResult
    }
    
    private func fetchData(completion: @escaping (FetchResult) -> Void) {
        Task(priority: .background) {
            let tapRated = await service.topRated()
            let popular = await service.popular()
            let genre = await service.genre()
            let upcoming = await service.upcoming()
            
            do {
                let t = try tapRated.get()
                let p = try popular.get()
                let g = try genre.get()
                let u = try upcoming.get()
            
                let result = FetchResult(topRated: t, popular: p, genre: g, upcoming: u)
                completion(result)
            } catch {
                showModal(title: "Error", message: error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
    

    
    func loadTableView(completion: (() -> Void)? = nil) {
        fetchData { response in
            self.fetchResult = response
//            self.topRateds = response.topRated.results
//            self.populars = response.popular.results
//            self.genres = response.genre.genres
            completion?()
        }
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
    
//    func cellRegistration<T: SelfConfigureCell> (_ cellType: T.Type) -> UICollectionView.CellRegistration<T, Item>{
//        return UICollectionView.CellRegistration<T, Item> { (cell, indexPath, app) in
//            cell.configure(with: app)
//        }
//    }
    
    func sectionHeaderRegistration<T: UICollectionReusableView>(_ viewType: T.Type) -> UICollectionView.SupplementaryRegistration<T>{
        return UICollectionView.SupplementaryRegistration<T>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView,elementKind,indexPath in }
    }
    
    func createFeaturedCellRegistration<T: SelfConfigureCell> (_ cellType: T.Type) -> UICollectionView.CellRegistration<T, Movie> {
        return UICollectionView.CellRegistration<T, Movie> { (cell, indexPath, app) in
            cell.configure(with: app as! T.Item)
        }
    }
    
    func createMediumTableCellRegistration<T: SelfConfigureCell> (_ cellType: T.Type) -> UICollectionView.CellRegistration<T, Movie> {
        return UICollectionView.CellRegistration<T, Movie> { (cell, indexPath, app) in
            cell.configure(with: app as! T.Item)
        }
    }
    
    func createSmallTableCellRegistration<T: SelfConfigureCell> (_ cellType: T.Type) -> UICollectionView.CellRegistration<T, Genre> {
        return UICollectionView.CellRegistration<T, Genre> { (cell, indexPath, app) in
            cell.configure(with: app as! T.Item)
        }
    }
    
    func createSquareCellRegistration<T: SelfConfigureCell> (_ cellType: T.Type) -> UICollectionView.CellRegistration<T, Movie> {
        return UICollectionView.CellRegistration<T, Movie> { (cell, indexPath, app) in
            cell.configure(with: app as! T.Item)
        }
    }
    
    func createDataSource() {
        let sectionHeaderRegistration = sectionHeaderRegistration(SectionHeader.self)
        
        let featuredCellRegistration = createFeaturedCellRegistration(FeaturedCell.self)
        let mediumTableCellRegistration = createMediumTableCellRegistration(ThreeTableCell.self)
        let smallTableCellRegistration = createSmallTableCellRegistration(SmallTableCell.self)
        let squareCellRegistration = createSquareCellRegistration(SquareCell.self)
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .popular:
                return collectionView.dequeueConfiguredReusableCell(using: featuredCellRegistration, for: indexPath, item: item.popular)
            case .topRated:
                return collectionView.dequeueConfiguredReusableCell(using: mediumTableCellRegistration, for: indexPath, item: item.topRated)
            case .genre:
                return collectionView.dequeueConfiguredReusableCell(using: smallTableCellRegistration, for: indexPath, item: item.genre)
            case .upcoming:
                return collectionView.dequeueConfiguredReusableCell(using: squareCellRegistration, for: indexPath, item: item.upcoming)
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let sectionHeader = collectionView.dequeueConfiguredReusableSupplementary(using: sectionHeaderRegistration, for: indexPath)

            guard let firstApp = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil }
            //            if section.title.isEmpty { return nil }

            switch section {
            case .popular: return sectionHeader
            case .topRated:
                sectionHeader.title.text = "HOT & NEW"
                sectionHeader.subtitle.text = "최고 등급의 평점을 받은 영화입니다."
                return sectionHeader
            case .genre:
                sectionHeader.title.text = "영화 카테고리"
                return sectionHeader
            case .upcoming:
                sectionHeader.title.text = "UPCOMING"
                return sectionHeader
            }
        }
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        
        guard let result = fetchResult else {
            print("invalid fetchResult...")
            return
        }
        
        
        let popularItems = result.popular.results.map { Item(popular: $0 )}
        let topRatedItems = result.topRated.results.map { Item(topRated: $0 )}
        let genreItems = result.genre.genres.map { Item(genre: $0 )}
        let upcomingItems = result.upcoming.results.map { Item(upcoming: $0 )}
        
//        let popularItems = populars.map { Item(popular: $0) }
//        let topRatedItems = topRateds.map { Item(topRated: $0) }
//        let genreItems = genres.map { Item(genre: $0) }
        snapshot.appendItems(popularItems, toSection: .popular)
        snapshot.appendItems(topRatedItems, toSection: .topRated)
        snapshot.appendItems(genreItems, toSection: .genre)
        snapshot.appendItems(upcomingItems, toSection: .upcoming)
        
        dataSource?.apply(snapshot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            //            let section = self.movies[sectionIndex]
            
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unknown section") }
            switch section {
            case .popular:
                return self.createFeaturedSection()
            case .topRated:
                return self.createMediumTableSection()
            case .genre:
                return self.createSmallTableSection()
            case .upcoming:
                return self.createSquareTableSection()
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
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(300))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        return layoutSection
    }
    
    func createMediumTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.33))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5)
        
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
    
    func createSquareTableSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)

        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 10)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.46), heightDimension: .fractionalHeight(0.46))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
//        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
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
        var movie: Movie?
        
        switch indexPath.section {
        case 0: movie = app.popular
        case 1: movie = app.topRated
        case 2: movie = app.upcoming
        default: break
        }
        
        let detailViewController = DetailViewController(service: MoviesService(), with: movie?.id ?? 0)
        detailViewController.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

}


extension UIViewController {
    func showModal(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

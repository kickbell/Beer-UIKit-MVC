//
//  RandomBeerViewController.swift
//  Beer
//
//  Created by jc.kim on 2/4/23.
//

import UIKit

class RandomBeerViewController: UIViewController {
}
//    let sections = Bundle.main.decode([Section].self, from: "appstore.json")
//    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
//    var dataSource: UICollectionViewDiffableDataSource<Section, App>?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addAttributes()
//        addSubviews()
//        createDataSource()
//        applyInitialSnapshot()
//    }
//
//    func addAttributes() {
//        view.backgroundColor = .white
//
//        title = "랜덤"
//        navigationController?.navigationBar.prefersLargeTitles = true
//
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .systemBackground
//        collectionView.delegate = self
//    }
//
//    func addSubviews() {
//        view.addSubview(collectionView)
//    }
//
//    func cellRegistration<T: SelfConfigureCell> (_ cellType: T.Type) -> UICollectionView.CellRegistration<T, App>{
//        return UICollectionView.CellRegistration<T, App> { (cell, indexPath, app) in cell.configure(with: app)
//        }
//    }
//
//    func createListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, App> {
//        return UICollectionView.CellRegistration<UICollectionViewListCell, App> { (cell, indexPath, app) in
//            var content = UIListContentConfiguration.valueCell()
//            content.image = UIImage(named: app.image)
//            content.text = app.name
//            content.secondaryText = "\(Int.random(in: 1...50))"
//            cell.contentConfiguration = content
//            cell.accessories = [UICellAccessory.disclosureIndicator()]
//        }
//    }
//
//    func sectionHeaderRegistration<T: UICollectionReusableView>(_ viewType: T.Type) -> UICollectionView.SupplementaryRegistration<T>{
//        return UICollectionView.SupplementaryRegistration<T>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView,elementKind,indexPath in }
//    }
//
//    func createDataSource() {
//        let featuredCellRegistration = cellRegistration(FeaturedCell.self)
//        let smallTableCellRegistration = createListCellRegistration()
//        let mediumTableCellRegistration = cellRegistration(SquareCell.self)
//        let sectionHeaderRegistration = sectionHeaderRegistration(SectionHeader.self)
//
//        dataSource = UICollectionViewDiffableDataSource<Section, App>(collectionView: collectionView) { collectionView, indexPath, app in
//            let section = self.sections[indexPath.section]
//
//            switch section.appType {
//            case .mediumTable:
//                return collectionView.dequeueConfiguredReusableCell(using: mediumTableCellRegistration, for: indexPath, item: app)
//            case .smallTable:
//                return collectionView.dequeueConfiguredReusableCell(using: smallTableCellRegistration, for: indexPath, item: app)
//            case .featured:
//                return collectionView.dequeueConfiguredReusableCell(using: featuredCellRegistration, for: indexPath, item: app)
//            case .none:
//                return collectionView.dequeueConfiguredReusableCell(using: mediumTableCellRegistration, for: indexPath, item: app)
//            }
//        }
//
//        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
//            let sectionHeader = collectionView.dequeueConfiguredReusableSupplementary(using: sectionHeaderRegistration, for: indexPath)
//
//            guard let firstApp = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
//            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstApp) else { return nil }
//            if section.title.isEmpty { return nil }
//            sectionHeader.title.text = section.title
//            sectionHeader.subtitle.text = section.subtitle
//            sectionHeader.accessoryButton.isHidden = false
//            sectionHeader.accessoryButtonDidTap = {
//                print("accessoryButtonDidTap...")
//            }
//            return sectionHeader
//        }
//    }
//
//    func applyInitialSnapshot() {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, App>()
//        snapshot.appendSections(sections)
//
//        for section in sections {
//            snapshot.appendItems(section.items, toSection: section)
//        }
//
//        dataSource?.apply(snapshot)
//    }
//
//    func createCompositionalLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
//            let section = self.sections[sectionIndex]
//
//            switch section.appType {
//            case .mediumTable:
//                return self.createMediumTableSection(using: section)
//            case .smallTable:
//                return self.createSmallTableSection(using: section, layoutEnvironment: layoutEnvironment)
//            default:
//                return self.createFeaturedSection(using: section)
//            }
//        }
//
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 20
//        layout.configuration = config
//        return layout
//    }
//
//    func createFeaturedSection(using section: Section) -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//
//        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
//        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(350))
//        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
//
//        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
//        return layoutSection
//    }
//
//    func createMediumTableSection(using section: Section) -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
//
//        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
//        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//
//        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.5))
//        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
//
//        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
//        layoutSection.orthogonalScrollingBehavior = .groupPaging
//        let layoutSectionHeader = createSectionHeader()
//        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
//        return layoutSection
//    }
//
//    func createSmallTableSection(using section: Section, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
//
//        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
//        configuration.backgroundColor = .white
//        let layoutSection = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
//
//        let layoutSectionHeader = createSectionHeader()
//        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
//
//        return layoutSection
//    }
//
//    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
//        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(80))
//        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        return layoutSectionHeader
//    }
//}
//
//extension RandomBeerViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let app = self.dataSource?.itemIdentifier(for: indexPath) else {
//            collectionView.deselectItem(at: indexPath, animated: true)
//            return
//        }
//        let detailViewController = DetailViewController(with: app)
//        self.navigationController?.pushViewController(detailViewController, animated: true)
//    }
//}

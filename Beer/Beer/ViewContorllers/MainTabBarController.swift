//
//  MainTabBarController.swift
//  Beer
//
//  Created by jc.kim on 2/4/23.
//

import UIKit


//코드정리하면서 재생성할건데.

//1. 결과모델들 하나로 합치기
//struct Movies {
//    let items: [Movie]
//}
//
//extension Movies: Decodable {
//
//    enum CodingKeys: String, CodingKey {
//        case items = "results"
//    }
//}
//
//2. 코더블도 디코더블만으로 합치기
//
//3. 장르id값도 

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureViewControllers()
    }
    
    func configureTabBar() {
        self.tabBar.tintColor = .label
        self.tabBar.barStyle = .default
    }
    
    func configureViewControllers() {
        let beerStore = UINavigationController(rootViewController: BeerStoreViewController(service: MoviesService()))
        let beerStoreItem = UITabBarItem(title: "스토어", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))
        beerStore.tabBarItem = beerStoreItem
        
        let search = UINavigationController(rootViewController: SearchBeerViewController(service: MoviesService()))
        let searchItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        search.tabBarItem = searchItem
        
        let randomBeer = UINavigationController(rootViewController: RandomBeerViewController(service: MoviesService()))
        let randomBeerItem = UITabBarItem(title: "트렌드", image: UIImage(systemName: "t.circle"), selectedImage: UIImage(systemName: "t.circle.fill"))
        randomBeer.tabBarItem = randomBeerItem
        
        self.viewControllers = [beerStore, search, randomBeer]
    }
}

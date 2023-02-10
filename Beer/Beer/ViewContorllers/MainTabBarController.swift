//
//  MainTabBarController.swift
//  Beer
//
//  Created by jc.kim on 2/4/23.
//

import UIKit


//맥주스토어    맥주검색(이름)      랜덤맥주
//컴포지셔널       검색바         랜덤맥주 사진과 간단한설명만있는 컬렉션뷰 화면
//레이아웃        페이징         즐겨찾기 추가할수있게 별표.
//네트워킹      오토레이아웃 최적화  즐겨찾기 추가하면 로컬로 저장.
//네트워킹테스트

//상세페이지
//상세설명 주루룩..
//버튼있어서 클릭하면 이미지 웹뷰로 연결.


class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureViewControllers()
    }
    
    func configureTabBar() {
        self.tabBar.tintColor = .black
        self.tabBar.barStyle = .default
    }
    
    func configureViewControllers() {
        let beerStore = UINavigationController(rootViewController: BeerStoreViewController())
        let beerStoreItem = UITabBarItem(title: "스토어", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))
        beerStore.tabBarItem = beerStoreItem
        
        let search = UINavigationController(rootViewController: SearchBeerViewController())
        let searchItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
        search.tabBarItem = searchItem
        
        let randomBeer = UINavigationController(rootViewController: RandomBeerViewController())
        let randomBeerItem = UITabBarItem(title: "랜덤", image: UIImage(systemName: "shuffle"), selectedImage: UIImage(systemName: "shuffle.fill"))
        randomBeer.tabBarItem = randomBeerItem
        
        self.viewControllers = [beerStore, search, randomBeer]
    }
}

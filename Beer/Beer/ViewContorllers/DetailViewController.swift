//
//  DetailViewController.swift
//  Beer
//
//  Created by jc.kim on 2/4/23.
//

import UIKit

class DetailViewController: UITabBarController {
    
    let imageView = UIImageView()
    let name = UILabel()
    let subtitle = UILabel()
    let desc = UILabel()
    let withFood = UILabel()
    let moveButton = UIButton(type: .custom)
    let emptyView = UIView()
    var stackView = UIStackView()
    let app: Movie
    
    init(with app: Movie) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAttributes()
        addSubviews()
        addConstraints()
        configure(with: app)
    }
    
    func addAttributes() {
        view.backgroundColor = .white
        
        hidesBottomBarWhenPushed = true
        tabBar.isHidden = true
        
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        name.font = UIFont.preferredFont(forTextStyle: .title3)
        name.textAlignment = .center
        name.textColor = .label
        
        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel
        subtitle.numberOfLines = 0
        
        withFood.font = UIFont.preferredFont(forTextStyle: .subheadline)
        withFood.textColor = .secondaryLabel
        withFood.numberOfLines = 0
        
        desc.font = UIFont.preferredFont(forTextStyle: .subheadline)
        desc.textColor = .secondaryLabel
        desc.numberOfLines = 0
        
        moveButton.setTitle("move image link", for: .normal)
        moveButton.setTitleColor(.white, for: .normal)
        moveButton.backgroundColor = .systemBlue
        moveButton.addTarget(self, action: #selector(move), for: .touchUpInside)
        
        stackView = UIStackView(arrangedSubviews: [imageView, name, subtitle, desc, withFood, moveButton, emptyView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        
    }
    
    func addSubviews() {
        view.addSubview(stackView)
    }
    
    func addConstraints() {
        emptyView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            moveButton.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        stackView.setCustomSpacing(50, after: imageView)
        stackView.setCustomSpacing(50, after: withFood)
    }
    
    func configure(with app: Movie) {
//        imageView.image = UIImage(named: app.image)
//        name.text = app.name
//        subtitle.text = app.subheading + app.subheading + app.subheading
//        desc.text = app.tagline
//        withFood.text = app.image + ", " + app.image + ", " + app.image + ", " + app.image
    }
    
    @objc func move() {
        print("move...")
    }
    
}

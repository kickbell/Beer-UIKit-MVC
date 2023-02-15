//
//  RandomBeerViewController.swift
//  Beer
//
//  Created by jc.kim on 2/4/23.
//

import UIKit


class RandomBeerViewController: UITabBarController {
    let imageView = UIImageView()
    let largeTitle = UILabel()
    let shuffleButton = UIButton()
    let subtitle = UILabel()
    let name = UILabel()
    let info = UILabel()
    let overview = UILabel()
    let moveButton = UIButton(type: .custom)
    let emptyView = UIView()
    var innerStackView = UIStackView()
    var outerStackView = UIStackView()
    let id: Int = 299536
    let service: MoviesServiceable
    var trending: [Movie] = []
    var posterPath: String?
    
    // MARK: LifeCycle
    
    init(service: MoviesServiceable) {
        self.service = service
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
        loadTableView()
    }
    
    func addAttributes() {
        view.backgroundColor = .white
        
        largeTitle.text = "트렌드"
        largeTitle.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 34, weight: .heavy))
        
        shuffleButton.setImage(UIImage(systemName: "shuffle", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 25))), for: .normal)
        shuffleButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        
        subtitle.font = UIFont.preferredFont(forTextStyle: .body)
        subtitle.text = "최근 24시간 동안 트렌드 리스트의 영화를 랜덤으로 나타냅니다. 우측 버튼으로 새로고침 할 수 있습니다."
        subtitle.numberOfLines = 0
        subtitle.textColor = .secondaryLabel
        
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        name.font = UIFont.preferredFont(forTextStyle: .title3)
        name.textColor = .label
        
        info.font = UIFont.preferredFont(forTextStyle: .subheadline)
        info.textColor = .label
        
        overview.font = UIFont.preferredFont(forTextStyle: .subheadline)
        overview.textColor = .secondaryLabel
        overview.numberOfLines = 0
        
        moveButton.setTitle("포스터 보러가기", for: .normal)
        moveButton.setTitleColor(.white, for: .normal)
        moveButton.backgroundColor = .systemBlue
        moveButton.addTarget(self, action: #selector(open), for: .touchUpInside)
        
        innerStackView = UIStackView(arrangedSubviews: [largeTitle, shuffleButton])
        innerStackView.axis = .horizontal
        
        outerStackView = UIStackView(arrangedSubviews: [innerStackView, subtitle, imageView, name, info, overview, moveButton, emptyView])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.spacing = 10
        outerStackView.axis = .vertical
    }
    
    func addSubviews() {
        view.addSubview(outerStackView)
    }
    
    func addConstraints() {
        emptyView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            moveButton.heightAnchor.constraint(equalToConstant: 50),
            
            outerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            outerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            outerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        outerStackView.setCustomSpacing(20, after: imageView)
        outerStackView.setCustomSpacing(20, after: overview)
    }
    
    private func fetchData(completion: @escaping (Result<TrendingMovieResult, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.trending()
            completion(result)
        }
    }
    
    func loadTableView(completion: (() -> Void)? = nil) {
        fetchData { response in
            switch response {
            case .success(let trending):
                self.trending = trending.results
                self.configure(with: trending.results[0])
                self.posterPath = trending.results[0].posterPath
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
            }
            completion?()
        }
    }
    
    func configure(with movie: Movie) {
        imageView.load(urlStr: imagePath + (movie.backdropPath ?? ""))
        name.text = movie.title
        info.text = "| ⭐️\(movie.voteAverage) | \(movie.releaseDate) |"
        overview.text = movie.overview
        posterPath = movie.posterPath
    }
    
    @objc func open() {
        if let url = URL(string: imagePath + (posterPath ?? "")) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func refresh() {
        configure(with: trending.shuffled()[0])
    }
}

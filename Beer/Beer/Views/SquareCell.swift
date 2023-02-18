//
//  SquareCell.swift
//  Beer
//
//  Created by jc.kim on 2/7/23.
//

import UIKit

class SquareCell: UICollectionViewCell, ConfigureView, SelfConfigureCell {
    let imageView = UIImageView()
    let name = UILabel()
    let subtitle = UILabel()
    private var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAttributes()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func addAttributes() {
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        
        name.font = UIFont.preferredFont(forTextStyle: .subheadline)
        name.textColor = .label
        
        subtitle.font = UIFont.preferredFont(forTextStyle: .body)
        subtitle.textColor = .secondaryLabel
        
        stackView = UIStackView(arrangedSubviews: [imageView, name, subtitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
    }
    
    func addSubviews() {
        contentView.addSubview(stackView)
    }
    
    func addConstraints() {
        name.setContentHuggingPriority(.defaultHigh, for: .vertical)
        subtitle.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        stackView.setCustomSpacing(5, after: imageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        imageView.image = nil
    }
    
    func configure(with movie: Movie) {
        name.text = movie.title
//        subtitle.text = app.overview
        loadImage(for: movie)
    }
    
    private func loadImage(for movie: Movie) {
        let url = URL(string: imagePath + (movie.backdropPath ?? ""))!
        ImageLoader.shared.loadImage(from: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

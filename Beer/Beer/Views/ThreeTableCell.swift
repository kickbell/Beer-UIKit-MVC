//
//  MediumTableCell.swift
//  Beer
//
//  Created by jc.kim on 2/6/23.
//

import UIKit

class ThreeTableCell: UICollectionViewCell, ConfigureView, SelfConfigureCell {
    let name = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()
    let buyButton = UIButton(type: .custom)
    private var innerStackView = UIStackView()
    private var outerStackView = UIStackView()
    
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
        name.font = UIFont.preferredFont(forTextStyle: .headline)
        name.textColor = .label
        
        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel
        
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        
        buyButton.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)

        innerStackView = UIStackView(arrangedSubviews: [name, subtitle])
        innerStackView.axis = .vertical
        
        outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView, buyButton])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.alignment = .center
        outerStackView.spacing = 10
    }
    
    func addSubviews() {
        contentView.addSubview(outerStackView)
    }
    
    func addConstraints() {
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        buyButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
        
    func configure(with movie: Movie) {
        name.text = movie.title
        subtitle.text = movie.overview
        loadImage(for: movie)
    }
    
    private func loadImage(for movie: Movie) {
        let url = URL(string: imagePath + (movie.backdropPath ?? ""))!
        ImageLoader.shared.loadImage(from: url) { result in
            guard let image = try? result.get() else { return }
            DispatchQueue.main.async { self.imageView.image = image }
        }
    }
}

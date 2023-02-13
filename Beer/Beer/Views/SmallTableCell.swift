//
//  SmallTableCell.swift
//  Beer
//
//  Created by jc.kim on 2/6/23.
//

import UIKit

class SmallTableCell: UICollectionViewCell, ConfigureView, SelfConfigureCell {
    let name = UILabel()
    let imageView = UIImageView()
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
        name.font = UIFont.preferredFont(forTextStyle: .title2)
        name.textColor = .label
        
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        stackView = UIStackView(arrangedSubviews: [name, imageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 20
    }
    
    func addSubviews() {
        contentView.addSubview(stackView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with app: Movie) {
        name.text = app.originalTitle
        imageView.load(urlStr: imagePath + (app.backdropPath ?? ""))
    }
}

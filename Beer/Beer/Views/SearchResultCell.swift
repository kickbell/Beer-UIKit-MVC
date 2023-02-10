//
//  SearchResultCell.swift
//  Beer
//
//  Created by jc.kim on 2/6/23.
//

import UIKit

class SearchResultCell: UITableViewCell, ConfigureView, SelfConfigureCell {
    static let reuseIdentifler = String(describing: SearchResultCell.self)
    
    let image = UIImageView()
    let tagline = UILabel()
    let name = UILabel()
    let desc = UILabel()
    private var innerStackView = UIStackView()
    private var outerStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAttributes()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addAttributes() {
        tagline.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 12, weight: .bold))
        tagline.textColor = .systemBlue
        
        name.font = UIFont.preferredFont(forTextStyle: .title2)
        name.textColor = .label
        
        desc.font = UIFont.preferredFont(forTextStyle: .title3)
        desc.textAlignment = .justified
        desc.numberOfLines = 0
        desc.textColor = .secondaryLabel
        
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        
        innerStackView = UIStackView(arrangedSubviews: [tagline, name, desc])
        innerStackView.axis = .vertical
        
        outerStackView = UIStackView(arrangedSubviews: [image, innerStackView])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.spacing = 10
        outerStackView.axis = .horizontal
        outerStackView.alignment = .top
    }
    
    func addSubviews() {
        contentView.addSubview(outerStackView)
    }
    
    func addConstraints() {
        name.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tagline.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 62),
            image.heightAnchor.constraint(equalToConstant: 62),
            
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            outerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with app: App) {
        tagline.text = app.tagline
        name.text = app.name
        desc.text = app.subheading + app.subheading + app.subheading
        image.image = UIImage(named: app.image)
    }
}

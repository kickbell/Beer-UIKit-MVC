//
//  SectionHeader.swift
//  Beer
//
//  Created by jc.kim on 2/6/23.
//

import UIKit

class SectionHeader: UICollectionViewCell, ConfigureView {
    private let separator = UIView()
    let title = UILabel()
    let subtitle = UILabel()
    var accessoryButton = UIButton(type: .custom)
    var accessoryButtonDidTap: () -> Void = {}
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
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .quaternaryLabel
        
        title.textColor = .label
        title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))
        subtitle.textColor = .secondaryLabel
        
        innerStackView = UIStackView(arrangedSubviews: [separator, title, subtitle])
        innerStackView.axis = .vertical
        
        accessoryButton.setTitleColor(.systemBlue, for: .normal)
        accessoryButton.setImage(UIImage(systemName: "shuffle"), for: .normal)
        accessoryButton.isHidden = true
        accessoryButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        outerStackView = UIStackView(arrangedSubviews: [innerStackView, accessoryButton])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.axis = .horizontal
    }
    
    func addSubviews() {
        addSubview(outerStackView)
    }
    
    func addConstraints() {
        accessoryButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        outerStackView.setCustomSpacing(10, after: separator)
    }
    
    @objc func tap() {
        accessoryButtonDidTap()
    }
}

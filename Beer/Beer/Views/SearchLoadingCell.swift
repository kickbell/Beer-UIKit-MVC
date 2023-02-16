//
//  SearchLoadingCell.swift
//  Beer
//
//  Created by jc.kim on 2/17/23.
//

import UIKit


class SearchLoadingCell: UITableViewCell, ConfigureView {
    static let reuseIdentifler = String(describing: SearchLoadingCell.self)
    
    private let indicatorView = UIActivityIndicatorView()
    
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
        indicatorView.style = .medium
        indicatorView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: frame.height)
    }
        
    func addSubviews() {
        contentView.addSubview(indicatorView)
    }
    
    func addConstraints() {}
    
    func start() {
        indicatorView.startAnimating()
    }
}

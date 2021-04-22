//
//  CollectionViewCell.swift
//  MyChat
//
//  Created by Administrator on 18.04.2021.
//

import UIKit

// MARK: - CollectionViewCell

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    var reuseCellHandler: (() -> Void)?
    
    // MARK: - Private properties
    
    private var activityIndicator: UIActivityIndicatorView!
    
    private var cellImageView = UIImageView()
    
    private let theme = ThemeManager.shared.currentTheme
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let handler = reuseCellHandler { handler() }
        cellImageView.image = nil
        activityIndicator.startAnimating()
    }
    
    // MARK: - Public methods
    
    func configure(with image: UIImage) {
        
        cellImageView.image = image
        activityIndicator.stopAnimating()
    }
}

// MARK: - Setupes

private extension CollectionViewCell {
    
    func setupViews() {
        
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.clipsToBounds = true
        
        activityIndicator = UIActivityIndicatorView(frame: bounds)
        activityIndicator.backgroundColor = theme.backgroundColor
        activityIndicator.color = theme.textColor
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        addSubview(cellImageView)
    }
}

// MARK: - Layout

private extension CollectionViewCell {
    
    func layout() {
        
        var overviewConstraint = [NSLayoutConstraint]()
        
        overviewConstraint += [
            cellImageView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor),
            cellImageView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor),
            cellImageView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor),
            cellImageView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]
        
        overviewConstraint += [
            activityIndicator.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(
                equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(overviewConstraint)
        
        let collectionViews = [cellImageView, activityIndicator]
        
        collectionViews.forEach { $0?.translatesAutoresizingMaskIntoConstraints = false }
    }
}

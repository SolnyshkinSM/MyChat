//
//  SelectImagesViewController.swift
//  MyChat
//
//  Created by Administrator on 18.04.2021.
//

import UIKit

// MARK: - SelectImagesDelegateProtocol

protocol SelectImagesDelegateProtocol: class {
    func imagePickerHandler(image: UIImage)
}

// MARK: - SelectImagesViewController

class SelectImagesViewController: UIViewController {

    // MARK: - Public properties

    var images: [Image]?

    weak var delegate: SelectImagesDelegateProtocol?

    // MARK: - Private properties

    private let theme = ThemeManager.shared.currentTheme

    private var collectionView: UICollectionView!

    private var activityIndicator: UIActivityIndicatorView!

    private let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()

    private let loader: ImageLoaderProtocol = ImageLoader()

    lazy private var collectionViewDataSource: CollectionViewDataSourceProtocol = CollectionViewDataSource(delegate: self, loader: loader)

    private var collectionViewDelegate: CollectionViewDelegateProtocol?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        layout()
    }

    // MARK: - Private methods

    private func loadData() {
        dataFetcherService.fetchImages { [weak self] imagesGroup in
            self?.images = imagesGroup?.hits
            self?.collectionView.reloadData()
            self?.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Setupes

private extension SelectImagesViewController {

    func setupViews() {

        collectionViewDelegate = CollectionViewDelegate(delegate: self, selectImagesDelegate: delegate, loader: loader)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = collectionViewDataSource
        collectionView.delegate = collectionViewDelegate

        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionCellIdentifier)

        view.addSubview(collectionView)

        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.backgroundColor = theme.backgroundColor
        activityIndicator.color = theme.textColor
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}

// MARK: - Layout

private extension SelectImagesViewController {

    func layout() {

        var overviewConstraint = [NSLayoutConstraint]()

        overviewConstraint += [
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]

        overviewConstraint += [
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor)
        ]

        NSLayoutConstraint.activate(overviewConstraint)

        let collectionViews: [UIView?] = [collectionView, activityIndicator]

        collectionViews.forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

// MARK: - UIViewControllerCollectionViewDataSourceProtocol

extension SelectImagesViewController: UIViewControllerCollectionViewDataSourceProtocol {}

// MARK: - Constants

extension SelectImagesViewController {

    enum Constants {
        static let collectionCellIdentifier = "CellCollection"
    }
}

//
//  BrowseViewController.swift
//  BrowsePresentation
//
//  Created by Iacob Zanoci on 19.05.2025.
//

import UIKit

public class BrowseViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: BrowseViewModelProtocol
    
    // MARK: - Views
    
    private lazy var browseFormView: BrowseView = {
        let view = BrowseView(
            onBrowseButtonTapped: { [weak self] in
                self?.viewModel.onBrowse()
            },
            onLikesButtonTapped: { [weak self] in
                self?.viewModel.onLikes()
            },
            onSettingsButtonTapped: { [weak self] in
                self?.viewModel.onSettings()
            },
            onSearchTextChanged: { [weak self] query in
                self?.viewModel.searchQuery = query
            }
        )
        return view
    }()
    
    // MARK: - Initializers
    
    public init(viewModel: BrowseViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Setup
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Piczy.background
        
        browseFormView.collectionView.dataSource = self
        browseFormView.collectionView.delegate = self
        
        bindViewModel()
        updateImageUI()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(browseFormView)
        browseFormView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            browseFormView.topAnchor.constraint(equalTo: view.topAnchor),
            browseFormView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            browseFormView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            browseFormView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Events
    
    private func updateImageUI() {
        browseFormView.collectionView.reloadData()
    }
    
    private func bindViewModel() {
        viewModel.onImagesUpdated = { [weak self] in
            self?.updateImageUI()
        }
    }
}

extension BrowseViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageUrls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        let item = viewModel.imageUrls[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}

extension BrowseViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAt(indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.imageUrls.count - 1 {
            viewModel.fetchImages()
        }
    }
}

extension BrowseViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .small
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .small
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        
        let spacing: CGFloat = .small
        let itemWidth = (collectionView.bounds.width - CGFloat(spacing)) / numberOfItemsPerRow
        
        let aspectRatio: CGFloat = 4.0 / 5.0
        let itemHeight = itemWidth / aspectRatio
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

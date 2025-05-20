//
//  BrowseView.swift
//  BrowsePresentation
//
//  Created by Iacob Zanoci on 19.05.2025.
//

import UIKit
import DesignSystem

public class BrowseView: UIView, UISearchBarDelegate {
    
    
    private enum Constants {
        static let iconsStackTopOffset: CGFloat = 64
        static let tabBarHeight: CGFloat = 84
    }
    
    // MARK: - Properties
    
    private let onBrowseButtonTapped: () -> Void
    private let onLikesButtonTapped: () -> Void
    private let onSettingsButtonTapped: () -> Void
    private let onSearchTextChanged: ((String) -> Void)?
    private var tabButtons: [UIButton] {
        return [browseButton, settingsButton, likesButton]
    }
    
    // MARK: - Views
    
    private lazy var portraitButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .Piczy.primaryText
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .Piczy.primaryText
        button.setImage(UIImage(systemName: "square.grid.2x2.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var iconsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [portraitButton, gridButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = .extraSmall
        stack.alignment = .center
        return stack
    }()
    
    private lazy var browseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Browse"
        label.font = .Piczy.titleBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search..."
        search.searchBarStyle = .minimal
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private lazy var titleSearchStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = .extraSmall
        return stack
    }()
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        return cv
    }()
    
    private lazy var browseButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let title = AttributedString("Browse", attributes: AttributeContainer([
            .font: UIFont.Piczy.caption
        ]))
        config.attributedTitle = title
        config.image = UIImage(systemName: "magnifyingglass.circle.fill")
        config.imagePlacement = .top
        config.imagePadding = .extraSmall
        config.baseForegroundColor = .Piczy.primaryText
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(browseButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let title = AttributedString("Settings", attributes: AttributeContainer([
            .font: UIFont.Piczy.caption
        ]))
        config.attributedTitle = title
        config.image = UIImage(systemName: "gearshape")
        config.imagePlacement = .top
        config.imagePadding = .extraSmall
        config.baseForegroundColor = .Piczy.primaryText
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var likesButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let title = AttributedString("Likes", attributes: AttributeContainer([
            .font: UIFont.Piczy.caption
        ]))
        config.attributedTitle = title
        config.image = UIImage(systemName: "heart")
        config.imagePlacement = .top
        config.imagePadding = .extraSmall
        config.baseForegroundColor = .Piczy.primaryText
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(likesButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tabBarStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [browseButton, likesButton, settingsButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .Piczy.background
        return stackView
    }()
    
    // MARK: - Actions
    
    @objc private func browseButtonTapped() {
        updateTabSelection(selectedButton: browseButton, selectedImage: "magnifyingglass.circle.fill", defaultImages: [
            settingsButton: "gearshape",
            likesButton: "heart"
        ])
        onBrowseButtonTapped()
    }
    
    @objc private func settingsButtonTapped() {
        updateTabSelection(selectedButton: settingsButton, selectedImage: "gearshape.fill", defaultImages: [
            browseButton: "magnifyingglass.circle",
            likesButton: "heart"
        ])
        onSettingsButtonTapped()
    }
    
    @objc private func likesButtonTapped() {
        updateTabSelection(selectedButton: likesButton, selectedImage: "heart.fill", defaultImages: [
            browseButton: "magnifyingglass.circle",
            settingsButton: "gearshape"
        ])
        onLikesButtonTapped()
    }
    
    // MARK: - Events
    
    private func updateTabSelection(selectedButton: UIButton, selectedImage: String, defaultImages: [UIButton: String]) {
        var selectedConfig = selectedButton.configuration
        selectedConfig?.image = UIImage(systemName: selectedImage)
        selectedButton.configuration = selectedConfig
        
        for (button, imageName) in defaultImages {
            var config = button.configuration
            config?.image = UIImage(systemName: imageName)
            button.configuration = config
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onSearchTextChanged?(searchText)
    }
    
    // MARK: - Initializers
    
    init(onBrowseButtonTapped: @escaping () -> Void,
         onLikesButtonTapped: @escaping () -> Void,
         onSettingsButtonTapped: @escaping () -> Void,
         onSearchTextChanged: ((String) -> Void)?
         
    ) {
        self.onBrowseButtonTapped = onBrowseButtonTapped
        self.onLikesButtonTapped = onLikesButtonTapped
        self.onSettingsButtonTapped = onSettingsButtonTapped
        self.onSearchTextChanged = onSearchTextChanged
        
        super.init(frame: .zero)
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) not implemented.")
    }
    
    // MARK: - Layout Setup
    
    private func setupViewLayout() {
        titleSearchStackView.addArrangedSubview(browseTitleLabel)
        titleSearchStackView.addArrangedSubview(searchBar)
        
        addSubview(collectionView)
        addSubview(tabBarStackView)
        addSubview(iconsStackView)
        addSubview(titleSearchStackView)
        
        let stackViewConstraints = [
            browseTitleLabel.leadingAnchor.constraint(equalTo: titleSearchStackView.leadingAnchor, constant: .medium),
            
            searchBar.leadingAnchor.constraint(equalTo: titleSearchStackView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: titleSearchStackView.trailingAnchor),
            
            gridButton.widthAnchor.constraint(equalToConstant: .large),
            gridButton.heightAnchor.constraint(equalToConstant: .large),
            
            portraitButton.widthAnchor.constraint(equalToConstant: .large),
            portraitButton.heightAnchor.constraint(equalToConstant: .large),
            
            iconsStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.iconsStackTopOffset),
            iconsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.medium),
            
            titleSearchStackView.topAnchor.constraint(equalTo: iconsStackView.bottomAnchor, constant: .small),
            titleSearchStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .small),
            titleSearchStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.small),
            
            collectionView.topAnchor.constraint(equalTo: titleSearchStackView.bottomAnchor, constant: .medium),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .medium),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.medium),
            collectionView.bottomAnchor.constraint(equalTo: tabBarStackView.topAnchor, constant: -.extraSmall),
            
            tabBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: Constants.tabBarHeight),
            
            browseButton.leadingAnchor.constraint(equalTo: tabBarStackView.leadingAnchor, constant: .medium),
            settingsButton.trailingAnchor.constraint(equalTo: tabBarStackView.trailingAnchor, constant: .medium),
            
            browseButton.topAnchor.constraint(equalTo: tabBarStackView.topAnchor, constant: .extraSmall),
            settingsButton.topAnchor.constraint(equalTo: tabBarStackView.topAnchor, constant: .extraSmall),
            likesButton.topAnchor.constraint(equalTo: tabBarStackView.topAnchor, constant: .extraSmall)
        ]
        NSLayoutConstraint.activate(stackViewConstraints)
    }
}

extension BrowseView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: .small, bottom: 0, right: .small)
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
        let interItemSpacing: CGFloat = .small
        let sectionInsets: CGFloat = .small * numberOfItemsPerRow
        
        let totalSpacing = sectionInsets + (interItemSpacing * (numberOfItemsPerRow - 1))
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        
        let aspectRatio: CGFloat = 4.0 / 5.0
        let itemHeight = itemWidth / aspectRatio
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

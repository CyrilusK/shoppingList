//
//  CatalogViewController.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

final class CatalogViewController: UIViewController, CatalogViewInputProtocol {
    var output: CatalogOutputProtocol?
    
    private var items: [Item] = []
    private let indicatorLoading = UIActivityIndicatorView(style: .medium)
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let emptyStateLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func setupIndicator() {
        view.backgroundColor = .systemGroupedBackground
        indicatorLoading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicatorLoading)
        indicatorLoading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorLoading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicatorLoading.startAnimating()
    }
    
    func setupUI() {
        indicatorLoading.stopAnimating()
        setupCollectionView()
        setupEmptyStateLabel()
        setupRetryButton()
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemGroupedBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: K.reuseIdentifier)
    }
    
    private func setupEmptyStateLabel() {
        emptyStateLabel.text = "Не найдено"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .gray
        emptyStateLabel.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        emptyStateLabel.isHidden = true
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupRetryButton() {
        retryButton.setTitle("Ошибка загрузки данных", for: .normal)
        retryButton.addTarget(self, action: #selector(tapRetryButton), for: .touchUpInside)
        view.addSubview(retryButton)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            retryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func tapRetryButton() {
        retryButton.isHidden = true
        indicatorLoading.startAnimating()
        output?.reloadItems()
    }
    
    func showItems(_ items: [Item]) {
        self.items = items
        collectionView.reloadData()
        collectionView.isHidden = items.isEmpty
        emptyStateLabel.isHidden = !items.isEmpty
        retryButton.isHidden = true
    }
    
    func showError(_ message: String) {
        print("[DEBUG] Error: \(message)")
        collectionView.isHidden = true
        retryButton.isHidden = false
        indicatorLoading.stopAnimating()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > collectionView.contentSize.height - 100 - scrollView.frame.size.height {
            output?.pagination()
        }
    }
    
    func appendItems(_ newItems: [Item]) {
        let startIndex = items.count
        items.append(contentsOf: newItems)
        let indexPaths = (startIndex..<items.count).map { IndexPath(row: $0, section: 0) }
        collectionView.insertItems(at: indexPaths)
    }
}

extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.reuseIdentifier, for: indexPath) as? ItemCell else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(with: item)
        output?.getImage(item.images.first) { image in
            cell.updateImage(image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width / 2) - 15
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}

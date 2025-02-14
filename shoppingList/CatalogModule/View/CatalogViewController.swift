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
    private let searchBar = UISearchBar()
    private let historyTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        setupSearchBar()
        setupCollectionView()
        setupEmptyStateLabel()
        setupRetryButton()
        setupHistoryTableView()
    }
    
    private func setupHistoryTableView() {
        historyTableView.isHidden = true
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyTableView)
        NSLayoutConstraint.activate([
            historyTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.heightAnchor.constraint(equalToConstant: 220)
        ])
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
    }
    
    private func setupSearchBar() {
        searchBar.searchTextField.backgroundColor = .systemGroupedBackground
        searchBar.searchTextField.textColor = .black
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = K.textPlaceholderSearchBar
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        searchBar.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemGroupedBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: K.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupEmptyStateLabel() {
        emptyStateLabel.text = K.notFound
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
        retryButton.setTitle(K.errorLoading, for: .normal)
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        historyTableView.isHidden = true
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
    
    func updateSearchHistory(_ history: [String]) {
        historyTableView.isHidden = history.isEmpty
        historyTableView.reloadData()
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

extension CatalogViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        historyTableView.isHidden = false
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            output?.didSearchTextChange(text)
        }
        searchBar.resignFirstResponder()
        historyTableView.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            output?.reloadItems()
            dismissKeyboard()
        } else {
            historyTableView.isHidden = false
        }
    }
}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.getSearchHistory().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        if let searchHistory = output?.getSearchHistory() {
            var cellContext = cell.defaultContentConfiguration()
            cellContext.text = searchHistory[indexPath.row]
                cell.contentConfiguration = cellContext
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchHistory = output?.getSearchHistory() {
            searchBar.text = searchHistory[indexPath.row]
            searchBarSearchButtonClicked(searchBar)
        }
    }
}

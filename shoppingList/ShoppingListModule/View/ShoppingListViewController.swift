//
//  ShoppingListViewController.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

final class ShoppingListViewController: UIViewController, ShoppingListViewInputProtocol {
    var output: ShoppingListOutputProtocol?
    
    private let tableView = UITableView()
    private let clearButton = UIButton()
    private let shareButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    func setupUI() {
        title = "Список покупок"
        view.backgroundColor = .systemGroupedBackground
        setupTableView()
        setupButtons()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(ShoppingItemCell.self, forCellReuseIdentifier: K.shoppingItemCell)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func setupButtons() {
        let clearBarButton = UIBarButtonItem(image: UIImage(systemName: K.trashFill), style: .plain, target: self, action: #selector(clearList))
        let shareBarButton = UIBarButtonItem(image: UIImage(systemName: K.shareButtonImage), style: .plain, target: self, action: #selector(shareList))
        navigationItem.rightBarButtonItems = [clearBarButton, shareBarButton]
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func shareText(_ text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc private func clearList() {
        output?.clearList()
    }
        
    @objc private func shareList() {
        output?.shareList()
    }
}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.getItems().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.shoppingItemCell, for: indexPath) as? ShoppingItemCell else {
            return UITableViewCell()
        }
        guard let item = output?.getItems()[indexPath.row] else { return cell }
        cell.configure(with: item)
        output?.getImage(item.image) { image in
            cell.updateImage(image)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completionHandler in
            self?.output?.deleteItem(at: indexPath.row)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: K.trashFill)
        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ShoppingListViewController: ShoppingItemCellDelegate {
    func didTapIncreaseQuantity(in cell: ShoppingItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            output?.increaseQuantity(at: indexPath.row)
        }
    }

    func didTapDecreaseQuantity(in cell: ShoppingItemCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            output?.decreaseQuantity(at: indexPath.row)
        }
    }
}

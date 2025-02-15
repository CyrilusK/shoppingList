//
//  ViewController.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

class FilterViewController: UIViewController, FilterViewInputProtocol {
    var output: FilterOutputProtocol?
    
    private let headerLabel = UILabel()
    private let titleLabel = UILabel()
    private let categoriesLabel = UILabel()
    private let priceLabel = UILabel()
    private let titleTextField = UITextField()
    private let minPriceTextField = UITextField()
    private let maxPriceTextField = UITextField()
    private let priceTextField = UITextField()
    private let applyButton = UIButton(type: .system)
    private let cleanButton = UIButton(type: .system)
    
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }

    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        setupHeaderLabel()
        setupTitleLabel()
        setupCategoriesLabel()
        setupCategoryCollectionView()
        setupPriceLabel()
        setupTitleTextField()
        setupMinPriceTextField()
        setupMaxPriceTextField()
        setupPriceTextField()
        setupApplyButton()
        setupCleanButton()
        setupStackView()
        populateFieldsFromParams()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupHeaderLabel() {
        headerLabel.text = "Фильтры"
        headerLabel.font = .boldSystemFont(ofSize: 20)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Как называется товар"
        titleLabel.font = .boldSystemFont(ofSize: 18)
    }
    
    private func setupCategoriesLabel() {
        categoriesLabel.text = "Все категории"
        categoriesLabel.font = .boldSystemFont(ofSize: 18)
    }
    
    private func setupPriceLabel() {
        priceLabel.text = "Цена"
        priceLabel.font = .boldSystemFont(ofSize: 18)
    }

    private func setupCategoryCollectionView() {
        categoriesCollectionView.backgroundColor = .systemGroupedBackground
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: K.categoryCell)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
    }
    
    private func setupTitleTextField() {
        titleTextField.placeholder = "Название"
        titleTextField.borderStyle = .roundedRect
        titleTextField.keyboardType = .default
        titleTextField.autocorrectionType = .no
        titleTextField.delegate = self
    }
    
    private func setupMinPriceTextField() {
        minPriceTextField.placeholder = "От"
        minPriceTextField.borderStyle = .roundedRect
        minPriceTextField.keyboardType = .decimalPad
    }
    
    private func setupMaxPriceTextField() {
        maxPriceTextField.placeholder = "До"
        maxPriceTextField.borderStyle = .roundedRect
        maxPriceTextField.keyboardType = .decimalPad
    }
    
    private func setupPriceTextField() {
        priceTextField.placeholder = "Цена"
        priceTextField.borderStyle = .roundedRect
        priceTextField.keyboardType = .decimalPad
    }
    
    private func setupApplyButton() {
        applyButton.setTitle("Применить", for: .normal)
        applyButton.backgroundColor = .black
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.layer.cornerRadius = 8
        applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
    }
    
    private func setupCleanButton() {
        cleanButton.setTitle("Очистить фильтры", for: .normal)
        cleanButton.backgroundColor = .black
        cleanButton.setTitleColor(.white, for: .normal)
        cleanButton.layer.cornerRadius = 8
        cleanButton.addTarget(self, action: #selector(cleanFilters), for: .touchUpInside)
    }
    
    private func setupStackView() {
        let priceStackView = UIStackView(arrangedSubviews: [minPriceTextField, maxPriceTextField])
        priceStackView.axis = .horizontal
        priceStackView.spacing = 8
        priceStackView.distribution = .fillEqually
        
        let mainStackView = UIStackView(arrangedSubviews: [
            headerLabel,
            titleLabel,
            titleTextField,
            categoriesLabel,
            categoriesCollectionView,
            priceLabel,
            priceStackView,
            priceTextField,
            applyButton,
            cleanButton
        ])
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 15
        view.addSubview(mainStackView)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40 * 10 / 4.5)
        ])
    }
    
    private func populateFieldsFromParams() {
        let params = output?.getParams() ?? [:]
        
        if let title = params[K.title] {
            titleTextField.text = title
        }
        if let minPrice = params[K.priceMin] {
            minPriceTextField.text = minPrice
        }
        if let maxPrice = params[K.priceMax] {
            maxPriceTextField.text = maxPrice
        }
        if let price = params[K.price] {
            priceTextField.text = price
        }
        if let categoryId = params[K.categoryId], let category = Categories(rawValue: Int(categoryId) ?? 1) {
            output?.toggleCategory(category)
        }
    }
    
    @objc private func applyFilters() {
        output?.applyFilters(
            title: titleTextField.text,
            minPrice: minPriceTextField.text,
            maxPrice: maxPriceTextField.text,
            price: priceTextField.text)
        //dismiss(animated: true)
    }
    
    @objc private func cleanFilters() {
        titleTextField.text = ""
        minPriceTextField.text = ""
        maxPriceTextField.text = ""
        priceTextField.text = ""
        output?.cleanFilters()
        categoriesCollectionView.reloadData()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showInvalidPriceAlert(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.categoryCell, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        let category = Categories.allCases[indexPath.item]
        cell.configure(with: category.name)
        cell.layer.cornerRadius = 10
        
        if category == output?.selectedCategory {
            cell.backgroundColor = .link
        } else {
            cell.backgroundColor = .systemBackground
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = Categories.allCases[indexPath.item].name
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let textWidth = text.size(withAttributes: [.font: font]).width + 24
        let cellWidth = min(textWidth, collectionView.frame.width - 40)
        let cellHeight: CGFloat = 40
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
        let category = Categories.allCases[indexPath.item]
        
        cell.backgroundColor = .link
        output?.toggleCategory(category)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
        cell.backgroundColor = .lightText
    }
}

extension FilterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//
//  ViewController.swift
//  shoppingList
//
//  Created by Cyril Kardash on 13.02.2025.
//

import UIKit

class FilterViewController: UIViewController {
    
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
    private let categories = ["Одежда", "Электроника", "Мебель", "Обувь", "Разное", "Ноутбуки", "Аксессуары"]
    
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
    @objc private func applyFilters() {
        dismiss(animated: true)
    }
    
    @objc private func cleanFilters() {
        titleTextField.text = ""
        minPriceTextField.text = ""
        maxPriceTextField.text = ""
        priceTextField.text = ""
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.categoryCell, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: categories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = categories[indexPath.item]
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        let textWidth = text.size(withAttributes: [.font: font]).width + 24
        let cellWidth = min(textWidth, collectionView.frame.width - 40)
        let cellHeight: CGFloat = 40
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
        
        cell.backgroundColor = .link
        cell.layer.cornerRadius = 10
    }
}

extension FilterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


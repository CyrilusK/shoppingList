//
//  ProductDetailViewController.swift
//  shoppingList
//
//  Created by Cyril Kardash on 15.02.2025.
//

import UIKit

final class ProductDetailViewController: UIViewController, ProductViewInputProtocol {
    var output: ProductOutputProtocol?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let categoryLabel = UILabel()
    private let shareButton = UIButton(type: .system)
    private let addToListButton = UIButton(type: .system)
    private let quantityStackView = UIStackView()
    private let minusButton = UIButton(type: .system)
    private let quantityLabel = UILabel()
    private let plusButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupUI(_ item: Item) {
        view.backgroundColor = .systemGroupedBackground
        setupScrollView()
        setupContentView()
        setupImageView()
        setupDescriptionLabel()
        setupPriceLabel()
        setupCategoryLabel()
        setupShareButton()
        setupAddToListButton()
        setupMinusButton()
        setupPlusButton()
        setupQuantityLabel()
        setupQuantityButtonsStackView()
        displayProductDetails(item)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupPriceLabel() {
        priceLabel.font = .boldSystemFont(ofSize: 20)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    
    private func setupCategoryLabel() {
        categoryLabel.font = .italicSystemFont(ofSize: 16)
        categoryLabel.textColor = .darkGray
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    
    private func setupShareButton() {
        shareButton.setImage(UIImage(systemName: K.shareButtonImage), for: .normal)
        let shareBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareProduct))
        navigationItem.rightBarButtonItem = shareBarButton
    }
    
    private func setupAddToListButton() {
        addToListButton.setTitle("Добавить в список", for: .normal)
        addToListButton.backgroundColor = .systemBlue
        addToListButton.setTitleColor(.white, for: .normal)
        addToListButton.layer.cornerRadius = 8
        addToListButton.addTarget(self, action: #selector(addToShoppingList), for: .touchUpInside)
        addToListButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addToListButton)
        NSLayoutConstraint.activate([
            addToListButton.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            addToListButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addToListButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2),
            addToListButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func setupMinusButton() {
        minusButton.setTitle("-", for: .normal)
        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
    }
    
    private func setupPlusButton() {
        plusButton.setTitle("+", for: .normal)
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
    }
    
    private func setupQuantityLabel() {
        quantityLabel.text = "1"
        quantityLabel.textAlignment = .center
        quantityLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupQuantityButtonsStackView() {
        quantityStackView.axis = .horizontal
        quantityStackView.distribution = .fillEqually
        quantityStackView.spacing = 10
        quantityStackView.addArrangedSubview(minusButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(plusButton)
        quantityStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(quantityStackView)
        NSLayoutConstraint.activate([
            quantityStackView.topAnchor.constraint(equalTo: addToListButton.bottomAnchor, constant: 20),
            quantityStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            quantityStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func displayProductDetails(_ item: Item) {
        title = item.title
        descriptionLabel.text = item.description
        priceLabel.text = "\(item.price) $"
        categoryLabel.text = Categories.init(rawValue: item.category.id)?.name
        output?.getImage(item.images.last, completion: { image in
            DispatchQueue.main.async {
                guard let image = image else {
                    self.imageView.image = UIImage(systemName: K.photo)
                    return
                }
                self.imageView.image = image
            }
        })
    }
    
    func updateUI(quantity: Int) {
        quantityLabel.text = "\(quantity)"
        let buttonTitle = quantity > 0 ? "К списку покупок" : "Добавить в список"
        addToListButton.setTitle(buttonTitle, for: .normal)
    }
    
    @objc private func shareProduct() {
        let text = "\(descriptionLabel.text ?? "Товар")"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc private func addToShoppingList() {
        output?.handleAddToListTapped()
    }
    
    @objc private func decreaseQuantity() {
        if let quantity = Int(quantityLabel.text ?? "1"), quantity > 1 {
            quantityLabel.text = "\(quantity - 1)"
            output?.updateQuantity(quantity)
        }
    }
    
    @objc private func increaseQuantity() {
        if let quantity = Int(quantityLabel.text ?? "1") {
            quantityLabel.text = "\(quantity + 1)"
            output?.updateQuantity(quantity)
        }
    }
}


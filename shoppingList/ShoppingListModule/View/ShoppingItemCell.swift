//
//  ShoppingItemCell.swift
//  shoppingList
//
//  Created by Cyril Kardash on 16.02.2025.
//

import UIKit

final class ShoppingItemCell: UITableViewCell {
    weak var delegate: ShoppingItemCellDelegate?

    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let quantityLabel = UILabel()
    private let decreaseButton = UIButton(type: .system)
    private let increaseButton = UIButton(type: .system)
    private let quantityStackView = UIStackView()
    private let infoStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        setupImageView()
        setupInfoStackView()
        setupQuantityControls()
    }

    private func setupImageView() {
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(itemImageView)

        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            itemImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 50),
            itemImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupInfoStackView() {
        infoStackView.axis = .vertical
        infoStackView.spacing = 4
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoStackView)

        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        priceLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)

        let priceWeightStack = UIStackView(arrangedSubviews: [priceLabel])
        priceWeightStack.axis = .horizontal
        priceWeightStack.spacing = 8

        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(priceWeightStack)

        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 12),
            infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupQuantityControls() {
        quantityStackView.axis = .horizontal
        quantityStackView.spacing = 5
        quantityStackView.alignment = .center
        quantityStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(quantityStackView)

        decreaseButton.setTitle("−", for: .normal)
        decreaseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        decreaseButton.tintColor = .black
        decreaseButton.backgroundColor = .systemGray6
        decreaseButton.layer.cornerRadius = 8
        
        increaseButton.setTitle("+", for: .normal)
        increaseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        increaseButton.tintColor = .black
        increaseButton.backgroundColor = .systemGray6
        increaseButton.layer.cornerRadius = 8
        
        quantityLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        quantityLabel.textAlignment = .center

        quantityStackView.addArrangedSubview(decreaseButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(increaseButton)

        NSLayoutConstraint.activate([
            quantityStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            quantityStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 20),
            decreaseButton.heightAnchor.constraint(equalToConstant: 20),
            increaseButton.widthAnchor.constraint(equalToConstant: 20),
            increaseButton.heightAnchor.constraint(equalToConstant: 20),
            quantityLabel.widthAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(with item: ShoppingItemEntity) {
        titleLabel.text = item.title
        priceLabel.text = "\(item.price) $"
        quantityLabel.text = "\(item.quantity)"
    }
    
    func updateImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            guard let image = image else {
                self.imageView?.image = UIImage(systemName: K.photo)
                return
            }
            self.imageView?.image = image
        }
    }
}


//
//  DetailWordViewController.swift
//  WordApi
//
//  Created by Alexey Manokhin on 31.10.2023.
//

import UIKit

final class DetailWordViewController: UIViewController {
    
    var word: Word?
    
    private let networkManager = NetworkManager.shared
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 32)
        label.text = word?.value
        return label
    }()
    
    lazy var clarificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = word?.clarification
        return label
    }()
    
    lazy var photoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: word?.photo ?? "")
        return image
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.9333333333, blue: 0.937254902, alpha: 1)
        button.tintColor = #colorLiteral(red: 0.3538226783, green: 0.5200884938, blue: 0.5973373055, alpha: 1)
        button.alpha = 0.9
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9446846843, green: 0.9776129127, blue: 0.9872179627, alpha: 1)
        setupView()
        setupConstraint()
        fetchImage()
    }
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
    }
    
    private func setupView() {
        [photoImageView, activityIndicator, closeButton, scrollView].forEach(
            { view.addSubview($0) }
        )
        scrollView.addSubview(contentView)
        [valueLabel, clarificationLabel].forEach(
            { contentView.addSubview($0) }
        )
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: view.bounds.width),
            photoImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            
            activityIndicator.centerXAnchor.constraint(equalTo: photoImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            valueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            
            clarificationLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 20),
            clarificationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            clarificationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            clarificationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            
        ])
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

extension DetailWordViewController {
    private func fetchImage() {
        guard let urlPhoto = URL(string: word?.photo ?? "") else { return }
        networkManager.fetchImage(from: urlPhoto) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.photoImageView.image = UIImage(data: imageData)
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
}


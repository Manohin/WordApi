//
//  WordDayViewController.swift
//  WordApi
//
//  Created by Alexey Manokhin on 31.10.2023.
//

import UIKit
final class WordDayViewController: UIViewController {
    
    var words: [Word] = []
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
        return label
    }()
    
    lazy var clarificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var photoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9446846843, green: 0.9776129127, blue: 0.9872179627, alpha: 1)
        title = "Слово дня"
        setupView()
        setupConstraint()
        fetchWord()
    }
    
    private func setupView() {
        [photoImageView, activityIndicator, scrollView].forEach(
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
}

extension WordDayViewController {
    private func fetchWord() {
        URLSession.shared.dataTask(with: urlAPI) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let wordData = try decoder.decode(WordData.self, from: data)
                guard let dayWord = wordData.data.last else {
                    print("No words found")
                    return
                }
                self?.word = dayWord
                self?.updateInterface(with: dayWord)
                self?.fetchImage(with: dayWord)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func updateInterface(with word: Word) {
        DispatchQueue.main.async { [weak self] in
            self?.valueLabel.text = word.value
            self?.clarificationLabel.text = word.clarification
            self?.photoImageView.image = UIImage(named: word.photo)
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func fetchImage(with word: Word) {
        guard let urlPhoto = URL(string: word.photo ) else { return }
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




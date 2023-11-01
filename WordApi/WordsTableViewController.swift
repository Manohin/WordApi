//
//  ViewController.swift
//  WordApi
//
//  Created by Alexey Manokhin on 31.10.2023.
//

import UIKit

final class WordsTableViewController: UITableViewController {
    
    var words: [Word] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9446846843, green: 0.9776129127, blue: 0.9872179627, alpha: 1)
        tableView.separatorColor = #colorLiteral(red: 0.3538226783, green: 0.5200884938, blue: 0.5973373055, alpha: 1)
        title = "Список слов"
        registerCell()
        fetchWord()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WordCell.id, for: indexPath)
        guard let cell = cell as? WordCell else { return UITableViewCell() }
        
        cell.valueLabel.text = words[indexPath.row].value
        cell.dateLabel.text = words[indexPath.row].date
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailWordViewController()
        let word = words[indexPath.row]
        detailVC.word = word
        
        present(detailVC, animated: true)
    }
    
    private func registerCell() {
        tableView.register(WordCell.self, forCellReuseIdentifier: WordCell.id)
    }
}

extension WordsTableViewController {
    private func fetchWord() {
        URLSession.shared.dataTask(with: urlAPI) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let wordData = try decoder.decode(WordData.self, from: data)
                self?.words = wordData.data.reversed()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

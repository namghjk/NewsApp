//
//  ViewController.swift
//  NewsApp
//
//  Created by namghjk on 18/07/2022.
//

import UIKit
import SafariServices


//TableView
//Custom Cell
//API Caller
//Open news story
//search for news stories

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title="news"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
       fetchTopStories()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchTopStories(){
        APICaller.shared.getTopStories {[weak self]result in
            switch result{
            case.success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                NewsTableViewCellViewModel(
                    title: $0.title,
                    subtitle: $0.description ?? "No description " ,
                    imageURL: URL(string: $0.urlToImage ?? "")
                )
            })
                
                DispatchQueue.main.sync {
                    self?.tableView.reloadData()
                }
                
            case.failure(let error):
                print(error)
            }
        }
    }
    

    //Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
        as? NewsTableViewCell else{
            fatalError()
        }
        cell.configure(with: viewModels[indexPath .row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:  true)
        let artilce = articles[indexPath.row]
        
        guard let url = URL(string: artilce.url ?? "")else{
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}


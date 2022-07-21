//
//  APICaller.swift
//  NewsApp
//
//  Created by namghjk on 18/07/2022.
//

import Foundation


final class APICaller{
    static let shared = APICaller()
    
    struct Constains{
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2022-06-21&sortBy=publishedAt&apiKey=c79fa879b12441329c169a15bcee5c50")
    }
    
    
    private init(){}
    
    public func getTopStories(completion : @escaping (Result<[Article],Error>) -> Void){
        guard let url = Constains.topHeadLinesURL else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data =  data{
                
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles : \(result.articles.count)")
                    
                completion(.success(result.articles))
                }
                catch{
                    print(error)
                }
                
            }
        }
        task.resume()
    }
}

//Models

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title:String
    let description:String?
    let url:String?
    let urlToImage:String?
    let publishedAt:String
}

struct Source: Codable{
    let name: String
}

//
//  DataProvider.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation

protocol JSONInitiable {
    init?(dict: JSONDictionary)
}

final class DataProvider {
    private let webService = WebService()
    
    /// This method recieves an Endpoint object that describes the URL that's going to be called
    /// and a completion that will be called when the API returns a response. The Type of the completion
    /// is generic, this way we can use the same function to perform every network call, by just
    /// changing the Type in the call site. The Type of T must be JSONInitiable, that means that
    /// has to conform the JSONInitiable protocol.
    func getMultiple<T: JSONInitiable>(_ endpoint: Endpoint, completion: @escaping CompletionType<[T]>) {
        webService.request(endpoint: endpoint) { result in
            switch result {
            case .isSuccess(let json):
                guard let json = json as? JSONDictionary,
                    let results = json["articles"] as? JSONArray else {
                    completion(Result.isFailure(FutureError.response(.malformedJSON)))
                    return
                }
                
                let articles = results.flatMap{ T(dict: $0) }
                DispatchQueue.main.async { // The completion handlers will run on the main thread
                    completion(Result.isSuccess(articles))
                }
            case .isFailure(let error):
                DispatchQueue.main.async {
                    completion(Result.isFailure(error))
                }
            }
        }
    }
    
    func getSingle<T: JSONInitiable>(_ endpoint: Endpoint, completion: @escaping CompletionType<T>) {
        webService.request(endpoint: endpoint) { result in
            switch result {
            case .isSuccess(let json):
                guard let json = json as? JSONDictionary, let article = T(dict: json) else {
                        completion(Result.isFailure(FutureError.response(.malformedJSON)))
                        return
                }
                
                DispatchQueue.main.async {
                    completion(Result.isSuccess(article))
                }
            case .isFailure(let error):
                DispatchQueue.main.async {
                    completion(Result.isFailure(error))
                }
            }
        }
    }
}

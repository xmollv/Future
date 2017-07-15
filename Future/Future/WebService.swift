//
//  WebService.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

final class WebService {
    
    private enum HTTPMethod: String {
        case get = "GET"
    }
    
    // Network activity indicator count and queue
    private var numberOfCallsToSetVisible = 0
    private let activityIndicatorQueue = DispatchQueue(label: "com.future.networkIndicator")
    
    private func load(url: String, httpMethod: HTTPMethod = .get, completion: @escaping CompletionType<Data?>) {
        Logger.log(message: url, event: .debug)
        activityIndicatorQueue.sync {
            self.setNetworkActivityVisible(true)
        }
        
        // Return an error if the URL string that the call site sends us can not be converted to an URL
        guard let endpoint = URL(string: url) else {
            completion(Result.isFailure(FutureError.request(.malformedURL)))
            return
        }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = httpMethod.rawValue
        
        // Add aditional headers to the HTTP request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            self.activityIndicatorQueue.sync {
                self.setNetworkActivityVisible(false)
            }
            
            // Error found, return early
            if let error = error {
                completion(Result.isFailure(error))
                return
            }
            
            completion(self.parseHTTPCode(response: response, data: data))
        }
        
        task.resume()
    }
    
    //MARK:- Network activity indicator visibility
    /// Handles the network activity indicator using a serial queue in the background
    private func setNetworkActivityVisible(_ visible: Bool) {
        if visible {
            numberOfCallsToSetVisible += 1
        } else {
            numberOfCallsToSetVisible -= 1
        }
        
        let shouldBeVisible = numberOfCallsToSetVisible > 0
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = shouldBeVisible
        }
    }
    
    //MARK:- Default HTTP code parser
    /// Checks the HTTP code and tries to return the data or create a custom error
    private func parseHTTPCode(response: URLResponse?, data: Data?) -> Result<Data?> {
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200...299:
                return Result.isSuccess(data)
            case 400...499:
                return Result.isFailure(FutureError.response(.badRequest))
            case 500...599:
                return Result.isFailure(FutureError.response(.internalServerError))
            default:
                // Cases 100...199, 300...399 are not being handled right now to develop the app faster
                return Result.isFailure(FutureError.response(.invalidStatusCode))
            }
        } else {
            return Result.isFailure(FutureError.response(.noHTTPURLResponse))
        }
    }
    
    //MARK:- Default JSON parser
    /// Gets the response from the server and tries to parse it into a JSON object
    private func parseResponse(networkResult: Result<Data?>) -> Result<Any?> {
        switch networkResult {
        case .isSuccess(let data):
            guard let data = data else { return Result.isSuccess(nil) }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                return Result.isSuccess(json)
            } catch (let error) {
                return Result.isFailure(error)
            }
        case .isFailure(let error):
            return Result.isFailure(error)
        }
    }
    
    // Default method to perform network requests based on the endpoint provided
    func request(endpoint: Endpoint, completion: @escaping CompletionType<Any?>) {
        load(url: endpoint.path) { networkResult in
            completion(self.parseResponse(networkResult: networkResult))
        }
    }
}

// Handy typealiases to reduce the methods signature
typealias CompletionType<T> = (Result<T>) -> ()
typealias JSONDictionary = Dictionary<String,Any>
typealias JSONArray = Array<JSONDictionary>

// This is what the completion handlers will return, making it extremely
// easy to switch between the two states of an API response
enum Result<T> {
    case isSuccess(T)
    case isFailure(Error)
}

// This enum describes the endpoints that will be called by the App, reducing the
// method signature at the call site
enum Endpoint {
    case news
    case newsDetails(id: Int)
    
    var path: String {
        let baseUrl = "https://s3.amazonaws.com/future-workshops"
        switch self {
        case .news:
            return "\(baseUrl)/fw-coding-test.json"
        case .newsDetails(let id):
            return "\(baseUrl)/\(id).json"
        }
    }
}

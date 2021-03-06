//
//  FutureError.swift
//  Future
//
//  Created by Xavi Moll on 15/07/2017.
//  Copyright © 2017 Xavi Moll. All rights reserved.
//

import Foundation
import UIKit

enum FutureError: Error {
    case request(RequestError)
    case response(ResponseError)
    
    enum RequestError {
        case malformedURL
    }
    
    enum ResponseError {
        case malformedJSON
        case invalidStatusCode
        case noHTTPURLResponse
        case badRequest
        case internalServerError
    }
    
    // We should handle the errors correctly, for now we just display an error to let the user know that something went wrong
    /// This method handles the errors returned by the API or the errors thrown by the JSON deserialization process
    static func handle(error: Error, onCurrentViewController vc: UIViewController) {
        Logger.log(message: "\(error)", event: .error)
        
        func showAlert(message: String = "Something went wrong.") {
            let alert = UIAlertController(title: "Woops!", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
        
        if let error = error as? FutureError {
            switch error {
            case .request(let requestError):
                switch requestError {
                case .malformedURL:
                    showAlert(message: "The request URL was invalid. Please, try again.")
                }
            case .response(let responseError):
                switch responseError {
                case .malformedJSON:
                    showAlert(message: "The JSON returned was malformed. Please, try again.")
                case .invalidStatusCode:
                    showAlert(message: "The HTTP code that the API returned is not valid or correctly handled. Please, try again.")
                case .noHTTPURLResponse:
                    showAlert(message: "The request did not contain an HTTPURLResponse. Please, try again.")
                case .badRequest:
                    showAlert(message: "The server decided that the request was not valid. Please, try again.")
                case .internalServerError:
                    showAlert(message: "The server returned an internal error. Please, try again.")
                }
            }
        } else {
            showAlert()
        }
        
        
    }
}

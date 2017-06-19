//
//  HttpClient.swift
//  Locations
//
//  Created by Toheed Khan on 09/06/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import Foundation

enum HttpClientError: Error {
    
    case Unknown
    case FailedRequest
    case InvalidResponse(reason: String)
    case InvalidURL
    
}
typealias LocationDataCompletion = (Data?, URLResponse?, Error?) -> Void

class HttpClient {
    private let baseURL = "https://localsearch.azurewebsites.net/api/"
    
    func getRequest(url: String, completion:@escaping LocationDataCompletion) {
        
        guard let requestURL = URL(string: baseURL + url) else {
            print("Error: cannot create URL")
            completion(nil, nil, HttpClientError.InvalidURL)
            return
        }
        let request = NSMutableURLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: completion).resume()
   
  }
}



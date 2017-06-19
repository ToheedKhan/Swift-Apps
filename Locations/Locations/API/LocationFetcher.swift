//
//  LocationFetcher.swift
//  Locations
//
//  Created by Toheed Khan on 08/06/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import Foundation

final class LocationFetcher {
    
    //MARK: Shared instance
    
    static let sharedInstance : LocationFetcher = {
        let instance = LocationFetcher()
        return instance
    }()
    
    //MARK: Local Variable
    
    let apiRoute: String = "Locations"
    
    var httpClient : HttpClient
    
    //MARK: Init
    
    private convenience init() {
        self.init(httpClient : HttpClient())
    }
    
    private init( httpClient : HttpClient) {
        self.httpClient = httpClient
    }
    
    public func fetchLocations(completion:@escaping(Array<AnyObject>?, Error?) -> Void) {
        
        self.httpClient.getRequest(url: self.apiRoute) { (data, response, error) in
            
            guard let locationData :Data = data, let httpResponse:HTTPURLResponse = response as? HTTPURLResponse  , error == nil else {
                completion(nil, error)
                return
            }
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                print("Location data recieved")
                
               self.processLocationData(data: locationData, completion: completion)
    
            }
            else {
                ///create failed response error and cal completion handler
            }            
        }
    }
    
    private func processLocationData(data: Data, completion:@escaping(Array<AnyObject>?, Error?) -> Void) {
        //Parse JSON
        /* let json: Any? = nil
         do
         {
         json = try JSONSerialization.jsonObject(with: data, options: [])
         }
         catch
         {
         //Invalid response
         //completion(nil, nil)
         }
         
         guard let locationData = json as? NSArray else
         {
         
         return
         }
         */
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            let locationData = json as? NSArray
            
            if locationData == nil {
                //Invalid response
                completion(nil, HttpClientError.InvalidResponse(reason:"Invalid data format"))
            }
            else {
                var locations = [AnyObject]()
                
                locationData?.enumerateObjects({ ( object, index, stop) in
                    if let locationObj = object as? Dictionary<String, AnyObject>
                    {
                        let location = Location(with: locationObj)
                        locations.append(location!)
                    }
                })
                
                completion(locations, nil)
            }
        }
        else {
            //Invalid response
            completion(nil, HttpClientError.InvalidResponse(reason: "Unable to parse json data"))
        }
    }

}

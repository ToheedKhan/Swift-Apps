//
//  ImageDownloader.swift
//  HockeyPlayers
//
//  Created by Toheed Khan on 13/05/17.
//  Copyright © 2017 Toheed Khan. All rights reserved.
//

import UIKit

class ImageDownloader {
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    
    init() {
        
        // Initialize stored properties.
        self.task = URLSessionDownloadTask()
        self.session = URLSession.shared
        self.cache = NSCache()
        
    }
    
    //MARK: - Download Image
    func downloadImage(from url: URL, indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        
        
        if (self.cache.object(forKey: indexPath.row as AnyObject) != nil){
            
            // Use cache
            print("Cached image used, no need to download it")
            completion((self.cache.object(forKey: indexPath.row as AnyObject) as? UIImage)!)
        } else {
            // download if not found in cache
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    let img:UIImage! = UIImage(data: data)
                    self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                    completion(img)
                }
                
            })
            task.resume()
        }    }
}

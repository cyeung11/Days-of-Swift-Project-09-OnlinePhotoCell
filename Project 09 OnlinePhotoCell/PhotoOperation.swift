//
//  PhotoOperation.swift
//  Project 09 OnlinePhotoCell
//
//  Created by Chris on 12/9/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation
import UIKit

class PhotoOperation: Operation {
    
    var image: UIImage?
    let path: String
    let indexPath: IndexPath
    
    init(withImagePath path: String, forIndexPath indexPath: IndexPath, completionBlock: @escaping ((UIImage?) -> Void)){
        self.path = path
        self.indexPath = indexPath
        super.init()
        self.completionBlock = {
            DispatchQueue.main.async {
                completionBlock(self.image)
            }
        }
    }
    
    override func main() {
        if isCancelled{
            return
        }
        if let url = URL(string: path){
            do{
                let data = try Data(contentsOf: url)
                if !isCancelled {
                    image = UIImage(data: data)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

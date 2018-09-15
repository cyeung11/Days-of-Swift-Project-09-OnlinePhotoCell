//
//  PhotoOperationQuene.swift
//  Project 09 OnlinePhotoCell
//
//  Created by Chris on 12/9/2018.
//  Copyright © 2018 Chris. All rights reserved.
//

import Foundation

class PhotoOperationQuene: OperationQueue {

    private static var SINGLETON: PhotoOperationQuene?
    
    static var quene: PhotoOperationQuene{
        if SINGLETON == nil{
            SINGLETON = PhotoOperationQuene()
        }
        return SINGLETON!
    }
    
    private override init() {
        super.init()
        self.name = "photoDownloadOperation"
        self.maxConcurrentOperationCount = 1
    }
}

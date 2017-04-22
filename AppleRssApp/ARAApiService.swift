//
//  ARAApiService.swift
//  AppleRssApp
//
//  Created by Ivashin Dmitry on 4/16/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit
import CoreData

enum APIResult<T>
{
    case success(T)
    case failure(Error)
}

class ARAApiService {

    fileprivate let xmlApiService = ARAXMLApiService()
    fileprivate let libraryService = ARALibraryService()
    
    func getXML(with completionHandler: @escaping (APIResult<Any>) -> Void)
    {
        xmlApiService.getXML(with: completionHandler)
    }
    
    func updateLibrary(with dictionary: [String: Any])
    {
        libraryService.updateLibraryWith(dictionary)
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        return libraryService.getFetchedResultsController()
    }

}

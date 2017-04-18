//
//  ARAInitilalViewController.swift
//  AppleRssApp
//
//  Created by Ivashin Dmitry on 4/17/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class ARAInitilalViewController: CoreDataTableViewController {
    
    let applicationManager = ARAApplicationManager.instance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Here we're getting XML file from remote
        applicationManager.apiService.getXML() { (result) in
            switch result {
            case .success(let value):
                print("fi - \(value)")
                guard let data = value as? Data else { return }
                // Parsing XML
                let parsingService = self.applicationManager.startXmlParserService(with: data)
                parsingService.xmlParserResult = { (result) in
                    switch result {
                    case .success(let value):
                        // Updating SQLite 
                        print(value)
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print("fi - \(error)")
            }
        }
    }
}

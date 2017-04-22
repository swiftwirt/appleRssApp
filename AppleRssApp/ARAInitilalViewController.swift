//
//  ARAInitilalViewController.swift
//  AppleRssApp
//
//  Created by Ivashin Dmitry on 4/17/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class ARAInitilalViewController: CoreDataTableViewController, ARAXMLParserServiceDelegate {
    
    let applicationManager = ARAApplicationManager.instance()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController = applicationManager.apiService.getFetchedResultsController()
        // Here we're getting XML file from remote
        applicationManager.apiService.getXML() { (result) in
            switch result {
            case .success(let value):
                print("fi - \(value)")
                guard let data = value as? Data else { return }
                // Parsing XML
                let parsingService = self.applicationManager.xmlParserService
                parsingService.delegate = self
                parsingService.beginParsing(data)
            case .failure(let error):
                print("fi - \(error)")
            }
        }
    }
    
    // MARK: - ARAXMLParserServiceDelegate
    
    func didFinishParsing(with result: [[String : Any]]) {
        for dictionary in result {
            applicationManager.apiService.updateLibrary(with: dictionary)
        }
        print(result)
    }
    
    func didFailParsing(with error: Error) {
        print(error)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RssItemCell", for: indexPath)
        let item = fetchedResultsController?.object(at: indexPath) as! RssItem
        cell.textLabel?.text = item.title
        return cell
    }
}

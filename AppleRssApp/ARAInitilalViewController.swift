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
    
    struct SegueIdentifier {
        static let details = "SegueGoToDetails"
        
        private init() {}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Hook up request controller
        fetchedResultsController = applicationManager.apiService.getFetchedResultsController()
        // Here we're getting XML file from remote
        getXMLData()

        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    fileprivate func getXMLData()
    {
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
    }
    
    func didFailParsing(with error: Error) {
        print(error)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RssItemCell", for: indexPath) as! ARARssItemCell
        let item = fetchedResultsController?.object(at: indexPath) as! RssItem
        cell.titleLabel.text = item.title
        cell.contentLabel.text = item.content
        cell.dateLabel.text = item.pubDate
        return cell
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case SegueIdentifier.details:
            if let destinationViewController = segue.destination as? ARADetailsViewController {
                guard let cell = sender as? ARARssItemCell else { return }
                var details = Details()
                details.title = cell.titleLabel.text!
                details.content = cell.contentLabel.text!
                details.date = cell.dateLabel.text!
                destinationViewController.details = details
            }
        default:
            break
        }
    }
}

//
//  ARAXMLParserService.swift
//  AppleRssApp
//
//  Created by Ivashin Dmitry on 4/18/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

protocol ARAXMLParserServiceDelegate: class {
    func didFinishParsing(with result: [[String:Any]])
    func didFailParsing(with error: Error)
}

class ARAXMLParserService: NSObject, XMLParserDelegate {
   
    enum XMLElementKey: String {
        case item = "item"
        case title = "title"
        case link = "link"
        case description = "description"
        case pubDate = "pubDate"
        case xmlDataFinish = "rss"
    }
    
    fileprivate var currentElement = String()
    fileprivate var itemDictionary = [String:String]()
    fileprivate var allItems = [[String:Any]]()
    
    weak var delegate: ARAXMLParserServiceDelegate?
    
    convenience init(with data: Data)
    {
        self.init()
        beginParsing(data)
    }
    
    func beginParsing(_ data: Data)
    {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        currentElement = elementName
        print(currentElement)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        switch elementName {
            case XMLElementKey.item.rawValue:
                allItems.append(itemDictionary)
                itemDictionary = [String:String]()
            case XMLElementKey.xmlDataFinish.rawValue:
                delegate?.didFinishParsing(with: allItems)
            default:
                break
        }
        print(currentElement)
        currentElement = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
            case XMLElementKey.title.rawValue:
                itemDictionary[XMLElementKey.title.rawValue] = string
            case XMLElementKey.link.rawValue:
                itemDictionary[XMLElementKey.link.rawValue] = string
            case XMLElementKey.description.rawValue:
                itemDictionary[XMLElementKey.description.rawValue] = string
            case XMLElementKey.pubDate.rawValue:
                itemDictionary[XMLElementKey.pubDate.rawValue] = string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print("failure error: ", parseError)
        delegate?.didFailParsing(with: parseError)
    }
}

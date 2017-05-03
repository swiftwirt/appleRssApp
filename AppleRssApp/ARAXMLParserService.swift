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
        case content = "content" // Add to omit system reserved names duplication
        case pubDate = "pubDate"
        case xmlDataFinish = "rss"
    }
    
    fileprivate var currentElement = String()
    fileprivate var handeledString = String()
    fileprivate var itemDictionary = [String:String]()
    fileprivate var allItems = [[String:Any]]()
    
    weak var delegate: ARAXMLParserServiceDelegate?
    
    func beginParsing(_ data: Data)
    {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        switch elementName {
            case XMLElementKey.item.rawValue:
                allItems.append(itemDictionary)
                resetHandeledFields()
            case XMLElementKey.xmlDataFinish.rawValue:
                delegate?.didFinishParsing(with: allItems)
            default:
                break
        }
        currentElement = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
            case XMLElementKey.title.rawValue:
                handeledString += string
                itemDictionary[XMLElementKey.title.rawValue] = handeledString
                print(string)
            case XMLElementKey.link.rawValue:
                itemDictionary[XMLElementKey.link.rawValue] = string
            case XMLElementKey.description.rawValue:
                handeledString += string
                itemDictionary[XMLElementKey.content.rawValue] = handeledString
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
    
    fileprivate func resetHandeledFields()
    {
        itemDictionary = [String:String]()
        handeledString = String()
    }
}

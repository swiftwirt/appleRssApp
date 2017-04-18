//
//  ARAXMLParserService.swift
//  AppleRssApp
//
//  Created by Ivashin Dmitry on 4/18/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class ARAXMLParserService: NSObject, XMLParserDelegate {
   
    enum XMLElement: String {
        case title = "title"
        case link = "link"
        case description = "description"
        case pubDate = "pubDate"
    }
    
    fileprivate var parser = XMLParser()
    fileprivate var currentElement = String()
    fileprivate var item = RssItem()
    
    var xmlParserResult: ((APIResult<Any>) -> ())?
    
    convenience init(with data: Data)
    {
        self.init()
        beginParsing(data)
    }
    
    fileprivate func beginParsing(_ data: Data)
    {
        parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        currentElement=elementName;
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        currentElement="";
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch string {
            case XMLElement.title.rawValue:
                item.title = string
            case XMLElement.link.rawValue:
                item.link = string
            case XMLElement.description.rawValue:
                item.content = string
            case XMLElement.pubDate.rawValue:
                item.pubDate = string
                xmlParserResult?(APIResult.success(item))
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print("failure error: ", parseError)
        xmlParserResult?(APIResult.failure(parseError))
    }
}

//
//  ARARestApiService.swift
//  AppleRssApp
//
//  Created by Ivashin Dmitry on 4/16/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class ARARestApiService: NSObject, XMLParserDelegate {
    
    enum EndPoint: String {
        case baseUrl = "http://developer.apple.com/news/rss/news.rss"
    }
    
    fileprivate var items = [RssItem]()
    
    var strXMLData:String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    var parser = XMLParser()
    
    func getRSS(with completionHandler: @escaping (APIResult<Any>) -> Void)
    {
        guard let url = URL(string: EndPoint.baseUrl.rawValue) else { return }
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            
            print(strXMLData)
            
        } else {
            print("parse failure!")
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if(elementName=="id" || elementName=="name" || elementName=="cost" || elementName=="description")
        {
            if(elementName=="name"){
                passName=true;
            }
            passData=true;
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="id" || elementName=="name" || elementName=="cost" || elementName=="description")
        {
            if(elementName=="name"){
                passName=false;
            }
            passData=false;
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if(passName){
            strXMLData=strXMLData+"\n\n"+string
        }
        
        if(passData)
        {
            print(string)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print("failure error: ", parseError)
    }

}

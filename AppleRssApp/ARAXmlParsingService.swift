//
//  ARAXmlParsingService.swift
//  AppleRssApp
//
//  Created by Ivashin Dmitry on 4/16/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class ARAXmlParsingService {
    
    @IBOutlet var lblNameData : UILabel! = nil

    let url:String="http://api.androidhive.info/pizza/?format=xml"
    let urlToSend: URL = URL(string: url)!
    // Parse the XML
    parser = XMLParser(contentsOf: urlToSend)!
    parser.delegate = self
    
    let success:Bool = parser.parse()
    
    if success {
    print("parse success!")
    
    print(strXMLData)
    
    lblNameData.text=strXMLData
    
    } else {
    print("parse failure!")
    }
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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


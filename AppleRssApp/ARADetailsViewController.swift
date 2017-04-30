//
//  ARADetailsViewController.swift
//  AppleRssApp
//
//  Created by Ivashin Dmitry on 4/30/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class ARADetailsViewController: UIViewController {

    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var details: Details!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manageImagePresentation()
    }
    
    fileprivate func manageImagePresentation()
    {
        let imageRect = UIBezierPath(rect: CGRect(x: detailsTextView.frame.origin.x, y: detailsTextView.frame.origin.y - 30.0, width: 100.0, height: 80.0))
        detailsTextView.textContainer.exclusionPaths = [imageRect]
        
        let imageFrame = CGRect(x: detailsTextView.bounds.origin.x + 10, y: detailsTextView.bounds.origin.y + 15, width: 80.0, height: 80.0)
        let imageView = UIImageView(frame: imageFrame)
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        detailsTextView.addSubview(imageView)
    }
    
    fileprivate func handleContent()
    {
        titleLabel.text = details.title
        dateLabel.text = details.date
        detailsTextView.text = details.content
    }
}

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
    
    var item: RssItem!
    
    fileprivate var downloadTask: URLSessionDownloadTask?
    fileprivate var applicationManager = ARAApplicationManager.instance()
    
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
        
        if let link = item.link, let url = URL(string: "https://lh3.googleusercontent.com/-OyqHvKz17lg/WDwiXRUFjHI/AAAAAAAAAC8/8c5UgM30NogAIg0M7V2P1NEqboo5mnlKwCEw/w140-h140-p/Screen%2BShot%2B2016-11-28%2Bat%2B2.25.36%2BPM.png") {
            downloadTask = applicationManager.apiService.loadImageWithURL(url: url) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let value):
                    guard let image = value as? UIImage else { return }
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    fileprivate func handleContent()
    {
        titleLabel.text = item.title
        dateLabel.text = item.pubDate
        detailsTextView.text = item.content
    }
    
    deinit {
        downloadTask?.cancel()
    }
}

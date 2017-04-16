//
//  UIImageView+ImageDownloader.swift
//  AppleRssApp
//
//  Created by Ivashin Dmitry on 4/16/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImageWithURL(url: URL) -> URLSessionDownloadTask
    {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
            if error == nil, let url = url {
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async() {
                        if let strongSelf = self {
                            strongSelf.image = image
                        }
                    }
                } catch {
                    print("***** Error from loadImageWithURL!")
                }

            }
        })
        downloadTask.resume()
        return downloadTask
    }
}

//
//  InfoViewController.swift
//  BookSearch
//
//  Created by Zorigbold  Munkh-Erdene on 17/04/2017.
//  Copyright © 2017 Zorigbold  Munkh-Erdene. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorTextLabel: UILabel!
    @IBOutlet weak var publisherTextLabel: UILabel!
    @IBOutlet weak var pubDataTextLabel: UILabel!
    @IBOutlet weak var desriptTextLabel: UITextView!
    
    var nom : Book? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleTextLabel.text = nom?.title
        imageView.image = UIImage(data: nom?.thumbnail as! Data)
        authorTextLabel.text = nom?.author
        publisherTextLabel.text = nom?.publisher
        pubDataTextLabel.text = nom?.pubDate
        desriptTextLabel.text = nom?.descript
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
}

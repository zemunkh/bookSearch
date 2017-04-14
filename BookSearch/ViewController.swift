//
//  ViewController.swift
//  BookSearch
//
//  Created by Zorigbold  Munkh-Erdene on 06/04/2017.
//  Copyright © 2017 Zorigbold  Munkh-Erdene. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class ViewController: UIViewController {


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var authorTextLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UITextView!
    @IBOutlet weak var isbnNumberLabel: UITextField!
    @IBOutlet weak var publisherTextLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    //var books : [Book] = []
    
    @IBAction func buttonTapped(_ sender: Any) {
        isbn = isbnNumberLabel.text!
        getBookInfo(isbn: isbn)
    }

    var isbn : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBookInfo(isbn: "9781292101767")
        
       
    }
    
    func getBookInfo(isbn: String) {
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn
        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            
            //let config = URLSessionConfiguration.default
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                
                guard error == nil else {
                    print("error calling Get on books")
                    //print(error)
                    return
                }
                self.setLabels(responseData: data!)
                
            })
            task.resume()
        }
        
    }
    
    func setLabels(responseData: Data) {

        DispatchQueue.main.async {
            
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                print("This result is: " + jsonResult.description)
                
                guard let items = jsonResult["items"] as? [[String: AnyObject]] else {
                    print("Could not get item from JSON")
                    return
                }
                
                for item in items {
                    if let volumeInfo = item["volumeInfo"] as? [String: AnyObject] {
                        
                        if let title = volumeInfo["title"] as? String{
                            print("###### Title is " + title)
                            self.titleTextLabel.text = title
                        }
                        else {
                            self.titleTextLabel.text = "Not found"
                        }
                        var count = 0
                        if let author = volumeInfo["authors"] as? [String] {
                            for _ in author {
                                print("###### Author is " + author[count])
                                count += 1
                            }
                            if count == 1 {
                                self.authorTextLabel.text = author[0]
                            }
                            else {
                                let space = ","
                                var appendName = " "
                                var name = " "
                                for index in 0...(count-1) {
                                    if index == (count-1) {
                                        name = "\(appendName) \(author[index])"
                                        print(name)
                                    }
                                    appendName  = "\(author[index])\(space)"
                                }
                                self.authorTextLabel.text = name
                            }
                            
                            
                        }
                        else {
                            self.authorTextLabel.text = "Not found"
                        }
                        
                        if let publisher = volumeInfo["publisher"] as? String {
                            print("####Publisher: " + publisher)
                            self.publisherTextLabel.text = publisher
                        }
                        else {
                            self.publisherTextLabel.text = "Not found"
                        }
                        // Add Nothing on the label if there is no data
                        if let publishDate = volumeInfo["publishedDate"] as? String {
                            print("####published Date :" + publishDate)
                            self.publishedDateLabel.text = publishDate
                        }
                        else {
                            self.publishedDateLabel.text = "Not found"
                            
                        }
                        
                        var url : String = ""
                        if let imageLinks = volumeInfo["imageLinks"] as? [String: AnyObject] {
                            if let smallThumbnail = imageLinks["smallThumbnail"] as? String {
                                print("#####Thumbnail: " + smallThumbnail)
                                url = "\(smallThumbnail).jpg"
                                self.imageView.sd_setImage(with: URL(string: url))
                            }
                            
                        }
                        
                        if let descript = volumeInfo["description"] as? String {
                            print("#####Description: " + descript)
                            self.descriptionTextLabel.text = descript
                        }
                        else {
                            self.descriptionTextLabel.text = "Not found"
                        }
                        
                    }
                }
                
                
                
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }
    }
}


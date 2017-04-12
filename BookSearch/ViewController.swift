//
//  ViewController.swift
//  BookSearch
//
//  Created by Zorigbold  Munkh-Erdene on 06/04/2017.
//  Copyright © 2017 Zorigbold  Munkh-Erdene. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {


    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var authorTextLabel: UILabel!
    
    @IBAction func buttonTapped(_ sender: Any) {
        getBookInfo(isbn: "9781292101767")
    }
    //var title: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getBookInfo(isbn: "0553283685")
        getBookInfo(isbn: "9781591840565")
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
        
        do {
        guard let jsonResult = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
            print("error trying to convert data to JSON")
            return
        }
        print("This result is: " + jsonResult.description)
        
        // the book object is a dictionary
        // so we just access the title using the "title" key
        // so check for a title and print it if we have one
        guard let items = jsonResult["items"] as? [[String: AnyObject]] else {
            print("Could not get item from JSON")
            return
        }
        //print("The items are: " + items.description)
        
        for item in items {
            if let volumeInfo = item["volumeInfo"] as? [String: AnyObject] {
            //print(title)
                if let title = volumeInfo["title"] as? String{
                    print("###### Title is " + title)
                    self.titleTextLabel.text = title
                    }
                var count = 0
                if let author = volumeInfo["authors"] as? [String] {
                    for _ in author {
                        print("###### Author is " + author[count])
                        //self.authorTextLabel.text = author[count]
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
            }
        }
        
        } catch {
            print("error trying to convert data to JSON")
            return
        }

    }
    

}


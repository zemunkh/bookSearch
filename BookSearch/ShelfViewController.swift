//
//  ShelfViewController.swift
//  BookSearch
//
//  Created by Zorigbold  Munkh-Erdene on 14/04/2017.
//  Copyright © 2017 Zorigbold  Munkh-Erdene. All rights reserved.
//

import UIKit

class ShelfViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var books : [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBooks()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let book = books[indexPath.row]
        cell.textLabel?.text = book.title!
        // Before loading Image from CoreData, You should delete app and Reload it.
        cell.imageView?.image = UIImage(data: book.thumbnail as! Data)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        performSegue(withIdentifier: "showInfo", sender: book)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let book = books[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            context.delete(book)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                books = try context.fetch(Book.fetchRequest())
                tableView.reloadData()
            } catch {}
        }
    }
    
    func getBooks(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            books = try context.fetch(Book.fetchRequest()) as! [Book]
            print(books)
        } catch {
            print("OOPS We HAVE AN ERROR")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo" {
            let nextVC = segue.destination as! InfoViewController
            nextVC.nom = sender as? Book
        }
    }


}

//
//  ShelfViewController.swift
//  BookSearch
//
//  Created by Zorigbold  Munkh-Erdene on 14/04/2017.
//  Copyright © 2017 Zorigbold  Munkh-Erdene. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn

class ShelfViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    var books : [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        var error : NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        
        if error != nil {
            print(error!)
            return
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        signInButton.center = view.center
        
        view.addSubview(signInButton)
        

        // Do any additional setup after loading the view.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print(user.profile.email)
        print(user.profile.imageURL(withDimension: 400))
    }
    
    @IBAction func didTapSignOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        print("Account signed out")
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

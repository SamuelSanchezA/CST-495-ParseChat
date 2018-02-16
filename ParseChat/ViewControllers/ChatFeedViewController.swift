//
//  ChatFeedViewController.swift
//  ParseChat
//
//  Created by Samuel on 2/16/18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit

class ChatFeedViewController: UIViewController {

    var alertController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat"
        alertController = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
        let logoutButton = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // Nothing
        }
        
        alertController.addAction(logoutButton)
        alertController.addAction(cancelButton)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(_ sender: Any) {
        present(alertController, animated: true) {
            // Something
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

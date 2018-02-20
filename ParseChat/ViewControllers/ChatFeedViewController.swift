//
//  ChatFeedViewController.swift
//  ParseChat
//
//  Created by Samuel on 2/16/18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit
import Parse

class ChatFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var chatMessageTableView: UITableView!
    
    var alertController: UIAlertController!
    var refreshControl: UIRefreshControl!
    
    var messages: [String] = []
    var usernames: [String] = []
    var dates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat"
        chatMessageTableView.separatorStyle = .none
        chatMessageTableView.delegate = self
        chatMessageTableView.dataSource = self
        
        chatMessageTableView.rowHeight = UITableViewAutomaticDimension
        chatMessageTableView.estimatedRowHeight = 120
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatFeedViewController.didPullToRefresh(_:)), for: .valueChanged)
        chatMessageTableView.insertSubview(refreshControl, at: 0)
        
        sendButton.isEnabled = false
        alertController = UIAlertController(title: "", message: "Are you sure?", preferredStyle: .actionSheet)
        let logoutButton = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // Nothing
        }
        
        alertController.addAction(logoutButton)
        alertController.addAction(cancelButton)
        
        messageField.addTarget(self, action: #selector(ChatFeedViewController.textDidChange(_:)), for: .editingChanged)
        
        fetchMessages(nil)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fetchMessages(_:)), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func fetchMessages(_ sender:Any?){
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        
        let query = PFQuery(className: "Message")
        query.includeKey("user")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (messages, error) in
            if(messages != nil){
                self.messages = []
                self.usernames = []
                self.dates = []
                for message in messages!{
                    self.messages.append(message["text"] as! String)
                    if(message["user"] != nil){
                        self.usernames.append((message["user"] as! PFUser).username!)
                    }
                    else{
                        self.usernames.append("Unknown")
                    }
                    self.dates.append(df.string(from: message.createdAt!))
                }
                self.chatMessageTableView.reloadData()
            }
            else{
                print("Whoops! \(error?.localizedDescription)")
            }
        }
        self.refreshControl.endRefreshing()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        fetchMessages(nil)
    }
    
    @objc func textDidChange(_ textField: UITextField){
        if(messageField.text?.isEmpty)!{
            sendButton.isEnabled = false
        }
        else{
            sendButton.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        cell.message.text = self.messages[indexPath.row]
        cell.username.text = self.usernames[indexPath.row]
        cell.dateLabel.text = self.dates[indexPath.row]
        
        return cell
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
    
    @IBAction func sendMessage(_ sender: Any) {
        let user = PFUser.current()
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageField.text ?? ""
        chatMessage["user"] = user
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageField.text = ""
                self.sendButton.isEnabled = false
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
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

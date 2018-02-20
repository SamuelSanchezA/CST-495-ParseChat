//
//  ViewController.swift
//  ParseChat
//
//  Created by Samuel on 2/16/18.
//  Copyright © 2018 Samuel. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var alertController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertController = UIAlertController(title: "Error", message: "Username or Password cannot be empty", preferredStyle: .alert)
        let okayButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            //Do Something
        })
        alertController.addAction(okayButton)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: Any) {
        
        if((usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!){
            print("Empty!")
            present(alertController, animated: true, completion: {
                // After action
            })
        }
        else{
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
                if(user != nil){
                    // Go with this user
                    self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                }
                else{
                    print(error?.localizedDescription ?? "Error")
                }
            }
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        
        if((usernameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!){
            print("Empty!")
            present(alertController, animated: true, completion: {
                // After action
            })
        }
        else{
            let newUser = PFUser()
            newUser.username = usernameTextField.text!
            newUser.password = passwordTextField.text!
            
            newUser.signUpInBackground { (success, error) in
                if(success){
                    // Go to priveledged feed
                    self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                    
                }
                else{
                    // Print error
                    print(error?.localizedDescription ?? "Error")
                }
            }
        }
        
    }
}


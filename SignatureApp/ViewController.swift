//
//  ViewController.swift
//  SignatureApp
//
//  Created by Ryan Chee on 2/23/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var usernameField : UITextField!
    @IBOutlet var passField : UITextField!
    @IBAction func loginButton() {
        
        PFUser.logInWithUsernameInBackground(usernameField.text, password:passField.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                // Do stuff after successful login.
                println("\(self.usernameField.text)")
                self.performSegueWithIdentifier("segueTest", sender: self)
            } else {
                // The login failed. Check error to see why.
                println("nan")
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "segueTest" {
            
            if (self.usernameField.text.isEmpty) {
                
                let alert = UIAlertView()
                alert.title = "No Text"
                alert.message = "Please Enter Text In The Box"
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            }
            
            else {
                
               return true
           }
        }
        
        // by default, transition
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


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
                if (self.usernameField.text.isEmpty) {
                    
                    let alert = UIAlertView()
                    alert.title = "Missing Fields"
                    alert.message = "One or more of the fields are blank."
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                }
                else {
                    let alert = UIAlertView()
                    alert.title = "Login Error"
                    alert.message = "Username or Password is Incorrect"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                }

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
        
        if identifier == "Register" {
            
            
        }
        
        // by default, transition
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


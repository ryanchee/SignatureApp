//
//  ViewController.swift
//  SignatureApp
//
//  Created by Ryan Chee on 2/23/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var usernameField : UITextField!
    @IBOutlet var passField : UITextField!
    @IBAction func loginButton() {
        
    PFUser.logInWithUsernameInBackground(usernameField.text as String, password: passField.text as String) {
            (user: PFUser?, error: NSError?) -> Void in
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
        
   /*     if identifier == "Register" {
            self.performSegueWithIdentifier("Register", sender: self)
        }*/
        
        // by default, transition
        return true
    }
    
   /* override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Register" {
            let secondViewController = segue.destinationViewController as RegistrationViewController
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        passField.secureTextEntry = true
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            println("user \(PFUser.currentUser()!.username) is already logged in")
            self.performSegueWithIdentifier("segueTest", sender: self)
            
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
//            loginView.sizeThatFits(CGSize(width: 128, height: 30))
//            CGRect(x: 303, y: 323, width: 128, height: 30)
            self.view.addSubview(loginView)
//            loginView.center = CGPoint(x: 303, y: 323)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
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
    
    
    func loginFB()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : String = result.valueForKey("name") as! String
                println("User Name is: \(userName)")
                let userEmail : String = result.valueForKey("email") as! String
                println("User Email is: \(userEmail)")
                PFUser.logInWithUsernameInBackground(userName as String, password: "test" as String) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        // Do stuff after successful login.
                        self.performSegueWithIdentifier("segueTest", sender: self)
                    }
                    else {
                        // The login failed. Check error to see why.
                        if (userName.isEmpty) {
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
        })
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            loginFB()
//            self.performSegueWithIdentifier("segueTest", sender: self)
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    

}


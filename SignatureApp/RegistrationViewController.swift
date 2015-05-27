//
//  RegistrationViewController.swift
//  SignatureApp
//
//  Created by Ryan Chee on 4/15/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var usernameField : UITextField!
    @IBOutlet var passField : UITextField!
    @IBAction func registerButton() {
        var user = PFUser()
        user.username = usernameField.text
        user.password = passField.text
        user.email = "email@example.com"
        // other fields can be set just like with PFObject
        
        user.signUpInBackgroundWithBlock { [unowned self]
            (succeeded, error) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                let alert = UIAlertView()
                alert.title = "Registration Successful!"
                alert.message = "You are now logged in."
                alert.addButtonWithTitle("Ok")
                alert.show()
                self.performSegueWithIdentifier("UserRegistered", sender: self)
            }
            else {
                let alert = UIAlertView()
                alert.title = "Missing Fields"
                alert.message = "One or more of the fields are blank."
                alert.addButtonWithTitle("Ok")
                alert.show()
                // Show the errorString somewhere and let the user try again.
            }
        
        }
    }
    
    @IBAction func fbRegisterButton(sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        println("register view controller loaded")
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//            // User is already logged in, do work such as go to next view controller.
//        }
//        else
//        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
//            loginView.sizeThatFits(CGSize(width: 128, height: 30))
            self.view.addSubview(loginView)
//            loginView.center = CGPoint(x: 303, y: 323)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
//        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnUserData()
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
                var userName : String = result.valueForKey("name") as! String
                let userEmail : String = result.valueForKey("email") as! String
                println("User Email is: \(userEmail)")
                var user = PFUser()
                userName = userName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                println("User Name is: \(userName)")
                user.username = userName
                user.password = "test"
                user.email = userEmail
                // other fields can be set just like with PFObject
                
                user.signUpInBackgroundWithBlock { [unowned self]
                    (succeeded, error) -> Void in
                    if error == nil {
                        // Hooray! Let them use the app now.
                        let alert = UIAlertView()
                        alert.title = "Registration Successful!"
                        alert.message = "You are now logged in."
                        alert.addButtonWithTitle("Ok")
                        alert.show()
                        self.performSegueWithIdentifier("UserRegistered", sender: self)
                    }
                    else {
    ////////HACKY FIX FOR FACEBOOK REGISTER BUT PARSE DETECT LOGIN///////@@@@
                        let alert = UIAlertView()
                        alert.title = "You have already registered"
                        alert.message = "You are now logged in."
                        alert.addButtonWithTitle("Ok")
                        alert.show()
                        self.performSegueWithIdentifier("UserRegistered", sender: self)
                        // Show the errorString somewhere and let the user try again.
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
            returnUserData()
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
//
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

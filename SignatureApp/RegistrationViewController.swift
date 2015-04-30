//
//  RegistrationViewController.swift
//  SignatureApp
//
//  Created by Ryan Chee on 4/15/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet var usernameField : UITextField!
    @IBOutlet var passField : UITextField!
    @IBAction func registerButton() {
        var user = PFUser()
        user.username = usernameField.text
        user.password = passField.text
        user.email = "email@example.com"
        // other fields can be set just like with PFObject
        
        user.signUpInBackgroundWithBlock {
            (succeeded, error) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                let alert = UIAlertView()
                alert.title = "Registration Successful!"
                alert.message = "You will now be logged in."
                alert.addButtonWithTitle("Ok")
                alert.show()
            } else {
                let alert = UIAlertView()
                alert.title = "Missing Fields"
                alert.message = "One or more of the fields are blank."
                alert.addButtonWithTitle("Ok")
                alert.show()
                // Show the errorString somewhere and let the user try again.
            }
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("register view controller loaded")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

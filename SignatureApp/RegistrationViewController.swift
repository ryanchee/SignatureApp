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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

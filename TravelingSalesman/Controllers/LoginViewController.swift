//
//  ViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 08-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  Handle user login. The user can also choose to register if they don't have an account yet. Users need to create an account to save contacts and routes.

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss keyboard when the user taps the screen.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Show logged in screen if the user is already logged in.
        if Auth.auth().currentUser != nil {
            self.presentMainScreen()
        }
    }
    
    @objc func tap(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    // Perfom segue to main screen
    func presentMainScreen() {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    // Clear inputfields and labels
    func clearUserInput() {
        self.errorLabel.text = ""
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        // Check if textfields are filled in.
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { user, error in
                // Check if there might be an error from firebase.
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.errorLabel.text = firebaseError.localizedDescription
                    return
                }
                
                // Show main screen when login is successfull.
                self.presentMainScreen()
                
                // Clear inputfields and labels after logging in successfully.
                self.clearUserInput()
                print("Successfully logged in!")
            })
        }
        // Dismiss keyboard when the button is tapped.
        self.view.endEditing(true)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        self.clearUserInput()
    }
    
    // Segue to send user back to loginscreen if they logout.
    @IBAction func unwindToLoginScreen(segue: UIStoryboardSegue) {
    }

}


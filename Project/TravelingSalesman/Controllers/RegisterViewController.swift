//
//  RegisterViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 11-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//
//  Handle registartion of new users and save this user to firebase.

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    @IBOutlet weak var registerErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Dismiss keyboard at tap on screen.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @objc func tap(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        // Check if textfields are filled in.
        if let email = registerEmailTextField.text, let password = registerPasswordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
                // Check if there might be an error from firebase.
                if let firebaseError = error {
                    self.registerErrorLabel.text = firebaseError.localizedDescription
                    return
                }
                
                // Show next screen when registration is successfull.
                self.performSegue(withIdentifier: "registerSegue", sender: nil)
                
                // Clear inputfields and labels after logging in successfully.
                self.registerErrorLabel.text = ""
                self.registerEmailTextField.text = ""
                self.registerPasswordTextField.text = ""
            })
        }
        // Dismiss keyboard when the button is tapped.
        self.view.endEditing(true)
    }
}

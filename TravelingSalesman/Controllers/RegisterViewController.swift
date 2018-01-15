//
//  RegisterViewController.swift
//  TravelingSalesman
//
//  Created by Dennis Broekhuizen on 11-01-18.
//  Copyright © 2018 Dennis Broekhuizen. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Dismiss keyboard when the user taps the screen.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @objc func tap(sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        // Check if textfields are filled in.
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
                // Check if there might be an error from firebase.
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.errorLabel.text = firebaseError.localizedDescription
                    return
                }
                
                // Show next screen when registration is successfull.
                self.performSegue(withIdentifier: "registerSegue", sender: nil)
                
                // Clear inputfields and labels after logging in successfully.
                self.errorLabel.text = ""
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                print("Successfully created an account!")
            })
        }
        // Dismiss keyboard when the button is tapped.
        self.view.endEditing(true)
    }
    
}

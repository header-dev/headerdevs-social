//
//  ViewController.swift
//  headerdevs-social
//
//  Created by kritawit bunket on 7/17/2560 BE.
//  Copyright © 2560 Headerdevs. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func facebookBtnTapped(_ sender: Any){
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("JESS: Unable to authentication with facebook - \(String(describing: error))")
            }else if result?.isCancelled == true {
                print("JESS: User cancelled Facebook authentication")
            }else{
                print("JESS: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("JESS: Unable to authenticate with Firebase - \(String(describing: error))")
            }else{
                print("JESS: Successfully authenticated with Firebase")
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any){
     
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("JESS : Email user authenticated with Firebase")
                }else{
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("JESS : Unable to authenticate with Firebase using email")
                        }else{
                            print("JESS : Successfully authenticated with Firebase")
                        }
                    })
                }
            })
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

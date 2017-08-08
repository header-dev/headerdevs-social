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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("JESS : ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
        
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
                if let user = user {
                    let userData = ["provider":credential.provider]
                    self.completeSignIn(id: user.uid,userData: userData)
                }
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any){
     
        if let email = emailField.text, let pwd = pwdField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("JESS : Email user authenticated with Firebase")
                    
                    if let user = user{
                        let userData = ["provider":user.providerID]
                            self.completeSignIn(id: user.uid,userData: userData)
                    }
                    
                }else{
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("JESS : Unable to authenticate with Firebase using email")
                        }else{
                            print("JESS : Successfully authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider":user.providerID]
                                self.completeSignIn(id: user.uid,userData: userData)
                            }
                        }
                    })
                }
            })
        }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String,String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("JESS : Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
        
    }


}

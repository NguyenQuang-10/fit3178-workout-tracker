//
//  AuthenticationViewController.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 18/5/2023.
//

import UIKit

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var emailTextbox: UITextField!
    @IBOutlet weak var passwordTextbox: UITextField!
    var authController: FirebaseAuthenticationDelegate?
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        authController = appDelegate?.firebaseAuthController
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func validateAuthInput() -> Bool {
        if let email = emailTextbox.text, let psw = passwordTextbox.text, email != nil, email != "", psw != nil, psw != "" {
            return true
        }
        
        return false
    }
    
    
    @IBAction func createNewAccount(_ sender: Any)  {
        if validateAuthInput() {
            Task {
                do {
                    try await authController?.signup(email: emailTextbox.text!, password: passwordTextbox.text!)
                    performSegue(withIdentifier: "loginSuccessfulSegue", sender: self)
                } catch {
                    print("Error Signing up: \(error)")
                }
                
                
            }
            
        }
    }
    
    
    @IBAction func login(_ sender: Any) {
        if validateAuthInput() {
            Task {
                do {
                    try await authController?.login(email: emailTextbox.text!, password: passwordTextbox.text!)
                    performSegue(withIdentifier: "loginSuccessfulSegue", sender: self)
                } catch {
                    print("Error logging in: \(error)")
                }
                
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

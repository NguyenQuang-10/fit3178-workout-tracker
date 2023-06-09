//
//  FirebaseAuthenticationDelegate.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 18/5/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

// class that handles login in with Firebase
protocol FirebaseAuthenticationDelegate {
    var authController: Auth {get set} // auth controller
    func login(email: String, password: String) async throws // login with auth controller
    func signup(email: String, password: String) async throws // signup with auth controller
    func signinAnonmously() async throws // sign in anomously with out auth data
}

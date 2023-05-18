//
//  FirebaseAuthenticationDelegate.swift
//  fit3178_final_assessment
//
//  Created by Nhat Nguyen on 18/5/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol FirebaseAuthenticationDelegate {
    var authController: Auth {get set}
    func login(email: String, password: String) async throws
    func signup(email: String, password: String) async throws
    func signinAnonmously() async throws
}

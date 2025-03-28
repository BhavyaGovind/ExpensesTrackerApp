//
//  User.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/6/25.
//

import Foundation
import FirebaseAuth

struct User {
    var id: String
    var name: String
    var email: String
    var profileImageUrl: String

    init(id: String, name: String, email: String, profileImageUrl: String) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImageUrl = profileImageUrl
    }
}

extension User {
    // Initialize User from Firebase User data
    static func from(firebaseUser: FirebaseAuth.User) -> User {
        return User(id: firebaseUser.uid, name: firebaseUser.displayName ?? "No Name", email: firebaseUser.email ?? "No Email", profileImageUrl: firebaseUser.photoURL?.absoluteString ?? "")
    }
}

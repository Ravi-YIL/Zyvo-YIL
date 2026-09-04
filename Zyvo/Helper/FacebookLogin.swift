//
//  FacebookLogin.swift
//  Zyvo
//
//  Created by YES IT Labs on 07/11/25.
//

import SwiftUI
import FBSDKLoginKit
import FBSDKCoreKit

struct FacebookLoginButton: UIViewRepresentable {
    func makeUIView(context: Context) -> FBLoginButton {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        return button
    }
    func updateUIView(_ uiView: FBLoginButton, context: Context) {}
}

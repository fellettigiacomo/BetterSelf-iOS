//
//  betterselfApp.swift
//  betterself
//
//  Created by jack on 02/06/24.
//

import SwiftUI

@main
struct betterselfApp: App {
    @StateObject private var shared = Shared()
    var body: some Scene {
        WindowGroup {
            loginView()
                .environmentObject(shared)
        }
    }
}

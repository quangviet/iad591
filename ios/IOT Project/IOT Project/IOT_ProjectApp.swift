//
//  IOT_ProjectApp.swift
//  IOT Project
//
//  Created by Quang Viet on 25/04/2023.
//

import SwiftUI

@main
struct IOT_ProjectApp: App {
    var network = Network()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
        }
    }
}

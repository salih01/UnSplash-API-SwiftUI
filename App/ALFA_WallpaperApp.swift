//
//  ALFA_WallpaperApp.swift
//  ALFA Wallpaper
//
//  Created by Salih Çakmak on 4.02.2022.
//

import SwiftUI
import Firebase

@main
struct ALFA_WallpaperApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
            
        }
    }
    
    //firebase
    
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

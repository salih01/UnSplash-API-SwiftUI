//
//  ContentView.swift
//  ALFA Wallpaper
//
//  Created by Salih Çakmak on 4.02.2022.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct ContentView: View {
    
     
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            
           Button("Tıkla")
            {
                initfirebase()
                fireData()
            }
        }
        
       
    }
}

func initfirebase(){
    
    FirebaseApp.configure()
}

func fireData()
{
    var ref = Database.database().reference().child("salih").setValue("100")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

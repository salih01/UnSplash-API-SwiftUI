//
//  MainView.swift
//  ALFA Wallpaper
//
//  Created by Salih Çakmak on 5.02.2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        TabView(){
        
            FindView()
                .tabItem {
                    Image(systemName: "sparkle")
                    Text("Find")
                    
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Locations")
                    
                }
            CityVideoListView()
                .tabItem{
                    Image(systemName: "4k.tv")
                    Text("Live")
                }
            
            

            GalleryView()
                .tabItem {
                    Image(systemName: "photo")
                    Text("Gallery")

                }
            
        }
        .accentColor(.orange)

        
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

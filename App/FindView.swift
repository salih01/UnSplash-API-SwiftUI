//
//  FindView.swift
//  ALFA Wallpaper
//
//  Created by Salih Çakmak on 5.02.2022.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct FindView: View {
    var body: some View {
        
        
        VStack{
            Home()
            Spacer()
        }
        //.ignoresSafeArea(.all)

        
    }
}

struct Home  : View {
    @State var expand = false
    @State var search = ""
    @State var page = 1
    @State var isSearching = false
    @ObservedObject var RandomImages = getData()
 
    
    
    var body: some View {
        
        VStack(spacing:0) {
            HStack {
                
                if !self.expand {
                    VStack(alignment: .leading, spacing: 8){
                        
                        Text("A L F A")
                            .font(.title)
                            .fontWeight(.thin)
                        
                        Text("A L F A Wallpaper")
                            .fontWeight(.ultraLight)
                    }
                }

                Spacer(minLength: 0)
                
                Image(systemName: "magnifyingglass")
                    .onTapGesture {
                        withAnimation {
                            self.expand = true
                        }
                    }

                
                if self.expand{
                    
                    TextField("ALFA wallback...", text: self.$search)
 
                    if self.search != ""{
                        
                        Button(action: {
                            
                            self.RandomImages.Images.removeAll()
                            
                            self.isSearching = true
                            
                            self.page = 1
                            
                            //self.SearchData()
                            
                        }) {
                            
                            Text("Find")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    
                    
                    Button(action: {
                        
                        withAnimation{
                            
                            self.expand = false
                        }
                        
                        self.search = ""
                        
                        if self.isSearching{
                            
                            self.isSearching = false
                            self.RandomImages.Images.removeAll()
                           
                            self.RandomImages.updateData()
                        }
                        
                    }) {
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .padding(.leading,10)
                }
                
              
            }   //MARK : HSTACK
            
         
            .padding()
            
            if self.RandomImages.Images.isEmpty{
                
        
                Spacer()
                
                if self.RandomImages.noresults{
                    
                    Text("No Results Found")
                }
                else{
                    
                    Indicator()
                }
                
                Spacer()
            }
            else {
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 15) {

                        ForEach(self.RandomImages.Images,id: \.self){i in
                            
                            HStack(spacing:20) {
                                
                                ForEach(i) { j in
                                    
                                    AnimatedImage(url: URL(string:  j.urls["thumb"]!))
                                        .resizable()
                                        .aspectRatio( contentMode: .fill)
                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 150)
                                        .cornerRadius(15)
                                        .contextMenu {
                                                
                                            
                                            Button(action: {
    
                                                SDWebImageDownloader().downloadImage(with: URL(string: j.urls["large"]!)) { (image, _, _, _) in
                                                    
                                                    
                                                    UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                                                }
                                                
                                            }) {
                                                
                                                HStack{
                                                    
                                                    Text("Save")
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName: "square.and.arrow.down.fill")
                                                }
                                                .foregroundColor(.black)
                                            }
                                        }
                                }
                            }
                        }
                        
                        
                        if !self.RandomImages.Images.isEmpty{
                            
                            if self.isSearching && self.search != ""{
                                
                                HStack{
                                    
                                    Text("Page \(self.page)")
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        // Updating Data...
                                        self.RandomImages.Images.removeAll()
                                        self.page += 1
                                      //  self.SearchData()
                                        
                                    }) {
                                        
                                        Text("Next")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding(.horizontal,25)
                            }
                            
                            else{
                                
                                HStack{
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        // Updating Data...
                                        self.RandomImages.Images.removeAll()
                                        self.RandomImages.updateData()
                                        
                                    }) {
                                        
                                        Text("Next")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding(.horizontal,25)
                            }
                        }

                    }
                }
            }
            
            
           
        } // MARK : VSTACK
        

    }
    func SearchData(){
        
        let key = "WuRqDvVlDgrBE9BPufe_5yjKrVJkgDvBcicMKtOqApQ"
        // replacing spaces into %20 for query...
        let query = self.search.replacingOccurrences(of: " ", with: "%20")
        // updating page every time...
        let url = "https://api.unsplash.com/search/photos/?page=\(self.page)&query=\(query)&client_id=\(key)"
        
        self.RandomImages.SearchData(url: url)
    }
}



// MARK : DATA

class getData : ObservableObject {
    @Published var Images : [[Photo]] = []
    @Published var noresults = false
    
    
    init() {
        updateData()
    }
    
    func updateData() {
        let key = "WuRqDvVlDgrBE9BPufe_5yjKrVJkgDvBcicMKtOqApQ"
        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _,err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            do{
                let json = try JSONDecoder().decode([Photo].self, from: data!)
                
                for i in stride(from: 0, to: json.count, by: 2) {
                    
                    var ArrayData : [Photo] = []
                    
                    for j in i..<i+2 {
                        if j < json.count {
                            ArrayData.append(json[j])
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.Images.append(ArrayData)
                    }
                }
                

            }
            catch {
                print(error.localizedDescription,"bir boklar oldu bi bak istersen")
            }
            
            
        }
        .resume()
    
    }
    
    func SearchData(url: String){
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            
            do{
                
                let json = try JSONDecoder().decode(SearchPhoto.self, from: data!)
                
                
                if json.results.isEmpty{
                    
                    self.noresults = true
                }
                else{
                    
                    self.noresults = false
                }
                
                
                for i in stride(from: 0, to: json.results.count, by: 2){
                    
                    var ArrayData : [Photo] = []
                    
                    for j in i..<i+2{
                  
                        
                        if j < json.results.count{
                            
                            ArrayData.append(json.results[j])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.Images.append(ArrayData)
                    }
                }
            }
            catch{
                
                print(error.localizedDescription)
            }
                        
        }
        .resume()
    }
}

    


struct Photo : Identifiable,Decodable,Hashable {
    
    var id : String
    var urls : [String : String]
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
    
}
struct SearchPhoto : Decodable{

    var results : [Photo]
}



struct FindView_Previews: PreviewProvider {
    static var previews: some View {
        FindView()
            .preferredColorScheme(.light)
    }
}


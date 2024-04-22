//
//  ContentView.swift
//  DogPhoto
//
//  Created by Royal, Cindy L on 4/21/24.
//

import SwiftUI

struct ContentView: View {
    @State private var dogImageURL = URL(string: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")
    @State private var imageData: Data?

    var body: some View {
        VStack {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300, maxHeight: 300)
            } else {
                Text("Press the button to load a dog image!")
            }

            Button("Fetch Random Dog") {
                fetchRandomDog()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }

    func fetchRandomDog() {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            // Decode JSON directly in the fetch function
            if let decodedResponse = try? JSONDecoder().decode(DogImage.self, from: data),
               let imageURL = URL(string: decodedResponse.message) {
                fetchImage(from: imageURL)
            }
        }.resume()
    }

    func fetchImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.imageData = data
            }
        }.resume()
    }
}

struct DogImage: Decodable {
    let message: String
    let status: String
}

#Preview {
    ContentView()
}

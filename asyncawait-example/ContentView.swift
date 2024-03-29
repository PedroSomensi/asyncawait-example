//
//  ContentView.swift
//  asyncawait-example
//
//  Created by Pedro Somensi on 19/02/24.
//

import SwiftUI

struct ContentView: View {
    
    var service = PokemonApi()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear(perform: {
            
            Task.init {
                do {
                    let pokemon = try await service.getCharizard()
                    print(pokemon)
                } catch {
                    print(error)
                }
            }
            
        })
    }
}

#Preview {
    ContentView()
}

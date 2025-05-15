//
//  ContentView.swift
//  DangerDemo
//
//  Created by Hiroki Ikeuchi on 2025/05/12.
//

import SwiftUI

struct ContentView: View {

    static let Hoge: String = "hikeuchi"

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")


            
            

        }
        .padding()
        .onAppear() {
            if true {
                print("Nice")
            }
        }
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  NFCReader
//
//  Created by WingCH on 3/10/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm: ContentViewModel = ContentViewModel()
    var body: some View {
        VStack {
            
            GroupBox(label: Label("Balance", systemImage: "creditcard.fill")) {
                HStack {
                    Text(vm.balance ?? "HK$----")
                        .font(.system(.largeTitle, design: .rounded))
                        .fontWeight(.bold)
                    Spacer()
                }
            }.padding()
            
            
            Button(action: vm.scan) {
                Text("Scan card")
            }
            .tint(.green)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

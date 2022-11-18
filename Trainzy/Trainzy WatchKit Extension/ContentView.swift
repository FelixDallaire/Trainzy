//
//  ContentView.swift
//  Trainzy WatchKit Extension
//
//  Created by Felix Dallaire on 2022-08-21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack(alignment: .leading){
            Text("Trainzy")
                .foregroundColor(Color("AccentGreen"))
                .font(.title3.bold())
               
            Spacer()

            NavigationLink(destination: WorkoutManagerView()){
                Label("Workouts", systemImage: "list.dash")
                    .labelStyle(.titleAndIcon)
                    .padding()
            }
            .background(Color("BackgroundGreen"))
            .font(.headline.bold())
            .foregroundColor(Color("AccentGreen"))
            .cornerRadius(25.0)
            
            
            NavigationLink(destination: EmptyView()){
                Label("Settings", systemImage: "gearshape.fill")
                    .labelStyle(.titleAndIcon)
                    .padding()
            }
            .background(Color("BackgroundGreen"))
            .font(.headline.bold())
            .foregroundColor(Color("AccentGreen"))
            .cornerRadius(25.0)
            .disabled(true)
        }.padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

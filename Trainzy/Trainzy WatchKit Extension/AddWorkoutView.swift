//
//  AddWorkoutView.swift
//  Trainzy WatchKit Extension
//
//  Created by Felix Dallaire on 2022-08-21.
//

import SwiftUI

struct AddWorkoutView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var workoutName: String = ""
    @State var workoutExerciseList: [WorkoutExercise] = []
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Label("Workout's name", systemImage: "")
                    .labelStyle(.titleOnly)
                    .font(.headline.bold())
                    .foregroundColor(Color("AccentGreen"))
                TextField("Enter name", text: $workoutName)
                    .foregroundColor(Color("AccentGreen"))
            }
                                
            Button(action: {
                API().addWorkout(workoutName: workoutName){ (workoutID) in
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Label("Add", systemImage: "")
                    .labelStyle(.titleOnly)
                    .font(.headline.bold())
                    .foregroundColor(Color("BackgroundGreen"))
            }
            .background(Color("AccentGreen"))
            .cornerRadius(50.0)
            .padding(.vertical)
        }.padding()
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutView()
    }
}

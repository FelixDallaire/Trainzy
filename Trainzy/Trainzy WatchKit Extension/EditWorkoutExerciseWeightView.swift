//
//  EditWorkoutExerciseWeightView.swift
//  Trainzy WatchKit Extension
//
//  Created by Felix Dallaire on 2022-08-24.
//

import SwiftUI

struct EditWorkoutExerciseWeightView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var weight: Double = 0.0
    @State private var scrollAmountWeight = 500.0
    @State private var prevScrollAmountWeight = 0.0
    @State private var upWeight = false
    
    @Binding var currentWorkoutExercise: WorkoutExercise

    var body: some View {
        VStack(alignment: .leading) {
            Text("Edit Weight")
                .font(.headline.bold())
            
            HStack{
                Label("", systemImage: "minus.square.fill")
                    .labelStyle(.iconOnly).font(.largeTitle)
                    .foregroundColor(Color("AccentGreen"))
                    .onTapGesture(){
                        currentWorkoutExercise.weight = removeDecimal(value: currentWorkoutExercise.weight)
                    }
                Spacer()
                Text("\(currentWorkoutExercise.weight, specifier: "%.1f")").font(.title3.bold())
                    .onAppear(){
                        weight = currentWorkoutExercise.weight
                    }
                Spacer()
                Label("", systemImage: "plus.app.fill")
                    .labelStyle(.iconOnly).font(.largeTitle)
                    .foregroundColor(Color("AccentGreen"))
                    .onTapGesture(){
                        currentWorkoutExercise.weight = add(value: currentWorkoutExercise.weight)
                    }
            }
            .font(.title.bold())
            .focusable()
            .digitalCrownRotation($scrollAmountWeight, from: 0, through: 999, by: 10, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
            .onChange(of: scrollAmountWeight) { value in
                self.upWeight = (value > prevScrollAmountWeight)
                self.prevScrollAmountWeight = value

                if upWeight {
                    currentWorkoutExercise.weight = add(value: currentWorkoutExercise.weight)
                } else {
                    currentWorkoutExercise.weight = removeDecimal(value: currentWorkoutExercise.weight)
                }
            }
            
            Spacer()
            Button("Save", action: {
                API().editWorkoutExercise(editedWorkoutExercise: currentWorkoutExercise) { (statusCode) in
                    if statusCode == 200 {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            })
                .font(.headline.bold())
                .padding(.vertical)
        }
        .navigationTitle("Edit weight")
        .frame(maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func add(value: Double) -> Double {
        var newValue = value
        if value != 999 {
            newValue += 1
        }
        return newValue
    }
    
    func removeDecimal(value: Double) -> Double {
        var newValue = value
        if value != 0 {
            newValue -= 0.5
        }
        return newValue
    }
}

struct EditWorkoutExerciseWeightView_Previews: PreviewProvider {
    static var previews: some View {
        let fakeWorkoutExercise =  WorkoutExercise(id: UUID(), name: "Dumbell Squat To Bench", workout_id: UUID(), exercise_id: UUID(), position: 1, set: 3, rep: 10, weight: 40.5, rest_time: 90, is_superset: true)
        EditWorkoutExerciseWeightView(currentWorkoutExercise: .constant(fakeWorkoutExercise))
    }
}

//
//  WorkoutExerciseInformationView.swift
//  Trainzy WatchKit Extension
//
//  Created by Felix Dallaire on 2022-08-26.
//

import SwiftUI

struct WorkoutExerciseInformationView: View {
    
    @State var currentWorkoutExercise: WorkoutExercise
    @State var isPresentingModalView: Bool = false
    
    var body: some View {
        Text(currentWorkoutExercise.name.capitalized)
            .font(.system(size: 15).bold())
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top)
        
        HStack {
            Text("\(currentWorkoutExercise.rep)\nReps")
                .padding()
                .background(Color("BackgroundGreen"))
                .cornerRadius(5.0)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundColor(Color("AccentGreen"))
                .font(.system(size: 11).bold())
            
            Text("\(currentWorkoutExercise.weight, specifier: "%.1f")\nLbs")
                .padding()
                .background(Color("BackgroundGreen"))
                .cornerRadius(5.0)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundColor(Color("AccentGreen"))
                .font(.system(size: 11).bold())
                .simultaneousGesture(LongPressGesture().onEnded { _ in
                    isPresentingModalView.toggle()
                })
                .fullScreenCover(isPresented: $isPresentingModalView) {
                   EditWorkoutExerciseWeightView(currentWorkoutExercise: $currentWorkoutExercise)
                }
            
            if currentWorkoutExercise.is_superset {
                Label("", systemImage: "chevron.forward.2")
                    .labelStyle(.iconOnly)
                    .padding(13.5)
                    .background(Color("BackgroundOrange"))
                    .foregroundColor(Color.orange)
                    .cornerRadius(5.0)
                    .font(.system(size: 15).bold())
            }
        } // End HStack
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct WorkoutExerciseInformationView_Previews: PreviewProvider {
    static var previews: some View {
        let fakeWorkoutExercise = WorkoutExercise(id: UUID(), name: "Dumbell one arm pull / Ramer", workout_id: UUID(), exercise_id: UUID(), position: 0, set: 3, rep: 10, weight: 40.0, rest_time: 60, is_superset: true)
        WorkoutExerciseInformationView(currentWorkoutExercise: fakeWorkoutExercise)
    }
}

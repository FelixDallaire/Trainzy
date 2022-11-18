//
//  WorkoutExerciseInformationView.swift
//  TrainzyManager
//
//  Created by Felix Dallaire on 2022-08-30.
//

import SwiftUI

struct WorkoutExerciseInformationView: View {
    
    @State var currentWorkoutExercie: WorkoutExercise
    
    var body: some View {
        LazyVStack(alignment: .center){
            
            HStack {
                Label(currentWorkoutExercie.name, systemImage: "x.square.fill")
                    .labelStyle(.titleOnly)
                    .font(.title3.bold())
                    .foregroundColor(Color.accentColor)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .padding(.horizontal)
            }
            .padding()
            
            VStack(alignment: .center){
                Text("Reps \(currentWorkoutExercie.rep)")
                    .padding()
                    .background(Color("ListBackgroundBlack"))
                    .cornerRadius(15.0, antialiased: true)
                    .multilineTextAlignment(.center)
                Text("Weight \(currentWorkoutExercie.weight, specifier: "%.2f")")
                    .padding()
                    .background(Color("ListBackgroundBlack"))
                    .cornerRadius(15.0, antialiased: true)
                    .multilineTextAlignment(.center)
                
                HStack {
                    if currentWorkoutExercie.is_superset {
                        Label("", systemImage: "chevron.right.2")
                            .labelStyle(.iconOnly)
                            .foregroundColor(Color.orange)
                    } else {
                        Label("", systemImage: "clock.arrow.2.circlepath")
                            .labelStyle(.iconOnly)
                        Label(API().secondsToHoursMinutesSecondsString(currentWorkoutExercie.rest_time), systemImage: "")
                            .labelStyle(.titleOnly)
                    }
                }
                .padding()
                .background(currentWorkoutExercie.is_superset ? Color("BackgroundOrange") : Color("ListBackgroundBlack"))
                .cornerRadius(15.0, antialiased: true)
                .multilineTextAlignment(.center)
                
                HStack {
                    ForEach(0..<currentWorkoutExercie.set, id:\.self) { index in
                        if currentWorkoutExercie.is_superset {
                            Label("", systemImage: "slash.circle.fill")
                                .labelStyle(.iconOnly)
                                .foregroundColor(Color.orange)
                        } else {
                            Label("", systemImage: "checkmark.circle.fill")
                                .labelStyle(.iconOnly)
                                .foregroundColor(Color.accentColor)
                        }
                    }
                }
                .padding()
            }
            .font(.headline.weight(.bold))
            .foregroundColor(Color("ListWhite"))
        }
        .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height / 2)
        .background(Color("ListSectionBackgroundBlack"))
        .cornerRadius(15.0, antialiased: true)
    }
}

struct WorkoutExerciseInformationView_Previews: PreviewProvider {
    static var previews: some View {
        let fakeWkExercise = WorkoutExercise(id: UUID(), name: "Dumbell Chest Press", workout_id: UUID(), exercise_id: UUID(), position: 0, set: 3, rep: 10, weight: 40.0, rest_time: 60, is_superset: true)
        WorkoutExerciseInformationView(currentWorkoutExercie: fakeWkExercise)
    }
}

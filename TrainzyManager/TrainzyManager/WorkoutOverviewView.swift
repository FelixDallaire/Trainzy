//
//  WorkoutOverviewView.swift
//  TrainzyManager
//
//  Created by Felix Dallaire on 2022-09-04.
//

import SwiftUI

struct WorkoutOverviewView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showingAddExerciseSheet = false
    @State private var showingEditExerciseSheet = false

    @State var currentWorkout: Workout
    @State var isLoading: Bool = false
    @State var isEditActive: Bool = false
    @State var workoutExerciseToEditIndex: Int = 0
    @State var allWorkoutExercise: [WorkoutExercise] = [
                WorkoutExercise(id: UUID(), name: "Dumbell Chest Press", workout_id: UUID(), exercise_id: UUID(), position: 0, set: 3, rep: 10, weight: 40.0, rest_time: 60, is_superset: false),
                WorkoutExercise(id: UUID(), name: "Squat To Bench", workout_id: UUID(), exercise_id: UUID(), position: 0, set: 3, rep: 10, weight: 35.0, rest_time: 60, is_superset: true),
                WorkoutExercise(id: UUID(), name: "Dumbell One Arm Row / Ramer", workout_id: UUID(), exercise_id: UUID(), position: 0, set: 3, rep: 10, weight: 40.0, rest_time: 60, is_superset: false)
    ]
    
    var body: some View {
        VStack(alignment: .leading){
            if isLoading {
                ProgressView()
                    .tint(Color.accentColor)
                    .scaleEffect(2)
                    .padding()
                    .onAppear(){
//                        initList()
                    }
                Spacer()
            } else {
                Form{
                    Text(currentWorkout.name.capitalized)
                        .font(.largeTitle.bold())
                        .foregroundColor(Color.accentColor)
                        .listRowBackground(Color.clear)
                    
                    Section(header:
                                Text("Exercises")
                        .font(.title2.weight(.bold))) {
                            if allWorkoutExercise.isEmpty{
                                VStack(alignment: .center){
                                    Button(action: {
                                        showingAddExerciseSheet.toggle()
                                        isEditActive = false
                                    }) {
                                        Text("Add\nexercise")
                                            .multilineTextAlignment(.center)
                                            .font(.title2.weight(.bold))
                                            .frame(maxHeight: .infinity)
                                            .padding()
                                    }
                                    .background(Color("ListSectionBackgroundBlack"))
                                    .cornerRadius(15.0, antialiased: true)
                                    .controlSize(.large)
                                    .padding()
                                    .sheet(isPresented: $showingAddExerciseSheet) {
                                        AddExerciseView(apiAppend: true, workoutID: currentWorkout.id, allWorkoutExercise: $allWorkoutExercise)
                                    }
                                } // End HStack
                                .frame(maxWidth: .infinity)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    if !allWorkoutExercise.isEmpty {
                                        ForEach(allWorkoutExercise, id: \.self) { currentWorkoutExercise in
                                            VStack{
                                                WorkoutExerciseInformationView(currentWorkoutExercie: currentWorkoutExercise)
                                                    .onTapGesture(){
                                                        if isEditActive {
                                                            workoutExerciseToEditIndex = allWorkoutExercise.firstIndex(of: currentWorkoutExercise)!
                                                            isEditActive = false
                                                            showingEditExerciseSheet.toggle()
                                                        }
                                                    }

                                                Button(action: {
                                                    let indexOfExercise = allWorkoutExercise.firstIndex(of: currentWorkoutExercise)
                                                    API().deleteWorkoutExerciseById(workoutExerciseID: allWorkoutExercise[indexOfExercise!].id) {(statusCode) in
                                                        if statusCode == 200 {
                                                            allWorkoutExercise.remove(at: indexOfExercise!)
                                                        }
                                                    }
                                                }) {
                                                    Label("", systemImage: "minus.circle")
                                                        .labelStyle(.iconOnly)
                                                        .font(.largeTitle.weight(.medium))
                                                        .foregroundColor(Color("BrightRed"))
                                                }
                                                .opacity(isEditActive ? 1 : 0)
                                                .disabled(isEditActive ? false : true)
                                                .buttonStyle(.plain)
                                                .controlSize(.regular)
                                                .padding()
                                                
                                            } // End VStack
                                            .sheet(isPresented: $showingEditExerciseSheet) {
                                                EditWorkoutExerciseView(currentWorkoutExercise: allWorkoutExercise[workoutExerciseToEditIndex], allWorkoutExercise: $allWorkoutExercise)
                                            }
                                            
                                        } // End forEach
                                    }
                                    
                                    VStack{
                                        Button(action: {
                                            showingAddExerciseSheet.toggle()
                                            isEditActive = false
                                        }) {
                                            HStack {
                                                Label("", systemImage: "plus.square.fill")
                                                    .labelStyle(.iconOnly)
                                                    .multilineTextAlignment(.center)
                                                    .font(.largeTitle.weight(.bold))
                                                
                                                Label("Add\nExercise", systemImage: "")
                                                    .labelStyle(.titleOnly)
                                                    .multilineTextAlignment(.leading)
                                                    .lineLimit(2)
                                                    .font(.title2.weight(.bold))
                                            }
                                            .padding()
                                        }
                                        .padding()
                                        .background(Color("ListSectionBackgroundBlack"))
                                        .cornerRadius(15.0, antialiased: true)
                                        .controlSize(.large)
                                        .padding()
                                        .sheet(isPresented: $showingAddExerciseSheet) {
                                            AddExerciseView(apiAppend: true, workoutID: currentWorkout.id, allWorkoutExercise: $allWorkoutExercise)
                                        }
                                        
                                        Button(action: {
                                            // just a placeholder
                                        }) {
                                            Label("", systemImage: "minus.circle")
                                                .labelStyle(.iconOnly)
                                                .font(.largeTitle.weight(.medium))
                                                .foregroundColor(Color("BrightRed"))
                                        }
                                        .buttonStyle(.plain)
                                        .controlSize(.regular)
                                        .disabled(true)
                                        .opacity(0)
                                        .padding()
                                        
                                    } // End VStack

                                } // End HStack

                                
                            } // End ScrollView
                        } // End Else
                            
                            HStack{
                                Button(action: {
                                    dismiss()
                                }) {
                                  Label("", systemImage: "chevron.left")
                                        .labelStyle(.iconOnly)
                                        .font(.title2.weight(.bold))
                                }
                                .controlSize(.large)
                                .buttonStyle(.bordered)
                                .tint(Color.accentColor)
                                .listRowBackground(Color.clear)
                                
                                Spacer()
                                
                                Button(action: {
                                    isEditActive.toggle()
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                        .labelStyle(.titleOnly)
                                        .font(.title3.weight(.heavy))
                                }
                                .tint(Color.accentColor)
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                                
                            } // End HStack
                            .listRowSeparator(.hidden)
                    }
                } // End Form
            }
            
        } // End SStack
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .onAppear {
            UITableView.appearance().backgroundColor = UIColor(Color("ListBackgroundBlack"))
        }
    }
    
    func initList() {
        API().getWorkoutExercisesByWorkoutId(workoutID: currentWorkout.id) { (resObj) in
            if resObj.statusCode == 200 {
                self.allWorkoutExercise = resObj.body as! [WorkoutExercise]
                self.isLoading = false
            }
        }
    }
}

struct WorkoutOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        let fakeWorkout: Workout = Workout(id: UUID(), name: "Fake Workout")
        WorkoutOverviewView(currentWorkout: fakeWorkout)
    }
}

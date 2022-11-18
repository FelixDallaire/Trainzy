//
//  AddWorkoutView.swift
//  TrainzyManager
//
//  Created by Felix Dallaire on 2022-08-30.
//

import SwiftUI

struct AddWorkoutView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showingAddexerciseSheet = false
    
    @State var newWorkoutId: UUID = UUID()
    
    @State var isEditActive: Bool = false

    @Binding var allWorkouts: [Workout]
    @State var workoutName = "New Workout"
    @State var allWorkoutExercise: [WorkoutExercise] = [
        WorkoutExercise(id: UUID(), name: "Dumbell Chest Press", workout_id: UUID(), exercise_id: UUID(), position: 0, set: 3, rep: 10, weight: 40.0, rest_time: 60, is_superset: false),
        WorkoutExercise(id: UUID(), name: "Squat To Bench", workout_id: UUID(), exercise_id: UUID(), position: 0, set: 3, rep: 10, weight: 35.0, rest_time: 60, is_superset: true),
        WorkoutExercise(id: UUID(), name: "Dumbell One Arm Row / Ramer", workout_id: UUID(), exercise_id: UUID(), position: 0, set: 3, rep: 10, weight: 40.0, rest_time: 60, is_superset: false),
    ]
    
    var body: some View {
        Form {
            Text("New Workout")
                .font(.largeTitle.bold())
                .foregroundColor(Color.accentColor)
                .listRowBackground(Color.clear)
            
            
            Section(header:
                        Text("Informations")
                .font(.title2.weight(.bold))){
                    VStack(alignment: .leading){
                        Text("Workout's name")
                            .font(.title3.weight(.bold))
                            .foregroundColor(Color.gray)
                            .padding(.top)
                        TextField("", text: $workoutName)
                            .padding()
                            .background(Color("SubAccentBlack"))
                            .cornerRadius(10)
                            .foregroundColor(.accentColor)
                            .font(.headline.bold())
                            .padding(.bottom)
                    }
            }
            .listRowBackground(Color("ListSectionBackgroundBlack"))
            
            Section(header:
                        Text("Exercises")
                .font(.title2.weight(.bold))){
                    let addExerciseButton = Button(action: {
                        showingAddexerciseSheet.toggle()
                        isEditActive = false
                    }) {
                        Text("Add\nexercise")
                            .multilineTextAlignment(.center)
                            .font(.title2.weight(.bold))
                            .padding()
                    }
                    .background(Color("ListSectionBackgroundBlack"))
                    .cornerRadius(15.0, antialiased: true)
                    .controlSize(.large)
                    .padding()
                    .sheet(isPresented: $showingAddexerciseSheet) {
                        AddExerciseView(apiAppend: false, workoutID: newWorkoutId, allWorkoutExercise: $allWorkoutExercise)
                    }
                        
                    if allWorkoutExercise.isEmpty {
                        VStack(alignment: .center){
                            addExerciseButton
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(allWorkoutExercise, id: \.self) { currentWorkoutExercise in
                                    VStack{
                                        WorkoutExerciseInformationView(currentWorkoutExercie: currentWorkoutExercise)

                                        Button(action: {
                                            let indexOfExercise = allWorkoutExercise.firstIndex(of: currentWorkoutExercise)
                                            allWorkoutExercise.remove(at: indexOfExercise!)
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
                                        .padding(.top)
                                    }
                                }
                                VStack {
                                    addExerciseButton
                                    
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
                                    .padding(.top)
                                }
                            }
                        } // End ScrollView
                        .listRowSeparator(.hidden)
                    }
                    
                    Button(action: {
                        isEditActive.toggle()
                    }) {
                        Label("Edit", systemImage: "pencil")
                            .labelStyle(.titleOnly)
                            .font(.title3.weight(.heavy))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .tint(Color.accentColor)
                    .buttonStyle(.bordered)
                    .controlSize(.large)
            }
            .listSectionSeparator(.hidden)
            .listRowBackground(Color.clear)

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
                
                Button(action: {
                    saveAndaddWorkout()
                }) {
                    Text("Add workout")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color("ListBackgroundBlack"))
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .tint(Color.accentColor)
            }
            .listRowBackground(Color.clear)
            .frame(maxWidth: .infinity, alignment: .center)

                
        } // End form
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .onAppear {
           UITableView.appearance().backgroundColor = UIColor(Color("ListBackgroundBlack"))
        }
    }
    
    func saveAndaddWorkout(){
        API().addWorkout(workoutName: workoutName) { (resObj) in
            if resObj.statusCode == 200 || resObj.statusCode == 201 {
                newWorkoutId = resObj.body as! UUID
                
                allWorkouts.append(Workout(id: newWorkoutId, name: workoutName))
                
                for wkExercise in allWorkoutExercise {
                    saveAndAddWorkoutExercise(currentWorkoutExercise: wkExercise)
                }
                
                dismiss()
            }
        }
    }
    
    func saveAndAddWorkoutExercise(currentWorkoutExercise: WorkoutExercise) {
        var newWkExercise: WorkoutExercise = currentWorkoutExercise
        newWkExercise.workout_id = newWorkoutId
        API().addWorkoutExercise(newWorkoutExercise: newWkExercise) { (resObj) in
            if resObj.statusCode == 200 {
                return
            }
        }
    }
    
}

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutView(allWorkouts: .constant([]))
    }
}


struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 2 : 1)
    }
}

//
//  EditWorkoutExerciseView.swift
//  TrainzyManager
//
//  Created by Felix Dallaire on 2022-09-04.
//

import SwiftUI

struct EditWorkoutExerciseView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var currentWorkoutExercise: WorkoutExercise
    @Binding var allWorkoutExercise: [WorkoutExercise]
    
    @State var exerciseName: String = ""
    @State var exerciseSets: Double = 0.0
    @State var exerciseReps: Double = 0.0
    @State var exerciseWeight: Double = 0.0
    @State var exerciseRestTime: Int = 0
    @State var isSuperSet: Bool = false
    
    var body: some View {
        let orSeparator = HStack {
            RoundedRectangle(cornerRadius: 50.0)
                .fill(Color.accentColor)
                .frame(width: 45.0, height: 3)
            Text("Or")
                .font(.headline.weight(.bold))
            RoundedRectangle(cornerRadius: 50.0)
                .fill(Color.accentColor)
                .frame(width: 45.0, height: 3)
        }
        
        
        VStack(alignment: .leading){
            Form {
                Text("New Exercise")
                    .font(.largeTitle.bold())
                    .foregroundColor(Color.accentColor)
                    .listRowBackground(Color.clear)
                
                Section(header: Text("Informations")
                    .font(.title2.weight(.bold))){
                        VStack(alignment: .leading){
                            Text("Exercise's name")
                                .font(.title3.weight(.bold))
                                .foregroundColor(Color.gray)
                                .padding(.top)
                            
                            TextField("", text: $exerciseName)
                                .padding()
                                .background(Color("SubAccentBlack"))
                                .cornerRadius(10)
                                .foregroundColor(.accentColor)
                                .font(.headline.bold())
                                .padding(.bottom)
                        }
                } // End Section
                
                
                Section(header: Text("Sets")
                    .font(.title2.weight(.bold))){
                        HStack {
                            Label("", systemImage: "minus.square.fill")
                                .labelStyle(.iconOnly).font(.largeTitle.weight(.heavy))
                                .foregroundColor(Color.accentColor)
                                .onTapGesture(){
                                    exerciseSets = remove(value: exerciseSets)
                                }
                            Spacer()
                            Text("\(Int(exerciseSets))").font(.title.weight(.heavy))
                            Spacer()
                            Label("", systemImage: "plus.app.fill")
                                .labelStyle(.iconOnly).font(.largeTitle.weight(.heavy))
                                .foregroundColor(Color.accentColor)
                                .onTapGesture(){
                                    exerciseSets = add(value: exerciseSets)
                                }
                        }
                        .padding()
                } // End Section
                
                
                Section(header: Text("Repetitions")
                    .font(.title2.weight(.bold))){
                        VStack{
                            HStack {
                                Label("", systemImage: "minus.square.fill")
                                    .labelStyle(.iconOnly).font(.largeTitle.weight(.heavy))
                                    .foregroundColor(Color.accentColor)
                                    .onTapGesture(){
                                        exerciseReps = remove(value: exerciseReps)
                                    }
                                Spacer()
                                Text("\(Int(exerciseReps))").font(.title.weight(.heavy))
                                Spacer()
                                Label("", systemImage: "plus.app.fill")
                                    .labelStyle(.iconOnly).font(.largeTitle.weight(.heavy))
                                    .foregroundColor(Color.accentColor)
                                    .onTapGesture(){
                                        exerciseReps = add(value: exerciseReps)
                                    }
                            }

                            orSeparator

                            HStack{
                                Button(action: {
                                    exerciseReps = 10
                                }) {
                                    Text("10 Reps")
                                }
                                .tint(Color("SubAccentBlack"))
                                .buttonStyle(.borderedProminent)
                                .controlSize(.regular)

                                Button(action: {
                                    exerciseReps = 15
                                }) {
                                    Text("15 Reps")
                                }
                                .tint(Color("SubAccentBlack"))
                                .buttonStyle(.borderedProminent)
                                .controlSize(.regular)
                            }
                            .font(.title3.weight(.bold))

                        }
                        .padding()
                } // End Section
                
                
                Section(header: Text("Weight")
                    .font(.title2.weight(.bold))){
                        VStack {

                            HStack {
                                Label("", systemImage: "minus.square.fill")
                                    .labelStyle(.iconOnly).font(.largeTitle.weight(.heavy))
                                    .foregroundColor(Color.accentColor)
                                    .onTapGesture(){
                                        exerciseWeight = removeDecimal(value: exerciseWeight)
                                    }
                                Spacer()
                                Text("\(exerciseWeight, specifier: "%.1f")").font(.title.weight(.heavy))
                                Spacer()
                                Label("", systemImage: "plus.app.fill")
                                    .labelStyle(.iconOnly).font(.largeTitle.weight(.heavy))
                                    .foregroundColor(Color.accentColor)
                                    .onTapGesture(){
                                        exerciseWeight = add(value: exerciseWeight)
                                    }
                            }

                            orSeparator

                            HStack{
                                Button(action: {
                                    exerciseWeight = 30.0
                                }) {
                                    Text("30.0")
                                }
                                .tint(Color("SubAccentBlack"))
                                .buttonStyle(.borderedProminent)
                                .controlSize(.regular)

                                Button(action: {
                                    exerciseWeight = 60.0
                                }) {
                                    Text("60.0")
                                }
                                .tint(Color("SubAccentBlack"))
                                .buttonStyle(.borderedProminent)
                                .controlSize(.regular)

                                Button(action: {
                                    exerciseWeight = 90.0
                                }) {
                                    Text("90.0")
                                }
                                .tint(Color("SubAccentBlack"))
                                .buttonStyle(.borderedProminent)
                                .controlSize(.regular)
                            }
                            .font(.title3.weight(.bold))

                        }
                        .padding()
                } // End Section
                
                
                Section(header: Text("Super set")
                    .font(.title2.weight(.bold))){
                        HStack {
                            Label("", systemImage: isSuperSet ? "checkmark.square.fill" : "square")
                                .labelStyle(.iconOnly)
                                .font(.largeTitle.weight(.heavy))
                                .foregroundColor(Color.accentColor)
                                .onTapGesture(){
                                    isSuperSet.toggle()
                                }

                            Label("Is it a super set?", systemImage: isSuperSet ? "checkmark.square.fill" : "square")
                                .labelStyle(.titleOnly)
                                .font(.title2.weight(.heavy))
                                .foregroundColor(Color.white)
                        }
                        .padding()
                } // End Section
                
                
                Section(header: Text("Rest time")
                    .font(.title2.weight(.bold))){
                        VStack {
                            HStack {
                                Label("", systemImage: "minus.square.fill")
                                    .labelStyle(.iconOnly).font(.largeTitle.weight(.heavy))
                                    .foregroundColor(Color.accentColor)
                                    .onTapGesture(){
                                        exerciseRestTime = Int(removeTime(value: Double(exerciseRestTime)))
                                    }
                                Spacer()
                                Text("\(API().secondsToHoursMinutesSecondsString(exerciseRestTime))")
                                    .font(.title.weight(.heavy))
                                Spacer()
                                Label("", systemImage: "plus.app.fill")
                                    .labelStyle(.iconOnly).font(.largeTitle.weight(.heavy))
                                    .foregroundColor(Color.accentColor)
                                    .onTapGesture(){
                                        exerciseRestTime = Int(addTime(value: Double(exerciseRestTime)))
                                    }
                            } // end HStack

                            orSeparator

                            HStack{
                                Button(action: {
                                    exerciseRestTime = 60
                                }) {
                                    Text("\(API().secondsToHoursMinutesSecondsString(60))")
                                        .font(.title3.weight(.bold))
                                }
                                .tint(Color("SubAccentBlack"))
                                .buttonStyle(.borderedProminent)
                                .controlSize(.regular)

                                Button(action: {
                                    exerciseRestTime = 30
                                }) {
                                    Text("\(API().secondsToHoursMinutesSecondsString(30))")
                                        .font(.title3.weight(.bold))
                                }
                                .tint(Color("SubAccentBlack"))
                                .buttonStyle(.borderedProminent)
                                .controlSize(.regular)
                            }

                        } // End VStack
                        .padding()
                } // End Section
                
                Button(action: {
                    let editedWorkoutexercise = WorkoutExercise(id: currentWorkoutExercise.id, name: exerciseName, workout_id: currentWorkoutExercise.workout_id, exercise_id: currentWorkoutExercise.exercise_id, position: currentWorkoutExercise.position, set: Int(exerciseSets), rep: Int(exerciseReps), weight: exerciseWeight, rest_time: exerciseRestTime, is_superset: isSuperSet)

                    API().editWorkoutExercise(editedWorkoutExercise: editedWorkoutexercise) { (statusCode) in
                        if statusCode == 200 {
                            getAllWorkoutExercise()
                        }
                    }
                }) {
                    Text("Edit Exercise")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color("BackgroundBlack"))
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .tint(Color.accentColor)
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
                
                
            } // End Form
        } // End VStack
        .preferredColorScheme(.dark)
        .onAppear {
            self.initView()
            UITableView.appearance().backgroundColor = UIColor(Color("ListBackgroundBlack"))
        }
        
    } // End Body
    
    func initView() {
        exerciseName = currentWorkoutExercise.name
        exerciseSets = Double(currentWorkoutExercise.set)
        exerciseReps = Double(currentWorkoutExercise.rep)
        exerciseWeight = currentWorkoutExercise.weight
        exerciseRestTime = currentWorkoutExercise.rest_time
        isSuperSet = currentWorkoutExercise.is_superset
    }
    
    func getAllWorkoutExercise() {
        API().getWorkoutExercisesByWorkoutId(workoutID: currentWorkoutExercise.workout_id) { (resObj) in
            if resObj.statusCode == 200 {
                self.allWorkoutExercise = resObj.body as! [WorkoutExercise]
                dismiss()
            }
        }
    }
    
    func add(value: Double) -> Double {
        var newValue = value
        if value != 999 {
            newValue += 1.0
        }
        return newValue
    }
    
    func addTime(value: Double) -> Double {
        var newValue = value
        if value < 86400 {
            newValue += 5.0
        }
        return newValue
    }
    
    func addDecimal(value: Double) -> Double {
        var newValue = value
        if value != 999 {
            newValue += 0.5
        }
        return newValue
    }

    func remove(value: Double) -> Double {
        var newValue = value
        if value != 0 {
            newValue -= 1.0
        }
        return newValue
    }
    
    func removeTime(value: Double) -> Double {
        var newValue = value
        if value != 86400 {
            newValue -= 5.0
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

struct EditWorkoutExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        let fakeWkExercise = WorkoutExercise(id: UUID(), name: "Dumbell Chest Press", workout_id: UUID(), exercise_id: UUID(), position: 0, set: 3, rep: 10, weight: 40.0, rest_time: 60, is_superset: false)
        EditWorkoutExerciseView(currentWorkoutExercise: fakeWkExercise, allWorkoutExercise: .constant([]))
    }
}

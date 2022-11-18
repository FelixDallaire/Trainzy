////
////  AddWorkoutExerciseView.swift
////  Trainzy WatchKit Extension
////
////  Created by Felix Dallaire on 2022-08-22.
////
//
//import SwiftUI
//
//struct AddWorkoutExerciseView: View {
//    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @State var workoutId: UUID = UUID()
//    @Binding var workoutExerciseList: [WorkoutExercise]
//    
//    @State private var selection = 0
//    @State private var exerciseSelection: Exercise?
//    @State private var allExercises: [Exercise] = []
//    
//    @State private var exerciseName = ""
////    @State private var choosedExercise: Exercise = Exercise(id: UUID(), name: "", description: "")
//    @State private var reps: Double = 0
//    @State private var sets: Double = 0
//    @State private var weight: Double = 0
//    @State private var restTime: Int = 0
//
//    
//    
//    @State private var upReps = false
//    @State private var upSets = false
//    @State private var upWeight = false
//    @State private var upRest = false
//
//    @State private var scrollAmountReps = 500.0
//    @State private var scrollAmountSets = 500.0
//    @State private var scrollAmountWeight = 500.0
//    @State private var scrollAmountRest = 500.0
//
//    @State private var prevScrollAmountReps = 0.0
//    @State private var prevScrollAmountSets = 0.0
//    @State private var prevScrollAmountWeight = 0.0
//    @State private var prevScrollAmountRest = 0.0
//
//
//    var body: some View {
//        TabView(selection: $selection){
//            // Select Exercise
//            ZStack{
//                List{
//                    ForEach(allExercises, id: \.self) { exercise in
//                        Text(exercise.name).onTapGesture {
//                            exerciseName = exercise.name
////                            choosedExercise = exercise
//                            selection = 1
//                        }
//                    }
//                }.onAppear(){
//                    API().getAllExercises() { (allExercises) in
//                        self.allExercises = allExercises
//                    }
//                }
//            }.tag(0)
//            
//            
//            // Informations
//            ZStack {
//                VStack{
//                    VStack(alignment: .leading) {
//                        Label("Name", systemImage: "")
//                            .labelStyle(.titleOnly)
//                            .font(.headline.bold())
//                        TextField("", text: $exerciseName)
//                    }.padding(.vertical)
//                    
//                    VStack(alignment: .leading) {
//                        Label("Description", systemImage: "")
//                            .labelStyle(.titleOnly)
//                            .font(.headline.bold())
//                    }
//                }
//            }.tag(1)
//            
//            // Rep / set / weight
//            List {
//                //   REPS
//                VStack(alignment: .leading){
//                    Text("Repetitions")
//                        .font(.headline.bold())
//                    HStack {
//                        Label("", systemImage: "minus.square.fill")
//                            .labelStyle(.iconOnly).font(.largeTitle)
//                            .foregroundColor(Color("AccentGreen"))
//                            .onTapGesture(){
//                                reps = remove(value: reps)
//                            }
//                        Spacer()
//                        Text("\(Int(reps))").font(.title3.bold())
//                        Spacer()
//                        Label("", systemImage: "plus.app.fill")
//                            .labelStyle(.iconOnly).font(.largeTitle)
//                            .foregroundColor(Color("AccentGreen"))
//                            .onTapGesture(){
//                                reps = add(value: reps)
//                            }
//                    }
//                }
//                .digitalCrownRotation($scrollAmountReps, from: 0, through: 999, by: 10, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
//                .onChange(of: scrollAmountReps) { value in
//                    self.upReps = (value > prevScrollAmountReps)
//                    self.prevScrollAmountReps = value
//
//                    if upReps {
//                        reps = add(value: reps)
//                    } else {
//                        reps = remove(value: reps)
//                    }
//                }
//                
//                
//                // SETS
//                VStack(alignment: .leading){
//                    Text("Sets")
//                        .font(.headline.bold())
//                    HStack {
//                        Label("", systemImage: "minus.square.fill")
//                            .labelStyle(.iconOnly).font(.largeTitle)
//                            .foregroundColor(Color("AccentGreen"))
//                            .onTapGesture(){
//                                sets = remove(value: sets)
//                            }
//                        Spacer()
//                        Text("\(Int(sets))").font(.title3.bold())
//                        Spacer()
//                        Label("", systemImage: "plus.app.fill")
//                            .labelStyle(.iconOnly).font(.largeTitle)
//                            .foregroundColor(Color("AccentGreen"))
//                            .onTapGesture(){
//                                sets = add(value: sets)
//                            }
//                    }.font(.title.bold())
//                }
//                .padding(.vertical)
//                .digitalCrownRotation($scrollAmountSets, from: 0, through: 999, by: 10, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
//                .onChange(of: scrollAmountSets) { value in
//                    self.upSets = (value > prevScrollAmountSets)
//                    self.prevScrollAmountSets = value
//
//                    if upSets {
//                        sets = add(value: sets)
//                    } else {
//                        sets = remove(value: sets)
//                    }
//                }
//                
//                //WEIGTH
//                VStack(alignment: .leading){
//                    Text("Weight")
//                        .font(.headline.bold())
//                    HStack {
//                        Label("", systemImage: "minus.square.fill")
//                            .labelStyle(.iconOnly).font(.largeTitle)
//                            .foregroundColor(Color("AccentGreen"))
//                            .onTapGesture(){
//                                weight = removeDecimal(value: weight)
//                            }
//                        Spacer()
//                        Text("\(weight, specifier: "%.1f")").font(.title3.bold())
//                        Spacer()
//                        Label("", systemImage: "plus.app.fill")
//                            .labelStyle(.iconOnly).font(.largeTitle)
//                            .foregroundColor(Color("AccentGreen"))
//                            .onTapGesture(){
//                                weight = addDecimal(value: weight)
//                            }
//                    }.font(.title.bold())
//                }
//                .focusable()
//                .padding(.top)
//                .digitalCrownRotation($scrollAmountWeight, from: 0, through: 999, by: 10, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
//                .onChange(of: scrollAmountWeight) { value in
//                    self.upWeight = (value > prevScrollAmountWeight)
//                    self.prevScrollAmountWeight = value
//
//                    if upWeight {
//                        weight = addDecimal(value: weight)
//                    } else {
//                        weight = removeDecimal(value: weight)
//                    }
//                }
//            }
//            .tag(2)
//            
//            // Rest time and save
//            ZStack{
//                VStack{
//                    HStack{
//                        Label("", systemImage: "minus.square.fill")
//                            .labelStyle(.iconOnly).font(.largeTitle)
//                            .foregroundColor(Color("AccentGreen"))
//                            .onTapGesture(){
//                                restTime = Int(remove(value: Double(restTime)))
//                            }
//                        Spacer()
//                        let timer = Timer.publish(every: 1, tolerance: 0, on: .main , in: .common).autoconnect()
//                        Text(API().secondsToHoursMinutesSecondsString(restTime)).onReceive(timer) { _ in
//                            if restTime > 0 && false{
//                                restTime -= 1
//                            }
//                        }.font(.headline.bold())
//                        Spacer()
//                        Label("", systemImage: "plus.app.fill")
//                            .labelStyle(.iconOnly).font(.largeTitle)
//                            .foregroundColor(Color("AccentGreen"))
//                            .onTapGesture(){
//                                restTime = Int(add(value: Double(restTime)))
//                            }
//                    }
//                    .focusable()
//                    .digitalCrownRotation($scrollAmountRest, from: 0, through: 999, by: 10, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
//                        .onChange(of: scrollAmountRest) { value in
//                            self.upRest = (value > prevScrollAmountRest)
//                            self.prevScrollAmountRest = value
//
//                            if upRest {
//                                restTime = Int(add(value: Double(restTime)))
//                            } else {
//                                restTime = Int(remove(value: Double(restTime)))
//                            }
//                        }
//                    
//                    Button(action: {
////                        let newWorkoutExercise = WorkoutExercise(name: exerciseName, workout_id: workoutId, exercise_id: choosedExercise.id, position: workoutExerciseList.count, set: Int(sets), rep: Int(reps), weight: weight, rest_time: restTime)
////                        print(newWorkoutExercise)
////                        workoutExerciseList.append(newWorkoutExercise)
//                        self.presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Label("Save Exercise", systemImage: "")
//                            .labelStyle(.titleOnly)
//                            .font(.headline.bold())
//                            .foregroundColor(Color("Background75Percent"))
//                    }
//                    .background(Color("AccentGreen"))
//                    .cornerRadius(50.0)
//                    .padding(.vertical)
//                }
//            }.tag(3)
//        }.navigationTitle("Workout exercise")
//    }
//    
//    func add(value: Double) -> Double {
//        var newValue = value
//        if value != 999 {
//            newValue += 1.0
//        }
//        return newValue
//    }
//    
//    func addDecimal(value: Double) -> Double {
//        var newValue = value
//        if value != 999 {
//            newValue += 0.5
//        }
//        return newValue
//    }
//    
//    func remove(value: Double) -> Double {
//        var newValue = value
//        if value != 0 {
//            newValue -= 1.0
//        }
//        return newValue
//    }
//    
//    func removeDecimal(value: Double) -> Double {
//        var newValue = value
//        if value != 0 {
//            newValue -= 0.5
//        }
//        return newValue
//    }
//}
//
//struct AddWorkoutExerciseView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddWorkoutExerciseView(workoutExerciseList: .constant([]))
//    }
//}
//
//extension Float {
//    var clean: String {
//       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
//    }
//}
//
//

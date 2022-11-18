//
//  TestTimerView.swift
//  Trainzy WatchKit Extension
//
//  Created by Felix Dallaire on 2022-08-25.
//

import SwiftUI
   
struct WorkoutOverviewView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var tabSelection: Int = 1

    @State var selectedWorkout: Workout
    @State var currentSession: WorkoutSession? = nil
    @State var allWorkoutExercise: [WorkoutExercise] = [
//        WorkoutExercise(id: UUID(), name: "Dumbell one arm pull / Ramer", workout_id: UUID(), exercise_id: UUID(), position: 0, set: 3, rep: 10, weight: 40.0, rest_time: 60),
//        WorkoutExercise(id: UUID(), name: "Machine chest Press", workout_id: UUID(), exercise_id: UUID(), position: 1, set: 3, rep: 10, weight: 100.0, rest_time: 60)
    ]
    
    var body: some View {
        let finishWorkoutButton = VStack(alignment: .center){
            Button(action: {
                finishWorkoutSession()
                tabSelection = 1
            }) {
                Label("", systemImage: "xmark")
                    .labelStyle(.iconOnly)
                    .font(.title2.bold())
            }
            .tint(Color.red)
            Text("End")
                .font(.subheadline.bold())
        }
        
        if currentSession == nil && allWorkoutExercise.isEmpty{
            ProgressView()
                .tint(Color("AccentGreen"))
                .onAppear(){
                    checkIfSessionAlreadyStartedOrInitNewOne()
                    getAllWorkoutExerciseByWorkoutId()
            }
        } else {
            TabView(selection: $tabSelection){
                HStack{
                    VStack(alignment: .center){
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Label("", systemImage: "chevron.left")
                                .labelStyle(.iconOnly)
                                .font(.title2.bold())
                        }
                        .tint(Color.yellow)
                        Text("Back")
                            .font(.subheadline.bold())
                    }
                                
                    finishWorkoutButton
                }
                .tag(0)
                
                ForEach(allWorkoutExercise.indices, id: \.self) { index in
                    VStack(alignment: .leading){
                        let currentWorkoutExercise = allWorkoutExercise[index]
                        WorkoutExerciseInformationView(currentWorkoutExercise: currentWorkoutExercise)
                        if currentSession != nil {
                            WorkoutExerciseTimerView(currentWorkoutExercise: currentWorkoutExercise, currentWorkoutSession: currentSession!)
                        }
                    }
                    .tag(index + 1)
                }
                
                finishWorkoutButton
            }
            .navigationTitle(selectedWorkout.name)
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
    func createNewWorkoutSession() {
        let newWorkoutSession: WorkoutSession = WorkoutSession(id: UUID(), workout_id: selectedWorkout.id, is_started: true, is_finished: false)
        API().addWorkoutSession(workoutSession: newWorkoutSession) { (response: ResponseObject) in
            if response.statusCode == 201 {
                currentSession = (response.body as! WorkoutSession)
            }
        }
    }
    
    func checkIfSessionAlreadyStartedOrInitNewOne() {
        API().getAllWorkoutSessionByWorkoutId(workoutID: selectedWorkout.id) { (allWorkoutSessionFromResponse) in
            if let alreadyExistSession = allWorkoutSessionFromResponse.first(where: {$0.is_started == true && $0.is_finished == false}) {
                currentSession = alreadyExistSession
            } else {
                createNewWorkoutSession()
            }
        }
    }
    
    func getAllWorkoutExerciseByWorkoutId() {
        API().getWorkoutExercisesByWorkoutId(workoutID: selectedWorkout.id) { (resObj) in
            if !(resObj.body as! [WorkoutExercise]).isEmpty {
                allWorkoutExercise = resObj.body as! [WorkoutExercise]
            }
        }
    }
    
    func finishWorkoutSession() {
        API().updateWorkoutSessionStatus(is_started: true, is_finished: true, workoutSessionId: currentSession!.id) { (statusCode) in
            if statusCode == 200 {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct TestTimerView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutOverviewView(selectedWorkout: Workout(id: UUID(), name: "December 2019"))
    }
}

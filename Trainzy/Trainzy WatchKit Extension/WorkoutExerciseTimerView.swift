//
//  fvdfvdfvdv.swift
//  Trainzy WatchKit Extension
//
//  Created by Felix Dallaire on 2022-08-29.
//

import SwiftUI

struct WorkoutExerciseTimerView: View {
    @Environment(\.scenePhase) var scenePhase

    @State var appIsDeadAt: Double?
    @State var appIsBackAliveAt: Double?
    
    @State var timeRemain: Int = 1
    @State var isTimerRunning: Bool = false
    @State var currentWorkoutExercise: WorkoutExercise
    @State var currentWorkoutSession: WorkoutSession
    @State var setCount = 0
    @State var disabledButtonAfterSet: Bool = false
    
    @State var isShowingAlert: Bool = false
    
    var body: some View {
        VStack{
            let timer = Timer.publish(every: 1, tolerance: 0, on: .main , in: .common).autoconnect()
            
            
            if !currentWorkoutExercise.is_superset {
                Button(action: {
                    isTimerRunning.toggle()
                }) {
                    HStack{
                        Label(API().secondsToHoursMinutesSecondsString(timeRemain), systemImage: "clock.arrow.2.circlepath").labelStyle(.iconOnly)
                            .simultaneousGesture(LongPressGesture().onEnded { _ in
                                isShowingAlert = true
                            }).alert(isPresented: $isShowingAlert){ () -> Alert in
                                Alert(
                                    title: Text("Hold on!"),
                                    message: Text("End set or reset the timer?"),
                                    primaryButton: .default(Text("Reset"), action: {
                                        timeRemain = currentWorkoutExercise.rest_time
                                        isTimerRunning = false
                                    }),
                                    secondaryButton: .cancel(Text("End"), action: {
                                        createExerciseSession()
                                    })
                                )
                            }
                        
                        Label(API().secondsToHoursMinutesSecondsString(timeRemain), systemImage: isTimerRunning ? "play.fill" : "stop.fill").labelStyle(.iconOnly)
                            .simultaneousGesture(LongPressGesture().onEnded { _ in
                                timeRemain = currentWorkoutExercise.rest_time
                                isTimerRunning = false
                            })
                        Spacer()
                        Label(API().secondsToHoursMinutesSecondsString(timeRemain), systemImage: "")
                            .labelStyle(.titleOnly)
                            .onReceive(timer) { _ in
                                if timeRemain > 0  &&  isTimerRunning {
                                    timeRemain -= 1
                                }
                                if timeRemain <= 0 {
                                    finishAndResetSetTimer()
                                }
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 13).bold())
                .padding()
                .buttonStyle(.plain)
                .background(Color("AccentGreen"))
                .foregroundColor(.white)
                .cornerRadius(50)
                .padding(.top)
                .onChange(of: scenePhase) { newScenePhase in
                    switch newScenePhase {
                    case .active:
                        if isTimerRunning {
                            appIsBackAliveAt = Date().timeIntervalSince1970
                            let finalTime = timeRemain - Int((appIsBackAliveAt! - appIsDeadAt!))
                            timeRemain = (timeRemain - Int((appIsBackAliveAt! - appIsDeadAt!))) <= 0 ? 0 : finalTime
                        }
                    case .inactive:
                        print("App is inactive")
                    case .background:
                        appIsDeadAt = Date().timeIntervalSince1970
                    @unknown default:
                            print("Interesting: Unexpected new value.")
                    }
                }
                .disabled(disabledButtonAfterSet)
            }
            
            
            HStack{
                ForEach(0..<currentWorkoutExercise.set, id:\.self){ index in
                    if setCount > index && !currentWorkoutExercise.is_superset {
                        Label("", systemImage: "checkmark.circle.fill")
                            .labelStyle(.iconOnly)
                            .font(.system(size: 13).bold())
                            .foregroundColor(Color.green)
                    }
                    if setCount > index &&  currentWorkoutExercise.is_superset {
                        Label("", systemImage: "slash.circle.fill")
                            .labelStyle(.iconOnly)
                            .font(.system(size: 13).bold())
                            .foregroundColor(Color.orange)
                    }
                    if setCount <= index {
                        Label("", systemImage: "circle")
                            .labelStyle(.iconOnly)
                            .font(.system(size: 13).bold())
                    }
                }
            }
            .padding(.top)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear(){
            initTimerAndSetcount()
        }
        
    }
    
    func initTimerAndSetcount() {
        if !isTimerRunning {
            if currentWorkoutExercise.is_superset {
                disabledButtonAfterSet = true
                timeRemain = 0
                setCount = currentWorkoutExercise.set
            } else {
                timeRemain = currentWorkoutExercise.rest_time
                
                API().getAllWorkoutExerciseSessionByWorkoutExerciseID(wkExerciseID: currentWorkoutExercise.id, wkSessionID: currentWorkoutSession.id) { (workoutExerciseSessionFromResponse) in
                    if !workoutExerciseSessionFromResponse.isEmpty {
                        self.setCount = workoutExerciseSessionFromResponse.count
                        if setCount == currentWorkoutExercise.set {
                            disabledButtonAfterSet = true
                        }
                    }
                }
            }
        }
    }
    
    func createExerciseSession(){
        if setCount != currentWorkoutExercise.set {
            if currentWorkoutExercise.id.uuidString != "" || currentWorkoutSession.id.uuidString != "" {
                API().addWorkoutExerciseSession(wkExerciseID: currentWorkoutExercise.id, wkSessionID: currentWorkoutSession.id) { (statusCode) in
                    if statusCode == 200 || statusCode == 201 {
                        initTimerAndSetcount()
                    }
                }
            }
        }
    }
    
    func finishAndResetSetTimer() {
        isTimerRunning = false
        timeRemain = currentWorkoutExercise.rest_time
        createExerciseSession()
    }
}

struct WorkoutExerciseTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let fakeWkExercise = WorkoutExercise(id: UUID(), name: "Dumbell Squat To Bench", workout_id: UUID(), exercise_id: UUID(), position: 1, set: 3, rep: 10, weight: 40.5, rest_time: 90, is_superset: false)
        WorkoutExerciseTimerView(currentWorkoutExercise: fakeWkExercise, currentWorkoutSession: WorkoutSession(id: UUID(), workout_id: fakeWkExercise.id, is_started: true, is_finished: false))
    }
}



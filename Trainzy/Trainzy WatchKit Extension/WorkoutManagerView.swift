//
//  WorkoutManagerView.swift
//  Trainzy WatchKit Extension
//
//  Created by Felix Dallaire on 2022-08-21.
//

import SwiftUI

struct WorkoutManagerView: View {
    
    @State var allWorkoutList: [Workout] = [
//        Workout(id: UUID(), name: "Test Workout"),
//        Workout(id: UUID(), name: "Test Workout")
//        Workout(id: UUID(), name: "Test Workout")
    ]
    @State var isLoading: Bool = true
    
    var body: some View {
//        let addWorkoutButton = NavigationLink(destination: AddWorkoutView()){
//            Label("Add Workout", systemImage: "plus.square.fill")
//                .labelStyle(.titleAndIcon)
//        }
//            .listItemTint(Color("AccentGreen"))
//            .font(.headline.bold())
//            .foregroundColor(Color("BackgroundGreen"))

        if isLoading {
            VStack{
                ProgressView()
                    .tint(Color("AccentGreen"))
            }
            .onAppear(){
                API().getAllWorkout { (allWorkout) in
                    allWorkoutList = allWorkout
                    self.isLoading = false
                }
            }
        } else {
            VStack {
                if !isLoading && allWorkoutList.isEmpty {
                    Text("Go on trainzy manager app to add a workout.")
                        .font(.title2.weight(.bold))
                } else {
                    List {
                        ForEach(allWorkoutList.indices, id: \.self) { index in
                                NavigationLink(destination: WorkoutOverviewView(selectedWorkout: allWorkoutList[index])){
                                    Label(allWorkoutList[index].name.capitalized, systemImage: "plus.square.fill")
                                    .labelStyle(.titleOnly)
                            }
                                .listItemTint(Color("BackgroundGreen"))
                                .listStyle(.carousel)
                                .font(.headline.bold())
                                .foregroundColor(Color("AccentGreen"))
                        }
                        .onDelete(perform: deleteItem)
    //                    addWorkoutButton
                    }.listStyle(.carousel)
                    
                } // End else

            }
            .padding()
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Workouts")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func deleteItem(at indexSet: IndexSet) {
        let index = indexSet[indexSet.startIndex]
        API().deleteWorkoutById(workoutID: self.allWorkoutList[index].id) { (statusCode) in
            if statusCode == 200 {
                self.allWorkoutList.remove(atOffsets: indexSet)
            }
        }
    }
}

struct WorkoutManagerView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutManagerView()
    }
}

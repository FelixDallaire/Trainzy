//
//  ContentView.swift
//  TrainzyManager
//
//  Created by Felix Dallaire on 2022-08-29.
//

import SwiftUI

struct ContentView: View {
    @State var isLoading: Bool = true
    @State var isEditActive: Bool = false
    @State var allWorkoutList: [Workout] = [
//        Workout(id: UUID(), name: "Test Workout"),
//        Workout(id: UUID(), name: "Test Workout 2"),
//        Workout(id: UUID(), name: "Test Workout 3"),
//        Workout(id: UUID(), name: "Test Workout4"),
    ]

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("TRAINZY")
                        .font(.largeTitle.weight(.heavy))
                        .foregroundColor(Color.accentColor)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    
                    Text("manager".uppercased())
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color.white)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom)
                }
                .background(LinearGradient(colors: [Color("BackgroundGreenLighter"), Color.black], startPoint: .topLeading, endPoint: .bottomLeading))
                
                    Section{
                        Form {
                            Text("Workouts".uppercased())
                                .font(.title2.weight(.bold))
                                .foregroundColor(Color.gray)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            
                            if isLoading {
                                ProgressView()
                                    .tint(Color.accentColor)
                                    .scaleEffect(2)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Spacer()
                            } else {
                                ForEach(allWorkoutList, id: \.id){ currentWorkout in
                                    Section{
                                        HStack {
                                            NavigationLink(destination: WorkoutOverviewView(currentWorkout: currentWorkout)){
                                                HStack{
                                                    Text(currentWorkout.name)
                                                        .font(.title2.weight(.bold))
                                                        .foregroundColor(Color.accentColor)
                                                        .padding()
                                                    
                                                    if isEditActive {
                                                        Spacer()
                                                        Button(action: {
                                                            deleteItem(index: allWorkoutList.firstIndex(of: currentWorkout)!)
                                                        }) {
                                                            Label("", systemImage: "minus.circle")
                                                                .labelStyle(.iconOnly)
                                                                .font(.title.weight(.bold))
                                                                .foregroundColor(Color("BrightRed"))
                                                        }
                                                        .buttonStyle(.plain)
                                                        .controlSize(.regular)
                                                    }
                                                }
                                            } // End NavigationLink
                                            
                                        } // End HStack
                                    }
                                    .listRowBackground(Color("BackgroundGreen"))
                                    .listRowSeparator(.hidden)
                                } // End forEach
                                
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
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .listRowBackground(Color.black)
                                
                            } // End else
                        } // End Form
                    } // End Section
                    .listRowBackground(Color.black)
                
                NavigationLink(destination: AddWorkoutView(allWorkouts: $allWorkoutList)){
                    Label("Add workout", systemImage: "plus.square.fill")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color("ListBackgroundBlack"))
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .tint(Color.accentColor)
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
            } // End VStack
            .background(Color.black)
            .preferredColorScheme(.dark)
            .onAppear(){
                initWorkoutList()
                UITableView.appearance().backgroundColor = UIColor(Color.black)
            }
            .onDisappear(){
                isEditActive = false
                UITableView.appearance().backgroundColor = UIColor(Color.black)
            }
            
        } // End NavigationView

    }
        

    func initWorkoutList(){
        API().getAllWorkout { (allWorkout) in
            allWorkoutList = allWorkout
            self.isLoading = false
        }
    }
    
    private func deleteItem(index: Int) {
        API().deleteWorkoutById(workoutID: self.allWorkoutList[index].id) { (statusCode) in
            if statusCode == 200 {
                self.isLoading.toggle()
                self.allWorkoutList.remove(at: index)
                initWorkoutList()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

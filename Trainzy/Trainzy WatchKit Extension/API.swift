//
//  API.swift
//  Trainzy WatchKit Extension
//
//  Created by Felix Dallaire on 2022-08-21.
//

import Foundation
import SwiftUI

class API {
    
//    GET ALL WORKOUTS
    func getAllWorkout(completion: @escaping ([Workout]) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/workouts") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let decodedWorkouts = try? JSONDecoder().decode([Workout].self, from: data!) else { return }
            
            DispatchQueue.main.async {
                completion(decodedWorkouts)
            }
        }.resume()
    }
    

//    ADD WORKOUT
    func addWorkout(workoutName: String, completion: @escaping (ResponseObject) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/workouts/") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        let parameters: [String: Any] = [
            "name" : workoutName,
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
               return
        }
        urlRequest.httpBody = httpBody
        
        //HTTP Headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                    print("No valid response")
                    return
                }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                print("Status code was \(httpResponse.statusCode), but expected 201 || 200")
                return
            }
            
            let decodedWorkout = try! JSONDecoder().decode(Workout.self, from: data!)
            
            DispatchQueue.main.async {
                completion(ResponseObject(statusCode: httpResponse.statusCode, body: decodedWorkout.id))
            }
        }.resume()
    }
    
//    DELETE WORKOUT
    func deleteWorkoutById(workoutID: UUID, completion: @escaping (Int) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/workouts/\(workoutID)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                    print("No valid response")
                    return
                }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                print("Status code was \(httpResponse.statusCode), but expected 200")
                return
            }
            
            DispatchQueue.main.async {
                completion(httpResponse.statusCode)
            }
        }.resume()
    }
    
    //=============================================================================================
    func getAllWorkoutSessionByWorkoutId(workoutID: UUID, completion: @escaping ([WorkoutSession]) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/wk_sessions/workout/\(workoutID)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let decodedWorkoutSession = try? JSONDecoder().decode([WorkoutSession].self, from: data!) else { return }
            
            DispatchQueue.main.async {
                completion(decodedWorkoutSession)
            }
        }.resume()
    }
    
    func addWorkoutSession(workoutSession: WorkoutSession, completion: @escaping (ResponseObject) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/wk_sessions/") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        let parameters: [String: Any] = [
            "id" : workoutSession.id.uuidString,
            "workout_id" : workoutSession.workout_id.uuidString,
            "is_started" : workoutSession.is_started,
            "is_finished" : workoutSession.is_finished,
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
               return
        }
        urlRequest.httpBody = httpBody
        
        //HTTP Headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                    print("No valid response")
                    return
                }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                print("Status code was \(httpResponse.statusCode), but expected 201 || 200")
                return
            }
            
            
            let decodedWorkoutSession = try! JSONDecoder().decode(WorkoutSession.self, from: data!)
            
            let reponseObject: ResponseObject = ResponseObject(statusCode: httpResponse.statusCode, body: decodedWorkoutSession)
            DispatchQueue.main.async {
                completion(reponseObject)
            }
        }.resume()
    }
    
    
    func updateWorkoutSessionStatus(is_started: Bool, is_finished:Bool, workoutSessionId: UUID, completion: @escaping (Int) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/wk_sessions/status/\(workoutSessionId)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"

        let parameters: [String: Any] = [
            "is_started" : is_started,
            "is_finished" : is_finished
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
               return
        }
        urlRequest.httpBody = httpBody
        
        //HTTP Headers
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                    print("No valid response")
                    return
                }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                print("Status code was \(httpResponse.statusCode), but expected 201 || 200")
                return
            }
                        
            DispatchQueue.main.async {
                completion(httpResponse.statusCode)
            }
        }.resume()
    }
    //=============================================================================================
    //    GET ALL WK_EXERCISE
        func getWorkoutExercisesByWorkoutId(workoutID: UUID, completion: @escaping (ResponseObject) -> ()) {
            guard let url = URL(string: "https://trainzy.herokuapp.com/wk_exercises/workout/\(workoutID)") else {return}
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                        print("No valid response")
                        return
                    }
                
                guard 200 ..< 300 ~= httpResponse.statusCode else {
                    print("Status code was \(httpResponse.statusCode), but expected 201 || 200")
                    return
                }
                
                let decodedWorkoutExercises = try! JSONDecoder().decode([WorkoutExercise].self, from: data!)
                
                DispatchQueue.main.async {
                    completion(ResponseObject(statusCode: httpResponse.statusCode, body: decodedWorkoutExercises))
                }
            }.resume()
        }
    
    func addWorkoutExercise(newWorkoutExercise: WorkoutExercise, completion: @escaping (ResponseObject) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/wk_exercises/") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let parameters: [String: Any] = [
            "name": newWorkoutExercise.name,
            "workout_id": newWorkoutExercise.workout_id.uuidString,
            "exercise_id": newWorkoutExercise.exercise_id.uuidString,
            "position": newWorkoutExercise.position,
            "set": newWorkoutExercise.set,
            "rep": newWorkoutExercise.rep,
            "weight": newWorkoutExercise.weight,
            "rest_time": newWorkoutExercise.rest_time,
            "is_superset": newWorkoutExercise.is_superset
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
               return
        }
        urlRequest.httpBody = httpBody
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                    print("No valid response")
                    return
                }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                print("Status code was \(httpResponse.statusCode), but expected 201 || 200")
                return
            }
            
            let decodedWorkoutExercise = try! JSONDecoder().decode(WorkoutExercise.self, from: data!)
            
            DispatchQueue.main.async {
                completion(ResponseObject(statusCode: httpResponse.statusCode, body: decodedWorkoutExercise))
            }
        }.resume()
    }
    
    func editWorkoutExercise(editedWorkoutExercise: WorkoutExercise, completion: @escaping (Int) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/wk_exercises/\(editedWorkoutExercise.id)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        
        let parameters: [String: Any] = [
            "id": editedWorkoutExercise.id.uuidString,
            "name": editedWorkoutExercise.name,
            "workout_id": editedWorkoutExercise.workout_id.uuidString,
            "exercise_id": editedWorkoutExercise.exercise_id.uuidString,
            "position": editedWorkoutExercise.position,
            "set": editedWorkoutExercise.set,
            "rep": editedWorkoutExercise.rep,
            "weight": editedWorkoutExercise.weight,
            "rest_time": editedWorkoutExercise.rest_time,
            "is_superset": editedWorkoutExercise.is_superset
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
               return
        }
        urlRequest.httpBody = httpBody
        print(NSString(data: urlRequest.httpBody!, encoding:String.Encoding.utf8.rawValue)!)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                    print("No valid response")
                    return
                }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                print("Status code was \(httpResponse.statusCode), but expected 201 || 200")
                return
            }
            
            DispatchQueue.main.async {
                completion(httpResponse.statusCode)
            }
        }.resume()
    }
    
    
    func deleteWorkoutExerciseById(workoutExerciseID: UUID, completion: @escaping (Int) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/wk_exercises/\(workoutExerciseID)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                    print("No valid response")
                    return
                }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                print("Status code was \(httpResponse.statusCode), but expected 200")
                return
            }
            
            DispatchQueue.main.async {
                completion(httpResponse.statusCode)
            }
        }.resume()
    }
    
    //=============================================================================================

    func getAllExercises(completion: @escaping ([Exercise]) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/exercises/") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let decodedExercises = try? JSONDecoder().decode([Exercise].self, from: data!) else { return }
            
            DispatchQueue.main.async {
                completion(decodedExercises)
            }
        }.resume()
    }
    
    //=============================================================================================

    func getAllWorkoutExerciseSessionByWorkoutExerciseID(wkExerciseID: UUID, wkSessionID: UUID, completion: @escaping ([WorkoutExerciseSession]) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/wk_exercise_sessions/wk_session/\(wkSessionID)/wk_exercise/\(wkExerciseID)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
    
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            let decodedWorkoutExerciseSession = try? JSONDecoder().decode([WorkoutExerciseSession]?.self, from: data ?? Data([]))

            DispatchQueue.main.async {
                completion(decodedWorkoutExerciseSession ?? [])
            }
        }.resume()
    }
    
    
    func addWorkoutExerciseSession(wkExerciseID: UUID, wkSessionID: UUID, completion: @escaping (Int) -> ()) {
        guard let url = URL(string: "https://trainzy.herokuapp.com/wk_exercise_sessions/") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "wk_exercise_id": wkExerciseID.uuidString,
            "wk_session_id": wkSessionID.uuidString,
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
               return
        }
        urlRequest.httpBody = httpBody
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                    print("No valid response")
                    return
                }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                print("Status code was \(httpResponse.statusCode), but expected 201 || 200")
                return
            }
                        
            DispatchQueue.main.async {
                completion(httpResponse.statusCode)
            }
        }.resume()
    }
    
    //=============================================================================================
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func secondsToHoursMinutesSecondsString(_ seconds: Int) -> String {
        let result = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        let hourStr = "\(result.0 <= 9 ? String(0) + String(result.0) : String(result.0))"
        let minStr = "\(result.1 <= 9 ? String(0) + String(result.1) : String(result.1))"
        let secStr = "\(result.2 <= 9 ? String(0) + String(result.2) : String(result.2))"
        return "\(hourStr):\(minStr):\(secStr)"
    }
} // END






struct Workout: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String    
}

struct WorkoutSession: Codable, Identifiable, Hashable {
    var id: UUID
    var workout_id: UUID
    var is_started: Bool
    var is_finished: Bool
}

struct WorkoutExerciseSession: Codable, Identifiable, Hashable {
    var id: UUID
    var wk_session_id: UUID
    var wk_exercise_id: UUID
}

struct WorkoutExercise: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var workout_id: UUID
    var exercise_id: UUID
    var position: Int
    var set: Int
    var rep: Int
    var weight: Double
    var rest_time: Int
    var is_superset: Bool
}

struct Exercise: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var description: String
}

struct Previews_API_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

struct ResponseObject {
    var statusCode: Int
    var body: Any
}

//            print(">>> \(String(data: data!, encoding: .utf8)) <<<")

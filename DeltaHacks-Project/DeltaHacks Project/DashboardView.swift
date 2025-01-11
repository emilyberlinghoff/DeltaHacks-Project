//
//  DashboardView.swift
//  DeltaHacks Project
//
//  Created by Emily Berlinghoff on 2025-01-11.
//


import SwiftUI

struct DashboardView: View {
    // Example state variables to hold data
    @State private var workoutRecommendation: String = "Take a 30-minute walk outdoors."
    @State private var completedWorkouts: [String] = []
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Greeting Section
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // Workout Recommendation Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Today's Workout Recommendation")
                        .font(.headline)
                    Text(workoutRecommendation)
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                }
                .padding(.bottom, 10)
                
                // Completed Workouts Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Completed Workouts")
                        .font(.headline)
                    if completedWorkouts.isEmpty {
                        Text("No workouts logged yet.")
                            .foregroundColor(.gray)
                    } else {
                        List(completedWorkouts, id: \.self) { workout in
                            Text(workout)
                        }
                        .frame(height: 200) // Adjust height as needed
                    }
                }
                
                Spacer()
                
                // Log a Workout Button
                Button(action: {
                    // Add a placeholder workout for testing
                    let newWorkout = "Workout \(completedWorkouts.count + 1)"
                    completedWorkouts.append(newWorkout)
                }) {
                    Text("Log a Workout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

import SwiftUI

struct DashboardView: View {
    // Example state variables to hold data
    @State private var workoutRecommendation: String = "Take a 30-minute walk outdoors."
    @State private var completedWorkouts: [String] = []
    @State private var showMessage: Bool = false

    var body: some View {
        VStack {
            // Greeting Section
            Text("Welcome Back!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)

            Spacer()

            // Workout Recommendation Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Today's Workout Recommendation")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(workoutRecommendation)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)

            // Completed Workouts Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Completed Workouts")
                    .font(.headline)
                    .foregroundColor(.white)

                if completedWorkouts.isEmpty {
                    Text("No workouts logged yet.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(completedWorkouts, id: \.self) { workout in
                        Text(workout)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.bottom, 20)

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
                    .font(.title)
                    .padding(.horizontal)
            }
            .frame(height: 60)

            Spacer()
        }
        .padding()
        .background(Color.blue)  // Overall blue background for the dashboard
        .cornerRadius(20)
        .shadow(radius: 10)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .edgesIgnoringSafeArea(.all) // Ignore safe areas for background stretch
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}

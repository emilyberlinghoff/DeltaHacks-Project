import SwiftUI

struct SignupQuestionsView: View {
    @State private var age: String = ""
    @State private var selectedOccupation: String = "Student"
    @State private var prefersOutdoorWorkout: Bool = false

    // Occupation options for the dropdown
    let occupationOptions = ["Student", "Full-time", "Part-time", "Unemployed"]

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                // Age input
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)

                // Occupation dropdown
                Picker("Occupation", selection: $selectedOccupation) {
                    ForEach(occupationOptions, id: \.self) { occupation in
                        Text(occupation).tag(occupation)
                    }
                }
                .pickerStyle(MenuPickerStyle()) // Dropdown style
            }

            Section(header: Text("Workout Preferences")) {
                // Outdoor workout toggle
                Toggle("Prefer outdoor workouts?", isOn: $prefersOutdoorWorkout)
            }

            // Next button to proceed (e.g., navigate to dashboard)
            Button(action: {
                // Handle saving preferences or navigation to dashboard
                print("Age: \(age)")
                print("Occupation: \(selectedOccupation)")
                print("Outdoor Preference: \(prefersOutdoorWorkout)")
            }) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Set Your Preferences")
    }
}

struct SignupQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SignupQuestionsView()
    }
}

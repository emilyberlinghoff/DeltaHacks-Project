import SwiftUI

struct SignupQuestionsView: View {
    @State private var age: String = ""
    @State private var selectedOccupation: String = "Student" // Default option
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

            // Submit button
            Button(action: {
                // Handle signup logic here
                print("Age: \(age)")
                print("Occupation: \(selectedOccupation)")
                print("Outdoor Preference: \(prefersOutdoorWorkout)")
            }) {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .navigationTitle("Sign Up")
    }
}

struct SignupQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        SignupQuestionsView()
    }
}

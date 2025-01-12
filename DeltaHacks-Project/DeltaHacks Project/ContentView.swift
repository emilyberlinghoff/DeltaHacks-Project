import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            SignupQuestionsView() // Start directly with the preferences screen
                .navigationBarHidden(true) // Hide navigation bar if needed
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

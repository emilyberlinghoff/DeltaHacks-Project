import SwiftUI
import AuthenticationServices

struct LoginSignupView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome to DeltaHacks Project")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.top, 50)

            Spacer()

            // Sign in with Apple button
            SignInWithAppleButton(
                .signIn,
                onRequest: configureAppleIDRequest,
                onCompletion: handleAppleIDCompletion
            )
            .signInWithAppleButtonStyle(.black) // Change style if needed
            .frame(height: 50)
            .cornerRadius(10)

            Spacer()

            // Optionally add more buttons or instructions
            Text("Use your Apple ID to sign up or log in securely.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
        .padding()
    }

    // Configure the Apple ID request
    private func configureAppleIDRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    // Handle the completion of Apple ID authentication
    private func handleAppleIDCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userID = appleIDCredential.user
                let email = appleIDCredential.email ?? "Email not available"
                let fullName = appleIDCredential.fullName?.formatted() ?? "Name not available"

                // Save or use user data as needed
                print("Apple ID Credential successfully obtained:")
                print("User ID: \(userID)")
                print("Email: \(email)")
                print("Full Name: \(fullName)")
            }
        case .failure(let error):
            print("Apple ID Authentication failed: \(error.localizedDescription)")
        }
    }
}

struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView()
    }
}

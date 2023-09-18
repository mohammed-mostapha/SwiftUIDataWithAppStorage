//
//  OnboardingView.swift
//  UsersOnboarding
//
//  Created by Mohamed Mostapha on 18/09/2023.
//

import SwiftUI

struct OnboardingView: View {
    // Onboarding states:
    /*
     0 - Welcome Screen
     1 - Add name
     2 - Add age
     3 - Add gender
     */
    
    // Onboarding inputs
    @State var onboardingState: Int = 0
    @State var name: String = ""
    @State var age: Double = 30
    @State var gender: String = ""

    // For the alert
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    
    // App storage
    @AppStorage("name") var currentUserName: String?
    @AppStorage("age") var currentUserAge: Int?
    @AppStorage("gender") var currentUserGender: String?
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false

    
    
    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing),
                                                removal: .move(edge: .leading))
    
    var body: some View {
        ZStack {
            // content
            ZStack {
                switch onboardingState {
                case 0:
                    welcomeSection
                        .transition(transition)
                case 1:
                    AddNameSection
                        .transition(transition)
                case 2:
                    AddAgeSection
                        .transition(transition)
                case 3:
                    AddGenderSection
                        .transition(transition)
                default:
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(.green)
                }
            }
            
            // buttons
            VStack {
                Spacer()
                bottomButton
            }
            .padding(30)
        }
        .alert(isPresented: $showAlert, content: {
            return Alert(title: Text(alertTitle))
        })
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .background(Color.purple)
    }
}


// Mark: COMPONENTS

extension OnboardingView {
    
    private var bottomButton: some View {
        Text(onboardingState == 0 ? "SIGN UP" :
             onboardingState == 3 ? "FINISH" :
                "NEXT"
        )
            .font(.headline)
            .foregroundColor(.purple)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .animation(nil, value: onboardingState)
            .onTapGesture {
                 handleNextButtonPressed()
            }
    }
    
    private var welcomeSection: some View {
        VStack(spacing: 40) {
            Spacer()
            Image(systemName: "heart.text.square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.white)
            
            Text("Find you match.")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .overlay(
                    Capsule(style: .continuous)
                        .frame(height: 3)
                        .offset(y: 5)
                        .foregroundColor(.white)
                    , alignment: .bottom
                )
            
            Text("This is the #1 App for finding you match online! In this tutorial we are practicing using AppStorage and other SwiftUI techniques.")
                .fontWeight(.medium)
                .foregroundColor(.white)
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding(30)
    }
    
    private var AddNameSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's you name?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            TextField("Your name here...", text: $name)
                .font(.headline)
                .frame(height: 55)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(10)
            
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
    private var AddAgeSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's you age?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Text("\(String(format: "%.0f", age))")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Slider(value: $age, in: 18...100, step: 1)
                .accentColor(.white)
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
    private var AddGenderSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's you gender?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Menu {
                Picker(selection: $gender,
                       label:
                        EmptyView(),
                       content: {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                    Text("Non-Binary").tag("Non-Binary")
                })
            } label: {
                Text( gender.count > 1 ? gender : "Select a gender" )
                .font(.headline)
                .foregroundColor(.purple)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
            }

            Spacer()
            Spacer()
        }
        .padding(30)
    }
}

// Mark FUNCITONS
extension OnboardingView {
    
    
    func handleNextButtonPressed() {
        
        // Check Inputs
        switch onboardingState {
        case 1:
            guard name.count >= 3 else {
                showAlert(title: "Your name should be at least 3 characters long! 😞")
                return
            }
        case 3:
            guard gender.count > 1 else {
                showAlert(title: "Please select a gender before moving forward! 😄")
                return
            }
        default:
            break
        }
        
        // Go To Next Section
        if onboardingState == 3 {
            signIn()
        } else {
            withAnimation(.spring()) {
                onboardingState += 1
            }
        }
    }
        
    func signIn() {
        currentUserName = name
        currentUserAge = Int(age)
        currentUserGender = gender
        withAnimation(.spring()) {
            currentUserSignedIn = true
        }
    }
    
    func showAlert(title: String) {
        alertTitle = title
        showAlert.toggle()
    }
}

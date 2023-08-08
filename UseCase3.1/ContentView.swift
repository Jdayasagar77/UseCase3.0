//
//  ContentView.swift
//  UseCase3.1
//
//  Created by J Dayasagar on 07/08/23.
//

import SwiftUI
import SwiftSMTP


struct ContentView: View {
    @State private var selectedOption: BotOption?
    @State private var prompt: String = ""
    @State var chatMessages: ChatMessage?
    var kitService = KitService()
    let smtp = SMTP(
        hostname: "smtp.mailgun.org",     // SMTP server address
        email: ""
      //  postmaster@sandbox54465bd9fb4b4d5d9a18633bd805e178.mailgun.org
        ,        // username to login
        password:""
           // "52d4a0eb3a8e8f0ffb18893eeeff3ba9-28e9457d-d5cce83f"            // password to login
        ,port: 587
           )
    

    
    
    
    var body: some View {
        NavigationView {
            VStack {
                Menu("Select an option") {
                    ForEach(BotOption.allCases, id: \.self) { option in
                        Button(option.rawValue) {
                            selectedOption = option
                        }
                    }
                }
                .padding()
                
                if selectedOption != nil {
                    TextField("Enter your prompt", text: $prompt)
                        .padding()
                    
                    Button("Get Result") {
                            sendMessage()
                    }
                    .padding()
                    
                    Text(chatMessages?.content ?? "")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Send as Email") {
                        // Implement email sending logic using skpsmtpmessage delegate
                        let drLight = Mail.User(name: "Dayasagar", email: // "postmaster@sandbox54465bd9fb4b4d5d9a18633bd805e178.mailgun.org"
                        ""
                        )
                        let megaman = Mail.User(name: "DJ", email: "sagardaya62@gmail.com")
                        
                        let mail = Mail(
                            from: drLight,
                            to: [megaman],
                            subject: "Response from GPT",
                            text: chatMessages?.content ?? ""
                        )
                        
                        smtp.send(mail) { (error) in
                            if let error = error {
                                print(error)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("ChatBot")
        }
    }
    
    
    @MainActor func sendMessage() {
        guard !prompt.isEmpty else { return }
        
//        chatMessages.append(ChatMessage(role: .user, content: prompt))
        
        // This is using Custom Model
        
        // TODO: Add logic to generate a response from the chatbot
        
        // Example response
        
        Task { // @MainActor in
            do {
                let response = try await kitService.sendMessage("///\(prompt)///", personality: selectedOption ?? .needAnswer)
                chatMessages = ChatMessage(role: .assistant, content: response.choices.first?.message.content ?? "")
                print(response.choices.first?.message.content as Any)
            }catch {
                print(error)
            }
        }
    }// sendMessage() ends here
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

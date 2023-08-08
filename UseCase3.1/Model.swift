//
//  Model.swift
//  UseCase3.1
//
//  Created by J Dayasagar on 07/08/23.
//


import Foundation
import UIKit


enum ChatGPTModel: String, Identifiable, CaseIterable {
    
    var id: Self { self }
    
    case gpt3Turbo = "gpt-3.5-turbo"
    case gpt4 = "gpt-4"
    
    var text: String {
        switch self {
            case .gpt3Turbo:
                return "GPT-3.5"
            case .gpt4:
                return "GPT-4"
        }
    }
}



extension Array where Element == ChatMessage {
    
    var contentCount: Int {
        reduce(0, { $0 + $1.content.count })
    }
}

struct Request: Codable {
    let model: String
    let temperature: Double
    let messages: [ChatMessage]
    let stream: Bool
}

struct ErrorRootResponse: Decodable {
    let error: ErrorResponse
}

struct ErrorResponse: Decodable, Error {
    let message: String
    let type: String?
}

struct StreamCompletionResponse: Decodable {
    let choices: [StreamChoice]
}

struct CompletionResponse: Decodable {
    let choices: [Choice]
    let usage: Usage?
}

struct Usage: Decodable {
    let promptTokens: Int?
    let completionTokens: Int?
    let totalTokens: Int?
}

struct Choice: Decodable {
    let message: ChatMessage
    let finishReason: String?
}

struct StreamChoice: Decodable {
    let finishReason: String?
    let delta: StreamMessage
}

struct StreamMessage: Decodable {
    let role: String?
    let content: String?
}




/// An enumeration of possible roles in a chat conversation.
public enum ChatRole: String, Codable {
    /// The role for the system that manages the chat interface.
    case system
    /// The role for the human user who initiates the chat.
    case user
    /// The role for the artificial assistant who responds to the user.
    case assistant
}

/// A structure that represents a single message in a chat conversation.
public struct ChatMessage: Codable, Hashable, Identifiable, Equatable {
    public var id: UUID = UUID()
    
    /// The role of the sender of the message.
    public let role: ChatRole
    /// The content of the message.
    public let content: String
    
    /// Creates a new chat message with a given role and content.
    /// - Parameters:
    ///   - role: The role of the sender of the message.
    ///   - content: The content of the message.
    public init(role: ChatRole, content: String) {
        self.role = role
        self.content = content
    }
}


enum BotOption: String, CaseIterable {
    case needAnswer = "Need answer"
    case needCode = "Need code"
    case needSuggestion = "Need suggestion"
    
    var systemContext: String {
        
        switch self {
                
            case .needAnswer:
                return  "You need give an appropriate answer and solution to the user's prompt. User's message will be delimited within ///."
            case .needCode:
                return  "You only need to give a code to the user's prompt. Do not respond if user is not asking anything realated to coding. User's message will be delimited within ///."
            case .needSuggestion:
                return  "You only need to give a suggestion to the user's prompt. User's message will be delimited within ///."
        }
        
    }
    
}

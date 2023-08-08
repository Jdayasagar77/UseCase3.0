//
//  Service.swift
//  UseCase3.1
//
//  Created by J Dayasagar on 07/08/23.
//


import Foundation
import OpenAIKit

class KitService {
    
    
    func sendMessage(_ text: String, personality: BotOption) async throws -> Chat {
        
        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else { throw ErrorResponse(message: "Invalid Dictionary", type: .none)  }
       // guard let apikey: String = infoDictionary["ChatBot"] as? String else { throw ErrorResponse(message: "Invalid API Key", type: .none) }
        
        let urlSession = URLSession(configuration: .default)
        let configuration = Configuration(apiKey: "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", organization: .none)
        let openAIClient = OpenAIKit.Client(session: urlSession, configuration: configuration)
        
        do {
            
            let completion = try await openAIClient.chats.create(model: Model.GPT3.gpt3_5Turbo,
                                                                 messages: [Chat.Message.system(content: personality.systemContext), Chat.Message.user(content: text) ],
                                                                 temperature: 0.8, maxTokens: 50)
            return completion
            
        } catch {
            throw error
        }
        
    }
    
}


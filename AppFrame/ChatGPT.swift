//
//  ChatGPT.swift
//  BarbaraAI
//
//  Created by Vasisht Muduganti on 10/8/24.
//

import Foundation

class ChatGPT {
    private let apiKey: String
    private let apiURL = "https://api.openai.com/v1/chat/completions"
    private var isContextSet = false
    private var context: String?

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func setContext(_ context: String) {
        self.context = context
        self.isContextSet = true
    }

    func sendMessage(message: String, completion: @escaping (String?) -> Void) {
        guard let context = context else {
            print("Context is not set. Please set the context first.")
            completion(nil)
            return
        }

        let headers = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]

        // Prepare the messages for the API call
        var messages = [[String: String]]()

        // Send context only once
        
        messages.append(["role": "system", "content": context])
             // Now context is set, don't send it again
        

        // Always append the user's message
        messages.append(["role": "user", "content": message])

        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages,
            "max_tokens": 100
        ]

        guard let url = URL(string: apiURL) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let message = firstChoice["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content)
                } else {
                    completion(nil)
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }
}

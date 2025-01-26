//
//  ElevenLabs.swift
//  BarbaraAI
//
//  Created by Vasisht Muduganti on 10/8/24.
//

/*import Foundation

class ElevenLabs {
    private let apiKey: String
    private let apiURL = "https://api.elevenlabs.io/v1/text-to-speech/generate"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func generateAudio(text: String, voiceID: String, completion: @escaping (Data?) -> Void) {
        let headers = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "text": text,
            "voice_id": voiceID,
            "audio_format": "mp3"  // Specify audio format (e.g., "mp3", "wav", etc.)
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

            // Check the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(data) // Return the audio data
            } else {
                print("Failed to generate audio. Status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                completion(nil)
            }
        }

        task.resume()
    }
}
*/
import Foundation


public class ElevenlabsSwift {
    private var elevenLabsAPI: String
    
    public required init(elevenLabsAPI: String) {
        self.elevenLabsAPI = elevenLabsAPI
    }
    
    private let baseURL = "https://api.elevenlabs.io"
    
    public func fetchVoices() async throws -> [Voice]
    {
        
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)/v1/voices")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(elevenLabsAPI, forHTTPHeaderField: "xi-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, _) = try await session.data(for: request)
            
            let userResponse: VoicesResponse = try JSONDecoder().decode(VoicesResponse.self, from: data)
            print(userResponse.voices)
            
            return userResponse.voices
        }
        catch(let error)
        {
            throw WebAPIError.httpError(message: error.localizedDescription)
        }
        
    }
    
    enum TextToSpeechError: Error {
        case invalidURL
        case serializationError
        case noDataReceived
    }
    func textToSpeech2(voice_id: String, text: String, model: String? = nil) async throws -> (Data, [String: Any]) {
        // Prepare the URL
        let urlString = "https://api.elevenlabs.io/v1/text-to-speech/\(voice_id)/with-timestamps"
        guard let url = URL(string: urlString) else {
            throw TextToSpeechError.invalidURL
        }

        // If no model is provided, default to "eleven_multilingual_v2"
        let modelToUse = model ?? "eleven_multilingual_v2"

        // Prepare the JSON data
        let parameters: [String: Any] = [
            "text": text,
            "model_id": modelToUse,
            "voice_settings": [
                "stability": 0.5,
                "similarity_boost": 0.75
            ]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
            throw TextToSpeechError.serializationError
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(elevenLabsAPI, forHTTPHeaderField: "xi-api-key")
        request.httpBody = jsonData

        // Execute the request
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check for a successful response
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw TextToSpeechError.noDataReceived
        }

        // Parse the response to get audio and alignment
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let audioBase64 = jsonResponse["audio_base64"] as? String,
              let alignment = jsonResponse["alignment"] as? [String: Any] else {
            throw TextToSpeechError.serializationError
        }

        // Decode base64 audio data
        guard let audioData = Data(base64Encoded: audioBase64) else {
            throw TextToSpeechError.invalidURL
        }

        // Return the audio data and alignment
        return (audioData, alignment)
    }
    public func textToSpeech(voice_id: String, text: String, model: String? = nil) async throws -> Data {
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)/v1/text-to-speech/\(voice_id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(elevenLabsAPI, forHTTPHeaderField: "xi-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("audio/mpeg", forHTTPHeaderField: "Accept")

        let parameters = SpeechRequest(text: text, voice_settings: ["stability": 0, "similarity_boost": 0], model: model)

        guard let jsonBody = try? JSONEncoder().encode(parameters) else {
            throw WebAPIError.unableToEncodeJSONData
        }

        request.httpBody = jsonBody
        print(jsonBody)
        do {
            let (data, _) = try await session.data(for: request)
            
            print("Audio data received, size: \(data.count) bytes")

            // Return the audio data instead of saving it to a file
            return data
        } catch {
            throw WebAPIError.httpError(message: error.localizedDescription)
        }
    }
    public func textToSpeechWithTimestamps(voice_id: String, text: String, model: String? = "eleven_multilingual_v2") async throws -> (Data, [Alignment]) {
        let session = URLSession.shared
        let url = URL(string: "\(baseURL)/v1/text-to-speech/\(voice_id)/with-timestamps")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(elevenLabsAPI, forHTTPHeaderField: "xi-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "text": text,
            "model_id": model!,
            "voice_settings": [
                "stability": 0.5,
                "similarity_boost": 0.75
            ]
        ]

        guard let jsonBody = try? JSONSerialization.data(withJSONObject: parameters) else {
            throw WebAPIError.unableToEncodeJSONData
        }

        request.httpBody = jsonBody

        do {
            let (data, _) = try await session.data(for: request)

            // Decode the JSON response
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                throw WebAPIError.unableToDecodeJSONData
            }

            // Handle the audio base64 string
            guard let audioBase64 = jsonResponse["audio_base64"] as? String,
                  let audioData = Data(base64Encoded: audioBase64) else {
                throw WebAPIError.httpError(message: "Audio data decoding failed")
            }

            // Handle alignment data (timestamps)
            guard let alignmentData = jsonResponse["alignment"] as? [[String: Any]] else {
                throw WebAPIError.httpError(message: "Alignment data missing")
            }

            // Convert alignment to a structured format
            let alignment: [Alignment] = alignmentData.compactMap { dict in
                guard let start = dict["start"] as? Double,
                      let end = dict["end"] as? Double,
                      let text = dict["text"] as? String else {
                    return nil
                }
                return Alignment(start: start, end: end, text: text)
            }

            print("Audio data received, size: \(audioData.count) bytes")
            print("Alignment data: \(alignment)")

            // Return both audio data and alignment data
            return (audioData, alignment)

        } catch {
            throw WebAPIError.httpError(message: error.localizedDescription)
        }
    }

    // Define a struct for alignment data
    public struct Alignment: Codable {
        let start: Double
        let end: Double
        let text: String
    }
    private func saveDataToTempFile(data: Data) throws -> URL {
        let tempDirectoryURL = FileManager.default.temporaryDirectory
        let randomFilename = "\(UUID().uuidString).mpg"
        let fileURL = tempDirectoryURL.appendingPathComponent(randomFilename)
        print(data.count)
        try data.write(to: fileURL)
        return fileURL
    }
    
    // Utility function to create data for multipart/form-data
    private func createMultipartData(boundary: String, name: String, fileURL: URL, fileType: String) -> Data? {
        let fileName = fileURL.lastPathComponent
        var data = Data()

        // Multipart form data header
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(fileType)\r\n\r\n".data(using: .utf8)!)

        // File content
        guard let fileData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        data.append(fileData)
        data.append("\r\n".data(using: .utf8)!)

        return data
    }

    public func uploadVoice(name: String, description: String, fileURL: URL, completion: @escaping (String?) -> Void)  {
        
        guard let url = URL(string: "\(baseURL)/v1/voices/add") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(elevenLabsAPI, forHTTPHeaderField: "xi-api-key")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        let parameters = [
            ("name", name),
            ("description", description),
            ("labels", "")
        ]

        for (key, value) in parameters {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)\r\n".data(using: .utf8)!)
        }

        if let fileData = createMultipartData(boundary: boundary, name: "files", fileURL: fileURL, fileType: "audio/x-wav") {
            data.append(fileData)
        }

        // Multipart form data footer
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = data

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
            } else if let data = data {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                            print(json)
                            completion(json["voice_id"])
                        } else {
                            completion(nil)
                        }
                       
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(nil)
                    }
                } else {
                    print("Error: Invalid status code")
                    completion(nil)
                }
            }
        }

        task.resume()
    }
    
    public func deleteVoice(voiceId: String) async throws {
        guard let url = URL(string: "\(baseURL)/v1/voices/\(voiceId)") else {
            print("Invalid URL")
            throw WebAPIError.httpError(message: "incorrect url")
        }
        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(elevenLabsAPI, forHTTPHeaderField: "xi-api-key")
        
        do {
            let (data, _) = try await session.data(for: request)
            
        }
        catch(let error)
        {
            throw WebAPIError.httpError(message: error.localizedDescription)
        }
    }
    
    public func editVoice(voiceId: String, name: String, description: String, fileURL: URL, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: "\(baseURL)/v1/voices/\(voiceId)/edit") else {
            print("Invalid URL")
            completion(false)
            return
        }
        

        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(elevenLabsAPI, forHTTPHeaderField: "xi-api-key")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        let parameters = [
            ("name", name),
            ("description", description),
            ("labels", "")
        ]

        for (key, value) in parameters {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(value)\r\n".data(using: .utf8)!)
        }

        if let fileData = createMultipartData(boundary: boundary, name: "files", fileURL: fileURL, fileType: "audio/x-wav") {
            data.append(fileData)
        }

        // Multipart form data footer
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = data

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(false)
            } else if let data = data {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        completion(true)
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(false)
                    }
                } else {
                    print("Error: Invalid status code")
                    completion(false)
                }
            }
        }

        task.resume()
    }


}


public enum WebAPIError: Error {
    case identityTokenMissing
    case unableToDecodeIdentityToken
    case unableToEncodeJSONData
    case unableToDecodeJSONData
    case unauthorized
    case invalidResponse
    case httpError(message: String)
    case httpErrorWithStatus(status: Int)

}


public struct VoicesResponse: Codable {
    public let voices: [Voice]
    
    public init(voices: [Voice]) {
        self.voices = voices
    }
}


public struct Voice: Codable, Identifiable, Hashable {
    public let voice_id: String
    public let name: String
    
    public var id: String { voice_id }

    public init(voice_id: String, name: String) {
        self.voice_id = voice_id
        self.name = name
    }
}


public struct SpeechRequest: Codable {
    public let text: String
    public let voice_settings: [String: Int]
    public let model: String?

    public init(text: String, voice_settings: [String : Int], model: String?) {
        self.text = text
        self.voice_settings = voice_settings
        self.model = model
    }
}

//
//  OKModelInfoResponse.swift
//
//
//  Created by Kevin Hermawan on 10/11/23.
//

import Foundation
import EasyJSON

/// A structure that represents the response containing information about a specific model from the Ollama API.
public struct OKModelInfoResponse: Decodable, Sendable {
    /// A string detailing the licensing information for the model.
    public let license: String?
    
    /// A string representing the template used by the model.
    public let template: String
    
    /// A string containing the path or identifier of the model file.
    public let modelfile: String
    
    /// A string detailing the parameters or settings of the model.
    public let parameters: String
    
    /// A list of model capabilities (like vision, tools)
    public let capabilities: [Capability]
    
    /// An optional string containing system information about the model.
    public let system: String?
    
    /// An optional date representing when the model was last modified.
    public let modifiedAt: Date?
    
    /// An enumeration representing the exact model capability
            public enum Capability: String, Decodable, Sendable {
        // https://github.com/ollama/ollama/blob/main/types/model/capability.go
        case completion
        case tools
        case insert
        case vision
        case embedding
        case thinking
    }
    
    /// The details about the model.
    public let details: ModelDetails
    
    /// A structure that represents the details of the model.
            public struct ModelDetails: Decodable, Sendable {
        
        ///
        public let parentModel: String
        
        /// The format of the model. E.g. "gguf".
        public let format: String
        
        /// The family of the model. E.g. "llama".
        public let family: String
        
        /// The parameter size of the model. E.g. "8.0B".
        public let parameterSize: String
        
        /// The quantization level of the model. E.g. "Q4_0".
        public let quantizationLevel: String
        
        /// All the families of the model. E.g. ["llama", "phi3"].
        public let families: [String]?
    }
    
    public let modelInfo: ModelInfo
    
    public struct ModelInfo: Decodable, Sendable {
        public let generalArchitecture: String
        public let generalFileType: Int
        public let generalParameterCount: Int
        public let generalQuantizationVersion: Int
        
        // Generic storage for all family-specific properties
        public let familyProperties: [String: [String: JSON]]
        
        // Note: familyProperties is now Sendable since JSON conforms to Sendable
        
        public let tokenizerGGMLBosTokenID: Int
        public let tokenizerGGMLEosTokenID: Int
        public let tokenizerGGMLMerges: [String]?
        public let tokenizerGGMLModel: String
        public let tokenizerGGMLPre: String
        public let tokenizerGGMLTokenType: [String]?
        public let tokenizerGGMLTokens: [String]?
        
        // JSONDecoder+Default uses .convertFromSnakeCase for the Decoder
        // Because of that the keys have to be converted to cammel case
        // For example: "general.file_type" must be converted to "general.fileType"
        enum CodingKeys: String, CodingKey {
            case generalArchitecture = "general.architecture"
            case generalFileType = "general.fileType"
            case generalParameterCount = "general.parameterCount"
            case generalQuantizationVersion = "general.quantizationVersion"
            case tokenizerGGMLBosTokenID = "tokenizer.ggml.bosTokenId"
            case tokenizerGGMLEosTokenID = "tokenizer.ggml.eosTokenId"
            case tokenizerGGMLMerges = "tokenizer.ggml.merges"
            case tokenizerGGMLModel = "tokenizer.ggml.model"
            case tokenizerGGMLPre = "tokenizer.ggml.pre"
            case tokenizerGGMLTokenType = "tokenizer.ggml.tokenType"
            case tokenizerGGMLTokens = "tokenizer.ggml.tokens"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Decode general fields
            generalArchitecture = try container.decode(String.self, forKey: .generalArchitecture)
            generalFileType = try container.decode(Int.self, forKey: .generalFileType)
            generalParameterCount = try container.decode(Int.self, forKey: .generalParameterCount)
            generalQuantizationVersion = try container.decode(Int.self, forKey: .generalQuantizationVersion)
            
            // Decode tokenizer fields
            tokenizerGGMLBosTokenID = try container.decode(Int.self, forKey: .tokenizerGGMLBosTokenID)
            tokenizerGGMLEosTokenID = try container.decode(Int.self, forKey: .tokenizerGGMLEosTokenID)
            tokenizerGGMLMerges = try container.decodeIfPresent([String].self, forKey: .tokenizerGGMLMerges)
            tokenizerGGMLModel = try container.decode(String.self, forKey: .tokenizerGGMLModel)
            tokenizerGGMLPre = try container.decode(String.self, forKey: .tokenizerGGMLPre)
            tokenizerGGMLTokenType = try container.decodeIfPresent([String].self, forKey: .tokenizerGGMLTokenType)
            tokenizerGGMLTokens = try container.decodeIfPresent([String].self, forKey: .tokenizerGGMLTokens)
            
            // Parse all family-specific properties dynamically
            var familyProps: [String: [String: JSON]] = [:]
            
            // Get all keys from the decoder using a different approach
            let allKeysContainer = try decoder.container(keyedBy: AllKeysCodingKeys.self)
            
            // Get all available keys and dynamically group them by family
            let allKeys = allKeysContainer.allKeys
            
            for key in allKeys {
                let keyString = key.stringValue
                
                // Skip keys that are already handled by our explicit CodingKeys
                if keyString.hasPrefix("general.") || keyString.hasPrefix("tokenizer.") {
                    continue
                }
                
                // Check if this is a family-specific key (e.g., "llama.attention.headCount")
                let components = keyString.split(separator: ".", maxSplits: 1)
                if components.count == 2 {
                    let family = String(components[0])
                    let propertyPath = String(components[1])
                    
                    // Try to decode the value
                    if let value = try? allKeysContainer.decode(AnyCodable.self, forKey: key) {
                        // Initialize family dictionary if it doesn't exist
                        if familyProps[family] == nil {
                            familyProps[family] = [:]
                        }
                        
                        if let jsonValue = try? JSON(value.value) {
                            familyProps[family]?[propertyPath] = jsonValue
                        }
                    }
                }
            }
            
            familyProperties = familyProps
        }
        
        // Helper method to get a property value for a specific family
        public func getProperty<T>(family: String, property: String) -> T? {
            guard let jsonValue = familyProperties[family]?[property] else { return nil }
            
            // Extract the value based on the expected type T
            switch T.self {
            case is Int.Type:
                if case .integer(let value) = jsonValue {
                    return value as? T
                }
            case is Double.Type:
                if case .double(let value) = jsonValue {
                    return value as? T
                }
            case is String.Type:
                if case .string(let value) = jsonValue {
                    return value as? T
                }
            case is Bool.Type:
                if case .boolean(let value) = jsonValue {
                    return value as? T
                }
            default:
                break
            }
            
            return nil
        }
        
        // Helper method to get all properties for a specific family
        public func getFamilyProperties(family: String) -> [String: JSON]? {
            return familyProperties[family]
        }
        
        // Helper method to get all available families
        public func getAvailableFamilies() -> [String] {
            return Array(familyProperties.keys)
        }
    }
    

    
    // Helper struct for all possible keys
    private struct AllKeysCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
    
    // Helper struct for decoding any JSON value
    private struct AnyCodable: Codable {
        let value: Any
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if container.decodeNil() {
                value = NSNull()
            } else if let bool = try? container.decode(Bool.self) {
                value = bool
            } else if let int = try? container.decode(Int.self) {
                value = int
            } else if let double = try? container.decode(Double.self) {
                value = double
            } else if let string = try? container.decode(String.self) {
                value = string
            } else if let array = try? container.decode([AnyCodable].self) {
                value = array.map { $0.value }
            } else if let dictionary = try? container.decode([String: AnyCodable].self) {
                value = dictionary.mapValues { $0.value }
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable cannot decode value")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch value {
            case is NSNull:
                try container.encodeNil()
            case let bool as Bool:
                try container.encode(bool)
            case let int as Int:
                try container.encode(int)
            case let double as Double:
                try container.encode(double)
            case let string as String:
                try container.encode(string)
            case let array as [Any]:
                try container.encode(array.map { AnyCodable(value: $0) })
            case let dictionary as [String: Any]:
                try container.encode(dictionary.mapValues { AnyCodable(value: $0) })
            default:
                try container.encodeNil()
            }
        }
        
        init(value: Any) {
            self.value = value
        }
    }
}

//
//  OKModelInfoResponse.swift
//
//
//  Created by Kevin Hermawan on 10/11/23.
//

import Foundation

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
        public let llamaAttentionHeadCount: Int
        public let llamaAttentionHeadCountKV: Int
        public let llamaAttentionLayerNormRMSEpsilon: Double
        public let llamaBlockCount: Int
        public let llamaContextLength: Int
        public let llamaEmbeddingLength: Int
        public let llamaFeedForwardLength: Int
        public let llamaRopeDimensionCount: Int
        public let llamaRopeFreqBase: Int
        public let llamaVocabSize: Int
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
            case llamaAttentionHeadCount = "llama4.attention.headCount"
            case llamaAttentionHeadCountKV = "llama4.attention.headCountKv"
            case llamaAttentionLayerNormRMSEpsilon = "llama4.attention.layerNormRmsEpsilon"
            case llamaBlockCount = "llama4.blockCount"
            case llamaContextLength = "llama4.contextLength"
            case llamaEmbeddingLength = "llama4.embeddingLength"
            case llamaFeedForwardLength = "llama4.feedForwardLength"
            case llamaRopeDimensionCount = "llama4.rope.dimensionCount"
            case llamaRopeFreqBase = "llama4.rope.freqBase"
            case llamaVocabSize = "llama4.vocabSize"
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
            
            // Try to decode llama4 fields first, then fall back to llama fields
            let llama4Container = try decoder.container(keyedBy: Llama4CodingKeys.self)
            let llamaContainer = try decoder.container(keyedBy: LlamaCodingKeys.self)
            
            // Try llama4 first, then fall back to llama
            if let value = try? llama4Container.decode(Int.self, forKey: .llamaAttentionHeadCount) {
                llamaAttentionHeadCount = value
            } else {
                llamaAttentionHeadCount = try llamaContainer.decode(Int.self, forKey: .llamaAttentionHeadCount)
            }
            
            if let value = try? llama4Container.decode(Int.self, forKey: .llamaAttentionHeadCountKV) {
                llamaAttentionHeadCountKV = value
            } else {
                llamaAttentionHeadCountKV = try llamaContainer.decode(Int.self, forKey: .llamaAttentionHeadCountKV)
            }
            
            if let value = try? llama4Container.decode(Double.self, forKey: .llamaAttentionLayerNormRMSEpsilon) {
                llamaAttentionLayerNormRMSEpsilon = value
            } else {
                llamaAttentionLayerNormRMSEpsilon = try llamaContainer.decode(Double.self, forKey: .llamaAttentionLayerNormRMSEpsilon)
            }
            
            if let value = try? llama4Container.decode(Int.self, forKey: .llamaBlockCount) {
                llamaBlockCount = value
            } else {
                llamaBlockCount = try llamaContainer.decode(Int.self, forKey: .llamaBlockCount)
            }
            
            if let value = try? llama4Container.decode(Int.self, forKey: .llamaContextLength) {
                llamaContextLength = value
            } else {
                llamaContextLength = try llamaContainer.decode(Int.self, forKey: .llamaContextLength)
            }
            
            if let value = try? llama4Container.decode(Int.self, forKey: .llamaEmbeddingLength) {
                llamaEmbeddingLength = value
            } else {
                llamaEmbeddingLength = try llamaContainer.decode(Int.self, forKey: .llamaEmbeddingLength)
            }
            
            if let value = try? llama4Container.decode(Int.self, forKey: .llamaFeedForwardLength) {
                llamaFeedForwardLength = value
            } else {
                llamaFeedForwardLength = try llamaContainer.decode(Int.self, forKey: .llamaFeedForwardLength)
            }
            
            if let value = try? llama4Container.decode(Int.self, forKey: .llamaRopeDimensionCount) {
                llamaRopeDimensionCount = value
            } else {
                llamaRopeDimensionCount = try llamaContainer.decode(Int.self, forKey: .llamaRopeDimensionCount)
            }
            
            if let value = try? llama4Container.decode(Int.self, forKey: .llamaRopeFreqBase) {
                llamaRopeFreqBase = value
            } else {
                llamaRopeFreqBase = try llamaContainer.decode(Int.self, forKey: .llamaRopeFreqBase)
            }
            
            if let value = try? llama4Container.decode(Int.self, forKey: .llamaVocabSize) {
                llamaVocabSize = value
            } else {
                llamaVocabSize = try llamaContainer.decode(Int.self, forKey: .llamaVocabSize)
            }
            
            // Decode tokenizer fields
            tokenizerGGMLBosTokenID = try container.decode(Int.self, forKey: .tokenizerGGMLBosTokenID)
            tokenizerGGMLEosTokenID = try container.decode(Int.self, forKey: .tokenizerGGMLEosTokenID)
            tokenizerGGMLMerges = try container.decodeIfPresent([String].self, forKey: .tokenizerGGMLMerges)
            tokenizerGGMLModel = try container.decode(String.self, forKey: .tokenizerGGMLModel)
            tokenizerGGMLPre = try container.decode(String.self, forKey: .tokenizerGGMLPre)
            tokenizerGGMLTokenType = try container.decodeIfPresent([String].self, forKey: .tokenizerGGMLTokenType)
            tokenizerGGMLTokens = try container.decodeIfPresent([String].self, forKey: .tokenizerGGMLTokens)
        }
        
        // Coding keys for llama4 prefix
        private enum Llama4CodingKeys: String, CodingKey {
            case llamaAttentionHeadCount = "llama4.attention.headCount"
            case llamaAttentionHeadCountKV = "llama4.attention.headCountKv"
            case llamaAttentionLayerNormRMSEpsilon = "llama4.attention.layerNormRmsEpsilon"
            case llamaBlockCount = "llama4.blockCount"
            case llamaContextLength = "llama4.contextLength"
            case llamaEmbeddingLength = "llama4.embeddingLength"
            case llamaFeedForwardLength = "llama4.feedForwardLength"
            case llamaRopeDimensionCount = "llama4.rope.dimensionCount"
            case llamaRopeFreqBase = "llama4.rope.freqBase"
            case llamaVocabSize = "llama4.vocabSize"
        }
        
        // Coding keys for llama prefix
        private enum LlamaCodingKeys: String, CodingKey {
            case llamaAttentionHeadCount = "llama.attention.headCount"
            case llamaAttentionHeadCountKV = "llama.attention.headCountKv"
            case llamaAttentionLayerNormRMSEpsilon = "llama.attention.layerNormRmsEpsilon"
            case llamaBlockCount = "llama.blockCount"
            case llamaContextLength = "llama.contextLength"
            case llamaEmbeddingLength = "llama.embeddingLength"
            case llamaFeedForwardLength = "llama.feedForwardLength"
            case llamaRopeDimensionCount = "llama.rope.dimensionCount"
            case llamaRopeFreqBase = "llama.rope.freqBase"
            case llamaVocabSize = "llama.vocabSize"
        }
    }
}

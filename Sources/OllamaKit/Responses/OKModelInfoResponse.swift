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
    public let license: String
    
    /// A string representing the template used by the model.
    public let template: String
    
    /// A string containing the path or identifier of the model file.
    public let modelfile: String
    
    /// A string detailing the parameters or settings of the model.
    public let parameters: String
    
    /// A list of model capabilities (like vision, tools)
    public let capabilities: [Capability]
    
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
            case tokenizerGGMLBosTokenID = "tokenizer.ggml.bosTokenId"
            case tokenizerGGMLEosTokenID = "tokenizer.ggml.eosTokenId"
            case tokenizerGGMLMerges = "tokenizer.ggml.merges"
            case tokenizerGGMLModel = "tokenizer.ggml.model"
            case tokenizerGGMLPre = "tokenizer.ggml.pre"
            case tokenizerGGMLTokenType = "tokenizer.ggml.tokenType"
            case tokenizerGGMLTokens = "tokenizer.ggml.tokens"
        }
    }
}

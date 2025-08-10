//
//  OKGenerateRequestData.swift
//
//
//  Created by Kevin Hermawan on 10/11/23.
//

import EasyJSON
import Foundation

/// A structure that encapsulates the data required for generating responses using the Ollama API.
public struct OKGenerateRequestData: Sendable {
    private let stream: Bool
    
    /// A string representing the identifier of the model.
    public let model: String
    
    /// A string containing the initial input or prompt.
    public let prompt: String
    
    /// the text after the model response
    public let suffix: String?
    
    /// An optional array of base64-encoded images.
    public let images: [String]?
    
    /// (for thinking models) should the model think before responding?
    public let think: Bool?

    /// Optional ``JSON`` representing the JSON schema for the response.
    /// Be sure to also include "return as JSON" in your prompt
    public var format: JSON?

    /// An optional string specifying the system message.
    public var system: String?
    
    /// The prompt template to use (overrides what is defined in the Modelfile)
    public var template: String?
    
    /// If true no formatting will be applied to the prompt. You may choose to use the raw parameter if you are specifying a full templated prompt in your request to the API
    public var raw: Bool?
    
    /// Controls how long the model will stay loaded into memory following the request (default: 5m)
    public var keepAlive: Int?
    
    /// An optional array of integers representing contextual information.
    public var context: [Int]?
    
    /// Optional ``OKCompletionOptions`` providing additional configuration for the generation request.
    public var options: OKCompletionOptions?
    
    public init(model: String, prompt: String, suffix: String? = nil, images: [String]? = nil, think: Bool? = nil) {
        self.stream = true
        self.model = model
        self.prompt = prompt
        self.suffix = suffix
        self.images = images
        self.think = think
    }
}

extension OKGenerateRequestData: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stream, forKey: .stream)
        try container.encode(model, forKey: .model)
        try container.encode(prompt, forKey: .prompt)
        try container.encodeIfPresent(suffix, forKey: .suffix)
        try container.encodeIfPresent(images, forKey: .images)
        try container.encodeIfPresent(think, forKey: .think)
        try container.encodeIfPresent(format, forKey: .format)
        try container.encodeIfPresent(system, forKey: .system)
        try container.encodeIfPresent(template, forKey: .template)
        try container.encodeIfPresent(raw, forKey: .raw)
        try container.encodeIfPresent(keepAlive, forKey: .keepAlive)
        try container.encodeIfPresent(context, forKey: .context)
        
        if let options {
            try options.encode(to: encoder)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case stream, model, prompt, suffix, images, think, format, system, template, raw, keepAlive, context
    }
}

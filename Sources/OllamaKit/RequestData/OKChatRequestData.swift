//
//  OKChatRequestData.swift
//
//
//  Created by Augustinas Malinauskas on 12/12/2023.
//

import EasyJSON
import Foundation

/// A structure that encapsulates data for chat requests to the Ollama API.
public struct OKChatRequestData: Sendable {
    private let stream: Bool
    
    /// A string representing the model identifier to be used for the chat session.
    public let model: String
    
    /// An array of ``Message`` instances representing the content to be sent to the Ollama API.
    public let messages: [Message]
    
    /// An optional array of ``JSON`` representing the tools available for tool calling in the chat.
    public let tools: [JSON]?
    
    /// (for thinking models) should the model think before responding?
    public let think: Bool?

    /// Optional ``JSON`` representing the JSON schema for the response.
    /// Be sure to also include "return as JSON" in your prompt
    public let format: JSON?

    /// Optional ``OKCompletionOptions`` providing additional configuration for the chat request.
    public var options: OKCompletionOptions?
    
    /// Controls how long the model will stay loaded into memory following the request (default: 5m)
    public var keepAlive: Int?
    
    public init(model: String, messages: [Message], tools: [JSON]? = nil, think: Bool? = nil, format: JSON? = nil) {
        self.stream = true
        self.model = model
        self.messages = messages
        self.tools = tools
        self.think = think
        self.format = format
    }
    
    /// A structure that represents a single message in the chat request.
    public struct Message: Encodable, Sendable {
        /// A ``Role`` value indicating the sender of the message (system, assistant, user).
        public let role: Role
        
        /// A string containing the message's content.
        public let content: String
        
        /// An optional array of base64-encoded images.
        public let images: [String]?
        
        /// An optional array of ``ToolCall`` instances representing any tools invoked in the response.
        public var toolCalls: [ToolCall]?
        
        /// (for thinking models) the model's thinking process
        public var thinking: String?
        
        /// (optional): add the name of the tool that was executed to inform the model of the result
        public var toolName: String?
        
        public init(role: Role, content: String, images: [String]? = nil) {
            self.role = role
            self.content = content
            self.images = images
        }
        
        /// An enumeration that represents the role of the message sender.
        public enum Role: String, Encodable, Sendable {
            /// Indicates the message is from the system.
            case system
            
            /// Indicates the message is from the assistant.
            case assistant
            
            /// Indicates the message is from the user.
            case user
            
            /// The message is from a tool.
            case tool
        }
        
        /// A structure that represents a tool call in the response.
        public struct ToolCall: Codable, Sendable {
            /// An optional ``Function`` structure representing the details of the tool call.
            public let function: Function?
            
            /// A structure that represents the details of a tool call.
            public struct Function: Codable, Sendable {
                /// The name of the tool being called.
                public let name: String?
                
                /// An optional ``JSON`` representing the arguments passed to the tool.
                public let arguments: JSON?
            }
        }
    }
}

extension OKChatRequestData: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stream, forKey: .stream)
        try container.encode(model, forKey: .model)
        try container.encode(messages, forKey: .messages)
        try container.encodeIfPresent(tools, forKey: .tools)
        try container.encodeIfPresent(format, forKey: .format)
        try container.encodeIfPresent(keepAlive, forKey: .keepAlive)

        if let options {
            try options.encode(to: encoder)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case stream, model, messages, tools, format, options, keepAlive
    }
}

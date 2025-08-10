//
//  OKCompletionData.swift
//
//
//  Created by Kevin Hermawan on 02/01/24.
//

import Foundation

// A structure that encapsulates options for controlling the behavior of content generation in the Ollama API.
public struct OKCompletionOptions: Encodable, Sendable {
    
    /// Optional integer setting the size of the context window for token generation.
    /// This defines the number of previous tokens the model considers when generating new tokens.
    /// Larger values allow the model to use more context, with a default of 2048 tokens.
    public var numCtx: Int?
    
    /// Optional integer setting how far back the model looks to prevent repetition.
    /// This parameter, `repeatLastN`, determines the number of tokens the model
    /// reviews to avoid repeating phrases. A value of 64 is typical, while 0 disables this feature.
    public var repeatLastN: Int?
    
    /// Optional double setting the penalty strength for repetitions.
    /// A higher value increases the penalty for repeated tokens, discouraging repetition.
    /// The default value is 1.1, providing moderate repetition control.
    public var repeatPenalty: Double?
    
    /// Optional double setting the penalty strength for repetitions.
    /// The Presence Penalty parameter prevents the model from repeating a word, even if it's only been used once
    /// Encourages using different words
    public var presencePenalty: Double?
    
    /// Optional double setting the penalty strength for repetitions.
    /// Tells the model not to repeat a word that has already been used multiple times in the conversation
    /// Avoid using the same words too often
    public var frequencyPenalty: Double?
    
    ///
    public var penalizeNewline: Bool?
    
    /// Optional double to control the model's creativity.
    /// (Higher values increase creativity and randomness)
    /// The `temperature` parameter adjusts the randomness of predictions; higher values
    /// like 0.8 make outputs more creative and diverse. The default is 0.7.
    public var temperature: Double?
    
    /// Optional integer for setting a random number seed for generation consistency.
    /// Specifying a seed ensures the same output for the same prompt and parameters,
    /// useful for testing or reproducing results. Default is 0, meaning no fixed seed.
    public var seed: Int?
    
    /// Optional string defining stop sequences for the model to cease generation.
    /// The `stop` parameter specifies sequences that, when encountered, will halt further text generation.
    /// Multiple stop sequences can be defined. For example, "AI assistant:".
    public var stop: String?
    
    /// Optional double for tail free sampling, reducing impact of less probable tokens.
    /// `tfsZ` adjusts how much the model avoids unlikely tokens, with higher values
    /// reducing their influence. A value of 1.0 disables this feature.
    public var tfsZ: Double?
    
    /// Optional integer for the maximum number of tokens to predict.
    /// `numPredict` sets the upper limit for the number of tokens to generate.
    /// A default of 128 tokens is typical, with special values like -1 for infinite generation.
    public var numPredict: Int?
    
    /// Optional integer to limit nonsense generation and control answer diversity.
    /// The `topK` parameter limits the set of possible tokens to the top-k likely choices.
    /// Lower values (e.g., 10) reduce diversity, while higher values (e.g., 100) increase it. Default is 40.
    public var topK: Int?
    
    /// Optional double working with top-k to balance text diversity and focus.
    /// `topP` (nucleus sampling) retains tokens that cumulatively account for a certain
    /// probability mass, adding flexibility beyond `topK`. A value like 0.9 increases diversity.
    public var topP: Double?
    
    /// Optional double for the minimum probability threshold for token inclusion.
    /// `minP` ensures that tokens below a certain probability threshold are excluded,
    /// focusing the model's output on more probable sequences. Default is 0.0, meaning no filtering.
    public var minP: Double?
    
    /// Optional double for the typical probability threshold for token inclusion.
    /// Local typicality measures how similar the conditional probability of predicting a target token next is
    /// to the expected conditional probability of predicting a random token next, given the partial text already
    /// generated. If set to `float < 1`, the smallest set of the most locally typical tokens with probabilities
    /// that add up to `typicalP` or higher are kept for generation
    public var typicalP: Double?
    
    ///
    public var numa: Bool?
    
    public var numBatch: Int?
    public var numGpu: Int?
    public var mainGpu: Int?
    public var useMmap: Bool?
    public var numThread: Int?
    
    /// Optional integer for the Tokens To Kee  p On Context Refresh.
    /// Description : This setting determines how many tokens are retained when the context is refreshed or truncated.
    /// Impact :
    /// * Higher Value : More of the recent context is preserved, which can help maintain relevance and coherence but may limit the model's ability to consider older parts of the conversation.
    /// * Lower Value : Less recent context is retained, which can reduce memory usage but might lead to less coherent responses.
    /// Tuning :
    /// * For maintaining a more consistent conversation flow, increase num_keep.
    /// * To manage memory more efficiently, decrease num_keep.
    public var numKeep: Int?
    
    public init(numCtx: Int? = nil, repeatLastN: Int? = nil, repeatPenalty: Double? = nil, presencePenalty: Double? = nil, penalizeNewline: Bool? = nil, frequencyPenalty: Double? = nil, temperature: Double? = nil, seed: Int? = nil, stop: String? = nil, tfsZ: Double? = nil, numPredict: Int? = nil, topK: Int? = nil, topP: Double? = nil, minP: Double? = nil, typicalP: Double? = nil, numKeep: Int? = nil, numa: Bool? = nil, numBatch: Int? = nil, numGpu: Int? = nil , mainGpu: Int? = nil, useMmap: Bool? = nil, numThread: Int? = nil) {
        self.numCtx = numCtx
        self.repeatLastN = repeatLastN
        self.repeatPenalty = repeatPenalty
        self.presencePenalty = presencePenalty
        self.frequencyPenalty = frequencyPenalty
        self.penalizeNewline = penalizeNewline
        self.temperature = temperature
        self.seed = seed
        self.stop = stop
        self.tfsZ = tfsZ
        self.numPredict = numPredict
        self.topK = topK
        self.topP = topP
        self.minP = minP
        self.typicalP = typicalP
        self.numKeep = numKeep
        self.numa = numa
        self.numBatch = numBatch
        self.numGpu = numGpu
        self.mainGpu = mainGpu
        self.useMmap = useMmap
        self.numThread = numThread
    }
}

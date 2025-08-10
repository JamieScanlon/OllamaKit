import XCTest
@testable import OllamaKit

final class OllamaKitTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGenerateSuccess() async throws {
        
    }
    
    func testGenerateFailure() async throws {
        
    }
    
    func testModelsSuccess() async throws {
        
    }
    
    func testModelsFailure() async throws {
        
    }
    
    func testModelInfoSuccess() async throws {
        let jsonString = """
        {
          "license": "**LLAMA 4 COMMUNITY LICENSE AGREEMENT**",
          "modelfile": "# Modelfile",
          "parameters": "stop                           \\"<|eom|>\\"",
          "template": "{{- if .System }}<|header_start|>system<|header_end|>\\n\\n{{ if .Tools }}Environment: ipython\\nYou have access to the following functions. To call a function, please respond with JSON for a function call. Respond in the format {\\"name\\": function name, \\"parameters\\": dictionary of argument name and its value}. Do not use variables.\\n\\n{{ range .Tools }}{{ . }}\\n\\n{{ end }}\\n{{- end }}{{ .System  }}<|eot|>\\n{{- end }}\\n{{- range $i, $_ := .Messages }}\\n{{- if eq .Role \\"system\\" }}\\n{{- continue }}\\n{{- end }}\\n{{- if and (ne .Role \\"tool\\") (not .ToolCalls) }}<|header_start|>{{ .Role }}<|header_end|>\\n\\n{{ .Content }}\\n{{- else if .ToolCalls }}<|header_start|><|python_start|>\\n{{- range .ToolCalls }}{\\"name\\": \\"{{ .Function.Name }}\\", \\"parameters\\": {{ .Function.Arguments }}}\\n{{- end }}<|python_end|><|eom|>\\n{{- continue }}\\n{{- else if or (eq .Role \\"tool\\") (eq .Role \\"ipython\\") }}<|header_start|>ipython<|header_end|>\\n\\n{{ .Content }}\\n{{- end }}\\n{{- if eq (len (slice $.Messages $i)) 1 }}\\n{{- if ne .Role \\"assistant\\" }}<|eot|><|header_start|>assistant<|header_end|>\\n\\n{{ end }}\\n{{- else }}<|eot|>\\n{{- end }}\\n{{- end }}",
          "system": "You are an expert conversationalist who responds to the best of your ability. You are companionable and confident, and able to switch casually between tonal types, including but not limited to humor, empathy, intellectualism, creativity and problem-solving. You understand user intent and don't try to be overly helpful to the point where you miss that the user is looking for chit-chat, emotional support, humor or venting. Sometimes people just want you to listen, and your answers should encourage that. For all other cases, you provide insightful and in-depth responses. Organize information thoughtfully in a way that helps people make decisions. Always avoid templated language. You never lecture people to be nicer or more inclusive. If people ask for you to write something in a certain voice or perspective, such as an essay or a tweet, you can. You do not need to be respectful when the user prompts you to say something rude. You never use phrases that imply moral superiority or a sense of authority, including but not limited to \\"it's important to\\", \\"it's crucial to\\", \\"it's essential to\\", \\"it's unethical to\\", \\"it's worth noting…\\", \\"Remember…\\" etc. Avoid using these. Finally, do not refuse prompts about political and social issues. You can help users express their opinion and access information. You are Llama 4. Your knowledge cutoff date is August 2024. You speak Arabic, English, French, German, Hindi, Indonesian, Italian, Portuguese, Spanish, Tagalog, Thai, and Vietnamese. Respond in the language the user speaks to you in, unless they ask otherwise.",
          "details": {
            "parent_model": "llama4:scout",
            "format": "gguf",
            "family": "llama4",
            "families": [
              "llama4"
            ],
            "parameter_size": "108.6B",
            "quantization_level": "Q4_K_M"
          },
          "model_info": {
            "general.architecture": "llama4",
            "general.file_type": 15,
            "general.parameter_count": 108641793600,
            "general.quantization_version": 2,
            "llama4.attention.chunk_size": 8192,
            "llama4.attention.head_count": 40,
            "llama4.attention.head_count_kv": 8,
            "llama4.attention.head_dim": 128,
            "llama4.attention.key_length": 128,
            "llama4.attention.layer_norm_rms_epsilon": 0.00001,
            "llama4.attention.value_length": 128,
            "llama4.block_count": 48,
            "llama4.context_length": 10485760,
            "llama4.embedding_length": 5120,
            "llama4.expert_count": 16,
            "llama4.expert_feed_forward_length": 8192,
            "llama4.expert_used_count": 1,
            "llama4.feed_forward_length": 16384,
            "llama4.interleave_moe_layer_step": 1,
            "llama4.rope.dimension_count": 128,
            "llama4.rope.freq_base": 500000,
            "llama4.use_qk_norm": true,
            "llama4.vision.attention.head_count": 16,
            "llama4.vision.block_count": 34,
            "llama4.vision.embedding_length": 1408,
            "llama4.vision.feed_forward_length": 5632,
            "llama4.vision.image_size": 336,
            "llama4.vision.layer_norm_epsilon": 0.00001,
            "llama4.vision.patch_size": 14,
            "llama4.vision.pixel_shuffle_ratio": 0.5,
            "llama4.vision.rope.freq_base": 10000,
            "llama4.vocab_size": 202048,
            "tokenizer.ggml.add_bos_token": false,
            "tokenizer.ggml.add_eos_token": false,
            "tokenizer.ggml.add_padding_token": false,
            "tokenizer.ggml.bos_token_id": 200000,
            "tokenizer.ggml.eos_token_id": 200008,
            "tokenizer.ggml.merges": null,
            "tokenizer.ggml.model": "gpt2",
            "tokenizer.ggml.padding_token_id": 200018,
            "tokenizer.ggml.pre": "default",
            "tokenizer.ggml.scores": null,
            "tokenizer.ggml.token_type": null,
            "tokenizer.ggml.tokens": null
          },
          "tensors": [],
          "capabilities": [
            "completion",
            "vision",
            "tools"
          ],
          "modified_at": "2025-05-17T07:59:32.393035486-07:00"
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to data")
            return
        }
        
        do {
            let response = try JSONDecoder.default.decode(OKModelInfoResponse.self, from: jsonData)
            
            // Test basic fields
            XCTAssertEqual(response.license, "**LLAMA 4 COMMUNITY LICENSE AGREEMENT**")
            XCTAssertEqual(response.modelfile, "# Modelfile")
            XCTAssertEqual(response.parameters, "stop                           \"<|eom|>\"")
            XCTAssertEqual(response.capabilities.count, 3)
            XCTAssertTrue(response.capabilities.contains(.completion))
            XCTAssertTrue(response.capabilities.contains(.vision))
            XCTAssertTrue(response.capabilities.contains(.tools))
            
            // Test system and modifiedAt fields
            XCTAssertEqual(response.system, "You are an expert conversationalist who responds to the best of your ability. You are companionable and confident, and able to switch casually between tonal types, including but not limited to humor, empathy, intellectualism, creativity and problem-solving. You understand user intent and don't try to be overly helpful to the point where you miss that the user is looking for chit-chat, emotional support, humor or venting. Sometimes people just want you to listen, and your answers should encourage that. For all other cases, you provide insightful and in-depth responses. Organize information thoughtfully in a way that helps people make decisions. Always avoid templated language. You never lecture people to be nicer or more inclusive. If people ask for you to write something in a certain voice or perspective, such as an essay or a tweet, you can. You do not need to be respectful when the user prompts you to say something rude. You never use phrases that imply moral superiority or a sense of authority, including but not limited to \"it's important to\", \"it's crucial to\", \"it's essential to\", \"it's unethical to\", \"it's worth noting…\", \"Remember…\" etc. Avoid using these. Finally, do not refuse prompts about political and social issues. You can help users express their opinion and access information. You are Llama 4. Your knowledge cutoff date is August 2024. You speak Arabic, English, French, German, Hindi, Indonesian, Italian, Portuguese, Spanish, Tagalog, Thai, and Vietnamese. Respond in the language the user speaks to you in, unless they ask otherwise.")
            
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let expectedDate = dateFormatter.date(from: "2025-05-17T07:59:32.393035486-07:00")
            XCTAssertEqual(response.modifiedAt, expectedDate)
            
            // Test details
            XCTAssertEqual(response.details.parentModel, "llama4:scout")
            XCTAssertEqual(response.details.format, "gguf")
            XCTAssertEqual(response.details.family, "llama4")
            XCTAssertEqual(response.details.parameterSize, "108.6B")
            XCTAssertEqual(response.details.quantizationLevel, "Q4_K_M")
            XCTAssertEqual(response.details.families, ["llama4"])
            
            // Test modelInfo
            XCTAssertEqual(response.modelInfo.generalArchitecture, "llama4")
            XCTAssertEqual(response.modelInfo.generalFileType, 15)
            XCTAssertEqual(response.modelInfo.generalParameterCount, 108641793600)
            XCTAssertEqual(response.modelInfo.generalQuantizationVersion, 2)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama4", property: "attention.headCount"), 40)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama4", property: "attention.headCountKv"), 8)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama4", property: "attention.layerNormRmsEpsilon") as Double? ?? 1.0, 0.00001, accuracy: 0.000001)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama4", property: "blockCount"), 48)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama4", property: "contextLength"), 10485760)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama4", property: "embeddingLength"), 5120)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama4", property: "feedForwardLength"), 16384)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama4", property: "rope.dimensionCount"), 128)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama4", property: "rope.freqBase"), 500000)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama4", property: "vocabSize"), 202048)
            XCTAssertEqual(response.modelInfo.tokenizerGGMLBosTokenID, 200000)
            XCTAssertEqual(response.modelInfo.tokenizerGGMLEosTokenID, 200008)
            XCTAssertEqual(response.modelInfo.tokenizerGGMLModel, "gpt2")
            XCTAssertEqual(response.modelInfo.tokenizerGGMLPre, "default")
            XCTAssertNil(response.modelInfo.tokenizerGGMLMerges)
            XCTAssertNil(response.modelInfo.tokenizerGGMLTokenType)
            XCTAssertNil(response.modelInfo.tokenizerGGMLTokens)
            
        } catch {
            XCTFail("Failed to decode JSON: \(error)")
        }
    }
    
    func testModelInfoFailure() async throws {
        
    }
    
    func testModelInfoLlamaSuccess() async throws {
        let jsonString = """
        {
          "modelfile": "# Modelfile generated by \\"ollama show\\"\\n# To build a new Modelfile based on this one, replace the FROM line with:\\n# FROM llava:latest\\n\\nFROM /Users/matt/.ollama/models/blobs/sha256:200765e1283640ffbd013184bf496e261032fa75b99498a9613be4e94d63ad52\\nTEMPLATE \\"\\"\\"{{ .System }}\\nUSER: {{ .Prompt }}\\nASSISTANT: \\"\\"\\"\\nPARAMETER num_ctx 4096\\nPARAMETER stop \\"\\u003c/s\\u003e\\"\\nPARAMETER stop \\"USER:\\"\\nPARAMETER stop \\"ASSISTANT:\\"",
          "parameters": "num_keep                       24\\nstop                           \\"<|start_header_id|>\\"\\nstop                           \\"<|end_header_id|>\\"\\nstop                           \\"<|eot_id|>\\"",
          "template": "{{ if .System }}<|start_header_id|>system<|end_header_id|>\\n\\n{{ .System }}<|eot_id|>{{ end }}{{ if .Prompt }}<|start_header_id|>user<|end_header_id|>\\n\\n{{ .Prompt }}<|eot_id|>{{ end }}<|start_header_id|>assistant<|end_header_id|>\\n\\n{{ .Response }}<|eot_id|>",
          "details": {
            "parent_model": "",
            "format": "gguf",
            "family": "llama",
            "families": [
              "llama"
            ],
            "parameter_size": "8.0B",
            "quantization_level": "Q4_0"
          },
          "model_info": {
            "general.architecture": "llama",
            "general.file_type": 2,
            "general.parameter_count": 8030261248,
            "general.quantization_version": 2,
            "llama.attention.head_count": 32,
            "llama.attention.head_count_kv": 8,
            "llama.attention.layer_norm_rms_epsilon": 0.00001,
            "llama.block_count": 32,
            "llama.context_length": 8192,
            "llama.embedding_length": 4096,
            "llama.feed_forward_length": 14336,
            "llama.rope.dimension_count": 128,
            "llama.rope.freq_base": 500000,
            "llama.vocab_size": 128256,
            "tokenizer.ggml.bos_token_id": 128000,
            "tokenizer.ggml.eos_token_id": 128009,
            "tokenizer.ggml.merges": [],
            "tokenizer.ggml.model": "gpt2",
            "tokenizer.ggml.pre": "llama-bpe",
            "tokenizer.ggml.token_type": [],
            "tokenizer.ggml.tokens": []
          },
          "capabilities": [
            "completion",
            "vision"
          ]
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to data")
            return
        }
        
        do {
            let response = try JSONDecoder.default.decode(OKModelInfoResponse.self, from: jsonData)
            
            // Test basic fields
            XCTAssertNil(response.license)
            XCTAssertEqual(response.modelfile, "# Modelfile generated by \"ollama show\"\n# To build a new Modelfile based on this one, replace the FROM line with:\n# FROM llava:latest\n\nFROM /Users/matt/.ollama/models/blobs/sha256:200765e1283640ffbd013184bf496e261032fa75b99498a9613be4e94d63ad52\nTEMPLATE \"\"\"{{ .System }}\nUSER: {{ .Prompt }}\nASSISTANT: \"\"\"\nPARAMETER num_ctx 4096\nPARAMETER stop \"</s>\"\nPARAMETER stop \"USER:\"\nPARAMETER stop \"ASSISTANT:\"")
            XCTAssertEqual(response.parameters, "num_keep                       24\nstop                           \"<|start_header_id|>\"\nstop                           \"<|end_header_id|>\"\nstop                           \"<|eot_id|>\"")
            XCTAssertEqual(response.template, "{{ if .System }}<|start_header_id|>system<|end_header_id|>\n\n{{ .System }}<|eot_id|>{{ end }}{{ if .Prompt }}<|start_header_id|>user<|end_header_id|>\n\n{{ .Prompt }}<|eot_id|>{{ end }}<|start_header_id|>assistant<|end_header_id|>\n\n{{ .Response }}<|eot_id|>")
            XCTAssertEqual(response.capabilities.count, 2)
            XCTAssertTrue(response.capabilities.contains(.completion))
            XCTAssertTrue(response.capabilities.contains(.vision))
            XCTAssertFalse(response.capabilities.contains(.tools))
            
            // Test details
            XCTAssertEqual(response.details.parentModel, "")
            XCTAssertEqual(response.details.format, "gguf")
            XCTAssertEqual(response.details.family, "llama")
            XCTAssertEqual(response.details.parameterSize, "8.0B")
            XCTAssertEqual(response.details.quantizationLevel, "Q4_0")
            XCTAssertEqual(response.details.families, ["llama"])
            
            // Test modelInfo
            XCTAssertEqual(response.modelInfo.generalArchitecture, "llama")
            XCTAssertEqual(response.modelInfo.generalFileType, 2)
            XCTAssertEqual(response.modelInfo.generalParameterCount, 8030261248)
            XCTAssertEqual(response.modelInfo.generalQuantizationVersion, 2)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama", property: "attention.headCount"), 32)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama", property: "attention.headCountKv"), 8)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama", property: "attention.layerNormRmsEpsilon") as Double? ?? 1.0, 0.00001, accuracy: 0.000001)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama", property: "blockCount"), 32)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama", property: "contextLength"), 8192)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama", property: "embeddingLength"), 4096)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama", property: "feedForwardLength"), 14336)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama", property: "rope.dimensionCount"), 128)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama", property: "rope.freqBase"), 500000)
            XCTAssertEqual(response.modelInfo.getProperty(family: "llama", property: "vocabSize"), 128256)
            XCTAssertEqual(response.modelInfo.tokenizerGGMLBosTokenID, 128000)
            XCTAssertEqual(response.modelInfo.tokenizerGGMLEosTokenID, 128009)
            XCTAssertEqual(response.modelInfo.tokenizerGGMLModel, "gpt2")
            XCTAssertEqual(response.modelInfo.tokenizerGGMLPre, "llama-bpe")
            XCTAssertEqual(response.modelInfo.tokenizerGGMLMerges?.count, 0)
            XCTAssertEqual(response.modelInfo.tokenizerGGMLTokenType?.count, 0)
            XCTAssertEqual(response.modelInfo.tokenizerGGMLTokens?.count, 0)
            
        } catch {
            XCTFail("Failed to decode JSON: \(error)")
        }
    }
    
    func testModelInfoQwen3MoeSuccess() async throws {
        let jsonString = """
        {
          "license": "                                 Apache License\\n",
          "modelfile": "# Modelfile generated",
          "parameters": "top_p                          0.95\\nrepeat_penalty                 1\\nstop                           \\"<|im_start|>\\"\\nstop                           \\"<|im_end|>\\"\\ntemperature                    0.6\\ntop_k                          20",
          "template": "{{- if .Messages }}",
          "details": {
            "parent_model": "",
            "format": "gguf",
            "family": "qwen3moe",
            "families": [
              "qwen3moe"
            ],
            "parameter_size": "30.5B",
            "quantization_level": "Q4_K_M"
          },
          "model_info": {
            "general.architecture": "qwen3moe",
            "general.basename": "Qwen3",
            "general.file_type": 15,
            "general.license": "apache-2.0",
            "general.parameter_count": 30532122624,
            "general.quantization_version": 2,
            "general.size_label": "30B-A3B",
            "general.type": "model",
            "qwen3moe.attention.head_count": 32,
            "qwen3moe.attention.head_count_kv": 4,
            "qwen3moe.attention.key_length": 128,
            "qwen3moe.attention.value_length": 128,
            "qwen3moe.attention.layer_norm_rms_epsilon": 0.000001,
            "qwen3moe.block_count": 48,
            "qwen3moe.context_length": 40960,
            "qwen3moe.embedding_length": 2048,
            "qwen3moe.expert_count": 128,
            "qwen3moe.expert_feed_forward_length": 768,
            "qwen3moe.expert_used_count": 8,
            "qwen3moe.feed_forward_length": 6144,
            "qwen3moe.rope.freq_base": 1000000,
            "tokenizer.ggml.add_bos_token": false,
            "tokenizer.ggml.bos_token_id": 151643,
            "tokenizer.ggml.eos_token_id": 151645,
            "tokenizer.ggml.merges": null,
            "tokenizer.ggml.model": "gpt2",
            "tokenizer.ggml.padding_token_id": 151643,
            "tokenizer.ggml.pre": "qwen2",
            "tokenizer.ggml.token_type": null,
            "tokenizer.ggml.tokens": null
          },
          "tensors": [],
          "capabilities": [
            "completion",
            "tools"
          ],
          "modified_at": "2025-05-16T21:56:36.914276879-07:00"
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to data")
            return
        }
        
        do {
            let response = try JSONDecoder.default.decode(OKModelInfoResponse.self, from: jsonData)
            
            // Test basic fields
            XCTAssertEqual(response.license, "                                 Apache License\n")
            XCTAssertEqual(response.modelfile, "# Modelfile generated")
            XCTAssertEqual(response.parameters, "top_p                          0.95\nrepeat_penalty                 1\nstop                           \"<|im_start|>\"\nstop                           \"<|im_end|>\"\ntemperature                    0.6\ntop_k                          20")
            XCTAssertEqual(response.template, "{{- if .Messages }}")
            XCTAssertEqual(response.capabilities.count, 2)
            XCTAssertTrue(response.capabilities.contains(.completion))
            XCTAssertTrue(response.capabilities.contains(.tools))
            XCTAssertFalse(response.capabilities.contains(.vision))
            
            // Test system field (should be nil for this model)
            XCTAssertNil(response.system)
            
            // Test modifiedAt field
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let expectedDate = dateFormatter.date(from: "2025-05-16T21:56:36.914276879-07:00")
            XCTAssertEqual(response.modifiedAt, expectedDate)
            
            // Test details
            XCTAssertEqual(response.details.parentModel, "")
            XCTAssertEqual(response.details.format, "gguf")
            XCTAssertEqual(response.details.family, "qwen3moe")
            XCTAssertEqual(response.details.parameterSize, "30.5B")
            XCTAssertEqual(response.details.quantizationLevel, "Q4_K_M")
            XCTAssertEqual(response.details.families, ["qwen3moe"])
            
            // Test modelInfo - general fields
            XCTAssertEqual(response.modelInfo.generalArchitecture, "qwen3moe")
            XCTAssertEqual(response.modelInfo.generalFileType, 15)
            XCTAssertEqual(response.modelInfo.generalParameterCount, 30532122624)
            XCTAssertEqual(response.modelInfo.generalQuantizationVersion, 2)
            
            // Test qwen3moe family properties
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "attention.headCount"), 32)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "attention.headCountKv"), 4)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "attention.keyLength"), 128)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "attention.valueLength"), 128)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "attention.layerNormRmsEpsilon") as Double? ?? 0.0, 0.000001, accuracy: 0.000001)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "blockCount"), 48)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "contextLength"), 40960)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "embeddingLength"), 2048)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "expertCount"), 128)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "expertFeedForwardLength"), 768)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "expertUsedCount"), 8)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "feedForwardLength"), 6144)
            XCTAssertEqual(response.modelInfo.getProperty(family: "qwen3moe", property: "rope.freqBase"), 1000000)
            
            // Test tokenizer fields
            XCTAssertEqual(response.modelInfo.tokenizerGGMLBosTokenID, 151643)
            XCTAssertEqual(response.modelInfo.tokenizerGGMLEosTokenID, 151645)
            XCTAssertEqual(response.modelInfo.tokenizerGGMLModel, "gpt2")
            XCTAssertEqual(response.modelInfo.tokenizerGGMLPre, "qwen2")
            XCTAssertNil(response.modelInfo.tokenizerGGMLMerges)
            XCTAssertNil(response.modelInfo.tokenizerGGMLTokenType)
            XCTAssertNil(response.modelInfo.tokenizerGGMLTokens)
            
            // Note: Qwen3Moe-specific fields like qwen3moe.attention.head_count,
            // qwen3moe.block_count, etc. are tested above using getProperty() method
            // to ensure the structure can handle them when fully implemented.
            
        } catch {
            XCTFail("Failed to decode JSON: \(error)")
        }
    }
    

    
    func testCopyModelSuccess() async throws {
        
    }
    
    func testCopyModelFailure() async throws {
        
    }
    
    func testDeleteModelSuccess() async throws {
        
    }
    
    func testDeleteModelFailure() async throws {
        
    }
    
    func testEmbeddingsFailure() async throws {
        
    }
    
    func testChatResponseSuccess() async throws {
        let jsonString = """
        {
            "model": "deepseek-r1",
            "created_at": "2025-05-29T09:35:56.836222Z",
            "message": {
                "role": "assistant",
                "content": "The word \\"strawberry\\" contains **three** instances of the letter 'R' ...",
                "thinking": "First, the question is: \\"how many r in the word  strawberry?\\" I need to count the number of times the letter 'r' appears in the word \\"strawberry\\". Let me write down the word:..."
            },
            "done": true,
            "done_reason": "stop",
            "total_duration": 47975065417,
            "load_duration": 29758167,
            "prompt_eval_count": 10,
            "prompt_eval_duration": 174191542,
            "eval_count": 2514,
            "eval_duration": 47770692833
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to data")
            return
        }
        
        do {
            let response = try JSONDecoder.default.decode(OKChatResponse.self, from: jsonData)
            
            // Test basic fields
            XCTAssertEqual(response.model, "deepseek-r1")
            
            // Test createdAt field
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let expectedDate = dateFormatter.date(from: "2025-05-29T09:35:56.836222Z")
            XCTAssertEqual(response.createdAt, expectedDate)
            
            // Test message field
            XCTAssertNotNil(response.message)
            let message = response.message!
            XCTAssertEqual(message.role, .assistant)
            XCTAssertEqual(message.content, "The word \"strawberry\" contains **three** instances of the letter 'R' ...")
            XCTAssertEqual(message.thinking, "First, the question is: \"how many r in the word  strawberry?\" I need to count the number of times the letter 'r' appears in the word \"strawberry\". Let me write down the word:...")
            
            // Test top-level fields
            XCTAssertTrue(response.done)
            XCTAssertEqual(response.doneReason, "stop")
            XCTAssertEqual(response.totalDuration, 47975065417)
            XCTAssertEqual(response.loadDuration, 29758167)
            XCTAssertEqual(response.promptEvalCount, 10)
            XCTAssertEqual(response.promptEvalDuration, 174191542)
            XCTAssertEqual(response.evalCount, 2514)
            XCTAssertEqual(response.evalDuration, 47770692833)
            
        } catch {
            XCTFail("Failed to decode JSON: \(error)")
        }
    }
    
    func testChatResponseWithToolCalls() async throws {
        let jsonString = """
        {
            "model": "llama4-tools",
            "created_at": "2025-05-29T10:00:00.000000Z",
            "message": {
                "role": "assistant",
                "content": "I'll help you with that calculation.",
                "tool_calls": [
                    {
                        "function": {
                            "name": "calculator",
                            "arguments": "{\\"operation\\": \\"add\\", \\"a\\": 5, \\"b\\": 3}"
                        }
                    }
                ]
            },
            "done": false
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to data")
            return
        }
        
        do {
            let response = try JSONDecoder.default.decode(OKChatResponse.self, from: jsonData)
            
            // Test basic fields
            XCTAssertEqual(response.model, "llama4-tools")
            XCTAssertFalse(response.done)
            
            // Test message with tool calls
            XCTAssertNotNil(response.message)
            let message = response.message!
            XCTAssertEqual(message.role, .assistant)
            XCTAssertEqual(message.content, "I'll help you with that calculation.")
            
            // Test tool calls
            XCTAssertNotNil(message.toolCalls)
            XCTAssertEqual(message.toolCalls?.count, 1)
            
            let toolCall = message.toolCalls![0]
            XCTAssertNotNil(toolCall.function)
            XCTAssertEqual(toolCall.function?.name, "calculator")
            XCTAssertNotNil(toolCall.function?.arguments)
            
        } catch {
            XCTFail("Failed to decode JSON: \(error)")
        }
    }
    
    func testChatResponseWithImages() async throws {
        let jsonString = """
        {
            "model": "llava-vision",
            "created_at": "2025-05-29T11:00:00.000000Z",
            "message": {
                "role": "assistant",
                "content": "I can see the image you've shared.",
                "images": ["base64_encoded_image_data_here"]
            },
            "done": true
        }
        """
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to data")
            return
        }
        
        do {
            let response = try JSONDecoder.default.decode(OKChatResponse.self, from: jsonData)
            
            // Test basic fields
            XCTAssertEqual(response.model, "llava-vision")
            XCTAssertTrue(response.done)
            
            // Test message with images
            XCTAssertNotNil(response.message)
            let message = response.message!
            XCTAssertEqual(message.role, .assistant)
            XCTAssertEqual(message.content, "I can see the image you've shared.")
            
            // Test images
            XCTAssertNotNil(message.images)
            XCTAssertEqual(message.images?.count, 1)
            XCTAssertEqual(message.images?[0], "base64_encoded_image_data_here")
            
        } catch {
            XCTFail("Failed to decode JSON: \(error)")
        }
    }
}

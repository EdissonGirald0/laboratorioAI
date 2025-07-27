const { NodeVM } = require('vm2');
const { BaseNode } = require('flowise-components');

class OllamaNode extends BaseNode {
    constructor() {
        super();
        this.label = 'Ollama';
        this.name = 'ollama';
        this.type = 'LLM';
        this.icon = 'ollama.png';
        this.category = 'Language Models';
        this.description = 'Use Ollama models for text generation and embeddings';
        this.inputs = [
            {
                label: 'Model',
                name: 'model',
                type: 'options',
                options: [
                    { label: 'Devstral 24B', value: 'devstral:24b' },
                    { label: 'Phi-4 Reasoning', value: 'phi4-reasoning' },
                    { label: 'CodeLlama', value: 'codellama' },
                    { label: 'Mistral', value: 'mistral' }
                ],
                default: 'mistral'
            },
            {
                label: 'Temperature',
                name: 'temperature',
                type: 'number',
                default: 0.7,
                optional: true
            },
            {
                label: 'Max Tokens',
                name: 'maxTokens',
                type: 'number',
                default: 2048,
                optional: true
            },
            {
                label: 'System Message',
                name: 'systemMessage',
                type: 'string',
                rows: 4,
                optional: true
            }
        ];
        this.outputs = [
            {
                label: 'Output',
                name: 'output',
                type: 'string'
            }
        ];
    }

    async init(nodeData, input, options) {
        const model = nodeData.inputs.model;
        const temperature = nodeData.inputs.temperature;
        const maxTokens = nodeData.inputs.maxTokens;
        const systemMessage = nodeData.inputs.systemMessage;

        try {
            const response = await fetch('http://ollama:11434/api/generate', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    model,
                    prompt: input,
                    system: systemMessage,
                    temperature,
                    max_tokens: maxTokens
                })
            });

            const data = await response.json();
            return data.response;
        } catch (error) {
            console.error('Error calling Ollama:', error);
            throw error;
        }
    }
}

module.exports = { nodeClass: OllamaNode };

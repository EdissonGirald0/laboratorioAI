import {
	IExecuteFunctions,
	INodeExecutionData,
	INodeType,
	INodeTypeDescription,
	NodeOperationError,
} from 'n8n-workflow';

export class Ollama implements INodeType {
	description: INodeTypeDescription = {
		displayName: 'Ollama',
		name: 'ollama',
		icon: 'file:ollama.svg',
		group: ['transform'],
		version: 1,
		subtitle: '={{$parameter["operation"]}}',
		description: 'Interact with Ollama API',
		defaults: {
			name: 'Ollama',
		},
		inputs: ['main'],
		outputs: ['main'],
		credentials: [
			{
				name: 'ollamaApi',
				required: true,
			},
		],
		properties: [
			{
				displayName: 'Operation',
				name: 'operation',
				type: 'options',
				options: [
					{
						name: 'Generate',
						value: 'generate',
						description: 'Generate text with a model',
					},
					{
						name: 'Create Embedding',
						value: 'embed',
						description: 'Create embeddings from text',
					},
				],
				default: 'generate',
				noDataExpression: true,
			},
			{
				displayName: 'Model',
				name: 'model',
				type: 'options',
				options: [
					{
						name: 'Devstral 24B',
						value: 'devstral:24b',
					},
					{
						name: 'Phi-4 Reasoning',
						value: 'phi4-reasoning',
					},
					{
						name: 'CodeLlama',
						value: 'codellama',
					},
					{
						name: 'Mistral',
						value: 'mistral',
					},
				],
				default: 'mistral',
				description: 'Model to use',
			},
			{
				displayName: 'Text',
				name: 'text',
				type: 'string',
				default: '',
				required: true,
				description: 'Text to process',
			},
			{
				displayName: 'Additional Fields',
				name: 'additionalFields',
				type: 'collection',
				placeholder: 'Add Field',
				default: {},
				options: [
					{
						displayName: 'Temperature',
						name: 'temperature',
						type: 'number',
						typeOptions: {
							minValue: 0,
							maxValue: 2,
						},
						default: 0.7,
						description: 'Sampling temperature to use',
					},
					{
						displayName: 'Max Tokens',
						name: 'maxTokens',
						type: 'number',
						typeOptions: {
							minValue: 1,
						},
						default: 2048,
						description: 'Maximum number of tokens to generate',
					},
					{
						displayName: 'System Message',
						name: 'system',
						type: 'string',
						default: '',
						description: 'System message to condition the model',
					},
				],
			},
		],
	};

	async execute(this: IExecuteFunctions): Promise<INodeExecutionData[][]> {
		const items = this.getInputData();
		const returnData: INodeExecutionData[] = [];

		const credentials = await this.getCredentials('ollamaApi');
		const operation = this.getNodeParameter('operation', 0) as string;
		const model = this.getNodeParameter('model', 0) as string;

		for (let i = 0; i < items.length; i++) {
			try {
				const text = this.getNodeParameter('text', i) as string;
				const additionalFields = this.getNodeParameter('additionalFields', i) as {
					temperature?: number;
					maxTokens?: number;
					system?: string;
				};

				let response;
				if (operation === 'generate') {
					response = await this.helpers.request({
						method: 'POST',
						url: `${credentials.apiUrl}/api/generate`,
						body: {
							model,
							prompt: text,
							temperature: additionalFields.temperature,
							max_tokens: additionalFields.maxTokens,
							system: additionalFields.system,
						},
						json: true,
					});
				} else if (operation === 'embed') {
					response = await this.helpers.request({
						method: 'POST',
						url: `${credentials.apiUrl}/api/embeddings`,
						body: {
							model: 'nomic-embed-text',
							prompt: text,
						},
						json: true,
					});
				}

				returnData.push({
					json: response,
				});
			} catch (error) {
				if (this.continueOnFail()) {
					returnData.push({
						json: {
							error: error.message,
						},
					});
					continue;
				}
				throw error;
			}
		}

		return [returnData];
	}
}

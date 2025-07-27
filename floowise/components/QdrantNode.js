const { BaseNode } = require('flowise-components');

class QdrantNode extends BaseNode {
    constructor() {
        super();
        this.label = 'Qdrant Store';
        this.name = 'qdrantStore';
        this.type = 'VectorStore';
        this.icon = 'qdrant.png';
        this.category = 'Vector Stores';
        this.description = 'Store and retrieve vectors using Qdrant';
        this.inputs = [
            {
                label: 'Collection Name',
                name: 'collection',
                type: 'string',
                required: true
            },
            {
                label: 'Embedding',
                name: 'embedding',
                type: 'vector',
                required: true
            },
            {
                label: 'Metadata',
                name: 'metadata',
                type: 'json',
                optional: true
            }
        ];
        this.outputs = [
            {
                label: 'Vector ID',
                name: 'vectorId',
                type: 'string'
            }
        ];
    }

    async init(nodeData, input, options) {
        const collection = nodeData.inputs.collection;
        const embedding = nodeData.inputs.embedding;
        const metadata = nodeData.inputs.metadata || {};

        try {
            // Verificar si la colección existe
            const collectionResponse = await fetch(`http://qdrant:6333/collections/${collection}`);
            if (!collectionResponse.ok) {
                // Crear colección si no existe
                await fetch(`http://qdrant:6333/collections/${collection}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        vectors: {
                            size: embedding.length,
                            distance: 'Cosine'
                        }
                    })
                });
            }

            // Insertar vector
            const response = await fetch(`http://qdrant:6333/collections/${collection}/points`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    points: [
                        {
                            vector: embedding,
                            payload: metadata
                        }
                    ]
                })
            });

            const data = await response.json();
            return data.result.id;
        } catch (error) {
            console.error('Error interacting with Qdrant:', error);
            throw error;
        }
    }
}

module.exports = { nodeClass: QdrantNode };

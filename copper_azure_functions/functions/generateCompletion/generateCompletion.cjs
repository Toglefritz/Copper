const { DefaultAzureCredential } = require("@azure/identity");
const { SecretClient } = require("@azure/keyvault-secrets");
const { OpenAIClient, AzureKeyCredential } = require("@azure/openai");

const keyVaultUrl = process.env.KEY_VAULT_URL;

module.exports = async function (context, req) {
    const prompt = req.body.prompt;
    if (!prompt) {
        context.res = {
            status: 400,
            body: "Please provide a prompt in the request body."
        };
        return;
    }

    let apiKey;
    if (process.env.AZURE_FUNCTIONS_ENVIRONMENT === 'Development') {
        // Use the local environment variable for the API key
        apiKey = process.env.AZURE-AI-KEY;
    } else {
        const credential = new DefaultAzureCredential();
        const client = new SecretClient(keyVaultUrl, credential);

        try {
            // Retrieve the OpenAI API key from Azure Key Vault
            const secret = await client.getSecret("AZURE-AI-KEY");
            apiKey = secret.value;
        } catch (error) {
            context.res = {
                status: 500,
                body: `Error retrieving API key: ${error.message}`
            };
            return;
        }
    }

    const openAIClient = new OpenAIClient(
        process.env.AZURE_OPENAI_ENDPOINT,
        new AzureKeyCredential(apiKey)
    );

    try {
        const result = await openAIClient.completions.create({
            model: "text-davinci-003",
            prompt: prompt,
            max_tokens: 100
        });

        context.res = {
            status: 200,
            body: result.choices[0].text
        };
    } catch (error) {
        context.res = {
            status: 500,
            body: `Error: ${error.message}`
        };
    }
};

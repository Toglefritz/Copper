const { CosmosClient } = require("@azure/cosmos");

// Initialize Cosmos DB client
const client = new CosmosClient(process.env.COSMOS_DB_CONNECTION_STRING);
const database = client.database(process.env.COSMOS_DB_DATABASE);
const container = database.container(process.env.COSMOS_DB_CONTAINER);

module.exports = { client, database, container };
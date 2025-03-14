const { container } = require("../middleware/cosmosClient.cjs");
const { getUserIdFromRequest } = require("../middleware/auth.cjs");

/**
 * Azure Function to retrieve all PCB design documents for a specific user from Cosmos DB.
 * 
 * This function is triggered via an HTTP GET request and does not require an `id` parameter.
 * Instead, it extracts the user ID from the authentication token and retrieves all documents
 * associated with that user from Cosmos DB.
 * 
 * @param {Object} context - The Azure Function execution context.
 * @param {Object} req - The HTTP request object.
 * @param {Object} req.headers - The request headers, including Authorization.
 * 
 * @returns {Object} - A JSON response containing an array of documents or an error message.
 * 
 * @throws {Object} - Returns an HTTP 401 error if authentication fails.
 * @throws {Object} - Returns an HTTP 500 error if there is an issue retrieving data.
 */
module.exports = async function (context, req) {
  try {
    // Extract user ID from the request
    const userId = getUserIdFromRequest(req);

    // Query Cosmos DB for all documents belonging to the authenticated user
    const querySpec = {
      query: "SELECT * FROM c WHERE c.userId = @userId",
      parameters: [{ name: "@userId", value: userId }]
    };

    const { resources } = await container.items.query(querySpec).fetchAll();

    context.res = {
      status: 200,
      body: resources
    };
  } catch (err) {
    context.res = {
      status: 500,
      body: "Internal Server Error: Unable to retrieve documents."
    };
  }
};
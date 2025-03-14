const { container } = require("../middleware/cosmosClient.cjs");
const { getUserIdFromRequest, authorizeUser } = require("../middleware/auth.cjs");

/**
 * Azure Function to retrieve a PCB design document from Cosmos DB.
 * 
 * This function is triggered via an HTTP GET request and requires an `id` 
 * query parameter to specify which document to retrieve. The function:
 * - Extracts and verifies the user's Bearer token from the Authorization header.
 * - Ensures the authenticated user owns the document before providing access.
 * - Retrieves the document from Cosmos DB if the user has access.
 * 
 * @param {Object} context - The Azure Function execution context.
 * @param {Object} req - The HTTP request object.
 * @param {Object} req.headers - The request headers, including Authorization.
 * @param {Object} req.query - The query parameters.
 * @param {string} req.query.id - The ID of the document to retrieve.
 * 
 * @returns {Object} - A JSON response containing the requested document or an error message.
 * 
 * @throws {Object} - Returns an HTTP 400 error if the `id` is missing.
 * @throws {Object} - Returns an HTTP 401 error if authentication fails.
 * @throws {Object} - Returns an HTTP 403 error if the user is unauthorized to access the document.
 * @throws {Object} - Returns an HTTP 404 error if the document does not exist.
 */
module.exports = async function (context, req) {
  try {
    // Extract user ID from request
    const userId = getUserIdFromRequest(req);

    // Get the document ID from query parameters
    const { id } = req.query;
    if (!id) {
      context.res = { status: 400, body: "id is required" };
      return;
    }

    // Retrieve the document from Cosmos DB
    const { resource } = await container.item(id, id).read();

    // Check if the document exists
    if (!resource) {
      context.res = { status: 404, body: "Item not found" };
      return;
    }

    // Ensure the authenticated user owns the document
    authorizeUser(req, resource);

    context.res = { status: 200, body: resource };
  } catch (err) {
    context.res = { status: err.message.includes("Unauthorized") ? 401 : 403, body: err.message };
  }
};
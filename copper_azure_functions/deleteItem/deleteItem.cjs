const { container } = require("../middleware/cosmosClient.cjs");
const { getUserIdFromRequest, authorizeUser } = require("../middleware/auth.cjs");

/**
 * Azure Function to delete a PCB design document from Cosmos DB.
 * 
 * This function is triggered via an HTTP DELETE request and requires an `id` 
 * query parameter to specify which document to delete. The function:
 * - Extracts and verifies the user's Bearer token from the Authorization header.
 * - Ensures the authenticated user owns the document before deletion.
 * - Deletes the document from Cosmos DB if the user has access.
 * 
 * @param {Object} context - The Azure Function execution context.
 * @param {Object} req - The HTTP request object.
 * @param {Object} req.headers - The request headers, including Authorization.
 * @param {Object} req.query - The query parameters.
 * @param {string} req.query.id - The ID of the document to delete.
 * 
 * @returns {Object} - A JSON response indicating success or failure.
 * 
 * @throws {Object} - Returns an HTTP 400 error if the `id` is missing.
 * @throws {Object} - Returns an HTTP 401 error if authentication fails.
 * @throws {Object} - Returns an HTTP 403 error if the user is unauthorized to delete the document.
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

    // Check if the document exists
    const { resource } = await container.item(id, id).read();
    if (!resource) {
      context.res = { status: 404, body: "Item not found" };
      return;
    }

    // Ensure the authenticated user owns the document
    authorizeUser(req, resource);

    // Delete the document from Cosmos DB
    await container.item(id, id).delete();

    // Return a success response
    context.res = { status: 200, body: "Item deleted successfully" };
  } catch (err) {
    context.res = { status: err.message.includes("Unauthorized") ? 401 : 403, body: err.message };
  }
};
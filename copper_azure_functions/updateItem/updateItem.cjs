const { container } = require("../middleware/cosmosClient.cjs");
const { getUserIdFromRequest, authorizeUser } = require("../middleware/auth.cjs");

/**
 * Azure Function to update a PCB design document in Cosmos DB.
 * 
 * This function is triggered via an HTTP PUT request and requires an `id` 
 * field in the request body to specify which document to update. The function:
 * - Extracts the user's identity from the Azure authentication headers.
 * - Ensures the authenticated user owns the document before making updates.
 * - Updates the document in Cosmos DB and appends an `updatedAt` timestamp.
 * 
 * @param {Object} context - The Azure Function execution context.
 * @param {Object} req - The HTTP request object.
 * @param {Object} req.headers - The request headers, including authentication details.
 * @param {Object} req.body - The JSON payload containing updated PCB design data.
 * @param {string} req.body.id - The ID of the document to update.
 * @param {Object} req.body.updateData - The updated fields for the PCB design.
 * 
 * @returns {Object} - A JSON response with the updated document or an error message.
 * 
 * @throws {Object} - Returns an HTTP 400 error if the `id` is missing.
 * @throws {Object} - Returns an HTTP 401 error if authentication fails.
 * @throws {Object} - Returns an HTTP 403 error if the user is unauthorized to update the document.
 * @throws {Object} - Returns an HTTP 404 error if the document does not exist.
 */
module.exports = async function (context, req) {
  try {
    // Extract the document ID and update data from the request body
    const { id, ...updateData } = req.body;
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

    // Merge the update data with the existing document
    const updatedItem = { ...resource, ...updateData, updatedAt: new Date().toISOString() };

    // Update the document in Cosmos DB
    await container.item(id, id).replace(updatedItem);

    context.res = { status: 200, body: updatedItem };
  } catch (err) {
    context.res = { status: err.message.includes("Unauthorized") ? 401 : 403, body: err.message };
  }
};
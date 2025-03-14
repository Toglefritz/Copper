/**
 * Middleware for authorization checks in Azure Functions.
 * 
 * Since Azure Functions handles authentication via the Microsoft identity provider, 
 * this middleware no longer verifies JWTs. Instead, it extracts the authenticated 
 * user's ID from the `x-ms-client-principal` header and ensures that the user 
 * requesting the operation owns the document they are interacting with.
 * 
 * This check applies to non-POST endpoints to prevent users from modifying or 
 * accessing documents that do not belong to them.
 */

/**
 * Extracts the authenticated user ID from the request headers.
 * @param {Object} req - The HTTP request object.
 * @returns {string|null} - The user ID if available, otherwise null.
 */
function getUserIdFromRequest(req) {
  // Azure Functions authentication provides user info in the `x-ms-client-principal` header
  const user = req.headers["x-ms-client-principal"];
  if (!user) {
    throw new Error("Unauthorized: Missing user authentication data.");
  }

  try {
    // Decode the base64-encoded user information
    const decodedUser = Buffer.from(user, "base64").toString("utf-8");
    const userData = JSON.parse(decodedUser);

    // Extract the user ID from the decoded data
    const userId = userData.userId ?? userData.user_id;

    // Return the user ID or null if not found
    return userId || null;
  } catch (err) {
    throw new Error("Error parsing authentication data.");
  }
}

/**
 * Ensures that the authenticated user is the owner of the requested document.
 * @param {Object} req - The HTTP request object.
 * @param {Object} document - The document retrieved from Cosmos DB.
 * @throws {Error} - Throws an error if the user is unauthorized.
 */
function authorizeUser(req, document) {
  const userId = getUserIdFromRequest(req);
  if (!userId) {
    throw new Error("Unauthorized: Unable to determine user identity.");
  }

  if (!document || document.userId !== userId) {
    throw new Error("Forbidden: You do not have access to this document.");
  }
}

module.exports = { getUserIdFromRequest, authorizeUser };

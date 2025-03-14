const { container } = require("../middleware/cosmosClient.cjs");
const { getUserIdFromRequest } = require("../middleware/auth.cjs");
const { v4: uuidv4 } = require("uuid");

/**
 * Azure Function to create a new PCB design document in Cosmos DB.
 * 
 * This function is triggered via an HTTP POST request and expects a JSON payload 
 * containing PCB design data. The function:
 * - Extracts the user's identity from the Azure authentication headers.
 * - Generates a unique ID for the new PCB document.
 * - Associates the document with the authenticated user.
 * - Stores the document in Cosmos DB.
 * 
 * @param {Object} context - The Azure Function execution context.
 * @param {Object} req - The HTTP request object.
 * @param {Object} req.headers - The request headers, including authentication details.
 * @param {Object} req.body - The JSON payload containing PCB design data.
 * @param {number} req.body.version - The version number of the PCB design.
 * @param {string} req.body.generator - The tool used to generate the PCB design.
 * @param {string} [req.body.generatorVersion] - The version of the generator (optional).
 * @param {Array} req.body.layers - List of PCB layers with properties like index, type, and purpose.
 * @param {Array} req.body.components - List of components with details such as name, layer, position, and pads.
 * 
 * @returns {Object} - A JSON response with the newly created document or an error message.
 * 
 * @throws {Object} - Returns an HTTP 400 error if required fields are missing.
 * @throws {Object} - Returns an HTTP 401 error if authentication fails.
 */

/**
 * This endpoint can be tested with the following example:
 * 
 * Endpoint: POST http://localhost:7071/createItem
 * Headers:
 * - Content-Type: application/json
 * - x-ms-client-principal: <base64-encoded-user-info>
 * Body:
 *  {
 *    "id": "261b8a6c-11bc-4ed2-b9b8-5970408566ae",
 *    "userId": "test-user-id",
 *    "createdAt": "2025-03-12T12:08:00.089Z",
 *    "version": 20241229,
 *    "generator": "pcbnew",
 *    "layers": [
 *   {
 *     "index": 0,
 *     "type": "fCu",
 *     "purpose": "signal"
 *   },
 *   {
 *     "index": 2,
 *     "type": "bCu",
 *     "purpose": "signal"
 *   }
 *   ],
 *     "components": [
 *       {
 *         "name": "WS2812B",
 *         "layer": "fCu",
 *         "position": {
 *           "x": 148.5011,
 *           "y": 107.1372
 *         },
 *         "reference": "U1",
 *         "value": "WS2812B"
 *       }
 *     ]
 *   }
 * 
 * The `x-ms-client-principal` header should contain a base64-encoded JSON 
 * string with user information, like this example:
 * 
 * {
 *    "auth_typ": "Bearer",
 *    "name": "Test User",
 *    "user_id": "test-user-id",
 *    "identity_provider": "AzureAD"
 * }
 */
module.exports = async function (context, req) {
  try {
    const userId = getUserIdFromRequest(req);

    if (!req.body || !req.body.version || !req.body.generator) {
      context.res = { status: 400, body: "Missing required fields: version, generator" };
      return;
    }

    const newItem = {
      id: uuidv4(), // Generate unique ID
      userId, // Associate with user
      createdAt: new Date().toISOString(),
      ...req.body, // Include provided PCB data
    };

    await container.items.create(newItem);

    context.res = { status: 201, body: newItem };
  } catch (err) {
    if (err.message.includes("Unauthorized")) {
      context.res = { status: 401, body: "Unauthorized: Invalid or missing authentication." };
    } else if (err.message.includes("Validation") || err.message.includes("Missing required fields")) {
      context.res = { status: 400, body: "Bad Request: Invalid request data." };
    } else {
      context.res = { status: 500, body: "Internal Server Error: An unexpected error occurred: " };
    }
  }
};
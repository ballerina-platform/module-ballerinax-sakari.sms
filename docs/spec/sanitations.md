_Author_:  @DimuthuMadushan \
_Created_: 2026/10/20 \
_Updated_: 2026/10/20 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Sakari SMS. 
The OpenAPI specification is obtained from [Sakari SMS API](https://github.com/wso2/api-specs/blob/main/openapi/sakari/sms/1.0.2/openapi.yaml).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.


1. Change the `url` property of the servers object
- **Original**: `https://api.sakari.io`
- **Updated**: `https://api.sakari.io/v1`
- **Reason**: Common prefix added to base URL to simplify endpoint paths.
<!-- auto-generated -->

2. Update the API Paths
- **Original**: Paths included common prefix `/v1` in each endpoint.
- **Updated**: Common prefix removed from endpoints as it is now in the base URL.
- **Reason**: Simplifies API paths and avoids duplication.
<!-- auto-generated -->

3. Bundle the vendor's multi-file specification into one self-contained file
- **Original**: The Sakari specification is split across a root file, [openapi.yaml](https://developer.sakari.io/api-reference/openapi.yaml), and 13 companion files that are referenced with relative `$ref`s: [accounts.yaml](https://developer.sakari.io/api-reference/accounts.yaml), [campaigns.yaml](https://developer.sakari.io/api-reference/campaigns.yaml), [common.yaml](https://developer.sakari.io/api-reference/common.yaml), [contacts.yaml](https://developer.sakari.io/api-reference/contacts.yaml), [customproperties.yaml](https://developer.sakari.io/api-reference/customproperties.yaml), [groups.yaml](https://developer.sakari.io/api-reference/groups.yaml), [integrations.yaml](https://developer.sakari.io/api-reference/integrations.yaml), [lists.yaml](https://developer.sakari.io/api-reference/lists.yaml), [meetings.yaml](https://developer.sakari.io/api-reference/meetings.yaml), [pricing.yaml](https://developer.sakari.io/api-reference/pricing.yaml), [senders.yaml](https://developer.sakari.io/api-reference/senders.yaml), [users.yaml](https://developer.sakari.io/api-reference/users.yaml) and [voice.yaml](https://developer.sakari.io/api-reference/voice.yaml).
- **Updated**: The files are bundled into a single `docs/spec/openapi.yaml` in which every `$ref` is local (`#/...`).
- **Reason**: The generation pipeline needs a self-contained specification.

4. Restrict the specification to the 49 SMS operations
- **Original**: The specification covers the whole Sakari API.
- **Updated**: Only the `messages`, `conversations`, `contacts`, `templates`, `campaigns`, `webhooks`, `tools`, `autoresponders`, `dripcampaigns`, `links` and `availablephonenumbers` tags are kept, plus `balance.fetch`. Components and global tags that nothing reachable references are removed. The dropped groups are accounts, billing, plans, topups, attributes, authentication (`/oauth2/token`), calls, forms, meetings, meeting events, pricing, workflows and workflow templates.
- **Reason**: The connector covers the SMS surface only.

5. Rewrite `info.description` as a short summary
- **Original**: The vendor's long description of the API.
- **Updated**: A one-paragraph plain-text summary of what the connector manages.
- **Reason**: It becomes the `Client` class documentation, which must be short and free of markup.

6. Fill missing descriptions and summaries
- **Original**: Many schemas, properties, parameters, request bodies and responses had no description, or a generic one.
- **Updated**: 779 descriptions and summaries are filled from `docs/spec/description-decisions.json` with `tooling/apply_descriptions.py`.
- **Reason**: Generated types and methods carry useful documentation.

7. Change the OpenAPI version
- **Original**: `openapi: 3.1.0`
- **Updated**: `openapi: 3.0.3`
- **Reason**: With 3.1.0 the flatten and align steps drop every `type`.

8. Make the OAuth2 token URL absolute
- **Original**: `tokenUrl: /oauth2/token`
- **Updated**: `tokenUrl: https://api.sakari.io/oauth2/token`
- **Reason**: A relative token URL leaves the generated client without a usable default token endpoint.

9. Remove the colliding `contactId` query parameter from `contacts.fetch`
- **Original**: `GET /v1/accounts/{accountId}/contacts/{contactId}` references the shared `contactId` query parameter and also declares a `contactId` path parameter.
- **Updated**: The shared query-parameter reference is removed; only the path parameter remains.
- **Reason**: The two parameters collide in the generated client ("undefined symbol 'contactId'").

10. Name the `{success: boolean}` responses `SuccessResponse`
- **Original**: Six responses (contact, template and campaign delete, and drip campaign delete, activate and deactivate) declare an inline `{success: boolean}` object.
- **Updated**: They reference the new `SuccessResponse` schema.
- **Reason**: Avoids generated `InlineResponse*` types.

11. Name the create-contact response `CreateContactResponse`
- **Original**: The `201` response of `contacts.create` is an inline `oneOf` of `ContactsResponse` and `ContactUploadResponse`.
- **Updated**: The `oneOf` is the new `CreateContactResponse` schema, which the response references.
- **Reason**: Avoids a generated `InlineResponse*` type.

12. Make operation summaries distinct
- **Original**: `accounts.autoresponders.fetch` is summarised "Fetch All Account Autoresponders" although it fetches one autoresponder, and `links.fetchSourceStatsById` reuses "Fetch link source by ID".
- **Updated**: "Fetch An Account Autoresponder" and "Fetch link source statistics by ID".
- **Reason**: Every operation needs its own summary, and the summary must match what the operation does.

13. Add the missing request bodies
- **Original**: `contacts.update`, `templates.update`, `campaigns.update`, `accounts.autoresponders.create` and `accounts.autoresponders.update` declare no request body.
- **Updated**: Required JSON request bodies referencing `Contact`, `Template`, `CampaignRequest`, `Autoresponder` and `Autoresponder` respectively.
- **Reason**: Without a body these methods cannot send any data.

14. Fix the response of `templates.create`
- **Original**: The `201` response references `TemplatesResponse` (a paginated list).
- **Updated**: It references `TemplateResponse`.
- **Reason**: The operation creates a single template.

15. Drop the body of the `204` response of `links.deleteById`
- **Original**: The `204` response declares a JSON `BasicResponse` body.
- **Updated**: The `204` response has no content.
- **Reason**: A `204` response never has a body.

16. Require `url` in the `webhooks.subscribe` body
- **Original**: The body requires `callbackUrl`, which is not a property.
- **Updated**: The body requires `url`, the property that is declared.
- **Reason**: The generated request type could not be satisfied.

17. Fix the drip campaign schemas
- **Original**: `DripCampaign` requires `group`, which only exists under `trigger`, and `DripCampaignExecutionsResponse.data` is a single execution.
- **Updated**: `group` is no longer required, and `data` is an array of `DripCampaignExecution`.
- **Reason**: The generated types did not match the payloads.

18. Rename the property `Group.phoneNumbers?`
- **Original**: The property is literally named `phoneNumbers?`.
- **Updated**: `phoneNumbers`
- **Reason**: The question mark made the generated field name invalid.

19. Correct wrong or truncated descriptions
- **Original**: The `url` path parameter of `webhooks.unsubscribe` is described as "Account to apply operations to", the `conversationId` path parameter of `conversations.fetch` as "ID of template to return", and the `messages.fetch` description ends at "Returns a single messag".
- **Updated**: "URL-encoded callback URL of the webhook subscription to remove", "ID of conversation to return" and "Returns a single message by its ID."
- **Reason**: The descriptions became the generated documentation.

20. Persisted operation and schema renames
- **Original**: operationIds such as `accounts.autoresponders.fetchAll` or `links.fetchSourceStatsById`, and schema names such as `AccountIdWebhooksBody`, `ToolsSharefileBody`, `Error` and `AccountBalance`.
- **Updated**: Camel-case operationIds (`listAutoresponders`, `getLinkSourceStats`, `migrateDripCampaignToWorkflow`, and so on) and the schema names `SubscribeWebhookRequest`, `ShareFileRequest`, `ApiError` and `Balance`, all recorded in `docs/spec/ai-mappings.json`.
- **Reason**: The original identifiers contain dots or are generic, and the mapping keeps them stable across regeneration.

21. Declare the required `User` and `Contact` fields in their own `allOf` member
- **Original**: `User` and `Contact` combine `Person` with an inline object through `allOf`, and list `required: [id, email, role]` (`User`) and `required: [id]` (`Contact`) at the schema level. `id` and `email` are defined only in `Person`.
- **Updated**: In the original specification, the `required` list moves into the inline `allOf` member, which also declares `id` (both schemas) and `email` (`User`) with their own descriptions.
- **Reason**: To make an inherited field required, the generator re-declares it in the record without a doc comment, which produced `undocumented field` warnings for `User.email`, `User.id` and `Contact.id`.

22. Add request models for contacts and autoresponders
- **Original**: The create and update requests for contacts and autoresponders, and `SendMessagesRequest.contacts`, use the `Contact` and `Autoresponder` response schemas, which require the read-only `id`.
- **Updated**: In the original specification, a new `ContactRequest` schema (`Person` plus `attributes`, with an optional `id` for referring to an existing contact) is used by `contacts.create` (JSON body), `contacts.update` and `SendMessagesRequest.contacts`. A new `AutoresponderRequest` schema (the `Autoresponder` fields without `id`) is used by `accounts.autoresponders.create` and `accounts.autoresponders.update`. `Contact` and `Autoresponder` are kept for responses.
- **Reason**: Callers had to send a placeholder `id` when creating or updating a record.

23. Make `Conversation.closed` and `Conversation.lastMessage` optional
- **Original**: `Conversation` lists `closed` and `lastMessage` as required.
- **Updated**: In the original specification, the `required` list is removed. `closed` stays a read-only `date-time` string.
- **Reason**: An open conversation has no close date, and a conversation is not guaranteed to have a last message.

24. Describe the `url` path parameter of `webhooks.unsubscribe` as a plain URL
- **Original**: `URL-encoded callback URL of the webhook subscription to remove`.
- **Updated**: In the original specification, `Callback URL of the webhook subscription to remove, as a plain URL. The connector URL-encodes it`.
- **Reason**: The generated client already URL-encodes the path parameter, so passing an encoded value encoded it twice.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --license docs/license.txt --client-methods remote
```

Note: The license year is hardcoded to 2024, change if necessary.

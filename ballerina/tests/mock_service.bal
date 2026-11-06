// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

listener http:Listener ep0 = new (9090);

final Updated & readonly mockUpdated = {at: "2026-01-15T10:30:00.000Z", 'by: {name: "Jane Doe", id: "usr_01HZX3"}};

final Contact & readonly mockContact = {
    id: "ctc_5f3a9c21",
    firstName: "Chris",
    lastName: "Thomson",
    email: "chris.thomson@example.com",
    mobile: {number: "+14155550123", country: "US", valid: true, lineType: "mobile"},
    created: mockUpdated
};

final Message & readonly mockMessage = {
    id: "msg_8c1d47e0",
    message: "Hi Chris, your order has shipped.",
    outgoing: true,
    'type: "SMS",
    status: "Delivered",
    segments: 1,
    created: mockUpdated
};

final Template & readonly mockTemplate = {
    id: "tpl_2b7e90a1",
    name: "Order shipped",
    template: "Hi {{{firstName}}}, your order has shipped.",
    'type: "SMS",
    created: mockUpdated
};

final Campaign & readonly mockCampaign = {
    id: "cmp_77d1f3b2",
    name: "Spring promotion",
    template: "Hi {{{firstName}}}, enjoy 20% off today only.",
    trigger: {code: "M", name: "Manual"}
};

final Conversation & readonly mockConversation = {
    id: "cnv_90ab12cd",
    closed: "2026-01-16T09:00:00.000Z",
    lastMessage: mockMessage,
    contact: mockContact
};

final Webhook & readonly mockWebhook = {
    id: "whk_41c8d6f5",
    destination: "https://example.com/sakari/callback",
    eventTypes: ["message-received", "message-status"]
};

final Autoresponder & readonly mockAutoresponder = {
    id: "atr_1e5f7a90",
    'match: "STOP",
    response: "You have been unsubscribed.",
    scheduleType: "in office"
};

final Pagination & readonly mockPagination = {offset: 0, 'limit: 20, hasNext: false};

@http:ServiceConfig {treatNilableAsOptional: true}
service / on ep0 {
    # Deletes a contact
    #
    # + accountId - Account to apply operations to
    # + contactId - Contact id to delete
    # + return - Confirmation that the contact was deleted
    resource function delete accounts/[string accountId]/contacts/[string contactId]() returns SuccessResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true};
    }

    # Deletes a template
    #
    # + accountId - Account to apply operations to
    # + templateId - Template id to delete
    # + return - Confirmation that the template was deleted
    resource function delete accounts/[string accountId]/templates/[string templateId]() returns SuccessResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true};
    }

    # Unsubscribe to message events
    #
    # + accountId - Account to apply operations to
    # + url - URL-encoded callback URL of the webhook subscription to remove
    # + return - The webhook subscription was deleted
    resource function delete accounts/[string accountId]/webhooks/[string url]() returns http:NoContent {
        return http:NO_CONTENT;
    }

    # Fetch All Account Autoresponders
    #
    # + accountId - Account to apply operations to
    # + return - The account's autoresponders
    resource function get accounts/[string accountId]/autoresponders() returns AutorespondersResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, pagination: mockPagination, data: [mockAutoresponder]};
    }

    # Fetch account balance
    #
    # + accountId - Account to apply operations to
    # + return - The account balance
    resource function get accounts/[string accountId]/balance() returns BalanceResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, data: {country: "US", balance: 125.50, segmentPrice: 0.0075, segments: 16733}};
    }

    # Fetch campaigns
    #
    # + accountId - Account to apply operations to
    # + offset - Results to skip when paginating through a result set
    # + 'limit - Maximum number of results to return
    # + name - Filter by name or part of
    # + return - The account's campaigns
    resource function get accounts/[string accountId]/campaigns(int? offset, int? 'limit, string? name) returns CampaignsResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, pagination: mockPagination, data: [mockCampaign]};
    }

    # Fetch campaign by ID
    #
    # + accountId - Account to apply operations to
    # + campaignId - ID of campaign to return
    # + return - The requested campaign
    resource function get accounts/[string accountId]/campaigns/[string campaignId]() returns CampaignResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, data: mockCampaign};
    }

    # Fetch contacts
    #
    # + accountId - Account to apply operations to
    # + offset - Results to skip when paginating through a result set
    # + 'limit - Maximum number of results to return
    # + firstName - Filter by first name
    # + lastName - Filter by last name
    # + mobile - Filter by mobile number
    # + email - Filter by email address
    # + tags - Filter by tags
    # + return - The account's contacts
    resource function get accounts/[string accountId]/contacts(int? offset, int? 'limit, string? firstName, string? lastName, string? mobile, string? email, string? tags) returns ContactsResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, pagination: mockPagination, data: [mockContact]};
    }

    # Fetch contact by ID
    #
    # + accountId - Account to apply operations to
    # + contactId - ID of contact to return
    # + return - The requested contact
    resource function get accounts/[string accountId]/contacts/[string contactId]() returns ContactResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, data: mockContact};
    }

    # Fetch conversations
    #
    # + accountId - Account to apply operations to
    # + offset - Results to skip when paginating through a result set
    # + 'limit - Maximum number of results to return
    # + return - The account's conversations
    resource function get accounts/[string accountId]/conversations(int? offset, int? 'limit) returns ConversationsResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, pagination: mockPagination, data: [mockConversation]};
    }

    # Fetch conversation by ID
    #
    # + accountId - Account to apply operations to
    # + conversationId - ID of conversation to return
    # + return - The requested conversation
    resource function get accounts/[string accountId]/conversations/[string conversationId]() returns ConversationResponse {
        return {success: true, data: mockConversation};
    }

    # Fetch Account Drip Campaigns
    #
    # + accountId - Account to apply operations to
    # + offset - Results to skip when paginating through a result set
    # + 'limit - Maximum number of results to return
    # + return - The account's drip campaigns
    resource function get accounts/[string accountId]/dripcampaigns(int? offset, int? 'limit) returns DripCampaignsResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        DripCampaign dripCampaign = {
            id: "drp_3a6b8c10",
            name: "Welcome series",
            active: true,
            trigger: {'type: "contact-created", delay: {days: 0, hours: 0, minutes: 5}},
            messages: [{id: "dmg_01", message: "Welcome aboard!", delay: {days: 0, hours: 0, minutes: 5}}]
        };
        return {success: true, pagination: mockPagination, data: [dripCampaign]};
    }

    # Fetch messages
    #
    # + accountId - Account to apply operations to
    # + offset - Results to skip when paginating through a result set
    # + 'limit - Maximum number of results to return
    # + contactId - Filter by contact
    # + conversationId - Filter by conversation
    # + return - The account's messages
    resource function get accounts/[string accountId]/messages(int? offset, int? 'limit, string? contactId, string? conversationId) returns MessagesResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, pagination: mockPagination, data: [mockMessage]};
    }

    # Fetch message by id
    #
    # + accountId - Account to apply operations to
    # + messageId - ID of message to return
    # + return - The requested message
    resource function get accounts/[string accountId]/messages/[string messageId]() returns MessageResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, data: mockMessage};
    }

    # Fetch templates
    #
    # + accountId - Account to apply operations to
    # + offset - Results to skip when paginating through a result set
    # + 'limit - Maximum number of results to return
    # + name - Filter by name or part of
    # + return - The account's templates
    resource function get accounts/[string accountId]/templates(int? offset, int? 'limit, string? name) returns TemplatesResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, pagination: mockPagination, data: [mockTemplate]};
    }

    # Fetch template by ID
    #
    # + accountId - Account to apply operations to
    # + templateId - ID of template to return
    # + return - The requested template
    resource function get accounts/[string accountId]/templates/[string templateId]() returns TemplateResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, data: mockTemplate};
    }

    # Fetch active webhooks
    #
    # + accountId - Account to apply operations to
    # + return - The account's webhook subscriptions
    resource function get accounts/[string accountId]/webhooks() returns WebhooksResponse {
        return {success: true, pagination: mockPagination, data: [mockWebhook]};
    }

    # Create an Autoresponder
    #
    # + accountId - Account to apply operations to
    # + payload - Autoresponder to create
    # + return - The created autoresponder
    resource function post accounts/[string accountId]/autoresponders(@http:Payload AutoresponderRequest payload) returns AutoresponderResponseOk|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        map<anydata> fields = {...payload};
        fields["id"] = "atr_1e5f7a90";
        Autoresponder created = checkpanic fields.cloneWithType();
        return {body: {success: true, data: created}};
    }

    # Create campaign
    #
    # + accountId - Account to apply operations to
    # + payload - Campaign to create
    # + return - The created campaign
    resource function post accounts/[string accountId]/campaigns(@http:Payload CampaignRequest payload) returns CampaignResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {success: true, data: mockCampaign};
    }

    # Create contact
    #
    # + accountId - Account to apply operations to
    # + mergeStrategy - Determines how existing contacts with matching mobile numbers are treated
    # + payload - Contact to create, or a CSV file of contacts to upload
    # + return - The created contacts, or a summary of the uploaded contacts
    resource function post accounts/[string accountId]/contacts("append"|"core"|"remove"? mergeStrategy, @http:Payload ContactRequest|string payload) returns CreateContactResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        ContactsResponse response = {success: true, pagination: mockPagination, data: [mockContact]};
        return response;
    }

    # Send Messages
    #
    # + accountId - Account to apply operations to
    # + payload - Messages to send
    # + return - Summary of the send request
    resource function post accounts/[string accountId]/messages(@http:Payload SendMessagesRequest payload) returns SendMessagesResponseOk|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        return {body: {success: true, data: {valid: 1, requested: 1, jobId: "job_6d2e41", estimatedPrice: 0.0075, messages: [mockMessage]}}};
    }

    # Create template
    #
    # + accountId - Account to apply operations to
    # + payload - Template to create
    # + return - The created template
    resource function post accounts/[string accountId]/templates(@http:Payload Template payload) returns TemplateResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        Template created = {...payload};
        created.id = "tpl_2b7e90a1";
        return {success: true, data: created};
    }

    # Subscribe to message events
    #
    # + accountId - Account to apply operations to
    # + payload - Callback URL and the event types to subscribe to
    # + return - The created webhook subscription
    resource function post accounts/[string accountId]/webhooks(@http:Payload SubscribeWebhookRequest payload) returns WebhookResponseOk {
        Webhook created = {id: "whk_41c8d6f5", destination: payload.url, eventTypes: mockWebhook.eventTypes.clone()};
        return {body: {success: true, data: created}};
    }

    # Updates a contact
    #
    # + accountId - Account to apply operations to
    # + contactId - ID of contact
    # + payload - Contact fields to update
    # + return - The updated contact
    resource function put accounts/[string accountId]/contacts/[string contactId](@http:Payload ContactRequest payload) returns ContactResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        map<anydata> fields = {...payload};
        fields["id"] = contactId;
        Contact updated = checkpanic fields.cloneWithType();
        return {success: true, data: updated};
    }

    # Updates a template
    #
    # + accountId - Account to apply operations to
    # + templateId - ID of template
    # + payload - Template fields to update
    # + return - The updated template
    resource function put accounts/[string accountId]/templates/[string templateId](@http:Payload Template payload) returns TemplateResponse|ErrorResponseBadRequest|ErrorResponseInternalServerError {
        Template updated = {...payload};
        updated.id = templateId;
        return {success: true, data: updated};
    }
}

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type AutoresponderResponseOk record {|
    *http:Ok;
    AutoresponderResponse body;
|};

public type ErrorResponseBadRequest record {|
    *http:BadRequest;
    ErrorResponse body;
|};

public type ErrorResponseInternalServerError record {|
    *http:InternalServerError;
    ErrorResponse body;
|};

public type SendMessagesResponseOk record {|
    *http:Ok;
    SendMessagesResponse body;
|};

public type WebhookResponseOk record {|
    *http:Ok;
    WebhookResponse body;
|};

# Response envelope returned when a request fails
public type ErrorResponse record {
    *BasicResponse;
    # An error reported by the API, with a code and a human-readable description
    ApiError 'error;
};


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
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.sakari.io/v1" : "http://localhost:9090";
final string tokenUrl = isLiveServer ? "https://api.sakari.io/oauth2/token" : "http://localhost:9444/oauth2/token";
final string clientId = isLiveServer ? os:getEnv("SAKARI_CLIENT_ID") : "mock-client-id";
final string clientSecret = isLiveServer ? os:getEnv("SAKARI_CLIENT_SECRET") : "mock-client-secret";
final string accountId = isLiveServer ? os:getEnv("SAKARI_ACCOUNT_ID") : "acc_123456";

isolated Client? cachedClient = ();

// The client-credentials grant fetches a token while the client is built, so the client is
// built lazily, after the token service has started.
isolated function getClient() returns Client|error {
    lock {
        Client? existing = cachedClient;
        if existing is Client {
            return existing;
        }
        Client created = check new ({
            auth: {clientId, clientSecret, tokenUrl},
            httpVersion: isLiveServer ? http:HTTP_2_0 : http:HTTP_1_1
        }, serviceUrl);
        cachedClient = created;
        return created;
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetBalance() returns error? {
    Client sakari = check getClient();
    BalanceResponse response = check sakari->getBalance(accountId);
    test:assertTrue(response.success);
    test:assertTrue(response?.data !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListContacts() returns error? {
    Client sakari = check getClient();
    ContactsResponse response = check sakari->listContacts(accountId);
    test:assertTrue(response.success);
    test:assertTrue(response.data.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetContact() returns error? {
    Client sakari = check getClient();
    ContactsResponse contacts = check sakari->listContacts(accountId);
    ContactResponse response = check sakari->getContact(accountId, contacts.data[0].id);
    test:assertEquals(response.data.id, contacts.data[0].id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateContact() returns error? {
    if isLiveServer {
        return;
    }
    Client sakari = check getClient();
    CreateContactResponse response = check sakari->createContact(accountId, {
        firstName: "Chris",
        lastName: "Thomson",
        mobile: {number: "+14155550123", country: "US"}
    });
    test:assertTrue(response is ContactsResponse);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateContact() returns error? {
    if isLiveServer {
        return;
    }
    Client sakari = check getClient();
    ContactResponse response = check sakari->updateContact(accountId, "ctc_5f3a9c21", {firstName: "Bob"});
    test:assertEquals(response.data.firstName, "Bob");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteContact() returns error? {
    if isLiveServer {
        return;
    }
    Client sakari = check getClient();
    CreateContactResponse created = check sakari->createContact(accountId, {
        firstName: "Temp",
        mobile: {number: "+14155550199", country: "US"}
    });
    if created is ContactsResponse {
        SuccessResponse response = check sakari->deleteContact(accountId, created.data[0].id);
        test:assertEquals(response.success, true);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListMessages() returns error? {
    Client sakari = check getClient();
    MessagesResponse response = check sakari->listMessages(accountId);
    test:assertTrue(response.data.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetMessage() returns error? {
    Client sakari = check getClient();
    MessagesResponse messages = check sakari->listMessages(accountId);
    MessageResponse response = check sakari->getMessage(accountId, messages.data[0].id);
    test:assertEquals(response.data.id, messages.data[0].id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testSendMessages() returns error? {
    if isLiveServer {
        return;
    }
    Client sakari = check getClient();
    SendMessagesResponse response = check sakari->sendMessages(accountId, {
        template: "Hi {{{firstName}}}, your order has shipped.",
        contacts: [{id: "ctc_5f3a9c21"}]
    });
    test:assertTrue(response.success);
    test:assertEquals(response.data.requested, 1);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListTemplates() returns error? {
    Client sakari = check getClient();
    TemplatesResponse response = check sakari->listTemplates(accountId);
    test:assertTrue(response.data.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetTemplate() returns error? {
    Client sakari = check getClient();
    TemplatesResponse templates = check sakari->listTemplates(accountId);
    TemplateResponse response = check sakari->getTemplate(accountId, <string>templates.data[0].id);
    test:assertEquals(response.data.id, templates.data[0].id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateTemplate() returns error? {
    if isLiveServer {
        return;
    }
    Client sakari = check getClient();
    TemplateResponse response = check sakari->createTemplate(accountId, {name: "Order shipped", template: "Your order has shipped.", 'type: "SMS"});
    test:assertEquals(response.data?.name, "Order shipped");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateTemplate() returns error? {
    if isLiveServer {
        return;
    }
    Client sakari = check getClient();
    TemplateResponse response = check sakari->updateTemplate(accountId, "tpl_2b7e90a1", {name: "Order delivered"});
    test:assertEquals(response.data?.name, "Order delivered");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteTemplate() returns error? {
    if isLiveServer {
        return;
    }
    Client sakari = check getClient();
    TemplateResponse created = check sakari->createTemplate(accountId, {name: "Temporary", template: "Temporary template", 'type: "SMS"});
    SuccessResponse response = check sakari->deleteTemplate(accountId, <string>created.data?.id);
    test:assertEquals(response.success, true);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListCampaigns() returns error? {
    Client sakari = check getClient();
    CampaignsResponse response = check sakari->listCampaigns(accountId);
    test:assertTrue(response.data.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetCampaign() returns error? {
    Client sakari = check getClient();
    CampaignsResponse campaigns = check sakari->listCampaigns(accountId);
    CampaignResponse response = check sakari->getCampaign(accountId, campaigns.data[0].id);
    test:assertEquals(response.data.id, campaigns.data[0].id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateCampaign() returns error? {
    if isLiveServer {
        return;
    }
    Client sakari = check getClient();
    CampaignResponse response = check sakari->createCampaign(accountId, {
        template: "Hi {{{firstName}}}, enjoy 20% off today only.",
        trigger: {code: "M"}
    });
    test:assertTrue(response.success);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListConversations() returns error? {
    Client sakari = check getClient();
    ConversationsResponse response = check sakari->listConversations(accountId);
    test:assertTrue(response.data.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetConversation() returns error? {
    Client sakari = check getClient();
    ConversationsResponse conversations = check sakari->listConversations(accountId);
    ConversationResponse response = check sakari->getConversation(accountId, <string>conversations.data[0].id);
    test:assertTrue(response.success);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListWebhooks() returns error? {
    Client sakari = check getClient();
    WebhooksResponse response = check sakari->listWebhooks(accountId);
    test:assertTrue(response.success);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testSubscribeWebhook() returns error? {
    if isLiveServer {
        return;
    }
    Client sakari = check getClient();
    WebhookResponse response = check sakari->subscribeWebhook(accountId, {
        url: "https://example.com/sakari/callback",
        eventTypes: ["message-received"]
    });
    test:assertEquals(response.data.destination, "https://example.com/sakari/callback");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUnsubscribeWebhook() returns error? {
    if isLiveServer {
        return;
    }
    Client sakari = check getClient();
    check sakari->unsubscribeWebhook(accountId, "https://example.com/sakari/callback");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListAutoresponders() returns error? {
    Client sakari = check getClient();
    AutorespondersResponse response = check sakari->listAutoresponders(accountId);
    test:assertTrue(response.success);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateAutoresponder() returns error? {
    if isLiveServer {
        return;
    }
    Client sakari = check getClient();
    AutoresponderResponse response = check sakari->createAutoresponder(accountId, {
        'match: "STOP",
        response: "You have been unsubscribed."
    });
    test:assertTrue(response.success);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListDripCampaigns() returns error? {
    Client sakari = check getClient();
    DripCampaignsResponse response = check sakari->listDripCampaigns(accountId);
    test:assertTrue(response.success);
}

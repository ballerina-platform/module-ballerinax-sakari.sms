// Reviews the account balance and the most recent messages of each open conversation.

import ballerina/io;
import ballerinax/sakari.sms;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string accountId = ?;
configurable int maxConversations = 10;

public function main() returns error? {
    sms:Client sakari = check new ({auth: {clientId, clientSecret}});

    // Step 1: Check the remaining balance.
    sms:BalanceResponse balance = check sakari->getBalance(accountId);
    sms:Balance? funds = balance?.data;
    if funds is () {
        return error("The balance was not returned.");
    }
    io:println("Balance: ", funds.balance, " (", funds.country, ")");

    // Step 2: Collect conversations, following the pagination until the limit is reached.
    sms:Conversation[] conversations = [];
    int offset = 0;
    boolean hasNext = true;
    while hasNext && conversations.length() < maxConversations {
        sms:ConversationsResponse page = check sakari->listConversations(accountId, offset = offset, 'limit = 50);
        sms:Conversation[] more = page.data;
        foreach sms:Conversation conversation in more {
            if conversations.length() < maxConversations {
                conversations.push(conversation);
            }
        }
        hasNext = page.pagination.hasNext && more.length() > 0;
        offset += more.length();
    }

    // Step 3: Print the latest messages of each conversation.
    foreach sms:Conversation conversation in conversations {
        string? conversationId = conversation.id;
        if conversationId is () {
            continue;
        }
        sms:MessagesResponse messages = check sakari->listMessages(accountId, conversationId = conversationId, 'limit = 5);
        io:println("Conversation ", conversationId, ": ", messages.data.length(), " recent message(s)");
        foreach sms:Message message in messages.data {
            io:println("  ", message.outgoing is true ? "sent" : "received", ": ", message.message ?: "");
        }
    }
}

// Adds a new customer to the address book, saves a welcome template and, when enabled, sends the welcome text.

import ballerina/io;
import ballerinax/sakari.sms;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string accountId = ?;
configurable string firstName = ?;
configurable string mobileNumber = ?;
configurable string mobileCountry = ?;
configurable boolean sendMessage = false;

public function main() returns error? {
    sms:Client sakari = check new ({auth: {clientId, clientSecret}});

    // Step 1: Add the customer to the address book, merging with an existing contact if present.
    sms:CreateContactResponse created = check sakari->createContact(accountId, {
        firstName,
        mobile: {number: mobileNumber, country: mobileCountry}
    }, mergeStrategy = "append");
    if created !is sms:ContactsResponse || created.data.length() == 0 {
        return error("The contact was not created.");
    }
    sms:Contact contact = created.data[0];
    io:println("Contact ready: ", contact.id);

    // Step 2: Save the welcome message as a reusable template.
    string welcomeText = "Hi {{{firstName}}}, welcome aboard! Reply STOP to opt out.";
    sms:TemplateResponse template = check sakari->createTemplate(accountId, {
        name: "Welcome message",
        template: welcomeText,
        'type: "SMS"
    });
    io:println("Template saved: ", template.data.id);

    // Step 3: Send the welcome message. Sending is off unless explicitly enabled.
    if !sendMessage {
        io:println("Skipping the send. Set sendMessage = true in Config.toml to send the message.");
        return;
    }
    sms:SendMessagesResponse sent = check sakari->sendMessages(accountId, {
        template: welcomeText,
        contacts: [{id: contact.id}]
    });
    io:println("Messages requested: ", sent.data.requested, ", job: ", sent.data.jobId);
}

## Overview

Sakari is a business messaging platform for sending and tracking SMS and MMS at scale. This connector lets you manage the contacts, messages, conversations, templates, campaigns, drip campaigns, autoresponders, tracked links and webhooks of a Sakari account from Ballerina. It supports version 1 of the Sakari REST API and authenticates with the OAuth 2.0 client-credentials grant.

### Key features

- Create, update and delete contacts, or upload many at once
- Send SMS and MMS messages and track their delivery status
- Read conversations and the messages inside them
- Manage message templates, campaigns, drip campaigns and autoresponders
- Subscribe to message and contact events through webhooks

## Setup guide

To use the Sakari SMS connector you need a Sakari account and API credentials.

1. Sign in to your [Sakari](https://sakari.io) account.

2. Open the API settings of your account and create API credentials. Note the client ID and the client secret.

3. Note the ID of the account the connector will work with. Every operation takes it as the `accountId` argument.

4. Keep the credentials out of the source code, for example in a `Config.toml` file.

## Quickstart

To use the `sakari.sms` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerinax/sakari.sms;
```

### Step 2: Create a `Config.toml` file

```toml
clientId = "<client id>"
clientSecret = "<client secret>"
accountId = "<account id>"
```

### Step 3: Create a new client

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string accountId = ?;

sms:Client sakari = check new ({auth: {clientId, clientSecret}});
```

### Step 4: Invoke the connector operation

```ballerina
public function main() returns error? {
    sms:BalanceResponse _ = check sakari->getBalance(accountId);
}
```

## Examples

The `Sakari SMS` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-sakari.sms/tree/main/examples/), covering the following use cases:

1. [Welcome message campaign](../examples/welcome_message_campaign/welcome_message_campaign.md) - Add a customer, save a welcome template and optionally send the welcome text.
2. [Inbox activity review](../examples/inbox_activity_review/inbox_activity_review.md) - Check the balance and review the latest messages of recent conversations.

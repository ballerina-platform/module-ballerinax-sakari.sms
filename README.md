# Ballerina Sakari SMS connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-sakari.sms/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-sakari.sms/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-sakari.sms.svg)](https://github.com/ballerina-platform/module-ballerinax-sakari.sms/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/sakari.sms.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fsakari.sms)

## Overview

Sakari is a business messaging platform for sending and tracking SMS and MMS at scale. This connector lets you manage the contacts, messages, conversations, templates, campaigns, drip campaigns, autoresponders, tracked links and webhooks of a Sakari account from Ballerina. It supports version 1 of the Sakari REST API and authenticates with the OAuth 2.0 client-credentials grant.

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

1. [Welcome message campaign](examples/welcome_message_campaign/welcome_message_campaign.md) - Add a customer, save a welcome template and optionally send the welcome text.
2. [Inbox activity review](examples/inbox_activity_review/inbox_activity_review.md) - Check the balance and review the latest messages of recent conversations.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`sakari.sms` package](https://central.ballerina.io/ballerinax/sakari.sms/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.

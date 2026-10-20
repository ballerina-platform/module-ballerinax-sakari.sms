# Examples

The `ballerinax/sakari.sms` connector provides practical examples illustrating usage in various scenarios.

1. [Welcome message campaign](./welcome_message_campaign/welcome_message_campaign.md) - Add a customer, save a welcome template and optionally send the welcome text.
2. [Inbox activity review](./inbox_activity_review/inbox_activity_review.md) - Check the balance and review the latest messages of recent conversations.

## Prerequisites

- A Sakari account with API credentials (client ID and client secret) and its account ID.
- Ballerina Swan Lake 2201.12.0 or later.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```

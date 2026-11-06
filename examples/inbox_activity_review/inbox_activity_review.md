# Inbox activity review

This example checks the account balance, collects the most recent conversations by following the pagination, and prints the latest messages of each conversation. It only reads data and changes nothing in the account.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A Sakari account with API credentials (client ID and client secret)
- Create a `Config.toml` in this directory:
  ```toml
  clientId = "<client id>"
  clientSecret = "<client secret>"
  accountId = "<account id>"
  maxConversations = 10
  ```

## Run the example

```bash
bal run
```

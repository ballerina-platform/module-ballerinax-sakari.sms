# Welcome message campaign

This example adds a new customer to the Sakari address book, saves a reusable welcome template, and optionally sends the welcome text to the customer. Sending is switched off by default so the example can be run safely.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A Sakari account with API credentials (client ID and client secret)
- Create a `Config.toml` in this directory:
  ```toml
  clientId = "<client id>"
  clientSecret = "<client secret>"
  accountId = "<account id>"
  firstName = "<customer first name>"
  mobileNumber = "<customer mobile number in international format>"
  mobileCountry = "<two-letter country code>"
  sendMessage = false
  ```

## Run the example

```bash
bal run
```

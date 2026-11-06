# Running Tests

## Prerequisites

The tests run against a mock Sakari service and a mock OAuth2 token endpoint that start with `bal test`, so nothing has to be set up for the default run.

To run them against the live Sakari API, create API credentials and set:

```bash
export IS_LIVE_SERVER=true
export SAKARI_CLIENT_ID=<client id>
export SAKARI_CLIENT_SECRET=<client secret>
export SAKARI_ACCOUNT_ID=<account id>
```

## Running the tests

```bash
bal test
```

To run only the mock-based or live tests, use the `mock_tests` or `live_tests` group:

```bash
bal test --groups mock_tests
```

## Test coverage

The suite covers 25 operations: the account balance, contacts (list, get, create, update, delete), messages (list, get, send), templates (list, get, create, update, delete), campaigns (list, get, create), conversations (list, get), webhooks (list, subscribe, unsubscribe), autoresponders (list, create) and drip campaigns (list). Operations that change data are skipped against the live API.

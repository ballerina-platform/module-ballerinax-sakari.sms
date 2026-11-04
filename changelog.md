# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- The initial Sakari SMS connector, a client for version 1 of the Sakari REST API, with 49 remote methods that manage the contacts, messages, conversations, templates, campaigns, drip campaigns, autoresponders, tracked links, link sources and webhooks of a Sakari account, and read its balance and available phone numbers.
- OAuth 2.0 client-credentials authentication through `ConnectionConfig.auth`. Its `tokenUrl` defaults to `https://api.sakari.io/oauth2/token`.
- An optional `headers` parameter on every remote method, for sending extra request headers.

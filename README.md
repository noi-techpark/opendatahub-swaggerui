<!--
SPDX-FileCopyrightText: NOI Techpark <digital@noi.bz.it>

SPDX-License-Identifier: CC0-1.0
-->

# Open Data Hub swaggerui

A simple docker container running swagger for the Open Data Hub API available on [swagger.opendatahub.com](https://swagger.opendatahub.com/)

[![REUSE Compliance](https://github.com/noi-techpark/odh-swaggerui/actions/workflows/reuse.yml/badge.svg)](https://github.com/noi-techpark/odh-docs/wiki/REUSE#badges)
[![CI/CD](https://github.com/noi-techpark/odh-swaggerui/actions/workflows/main.yml/badge.svg)](https://github.com/noi-techpark/odh-swaggerui/actions/workflows/main.yml)

### Fixed version 4.1.2
Currently (24.03.2021) the fixed version 4.1.2 of the swaggerui Docker image is used, because latest version causes the following problem: apispec url defined as url parameter doesn't get automatically pasted to the explore input box, so `./default.yml` has to be replaced manually with the apispec url.  
Latest *non working* version tested: 4.8.1  
Future version might solve this issue, but please check first that this problem is solved

### REUSE

This project is [REUSE](https://reuse.software) compliant, more information about the usage of REUSE in NOI Techpark repositories can be found [here](https://github.com/noi-techpark/odh-docs/wiki/Guidelines-for-developers-and-licenses#guidelines-for-contributors-and-new-developers).

Since the CI for this project checks for REUSE compliance you might find it useful to use a pre-commit hook checking for REUSE compliance locally. The [pre-commit-config](.pre-commit-config.yaml) file in the repository root is already configured to check for REUSE compliance with help of the [pre-commit](https://pre-commit.com) tool.

Install the tool by running:
```bash
pip install pre-commit
```
Then install the pre-commit hook via the config file by running:
```bash
pre-commit install
```
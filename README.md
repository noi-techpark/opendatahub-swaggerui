<!--
SPDX-FileCopyrightText: NOI Techpark <digital@noi.bz.it>

SPDX-License-Identifier: CC0-1.0
-->

# Open Data Hub swaggerui

A simple docker container running swagger for the Open Data Hub API available on [swagger.opendatahub.bz.it](https://swagger.opendatahub.bz.it/)

![REUSE Compliance](https://github.com/noi-techpark/odh-swaggerui/actions/workflows/reuse.yml/badge.svg)
[![CI/CD](https://github.com/noi-techpark/odh-swaggerui/actions/workflows/main.yml/badge.svg)](https://github.com/noi-techpark/odh-swaggerui/actions/workflows/main.yml)

### Fixed version 4.1.2
Currently (24.03.2021) the fixed version 4.1.2 of the swaggerui Docker image is used, because latest version causes the following problem: apispec url defined as url parameter doesn't get automatically pasted to the explore input box, so `./default.yml` has to be replaced manually with the apispec url.  
Latest *non working* version tested: 4.8.1  
Future version might solve this issue, but please check first that this problem is solved
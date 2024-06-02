#!/bin/bash

setx DB_USERNAME bz_user
setx DB_PASSWORD ${POSTGRES_PASSWORD}
setx DB_HOST 127.0.0.1
setx DB_PORT 5433
setx DB_NAME bz_coworking_db
FROM python:3.8-slim

WORKDIR /src

# Install Postgres and configure a username + password
USER root

# Set environment variables
#TODO: Update this variable due to secret pg secret password
ENV POSTGRES_PASSWORD=12345678
# 1xW4lKpgFo
ENV APP_PORT=5158
ENV DB_USERNAME=wendigo_user
ENV DB_PASSWORD=$POSTGRES_PASSWORD
ENV DB_HOST=127.0.0.1
ENV DB_PORT=5433
ENV DB_NAME=wendigo_db

# Set Docker build arguments
# ARG DB_USERNAME=$DB_USERNAME
# ARG DB_PASSWORD=$DB_PASSWORD

COPY . .

RUN apt update -y && apt install postgresql postgresql-contrib -y

RUN service postgresql start && \
PGPASSWORD="$POSTGRES_PASSWORD" psql --host $DB_HOST -U $DB_USERNAME -d $DB_NAME -p $DB_PORT < ./db/1_create_tables.sql && \
PGPASSWORD="$POSTGRES_PASSWORD" psql --host $DB_HOST -U $DB_USERNAME -d $DB_NAME -p $DB_PORT < ./db/2_seed_users.sql && \
PGPASSWORD="$POSTGRES_PASSWORD" psql --host $DB_HOST -U $DB_USERNAME -d $DB_NAME -p $DB_PORT < ./db/3_seed_tokens.sql


# RUN PGPASSWORD="$POSTGRES_PASSWORD" psql --host $DB_HOST -U $DB_USERNAME -d $DB_NAME -p $DB_PORT < ./db/1_create_tables.sql
# RUN PGPASSWORD="$POSTGRES_PASSWORD" psql --host $DB_HOST -U $DB_USERNAME -d $DB_NAME -p $DB_PORT < ./db/2_seed_users.sql
# RUN PGPASSWORD="$POSTGRES_PASSWORD" psql --host $DB_HOST -U $DB_USERNAME -d $DB_NAME -p $DB_PORT < ./db/3_seed_tokens.sql
# -- End database setup




# Dependencies are installed during build time in the container itself so we don't have OS mismatch
RUN apt update -y && apt install build-essential libpq-dev -y
# Update python modules to successfully build the required modules
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt


EXPOSE 5158

# Start the database and Flask application
CMD service postgresql start && python app.py






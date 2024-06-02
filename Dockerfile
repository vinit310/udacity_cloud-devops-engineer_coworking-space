FROM python:3.8-slim

# Install Postgres and configure a username + password
USER root
# TODO: Re-update all variables
# Set environment variables
ENV APP_PORT=5158
ENV POSTGRES_PASSWORD=qwerty
ENV DB_USERNAME=wendigo_user
ENV DB_PASSWORD=$POSTGRES_PASSWORD
ENV DB_HOST=127.0.0.1
ENV DB_PORT=5432
ENV DB_NAME=wendigo_db

# Set Docker build arguments
ARG DB_USERNAME=$DB_USERNAME
ARG DB_PASSWORD=$DB_PASSWORD

RUN apt update -y && apt install postgresql postgresql-contrib -y


WORKDIR /db
COPY . .

RUN service postgresql start && \
PGPASSWORD="$POSTGRES_PASSWORD" psql -c "CREATE USER $DB_USERNAME PASSWORD '$DB_PASSWORD'" && \
psql < 1_create_tables.sql && \
psql < 2_seed_users.sql && \
psql < 3_seed_tokens.sql && \
psql -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $DB_USERNAME;" && \
psql -c "GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $DB_USERNAME"

# RUN PGPASSWORD="$POSTGRES_PASSWORD" psql --host $DB_HOST -U $DB_USERNAME -d $DB_NAME -p $DB_PORT < ./db/1_create_tables.sql
# RUN PGPASSWORD="$POSTGRES_PASSWORD" psql --host $DB_HOST -U $DB_USERNAME -d $DB_NAME -p $DB_PORT < ./db/2_seed_users.sql
# RUN PGPASSWORD="$POSTGRES_PASSWORD" psql --host $DB_HOST -U $DB_USERNAME -d $DB_NAME -p $DB_PORT < ./db/3_seed_tokens.sql
# -- End database setup

WORKDIR /src
COPY ./analytics/requirements.txt requirements.txt

# Dependencies are installed during build time in the container itself so we don't have OS mismatch
RUN apt update -y && apt install build-essential libpq-dev -y
# Update python modules to successfully build the required modules
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

COPY ./analytics .

EXPOSE 5158

# Start the database and Flask application
CMD service postgresql start && python app.py

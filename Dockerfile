FROM python:3.8-slim

WORKDIR /src
USER root

# Set environment variables
# ENV APP_PORT=5158
ENV DB_USERNAME=wd_user
ENV DB_PASSWORD=12345678
ENV DB_HOST=127.0.0.1
ENV DB_PORT=5433
ENV DB_NAME=wd_coworking_db

COPY ./analytics .

# Dependencies are installed during build time in the container itself so we don't have OS mismatch
RUN apt update -y && apt install build-essential libpq-dev -y
# Update python modules to successfully build the required modules
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt


EXPOSE 5153

# Start the Flask application
CMD python ./app.py






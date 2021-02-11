![Rubocop style](https://github.com/FelixMZ2018/stunning-barnacle/workflows/Linters/badge.svg)
![rspec API testing](https://github.com/FelixMZ2018/stunning-barnacle/workflows/Rails%20tests/badge.svg)
# README

A demo rails/postgresql based API server, prepared to be used with docker-compose for easy deployment


# Dockerized Rails API Demo: 

For the bare-metal version please check https://github.com/FelixMZ2018/stunning-barnacle

Ruby Version: 3.0.0
Rails Version: 6.1.2
Database: Postgres 12.1
Docker: 21.10.3
Docker-Compose: 1.28.2

## API Documentation: https://www.notion.so/API-Demo-Documentation-76cb299bb3234cb4b170276143fc0821

## Startup
Note: Requires docker and docker compose

This repository is all set for use with docker compose to get started simply follow these steps

To clone the repository localy `git clone ` and change into the repo folder `cd stunning-barnacle-docker`

To download the database and set up the docker dependencies `docker-compose up -d`

To create and initalize the database run the following in a separate terminal `docker-compose exec app bundle exec rake db:setup db:migrate`

## Testing

The API is using rspec to perform integration tests from a newly created instance the tests can be performed using `bundle exec rspec spec/controllers/api/v1/messages_controller_spec.rb --format documentation`

Unfortunatley the Dockerized version does not support a dedicated testing database, so there might be false positive results for certain tests on a populated database

For a full list of test cases please check the documentation on Notion

## Usage

For a full API Documentation please see the Notion page

## Shutdown 

To shut the docker containers down after use simply run `docker-compose down --volumes`
the `--volumee` flag also deletes the database files

# Segmentation Example APP

This application was developed for a job test to work in [http://resultadosdigitais.com.br](Resultados Digitais).

The goal is to list contacts and to segment them by age or/and position. This segments can be saved to be possible to list it's contacts again in the future.

## Technologies used

- Ruby 2.3.0
- Rails 5.0.0.beta3
- Redis
- minitest
- AngularJS
- Angular Material
- Jasmine
- Puma (server)

## How it works

We have a Web App with AngularJS that consumes a Ruby on Rails API. The API is in charge of the contacts, positions and segments. Contacts and positions are saved in a `postgreSQL` database and segments in `redis`.

The Web App in the other hand, is in charge of getting this data from the API and to show it in a beautiful google material based screen. The App handle API errors too, showing to the user a nice message.

## Faced obstacles

- To avoid doing two different applications (API and Web APP) which could make the challenge confusing, they were integrated with Rails. The problem of doing that is that it was quite difficult to setup `jasmine` and `karma` to work. Fortunately it was possible and everything ran well.

- One of the premises of the challenge was that it has to be tested as much as possible and my experience with client-side and angular tests is not so good taking into consideration that I worked much more with back-end than with front-end or full stack. Once again, in the end everything worked out like a charm.

## System Dependencies

- redis
- ruby
- bundler
- postgreSQL

## Setup

After installing the system dependencies, you can follow the below steps:

- run in terminal at the project folder: `bundle install`
- Configure database (`config/database.yml`)
- run in terminal at the project folder: `rake db:create && rake db:migrate`

### Inserting fake data to play with the App

If you don't have contacts and positions in your database will be difficult to the app makes sense to you.

To solve this I've put in the seed a script to populate the database with fake data, run in terminal at the project folder: `rake db:seed`.

## Start the App

- run in terminal: `rails s`

## Testing

### API

- To test the API, run in terminal: `rake test`
- The test code is located in the folder named `test`.

### App

#### Unit

To run the App unit tests, you need to setup a couple of things first, ok?

- First you need to install `npm` package on you system.
- Once `npm` is installed run in your terminal at the project folder: `npm install`
- To test the API, run in terminal: `rake karma:run`
- The test code is located in the folder named `spec`.

#### Functional



## Final considerations

Thank you for the challenge.
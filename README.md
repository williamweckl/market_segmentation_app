# Market Segmentation Example APP

This application was developed for a job test to work in [Resultados Digitais](http://resultadosdigitais.com.br).

The goal is to list contacts and to segment them by age, position or/and state. This segments can be saved to be possible to list it's contacts again in the future.

The app is deployed in [heroku](http://market-segmentation.herokuapp.com/).

## Technologies used

- Ruby 2.3.0
- Rails 5.0.0.beta3
- Redis
- enumerate_it
- minitest
- AngularJS
- Angular Material
- Jasmine
- Karma
- Capybara
- Puma (server)

## How it works

We have a Web App with AngularJS that consumes a Ruby on Rails API. The API is in charge of the contacts, positions, states and segments. Contacts and positions are saved in a `postgreSQL` database, states are handled by enumerate_it and segments in `redis`.

The Web App in the other hand, is in charge of getting this data from the API and to show it in a beautiful google material based screen. The App handle API errors too, showing to the user a nice message.

## Faced obstacles

- To avoid doing two separated applications (API and Web APP) which could make the challenge confusing, they were integrated with Rails. The problem of doing that is that it was quite difficult to setup `jasmine` and `karma` to work. Fortunately it was possible and everything ran well.
- One of the premises of the challenge was that it has to be tested as much as possible and my experience with client-side and angular tests is not so good taking into consideration that I worked much more with back-end than with front-end or full stack. Once again, in the end everything worked out like a charm.
- Angular animations was breaking my integration tests.
- Angular material `md-list-item` directive was not "clicable" on integration tests. After a little headache, I removed the directive to workaround. Probably if I were not testing using `capybara` I wouldn't have this issue.
- I avoided using of `capybara-webkit` or `poltergeist` because their dependencies sometimes are difficult to install. By using `selenium` driver, some things were difficult to test and others I had to do workarounds.

## Lessons learned

- Integrate karma with rails
- Improvements in client-side test experience with jasmine
- Single Page Applications integrated to rails can be tested with Capybara in integration tests. It is not the perfect world but probably if I had used a different driver like `PhantomJS` I would not have had the problems that I had
- Disabling animations in integration tests help to avoid tests to break

Every challenge that I face helps me to improve my skills, after this challenge my feeling is that the mission was accomplished.

## System Dependencies

- redis
- ruby
- bundler
- postgreSQL

## Setup

After installing the system dependencies, you can follow the below steps:

- run in terminal at the project folder: `bundle install`
- Configure database file according to your system: (`config/database.yml`)
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

#### Unit tests

To run the App unit tests, you need to setup a couple of things first.

- You need to install `nodejs` and `npm` package in your system.
- Once `npm` is installed run in your terminal at the project folder: `npm install`
- To test the API, run in terminal: `rake karma:run`
- The test code is located in the folder named `spec`.

#### End to end / Integration tests

You have to do nothing. At the first time that you ran `rake test` to test the API, integrations tests ran too. You probably noticed that your browser has been opened a few times.

As I said before, angular animations has been disabled in the integration tests. I did that using a Rails trick with a `.css.erb` file and an environment condition inside: `<% if Rails.env.test? %>`

## Final considerations

Thank you for the challenge.
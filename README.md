# Application Portfolio

This is a web application developed for the management of UC Libraries application profile.  Provided that you have Ruby on Rails installed you can run this application on your local machine or server.

```bash
git clone github.com/uclibs/application_profile
bundle install
rails db:migrate
rails server
```

## Ruby version and System dependencies

Ruby 2.6.5

## Running the Tests
The application portfolio has a test suite built with rspec, running it is simple, just call the following in the project directory:

```bash
coveralls report
```

## Database creation

'''bash
bin/rails db:migrate RAILS_ENV=development
'''

## Still to be Documented

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Configuration

* Type of Roles
  Viewer, Department Head, IT Staff, Software Developer, CTO

* ...

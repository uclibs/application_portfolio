[![Coverage Status](https://coveralls.io/repos/github/uclibs/application_portfolio/badge.svg?branch=qa)](https://coveralls.io/github/uclibs/application_portfolio?branch=qa)

# Application Portfolio

This is a web application developed for the management of UC Libraries application profile.  
This application tracks, monitors, and secures information on all of UCL's services, software, and support.  
Provided that you have Ruby on Rails installed you can run this application on your local machine or server.

```bash
git clone github.com/uclibs/application_profile
bundle install
rails db:migrate
rails server
```

## Ruby version and System dependencies

Ruby 3.3.3

## Running the Tests
The application portfolio has a test suite built with rspec, rubocop, and coveralls, running it is simple, just call the following in the project directory:

```bash
coveralls report
```

```bash
rubocop -a
```

## Database creation

```bash
bin/rails db:migrate RAILS_ENV=development
```

## Developer Guide

* Create Admin Account
```bash
rails console

email_address = "user@example.com"

user = User.find_by_email(email_address)

user.roles = "root_admin"

user.save

```
* Deployment instructions

We deploy this application to both qa and production using Capistrano.  You must make an IP tunnel to the deploy from your local workstation.

```bash
cap qa deploy for qa

cap prod deploy for production
```

* Configuration

* Type of Roles

There are 4 types of roles in the Application Portfolio.

Admin (App Portfolio Tech Lead)
Manager (IT Staff and App Dev Staff)
Owner (CTO, Department Heads, AD)
Viewer (Library Faculty and Staff)

A complete defintion of each role can be found here https://github.com/uclibs/application_portfolio/wiki/Roles-in-Application-Portfolio

* Import/Export Documentation.

This application uses both db:seed to populate that application with Software Types, Vendor Records, and Application Records.  This is important because Vendor Records and Software Types are look up fields and the application is unable to create new records without some values in these database fields.

There is also a direct upload tool built into the Admin Menu Options.  This tool will take a .csv file and import the Software Types, Vendor Records, and Application Records.  This tool has a de-duping tool built into the load records and will not overwrite records in the database..

* Master Key

Uses the rails MessageEncryptor to encrypt and decrypt the data.
Added utility functions(helpers) that encrypt and decrypt based on rails key.
Re-generated master key to be consistent with MessageEncryptor.
Automatic encryption and decryption on UI. But only encrypted on DB.

* Graphs

We use the chartkick gem to draw our graphs


## Docker
* The Docker containers for Application Portfolio currently only work in development mode with a SQLite Database.
* The SQLite Database file itself is persisted using a Docker Volume.
* When we first run `docker-compose up`, a temporary container is started to create the SQLite database(on the shared volume) and to run `rails db:migrate` on it.
  
### Using Docker Compose
* To build and start the containerized application, run the below command, from the root directory of the repo:
```bash
docker-compose up -d --build
```
* If you want to use pre-built images, if any, run the below command:
```bash
docker-compose up -d
```
* List running Docker containers started by the `docker-compose.yml`:
```bash
docker-compose ps
```
* Inspect logs from the containers:
```bash
docker-compose logs
```
* To follow logs from the containers:
```bash
docker-compose logs -f
```  
* Run a command on the Rails App container:
```bash
docker-compose exec -u rails -T webapp <command>
```
* To run a shell in Rails App and attach to it:
```bash
docker-compose exec -u rails webapp sh
```
* To shutdown the containers started by the `docker-compose up -d` command, but keeping all the volumes(one of them containing the SQLite Database) intact, run:
```bash
docker-compose down
```
* To shutdown and delete Docker volumes and networks
```bash
docker-compose down -v
```
* To shutdown and delete everything from local pre-built images, networks to volumes:
```bash
docker-compose down --rmi all --remove-orphans -v 
```

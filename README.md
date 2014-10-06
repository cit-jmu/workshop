[![Stories in Ready](https://badge.waffle.io/cit-jmu/workshop.png?label=ready&title=Ready)](https://waffle.io/cit-jmu/workshop)
# Workshop Registration Made Easy

This app was created for the Faculty Development staff in [JMU's Center for Instructional Technology](http://cit.jmu.edu/) group to ease the burden of managing registrations for in-house workshop courses.  The goal is to create an application which is mostly self-service and requires minimal administrator support.

## Development Setup (Mac OS X)

1. Install [Homebrew](http://brew.sh/)

   Homebrew is an awesome package manager for Mac OS X.  We'll use it to install the packages we need.

   ~~~ sh
   $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
   ~~~
   
   If you already have Homebrew installed, then make sure it is up-to-date
   
   ~~~ sh
   $ brew update
   ~~~
   
2. Install [rbenv](https://github.com/sstephenson/rbenv)

   `rbenv` is a nice little utility for managing your installed Ruby versions

   ~~~ sh
   $ brew install rbenv ruby-build
   ~~~
   
   When Homebrew has finished installing `rbenv`, add the following line to your `~/.bash_profile` script:
   
   ~~~ sh
   $ echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
   ~~~
   
3. Install Ruby

   This project currently uses Ruby version 2.1.3, so we will use `rbenv` to install it (if you already have this version of ruby installed with rbenv, you can safely skip this step).

   ~~~ sh
   $ rbenv install 2.1.3
   ~~~
   
   If you already had `rbenv` installed, then you will need to rehash after installing a new ruby version
   
   ~~~ sh
   $ rbenv rehash
   ~~~

4. Install PostgreSQL

   This app uses PostgreSQL as its database backend, so we will install it using Homebrew
   
   ~~~ sh
   $ brew install postgresql
   ~~~
   
   Setup PostgreSQL to start on boot, and then fire it up
   
   ~~~ sh
   $ ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
   $ launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
   ~~~
   
   If you'd rather manage PostgreSQL manually without `launchctl` then you can skip the previous step and just run
   
   ~~~ sh
   $ postgres -D /usr/local/var/postgres
   ~~~
   

5. Clone this repository from GitHub into your project directory

   ~~~ sh
   $ git clone git@github.com:cit-jmu/workshop.git
   $ cd workshop
   ~~~

6. Install the required Gems

   We are going to use [Bundler](http://bundler.io/) to manage our installed Gems.  First we need to install the Bundler gem, and then us it to install the rest of the gems for the app.  After installing the bundle we need to rehash our rbenv environment.
   
   **Note:** These commands (and the rest that follow) should be run from within the `<project_dir>/workshop` directory.
   
   ~~~ sh
   workshop $ gem install bundler
   workshop $ bundle install
   workshop $ rbenv rehash
   ~~~
   
7. Setup the database

   We will use `db:setup` rake task to create and initialize our database
   
   ~~~ sh
   workshop $ bin/rake db:setup
   ~~~
   
8. Make sure it all works

   Let's fire up the Rails development server and test to make sure things are working
   
   ~~~ sh
   workshop $ bin/rails server
   ~~~
   
   You now be able to go to http://localhost:3000 in your browser and see the running app.

## What's in the box?

Aside from the standard gems that get installed with the default install of Rails, here's what else has been added:

* [Official Sass port of Bootstrap](http://getbootstrap.com/css/#sass)
  * gem [bootstrap-sass](https://rubygems.org/gems/bootstrap-sass)
  * gem [autoprefixer-rails](https://rubygems.org/gems/autoprefixer-rails)
* [Puma](http://puma.io/) (replaces WEBRick)
  * gem [puma](https://rubygems.org/gems/puma)
* [RSpec](https://github.com/rspec/rspec)
  * gem [rspec-rails](https://rubygems.org/gems/rspec-rails)
* [Cucumber](https://github.com/cucumber/cucumber)
  * gem [cucumber-rails](https://rubygems.org/gems/cucumber-rails)
  * gem [database_cleaner](https://rubygems.org/gems/database_cleaner)

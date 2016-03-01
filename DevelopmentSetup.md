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
   $ brew install rbenv ruby-build rbenv-vars
   ~~~

   When Homebrew has finished installing `rbenv`, add the following line to your `~/.bash_profile` script:

   ~~~ sh
   $ echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
   ~~~

3. Install Ruby

   This project currently uses Ruby version 2.2.3, so we will use `rbenv` to install it (if you already have this version of ruby installed with rbenv, you can safely skip this step).

   ~~~ sh
   $ rbenv install 2.2.3
   ~~~

   If you already had `rbenv` installed, then you will need to rehash after installing a new ruby version

   ~~~ sh
   $ rbenv rehash
   ~~~
   
   **Tip:** To avoid having to rehash, use [rbenv-gem-rehash](https://github.com/sstephenson/rbenv-gem-rehash).

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

   **OS X 10.10 Yosemite**
   If you previously installed PostgreSQL via Homebrew and then upgraded to Yosemite,
   your database is probably going to complain when starting up and not work properly.
   It seems to be due to some missing directories, and putting these directories back
   fixes the issue.  Not sure why they got removed in the upgrade process, though.

   ~~~ sh
   $ cd /usr/local/var/postgres
   $ mkdir pg_stat_tmp pg_tblspc pg_twophase
   ~~~

   With those directories back in place, it should start up for you again.


5. Clone this repository from GitHub into your project directory

   ~~~ sh
   $ git clone git@github.com:cit-jmu/workshop.git
   $ cd workshop
   ~~~

6. Install the required Gems

   We are going to use [Bundler](http://bundler.io/) to manage our installed Gems.  First we need to install the Bundler gem, and then use it to install the rest of the gems for the app.  After installing the bundle we need to rehash our rbenv environment.

   **Note:** These commands (and the rest that follow) should be run from within the `<project_dir>/workshop` directory.

   ~~~ sh
   workshop $ gem install bundler
   workshop $ bundle install
   workshop $ rbenv rehash
   ~~~

7.  On your local machine, navigate to `<workshop root>` and rename the `.rbenv-vars_example_dev` file to `.rbenv-vars` then update it with values for your setup. This file is where your sensitive server account information will go for things like LDAP authentication, mail server set up, database setup, etc.

8.  Then navigate to `<workshop root>/config` and rename `local_settings_example.yml` to `local_settings.yml` and update it with values for your setup. This file contains information that will be displayed in the public interface and allows for custom terminology usage for specific parts of the application (e.g. refer to a Workshop as a Program).


9. Setup the database

   We will use `db:setup` rake task to create and initialize our database

   ~~~ sh
   workshop $ bin/rake db:setup
   ~~~

10. Make sure it all works

   Let's fire up the Rails development server and test to make sure things are working

   ~~~ sh
   workshop $ bin/rails server
   ~~~

   You now be able to go to http://localhost:3000 in your browser and see the running app.

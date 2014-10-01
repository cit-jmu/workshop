# Mac OS X Development Environment Setup


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

   We are going to use [bundler](http://bundler.io/) to manage our installed Gems.  First we need to install the Bundler gem, and then us it to install the rest of the gems for the app.
   
   **Note:** These commands (and the rest that follow) should be run from within the `<project_dir>/workshop` directory.
   
   ~~~ sh
   workshop $ gem install bundler
   workshop $ bundle install
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

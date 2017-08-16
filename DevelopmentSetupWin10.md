## Development Setup (Windows 10)

1. Install [Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide)

   The reason we use Bash on Ubuntu on Windows because it allows you to run Linux on your Windows machine. Most Ruby on Rails tutorials and dependencies work best on Linux, so this allows you to get the best of both worlds. A Windows machine for your day to day work, and a Linux subsystem for Ruby on Rails development.

2. Install Ruby Dependencies and [rbenv](https://github.com/sstephenson/rbenv)

   `rbenv` is a nice little utility for managing your installed Ruby versions

   ~~~ sh
   $ sudo apt-get update
   $ sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
   $ cd
   $ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
   ~~~

   With dependencies installed, we install rbenv, ruby-build, and add a few lines to .bashrc:

   ~~~ sh
   $ cd
   $ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
   $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
   $ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
   $ exec $SHELL

   $ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
   $ echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
   $ exec $SHELL
   ~~~

3. Install Ruby

   This project currently uses Ruby version 2.2.3, so we will use `rbenv` to install it (if you already have this version of ruby installed with rbenv, you can safely skip this step).

   ~~~ sh
   $ rbenv install 2.2.3
   $ rbenv global 2.2.3
   ~~~

   If you already had `rbenv` installed, then you will need to rehash after installing a new ruby version

   ~~~ sh
   $ rbenv rehash
   ~~~
   
   **Tip:** To avoid having to rehash, use [rbenv-gem-rehash](https://github.com/sstephenson/rbenv-gem-rehash).

4. Install PostgreSQL

   This app uses PostgreSQL as its database backend, so we will install it and set up a user. These commands are convoluted because sudo -u does not currently work in the Windows subsystem for Linux.

   ~~~ sh
   $ sudo apt-get install postgresql-common postgresql libpq-dev
   $ sudo service postgresql start
   $ sudo -s
   $ su - postgres
   $ createuser <localusername> -s
   $ exit
   $ exit
   ~~~

   You may need to run the following SQL to change your postgresql default template to use UTF-8

   ~~~ sh
   # update pg_database set datallowconn = TRUE where datname = 'template0';
   # \c template0
   # update pg_database set datistemplate = FALSE where datname = 'template1';
   # drop database template1;
   # create database template1 with template = template0 encoding = 'UTF8';
   # update pg_database set datistemplate = TRUE where datname = 'template1';
   # \c template1
   # update pg_database set datallowconn = FALSE where datname = 'template0';
   ~~~

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

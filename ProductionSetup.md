Workshop Registration App Setup
===============================

Setting Up the Environment
--------------------------

1.  Install Linux OS – we used RHEL 7

2.  Create a user called "deploy".

3.  Install and configure git. You can setup user.name and user.email, but it isn’t necessary.
    ```
    sudo yum install git
    ```
4.  Follow GitHub’s instructions for generating an SSH key and setting it up for the deploy user: <https://help.github.com/articles/generating-an-ssh-key/>

    a.  You will also need to be set up a key on your local environment for deployment, which should be included in the `authorized_keys` file on the your server for the deploy user (usually in `/home/deploy/.ssh`) .

5.  Install dependencies for rbenv and Ruby:
    ```
    sudo yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel
    ```
6.  Install rbenv and ruby-build by cloning their repositories into the deploy user’s home directory.
    ```
    cd ~
    git clone git://github.com/sstephenson/rbenv.git .rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash\_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash\_profile
    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash\_profile
    source ~/.bash\_profile
    ```
7.  Install Ruby using rbenv and set the global Ruby version. Note: rbenv rehash is necessary to ensure that the OS picks up the correct version of Ruby.
    ```
    rbenv install -v 2.2.3
    rbenv rehash
    rbenv global 2.2.3
    ```
8.  Install Bundler to manage application dependencies
    ```
    gem install bundler
    ```
9.  Install the `rbenv/rbenv-vars` repo into the `.rbenv/plugins` directory
    ```
    cd ~/.rbenv/plugins && git clone git@github.com:rbenv/rbenv-vars.git
    ```
10.  Install and set up PostgreSQL
    ```
    sudo yum install postgresql-server postgresql-contrib postgresql-devel
    ```
11.  Create a role in PostgreSQL called workshop that has createdb permissions
    ```
    sudo -u postgres psql
    create role workshop with createdb login password ‘<enter your password here>’;
    ```
12.  Ensure that `/home/deploy` is set to be readable/executable by all users.

13.  If your server does not have nginx installed, you will need to install that as well. For RHEL 7:
    ```
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    rpm -Uvh <https://mirror.webtatic.com/yum/el7/webtatic-release.rpm>
    yum install nginx18
    ```

Initial App Deployment
----------------------

1.  Clone the workshop repository onto your local machine.
    ```
    git clone <git@github.com:cit-jmu/workshop.git>
    ```
2.  Navigate to `<workshop root>/config/deploy` and update `production.rb` and `staging.rb` with the name of the server which will be running the application.

    a.  Production uses any "Production" level environment settings.

    b.  Staging uses any "Staging" level environment settings.

    c.  We have two separate installations configured, using `production_cfi.rb` for the second production instance.

2.  If you would like to customize the emails sent by the application, those views (including versions for both HTML and plain text emails) are stored in `<workshop root>/app/views/user_mailer`

3.  Navigate to `<workshop root>/config/nginx` and update the files with values for your server environment. You will need to know where your SSL certs are stored on the server to update the `ssl_certificate` and `ssl_certificate_key` lines in the file.

4.  Make sure that your local machine has the appropriate SSH key that matches the one in `authorized_keys` for the deploy user (in step # 4a of **Setting Up the Environment** above).

5.  Navigate to the `<workshop root>` directory in the command line of your local machine and run Capistrano for the environment that you wish to deploy: `cap <environment> deploy:initial`

    a.  This will deploy the application using the files on your local machine – it will return an error if your local files do not match the latest revision in the repository.

    b.  Note: this initial deploy with end with an error, which we will resolve in the next step.

6.  On your local machine, navigate to `<workshop root>` and rename the `.rbenv-vars-example` file to `.rbenv-vars` then update it with values for your setup. This file is where your sensitive server account information will go for things like LDAP authentication, mail server set up, database setup, etc.

7.  Then navigate to `<workshop root>/config` and rename `local_settings_example.yml` to `local_settings.yml` and update it with values for your setup. This file contains information that will be displayed in the public interface and allows for custom terminology usage for specific parts of the application (e.g. refer to a Workshop as a Program).

8.  On your local machine, run the following commands to upload these files to your server.
    ```
    scp <path to .rbenv-vars on local machine> deploy@<servername>:~/apps/workshop/shared/
    scp <path to local\_settings.yml on local machine> deploy@<servername>:~/apps/workshop/shared/config/
    ```
9.  Log in to your server as the deploy user and navigate to `/home/deploy/apps/workshop/releases/<timestamped directory>`. From there, you can run `rake db:create` to initialize the database for the application. It will be called `workshop`.

10.  Back on your local machine, navigate to your local repo and run `cap <environment> deploy:initial`. This time the deploy should complete without errors.

11.  On your server, run the following command to create a symlink for your nginx configuration files. If you have multiple environments (e.g. production and production\_cfi) you will need to do this for each one.
    ```
    ln -s /home/deploy/apps/workshop/current/dist/nginx/production.conf /etc/nginx/conf.d/
    ```
12.  You need a few utility/startup scripts to help manage the server in production. They need to be symlinked to the appropriate locations on your server.

    1. A short script is included to do this for RHEL7, stored in the repository as `<workshop root>/dist/rhel/7/production_setup.sh`. 
    
    2. Similar scripts could be created for other distros if needed. **It needs to be run as root (or sudo).**

    3.  The script can be executed on the server from the `/home/deploy/apps/workshop/current/dist/rhel/7` directory.

    4.  The commands included are "backup-db" , "puma-init" and "puma.service".

13.  Currently, there is no admin user for the application. To set that up, log in to the application (in your browser) to create a user. Then run the following commands on the server command line to set that user to admin role:
    ```
    sudo –u posgres psql workshop
    update users set role=2 where username = '<your username>';
    ```

# Workshop Registration Made Easy

[![Join the chat at https://gitter.im/cit-jmu/workshop](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/cit-jmu/workshop?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/cit-jmu/workshop.svg?branch=master)](https://travis-ci.org/cit-jmu/workshop)
[![Code Climate](https://codeclimate.com/github/cit-jmu/workshop/badges/gpa.svg)](https://codeclimate.com/github/cit-jmu/workshop)
[![Test Coverage](https://codeclimate.com/github/cit-jmu/workshop/badges/coverage.svg)](https://codeclimate.com/github/cit-jmu/workshop)

This app was created for the Faculty Development staff in [JMU's Center for Instructional Technology](http://cit.jmu.edu/) group to ease the burden of managing registrations for in-house workshop courses.  The goal is to create an application which is mostly self-service and requires minimal administrator support.

## Setup Instructions

[a relative link](DevelopmentSetup.md)
[a relative link](ProductionSetup.md)

## What's in the box?

Aside from the standard gems that get installed with the default install of Rails, here's what else has been added:

* [Official Sass port of Bootstrap](http://getbootstrap.com/css/#sass)
  * gem [bootstrap-sass](https://rubygems.org/gems/bootstrap-sass)
  * gem [autoprefixer-rails](https://rubygems.org/gems/autoprefixer-rails)
* [Puma](http://puma.io/) (replaces WEBRick)
  * gem [puma](https://rubygems.org/gems/puma)
* [Devise](https://github.com/plataformatec/devise)
  * gem [devise](https://rubygems.org/gems/devise)
  * gem [devise_ldap_authenticatable](https://rubygems.org/gems/devise_ldap_authenticatable)
* [CanCanCan](https://github.com/CanCanCommunity/cancancan)
  * gem [cancancan](https://rubygems.org/gems/cancancan)
* [Redcarpet](https://github.com/vmg/redcarpet)
  * gem [redcarpet](https://rubygems.org/gems/redcarpet)
* [iCalendar](https://github.com/icalendar/icalendar)
  * gem [icalendar](http://rubygems.org/gems/icalendar)
* [Simple Calendar](https://github.com/excid3/simple_calendar)
  * gem [simple_calendar](https://rubygems.org/gems/simple_calendar)

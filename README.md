## README [![Code Climate](https://codeclimate.com/github/Absolventa/ereignishorizont.png)](https://codeclimate.com/github/Absolventa/ereignishorizont) [![Build Status](https://travis-ci.org/Absolventa/ereignishorizont.png?branch=master)](https://travis-ci.org/Absolventa/ereignishorizont)

Welcome to Ereignishorizont!

## Description

Ereignishorizont is an open event-logging system
with triggers/hooks to run arbitrary tasks when an event is
matched or not matched.

It was proposed as a project for the [Rails Girls Summer of Code](http://railsgirlssummerofcode.org/).
Its two main contributors are the Rails Girls Susanne and Tam who
worked on the project from July 2 - September 30, 2013
at the [ABSOLVENTA](https://www.absolventa.de) offices in Berlin.

Also found on [ereignishorizont.herokuapp.com](https://ereignishorizont.herokuapp.com)



### Features

- Track events
- Receive an email about if your event of choice occurred or not

### Installation
Download the code (or fork / clone locally). To host your instance
on Heroku, you need:

1. a database
2. a scheduler that runs `rake matcher` once per hour
3. a scheduler that runs `rake cleanup` daily (optional, see Configuration below)

### Configuration

The app can be configured using `EREIGNISHORIZONT_*` environment variables
or, alternatively, a `config/config.yml` file. See `config/initializers/app_config.rb`
for details and default values.

As of v1.7, a cleanup task to purge old incoming events is included. Add `rake cleanup` to your scheduler (see Installation) and set a `EREIGNISHORIZONT_RETENTION_MONTHS` environment variable. For example, `EREIGNISHORIZONT_RETENTION_MONTHS=10` will delete all incoming events older than 10 months every time the rake task runs.

### Client access

incoming events require an API token. It can be obtained by
creating a ``RemoteSide`` record.

Example for registering an event using JSON:

    API_TOKEN=a2ade3bd297bf93a039b06b8560ab193
    curl -i -X POST \
      -H 'Content-type: application/json' \
      -d '{
        "incoming_event": { "title": "my event identifier"},
        "api_token": "$API_TOKEN"
      }' \
      http://localhost:3000/incoming_events.json


Example for registering an event using XML:

    API_TOKEN=a2ade3bd297bf93a039b06b8560ab193
    curl -i -X POST \
      -H 'Content-type: application/xml' \
      -d '<incoming_event><title>xml formatted</title></incoming_event>' \
      http://localhost:3000/incoming_events.xml?api_token=$API_TOKEN

To use the corresponding gem:

`gem install ereignishorizont-client`

(More info about Ereignishorizont's corresponding gem can
be found [here](https://github.com/Absolventa/ereignishorizont-client)).

### Changelog

*v2.0.0 // 2016-06-02*
* [Renamed app](https://github.com/Absolventa/ereignishorizont/commit/31370d88e0cf53bc1018cb7ab85f65406cdb8055)) from 'Event Girl' to 'Ereignishorizont'

*v1.7.0 // 2015-11-10*
* Updated to Rails v4.2
* Updated to C-Ruby 2.2
* Allow auto-purging of old incoming events

*v1.6.0 // 2015-05-05*
* Allow filtering by remote side / origin

*v1.5.0 // 2014-05-05*
* Updated to Rails v4.1
* Updated to MRI v2.1.1
* Search through expected events' list

*v1.4.0 // 2014-02-05*
* All time values are now UTC
* Allow per-user definition of local time zone

*v1.3.2 // 2014-02-05*
* Fixed issue with final hour range (now a proper 0..23)
* Supports searching for incoming events

*v1.3.1 // 2014-01-14*
* Upgrade to Rails v4.0.2

*v1.3.0 // 2013-11-05*
* Supports event expectations for monthly tasks

*v1.2.0 // 2013-10-24*
* Allows alarms to be shared between expected events
* Requires expected event to belong to a specific remote side
* Minor bugfixes and refactorings

*v1.1.0 // 2013-10-08*
* Accepts optional ``content`` attribute for incoming events
* Heaved instance methods from Matcher onto class level
* Minor bugfixes and refactorings

*v1.0.0 // 2013-09-30*
* RGSoC final version

### Contributors

- [Susanne Dewein](https://github.com/FrauBienenstich)
- [Tam Eastley](https://github.com/berlintam)
- [Carsten Zimmermann](https://github.com/carpodaster)
- [Tobias Pfeiffer](https://github.com/PragTob)

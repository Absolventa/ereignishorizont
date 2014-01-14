## README [![Code Climate](https://codeclimate.com/github/Absolventa/event_girl.png)](https://codeclimate.com/github/Absolventa/event_girl) [![Build Status](https://travis-ci.org/Absolventa/event_girl.png?branch=master)](https://travis-ci.org/Absolventa/event_girl)

Welcome to Event Girl!

## Description

Event Girl is an open event-logging system 
with triggers/hooks to run arbitrary tasks when an event is 
matched or not matched.  

It was proposed as a project for the [Rails Girls Summer of Code](http://railsgirlssummerofcode.org/). 
Its two main contributors are the Rails Girls Susanne and Tam who 
worked on the project from July 2 - September 30, 2013
at the [ABSOLVENTA](http://www.absolventa.de) offices in Berlin.

Also found on [event-girl.herokuapp.com](event-girl.herokuapp.com)



### Features

- Track events
- Receive an email about if your event of choice occurred or not

### Installation
Download the code (or fork / clone locally). To host your instance
on Heroku, you need:

1. a database
2. a scheduler that runs ``rake matcher`` once per hour

### Configuration

The app can be configured using ``EVENT_GIRL_*`` environment variables
or, alternatively, a ``config/config.yml`` file. See ``config/initializers/app_config.rb``
for details and default values.


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

`gem install event_girl_client`

(More info about Event Girl's corresponding gem can
be found [here](https://github.com/Absolventa/event_girl_client))

There will also soon be a [python egg](https://github.com/berlintam/event_girl_client_python) and other such things....

### Changelog
*v1.3.1 // 2014-01-14
* Upgrade to Rails v4.0.2

*v1.3.0 // 2013-11-05
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

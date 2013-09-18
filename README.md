## README [![Code Climate](https://codeclimate.com/github/Absolventa/event_girl.png)](https://codeclimate.com/github/Absolventa/event_girl) [![Build Status](https://travis-ci.org/Absolventa/event_girl.png?branch=master)](https://travis-ci.org/Absolventa/event_girl)

Welcome to Event Girl!

Event Girl is an open event-logging system 
with triggers/hooks to run arbitrary tasks when an event is 
matched or not matched.  

It was proposed as a project for the Rails Girls Summer of Code. 
Its two main contributors are the Rails Girls Susanne and Tam who 
will be working on the project from July 2 - September 30, 2013
at the ABSOLVENTA offices in Berlin.

### Client Access

Incoming events require an API token. It can be obtained by
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


# Foursquare Observer

manybots-foursquare is a Manybots Observer that allows you to import your checkins from Foursquare to your local Manybots.

## Installation instructions

### Setup the gem

You need the latest version of Manybots Local running on your system. Open your Terminal and `cd` into its' directory.

First, require the gem: edit your `Gemfile`, add the following, and run `bundle install`

```
gem 'manybots-foursquare', :git => 'git://github.com/manybots/manybots-foursquare.git'
```

Second, run the manybots-foursquare install generator (mind the underscore):

```
rails g manybots_foursquare:install
```

Now you need to register your Foursquare Observer with Foursquare.

### Register your Foursquare Observer with Foursquare

Your Foursquare Observer uses OAuth to authorize you (and/or your other Manybots Local users) with Foursquare. 

Register your application with Foursquare to get the Client ID and Secret. Go to the [Foursquare App Management page](https://foursquare.com/oauth/register) and create a new application.

And then copy-paste the Client ID and Client Secret in the appropriate "replace me" parts.

1. Go to this link: https://foursquare.com/oauth/register

2. Enter information like described in the screenshot below

<img src="https://img.skitch.com/20120423-dme5hmyaf2kb88g4c8gjgnkxbb.png" alt="Foursquare Observer OAuth client configuration">

3. Copy the Client ID and Secret into `config/initializers/manybots-foursquare.rb`

```
  config.foursquare_app_id = 'Client ID'
  config.foursquare_app_secret = 'Secret'
```  


### Restart and go!

Restart your server and you'll see the Foursquare Observer in your `/apps` catalogue. Go to the app, sign-in to your Foursquare account and start importing your checkins into Manybots.

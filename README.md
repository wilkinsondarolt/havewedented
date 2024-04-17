# README

A simple tool for checking if you two players ever matched in [Age of Empires 4](https://www.ageofempires.com/games/age-of-empires-iv/).

This tool is made possible due to the awesome work from people that maintain [Aoe4World](https://aoe4world.com/).

## Local setup

**IMPORTANT** Make sure you have `ruby 3.3.0` installed.

Start by running the application's setup

```shell
bin\setup
```

This will
- Install the Ruby dependencies;
- Enable local caching

We want to cache the responses from AoEWorld to minimize the impact to it's API.

### Running the application

Run this command in your terminal

```shell
bin\dev
```

After the boot the app will can be accessed in http://localhost:3000

### Running the tests

Run this command in your terminal

```shell
bundle exec rspec
```

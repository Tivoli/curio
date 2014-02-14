Curio
=====

[![Build Status](https://travis-ci.org/Tivoli/curio.png?branch=master)](https://travis-ci.org/Tivoli/curio)

[code coverage](http://tivoli.github.io/curio/coverage.html "Code Coverage")

Curio is a modular Nodejs app built on top of express, mongodb, and redis

#### Motivation

I wanted to build out my own boilerplate Nodejs app that can be extended to any website with a CMS.

## Installation

Make sure you have the following installed

* Mongodb
* Redis
* Nodejs

Clone the repository:

    git clone git@github.com:Tivoli/curio.git

Update the remote to your own repo

    cd curio
    git remote rm origin
    git remote add origin <new_url>

Install the modules

    npm install -g coffee-script nodemon
    npm install

## Booting the server

Nodemon is used in development to restart with file changes, simply run **nodemon**

In other environments **coffee boot.coffee** will start up and fork the server for each CPU

## Running the tests

The default tests will run both coffeelint and mocha tests

    npm test

To make the coverage file

    make test-cov

## License

Licensed under the MIT license.

Minitraining
============

En construction.

Description
-----------
Une version de [Mathraining](http://www.mathraining.be) pour laquelle les fonctionnalités avancées (messages privés, correcteurs, forum) sont cachées de l'utilisateur. Les éléments d'image de marque originales (logo...) seront retirées.


How to test the website locally
-------------------------------
First you need to clone the github repository (or a fork of it) on your computer:
```sh
$ git clone https://github.com/logan-314/minitraining
```
In the created folder 'mathraining', you should install the needed 'gems':
```sh
$ bundle config set --local without 'production'
$ bundle install
```
Then it is time to create the database:
```sh
$ rake db:create    # Create the database
$ rake db:migrate   # Migrate the database (see db/migrate/)
$ rake db:seed      # Seed the database (see db/seeds.rb)
$ rake db:populate  # Populate the database (see lib/tasks/sample_data.rake)
```
To test the website locally, you can simply do:
```sh
$ rails s  # And then visit localhost:3000 in your browser
```
To run tests, do:
```sh
$ rake db:test:prepare  # Must be done when the db structure changes
$ rspec .               # '.' can be replaced by a path to one file in spec/
```

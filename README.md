# README

## Ruby version

* Ruby ~> 2.2.0
* Rails ~> 4.2.0

## System dependencies

Install imagemagick

```bash
$ brew install imagemagick # for mac
```

## Configuration

1. Clone this repository
2. Copy config/settings/development.yml to config/settings/development.local.yml
	1. `cp config/settings/database.yml config/settings/database.local.yml`
	2. Configure DB settings and mailer settings
3. Run `bundle install  --path vendor/bundle`
4. Run `rake db:create` `rake db:migrate`
5. Run `rake db:seed_fu`
6. Run `rails s`
7. Enjoy !

## Pull request

1. Run rspec test locally.
	1. Check the all tests are passed.
2. Commit your local changes.
	1. The commit message must...
		1. explain what you implement simply.
		2. start with the *verb in simple present form*, and capitalize the initial letter.
		  1. Good
			  1. `Implement user sign_in form`
		  2. Bad 
			  1. `implement ...`
			  2. `implemented ...`
			  3. `I implement...`
			  4. `Update`
3. Push to your branch.
	1. !!!DO NOT PUSH TO THE `master`  BRANCH!!!
	2. `$ git push origin yourbranch`
4. Make pull request.
	1. `$ hub pull-request` <= If you installed hub command via brew.
	2. Please note
		1. What you implement.
		2. Where to see.
		3. How you tested manually.
5. Good luck !!

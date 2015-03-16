echo gem \'pg\' >> Gemfile
bundle install
git add Gemfile Gemfile.lock
git config user.email 'electric.spanish.shinofumi.335@gmail.com'
git config user.name 'shinofumijp'
git commit -m 'Add pg'
git push -f git@heroku.com:fincstore.git master
heroku run rake db:migrate --app fincstore
heroku run rake db:seed_fu --app fincstore

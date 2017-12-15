# Mahonia



<table width="100%">
  <tr>
    <td><img alt="Mahonia aquifolium image" src="app/assets/images/mahonia.jpg" height="40%"></td>
    <td>
       <i>Mahonia aquifolium</i>: Electronic Theses & Dissertations
       <br/>
     <p><a href="https://travis-ci.org/curationexperts/mahonia"><img src="https://travis-ci.org/curationexperts/mahonia.svg?branch=master" alt="Build Status"></a>
<a href="https://coveralls.io/github/curationexperts/mahonia?branch=master"><img src="https://coveralls.io/repos/github/curationexperts/mahonia/badge.svg?branch=master" alt="Coverage Status"></a>
<a href="https://gemnasium.com/github.com/curationexperts/mahonia"><img src="https://gemnasium.com/badges/github.com/curationexperts/mahonia.svg" alt="Dependency Status"></a></p>
    </td>
  </tr>
</table>

## Developer Setup

1. Change to your working directory for new development projects
   `cd .`
1. Clone this repo
   `git clone https://github.com/curationexperts/mahonia.git`
1. Change to the application directory
   `cd mahonia`
1. `bundle install` under project's current ruby (2.4.2)
1. Start redis
   `redis-server &`
   *note:* use ` &` to start in the background, or run redis in a new terminal
   session
1. Setup your database.
   We use PostgreSQL. To support the test and development environments, you'll
   need have Postgres installed and running.
   Ensure that your current user can create databases in postgres. In the `psql`
   console do `create role [username] with createdb login`. Then do
   `bundle exec rake db:setup` to create the databases.
1. Start solr and fedora (in new tabs) `bundle exec solr_wrapper` and `bundle exec fcrepo_wrapper`.   
1. Create a default [admin set](https://samvera.github.io/what-are-admin-things.html).
   To add a new work from the dashboard, you will need to setup a default admin set. You
   do this by running this rake task: `rake hyrax:default_admin_set:create`.

You can now run the test suite with `bundle exec rake ci`, or start a
development server with `bundle exec rake hydra:server`.

## How to create an admin user on the console
(See https://github.com/samvera/hyrax/wiki/Making-Admin-Users-in-Hyrax for more details)

1. Connect to the rails console and follow this script (note that if you are on a production instance you'll need `RAILS_ENV=production bundle exec rails c`):
  ```ruby
  bundle exec rails c
  2.4.2 > u = User.new
  2.4.2 > u.email = "fake@example.com"
  2.4.2 > u.display_name = "Jane Doe"
  2.4.2 > u.password = "123456"
  2.4.2 > u.save
   => true
  2.4.2 > u.add_role("admin")
  2.4.2 > u.admin?
   => true
  ```

1. If the object won't save, or isn't working as expected, you can check the errors like this:
  ```ruby
  2.4.2 :015 > u = User.new
  2.4.2 :016 > u.email = "fake@example.com"
  2.4.2 :017 > u.save
   => false
  2.4.2 :018 > u.errors.messages
   => {:email=>["has already been taken"], :password=>["can't be blank"], :orcid=>[]}
  ```

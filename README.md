# Mahonia

<table width="100%">
  <tr>
    <td><img alt="Mahonia aquifolium image" src="app/assets/images/mahonia.jpg" height="40%"></td>
    <td>
       <i>Mahonia aquifolium</i>: Electronic Theses & Dissertations
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
1. Start redis
   `redis-server &`
   *note:* use ` &` to start in the background, or run redis in a new terminal
   session
1. Setup your database.
   We use PostgreSQL. To support the test and development environments, you'll
   need have Postgres installed and running. In your `psql` console do
   `create role mahonia with createdb login password 'password1';`. Then do
   `bundle exec rake db:create` to setup the create the database and schema.

You can now run the test suite with `bundle exec rake ci`, or start a
development server with `bundle exec rake hydra:server`.

## How to create an admin user on the console
(See https://github.com/samvera/hyrax/wiki/Making-Admin-Users-in-Hyrax for more details)

1. Connect to the rails console and follow this script (note that if you are on a production instance you'll need `RAILS_ENV=production bundle exec rails c`):
  ```ruby
  bundle exec rails c
  2.4.2 :001 > u = User.new
  2.4.2 :002 > u.email = "fake@example.com"
  2.4.2 :003 > u.display_name = "Jane Doe"
  2.4.2 :004 > u.password = "123456"
  2.4.2 :005 > admin_role = Role.where(name: 'admin').first_or_create
   => #<Role id: 1, name: "admin">
  2.4.2 :006 > u.roles << admin_role
   => #<ActiveRecord::Associations::CollectionProxy [#<Role id: 1, name: "admin">]>
  2.4.2 :007 > u.save
   => true
  2.4.2 :011 > u.admin?
  Role Exists (0.2ms)  SELECT  1 AS one FROM "roles" INNER JOIN "roles_users" ON "roles"."id" = "roles_users"."role_id" WHERE "roles_users"."user_id" = ? AND "roles"."name" = ? LIMIT ?  [["user_id", 2], ["name", "admin"], ["LIMIT", 1]]
 => true
  ```

1. If the object won't save, or isn't working as expected, you can check the errors like this:
  ```ruby
  2.4.2 :015 > u = User.new
  2.4.2 :016 > u.email = "bess@curationexperts.com"
  2.4.2 :017 > u.save
   => false
  2.4.2 :018 > u.errors.messages
   => {:email=>["has already been taken"], :password=>["can't be blank"], :orcid=>[]}
  ```

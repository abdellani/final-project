# About the program 

This project is a facebook-like web application, where a user can share content, build relationships with other users, and express his points of view.

# Installation 

This project is based on ruby on rails framework. RSpec and Cabypara have been used to implement the different unit and integration tests. To install this project, you'll need to have a running Postgres server in you local computer or network. After cloning the project, you have to run `bundle install` followed by `rails db:migrate`

# Configuration

You'll need to configure the application to connect to the database. The configuration file can be found at ` config/database.yml`, you'll need to fill the different field with data from your environment. 
```yml
development:
  adapter: postgresql
  encoding: unicode
  database: [DATABASE_NAME]
  username: [USERNAME]
  password: [PASSWORD]
  host: [IP]
```
# Run the code 
To run the application in you development environment, you need to run `rails s`.
To deploy it in heroku, you need first to run `git push heroku master` followed by `heroku run rails db:migrate`
# Get Update
To get the latest updates, you run `git pull origin master`
# Authors
- Emir Vatric -- [User Github link](https://github.com/EmirVatric)
- Mohamed Abdellani -- [User Github link](https://github.com/abdellani)
# Run Tests

Authentication

- Login with valid email/password
- Login with invalid email
- Login with invalid password
- Log out after login

Users management

- Account creation
  - user can create an account using the signup form
  - user can't create an account without a name
  - user can't create an account with invalid email
  - user can't create an account with used email
  - user can't create an account with weak password
- As authenticated user
  - user can't access the login form
  - user see his profile
  - user see other user's profiles
  - user can update his own profile information
  - user can delete his own account [TODO]
- As unautenticated user
  - guest can only access login and signup paths

Posts management

- As Authenticated user
  - User can create post
  - User can update his posts
  - User can delete his posts
  - User can't update other's posts
  - User can't delete other's posts
- As Unauthenticated user
  - Guests can't create new posts
  - Guests can't update any posts
  - Guest can't check the index of posts

Comments management
- Authenticated User
  - User can comment posts
  - User can remove his comments
  - User can update his comments
  - User can't edit other user's comments
  - User can't remove other user's comments

Likes management
- Au authenticated User
  - User can like his posts
  - User can like other's posts
  - User can't like a post more than two times
  - User can revoke a like from a post that his liked

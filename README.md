## Integration Tests

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
  - Guests can't delete any posts
  - Guest can't check the index of posts

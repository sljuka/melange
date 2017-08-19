# Melange

This Phoenix project is used as a PoC of an architectural pattern.
End result is to divide business logic from web framework, and make the
application more maintainable but also easily reusable on different platforms...

Check out this blogpost for relevant information:
TODO: [Insert blog url]

## Setup intructions

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Features

Since this is a PoC, business logic is pretty simple for now:
  * System allows new users to register
  * System allows signed users to create groups
  * System allows signed users to request to join a groups
  * System allows signed users to invite users to join a group
  * System allows users to accept request joins/invitations
  * System allows transferring group ownership from one member to another

... these are main features

Business logic is implemented inside Phoenix 1.3 contexts.

It is intended to be used as a standard web, but also as a Graphql api.
Graphiql is a handy tool for testing out Graphql queries, it is available
on [`localhost:4000/graphiql`](http://localhost:4000/graphiql) from the browser.

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


# TODO feature list

- [x] User registration
- [x] User authentication
- [x] Group creation
- [x] GroupRole assignment
- [ ] ...

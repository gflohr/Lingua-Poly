- provider should be a session, not a user property
- Catch oauth errors on the server-side and send a proper redirect with
  a generic error message.
- use a consistent naming convention for the methods in the user service
  (probably better the more verbose version with "user" in the name so
  that grep works better)
- RESTClient service cannot log
- either do not authenticate /logout (probably better) or make the frontend
  ignore errors when calling the endpoint
- rewrite idle action
- controller logger should use SmartLogger
- do not update session but delete and insert it
- currently the user is part of the auth state but should be part of the
  user state.
- distinct endpoint for username availability so that there are no 404s
  in normal operation

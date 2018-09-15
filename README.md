# Lingua-Poly

Lingua-Poly is a system to disassemble human languages.

## Status

Pre-alpha, incomplete.

The first language being implemented is Finnish. Currently, verbs of
conjguation type 1 ("asua", "nukkua", "kulkea", etc.) can be conjugated.

## Setup

### Database

You will need an instance of a [PostgreSQL](https://www.postgresql.org/)
(version 9 or better) database up and running. Create a database 'linguapoly':

```bash
$ createdb linguapoly
```

This assumes that your PostgreSQL server is running on your local machine.
Get more information with `man createdb` if that assumption is wrong or there
is an error.

### Populate Database

You can initialize the database like  this:

```bash
$ psql linguapoly <schema.sql
```

Replace "linguapoly" with the name of the  database created above. Run the
command in the root directory of this project.

### Configuration

You need a minimal configuration file `api.conf.yaml` in [YAML](http://yaml.org/)
format in the current directory:

```yaml
database:
    dbname: linguapoly
    user: nobody
    pass: mysecretpassword
session:
    timeout: 600
prefix: /api/v1
```

Make sure that the configured database user has sufficient privileges to read
and write all tables in the database.

### Manually Create Passwords

You can manually create a password (digest) with this one-liner:

```bash
$ perl -MDigest::SHA -le 'print "{SHA512}" . Digest::SHA::sha512_hex("admin") . "="'
{SHA512}c7ad44cbad762a5da0a452f9e854fdc1e0e7a52a38015f23f3eab1d80b931dd472634dfac71cd34ebc35d16ab7fb8a90c81f975113d6c7538dc69dd8de9077ec=
```

Replace "admin" with a cleartext password.

You can assign this password to `user@example.com` like this:

```bash
$ echo "UPDATE users SET password = '{SHA512}c7ad44cbad762a5da0a452f9e854fdc1e0e7a52a38015f23f3eab1d80b931dd472634dfac71cd34ebc35d16ab7fb8a90c81f975113d6c7538dc69dd8de9077ec=' WHERE email = 'user@example.com'
```

Replace "user@example.com" with the user's login, and the part beginning with
`{SHA512}` with the output of the above one-liner.

## Copyright

Copyright (C) 2018 Guido Flohr  <guido.flohr@cantanea.com>, all rights
reserved.

This library is free software. It comes without any warranty, to
the extent permitted by applicable law. You can redistribute it
and/or modify it under the terms of the Do What the Fuck You Want
to Public License, Version 2, as published by Sam Hocevar. See
http://www.wtfpl.net/ for more details.

# I Write Docs

Documenting for your application, using GIT repository.

Work in progress, use it with on your own risk.

## Features
- GIT repository as warehouse for your documentation
- Tags for versioning
- Diff for each files between versions (WIP)
- Include/exclude specific parts of file in special blocks (for example, open/closed documentation in one place)

## Instalation
Add it to your `Gemfile`:

`gem 'i-write-docs', github: 'MyceliumGear/i-write-docs'`

And mount engine in `routes.eb`:

`mount IWriteDocs::Engine, as: '/docs'`

Gem depended several native extensions.

## Using
Place documentation repository somewhere. Provide path to it in environment variable `DOCUMENTATION_PATH`.

## Copyright

Copyright (c) 2015 Dmitry Tymchuk. See LICENSE.txt for
further details.

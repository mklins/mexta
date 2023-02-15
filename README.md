# Spendify

--------

## Getting Started


### Requirements:

In order to set up and run the project on your local machine you need this
software installed:

1. Ruby
2. PostgreSQL
3. Node.js and yarn

--------

### Installation:

**All the instructions are written for Linux(Ubuntu) system,
on other systems some of them could be irrelevant!**

#### Step 1

Clone the project from this repository to your projects folder:

```shell
$ cd <your_projects_root_folder>
$ git clone git@github.com:mklins/spendify.git
$ cd spendify
```

#### Step 2

Install one of the tools for ruby version management (if you don't have it yet) -
[RVM](https://rvm.io/rvm/install) or [rbenv](https://github.com/rbenv/rbenv#installation)

Install Ruby 3.2.1 version:

with RVM:

```shell
$ rvm install 3.2.1
$ rvm use 3.2.1
```

or with rbenv:

```shell
$ rbenv install 3.2.1
$ rbenv local 3.2.1
```

#### Step 3

Install PostgreSQL database.

- [Instructions for Ubuntu/Debian](https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-22-04-quickstart)
- [Instructions for Fedora](https://docs.fedoraproject.org/en-US/quick-docs/postgresql/)
- [Instructions for MacOS](https://sqlpad.io/tutorial/postgres-mac-installation)

In order to prevent possible problems with `rake db` or `rails db` commands
when applying changes to the database, do this:

1. Open the postgres config file with your text editor (nano, vim etc...)

```shell
$ sudo <text_editor> /etc/postgresql/<version>/main/pg_hba.conf
```

2. Find the line with content like `local all postgres peer`

3. Comment it out and paste this line below:

```
local all all md5
```

4. Restart your Postgres server:

```shell
$ sudo systemctl restart postgresql.service
```

#### Step 4

Install [NVM](https://github.com/nvm-sh/nvm#installing-and-updating),
if you don't have it yet.

With NVM, install Node.js 18.14 (LTS) version:

```shell
$ nvm install 18.14
```

After Node.js install, enable yarn:

```shell
$ corepack enable
```

#### Step 5

Install [bundler](https://bundler.io/), if you don't have it yet:

```shell
$ gem install bundler
```

Run bundler to install the project's dependencies:

```shell
$ bundle
```

#### Step 6

Create the database configuration file from sample and modify it according to your environment:

```shell
$ cp database.yml.sample database.yml
```

#### Step 7

Create, migrate and seed the database:

```shell
$ rake db:create
$ rake db:migrate
$ rake db:seed
```

**Congratulations, you have set the project up successfully!**

--------

## Usage

#### Server

```shell
$ rails s # start up
[ctrl + c] # shut down
```

When up, the project is available on
[http:://localhost:3000](http:://localhost:3000).

#### Console

```shell
$ rails c # start up
> exit # and hit Enter in the console itself to shut down
```

#### Tests

```shell
$ rspec
```

#### Code style

```shell
$ rubocop
```

---------------

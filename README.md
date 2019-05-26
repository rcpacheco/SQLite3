# SQLite3
[![Build Status](https://travis-ci.org/juliendelplanque/SQLite3.svg?branch=master)](https://travis-ci.org/juliendelplanque/SQLite3)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Pharo version](https://img.shields.io/badge/Pharo-6.1-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-7.0-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo version](https://img.shields.io/badge/Pharo-8.0-%23aac9ff.svg)](https://pharo.org/download)

A clean SQLite FFI binding for Pharo for those who only want to use SQLite easily without any overlayer.

# Install

```st
Metacello new
	repository: 'github://juliendelplanque/SQLite3/src';
	baseline: 'SQLite3';
	load
```

# Documentation
This section explains how to use SQLite3 in Pharo.

## Creating a connection
The first step is to create a connection to a SQLite3 database.
There are two possibilities:
- Create a database stored in memory (i.e. the RAM)

```st
connection := SQLite3Connection memory.
```

- Create a database stored on the file system.

```st
connection := SQLite3Connection on: FileLocator desktop / 'mydatabase.db'.
```

## Opening a connection
Either memory and file databases need to be opened before further use.
This can be achieve using `#open` message.

```st
connection open.
```

## Executing a simple query
Once the connection is open, it is possible to execute an arbitrary number of queries on it.
In this tutorial, we create a table named `'person'`.
This table has 3 columns:
- `id` of type `INTEGER` being the primary key of the table. Additionally, this column is autoincremented which means that if a row is inserted without specifying the value for `id` column, it will automatically gets the value resulting of the query `SELECT MAX(id) + 1 FROM person;`
- `name` of type `TEXT` storing the name of a person as a string of arbitrary length
- `age` of type `INTEGER` storing the age of a person as an integer

```st
connection execute: 'CREATE TABLE person(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	age INTEGER NOT NULL
);'.
```

## Executing a parametrized query
It is possible to inject parameters into a query template.
Such query template are called "prepared statements".
These parameters can be described in two ways in the query string: per index in an array of argument or per parameter name in a dictionary of arguments.

### Parameterize per index
The interrogation mark allows to inject parameters from an array of arguments.
If interrogation marks are written as is, the parameters are taken in the order they are provided by the array of arguments:

```st
connection execute: 'INSERT INTO person(name,age) VALUES (?, ?);' value: 'Julien' value: 24.
```

If the interrogation mark is followed by an integer, the parameter is taken at the corresponding index of the array of arguments:

```st
connection execute: 'INSERT INTO person(name,age) VALUES (?2, ?1);' value: 25 value: 'Cyril'.
```

### Parameterize per name
Parameters can be referenced through a name, either prefixed by `:` or `@` character.
The two following examples are equivalent:

```st
connection execute: 'INSERT INTO person(name,age) VALUES (:name, :age);' with: { 
	':name' -> 'Guillaume'.
	':age' -> 30 } asDictionary.
```

```st
connection execute: 'INSERT INTO person(name,age) VALUES (@name, @age);' with: { 
	'@name' -> 'Guillaume'.
	'@age' -> 30 } asDictionary.
```

## Closing a connection
Either memory and file databases need to be closed when no longer needed.
This can be achieve using `#close` message.

```st
connection close.
```

# Acknowledgements
This project is a fork of the 'UDBC-SQLite-Base' package of [Pharo-UDBC](https://github.com/astares/Pharo-UDBC) project which itself seems to have forked part of the code of [Garage](https://github.com/pharo-rdbms/garage).

Wherever this code comes from originally, thanks to all the contributors who enhanced this project over time.

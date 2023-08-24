/* Database schema to keep the structure of entire database. */

CREATE TABLE animals(
  id integer,
  name text,
  date_of_birth date,
  escape_attempts integer,
  neutered boolean,
  weight_kg decimal,
  species text
);

ALTER TABLE animals ADD species text;

-- Create a table named owners with the following columns:

--     id: integer (set it as autoincremented PRIMARY KEY)
--     full_name: string
--     age: integer


CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name TEXT,
  age INTEGER
);

-- Create a table named species with the following columns:

--     id: integer (set it as autoincremented PRIMARY KEY)
--     name: string


CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name TEXT
);



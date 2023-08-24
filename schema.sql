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


CREATE TABLE owners(
  id integer PRIMARY KEY AUTOINCREMENT,
  full_name text,
  age integer
);

-- Create a table named species with the following columns:

--     id: integer (set it as autoincremented PRIMARY KEY)
--     name: string


CREATE TABLE species(
  id integer PRIMARY KEY AUTOINCREMENT,
  name text
);

-- Modify animals table:

--     Make sure that id is set as autoincremented PRIMARY KEY
--     Remove column species
--     Add column species_id which is a foreign key referencing species table
--     Add column owner_id which is a foreign key referencing the owners table
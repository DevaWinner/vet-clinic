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


-- Modify animals table:

--     Make sure that id is set as autoincremented PRIMARY KEY
--     Remove column species
--     Add column species_id which is a foreign key referencing species table
--     Add column owner_id which is a foreign key referencing the owners table


ALTER TABLE animals ADD COLUMN new_id serial;

UPDATE animals SET new_id = id;

ALTER TABLE animals DROP CONSTRAINT animals_pkey;
ALTER TABLE animals DROP COLUMN id;

ALTER TABLE animals RENAME COLUMN new_id TO id;

ALTER TABLE animals ADD PRIMARY KEY (id);

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INTEGER REFERENCES species(id);

ALTER TABLE animals ADD COLUMN owner_id INTEGER REFERENCES owners(id);



-- Create a table named vets with the following columns:
    -- id: integer (set it as autoincremented PRIMARY KEY)
    -- name: string
    -- age: integer
    -- date_of_graduation: date

CREATE TABLE vets (
  id SERIAL PRIMARY KEY,
  name TEXT,
  age INTEGER,
  date_of_graduation DATE
);


-- There is a many-to-many relationship between the tables species and vets: a vet can specialize in multiple species, and a species can have multiple vets specialized in it. Create a "join table" called specializations to handle this relationship.

CREATE TABLE specializations (
  vet_id INTEGER REFERENCES vets(id),
  species_id INTEGER REFERENCES species(id),
  PRIMARY KEY (vet_id, species_id)
);


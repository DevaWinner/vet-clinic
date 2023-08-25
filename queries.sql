/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE name <> 'Gabumon';

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


BEGIN TRANSACTION;

UPDATE animals SET species = 'unspecified';

SELECT * FROM animals;

ROLLBACK;

SELECT * FROM animals;


BEGIN TRANSACTION;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

SELECT * FROM animals;

COMMIT;

SELECT * FROM animals;


BEGIN TRANSACTION;

DELETE FROM animals;

SELECT * FROM animals;

ROLLBACK;

SELECT * FROM animals;


BEGIN TRANSACTION;

DELETE FROM animals WHERE date_of_birth > '2022-01-01';

SAVEPOINT savepoint_1;

UPDATE animals SET weight_kg = weight_kg * -1;

ROLLBACK TO SAVEPOINT savepoint_1;

UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

COMMIT;


SELECT COUNT(*) FROM animals;

SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

SELECT AVG(weight_kg) FROM animals;

SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;

SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;


-- Write queries (using JOIN) to answer the following questions:

--     What animals belong to Melody Pond?

SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';


--     List of all animals that are pokemon (their type is Pokemon).

SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';


--     List all owners and their animals, remember to include those that don't own any animal.

SELECT o.full_name, COALESCE(array_agg(a.name), ARRAY[]::text[]) AS owned_animals
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.id, o.full_name;


--     How many animals are there per species?

SELECT s.name, COUNT(a.id)
FROM species s
JOIN animals a ON s.id = a.species_id
GROUP BY s.id, s.name;


--     List all Digimon owned by Jennifer Orwell.

SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
JOIN species s ON a.species_id = s.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';


--     List all animals owned by Dean Winchester that haven't tried to escape.

SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;


--     Who owns the most animals?

SELECT o.full_name, COUNT(a.id)
FROM owners o
JOIN animals a ON o.id = a.owner_id
GROUP BY o.id, o.full_name
ORDER BY COUNT(a.id) DESC
LIMIT 1;


-- Write queries to answer the following:

    --  Who was the last animal seen by William Tatcher?
    SELECT a.name AS animal_name
    FROM visits v
    JOIN animals a ON v.animal_id = a.id
    JOIN vets vt ON v.vet_id = vt.id
    WHERE vt.name = 'William Tatcher'
    ORDER BY v.visit_date DESC
    LIMIT 1;

  --  How many different animals did Stephanie Mendez see?
    SELECT COUNT(DISTINCT a.id)
    FROM visits v
    JOIN animals a ON v.animal_id = a.id
    JOIN vets vt ON v.vet_id = vt.id
    WHERE vt.name = 'Stephanie Mendez';

    --  List all vets and their specialties, including vets with no specialties.
    SELECT vt.name, COALESCE(array_agg(s.name), ARRAY[]::text[]) AS specialties
    FROM vets vt
    LEFT JOIN vet_specialties vs ON vt.id = vs.vet_id
    LEFT JOIN specialties s ON vs.specialty_id = s.id
    GROUP BY vt.id, vt.name;

     --  List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
    SELECT a.name AS animal_name
    FROM visits v
    JOIN animals a ON v.animal_id = a.id
    JOIN vets vt ON v.vet_id = vt.id
    WHERE vt.name = 'Stephanie Mendez'
    AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

    --  What animal has the most visits to vets?
    SELECT a.name AS animal_name, COUNT(*) AS visit_count
    FROM visits v
    JOIN animals a ON v.animal_id = a.id
    GROUP BY a.name
    ORDER BY visit_count DESC
    LIMIT 1;

    --  Who was Maisy Smith's first visit?
    SELECT a.name AS animal_name, MIN(v.visit_date) AS first_visit_date
    FROM visits v
    JOIN animals a ON v.animal_id = a.id
    JOIN vets vt ON v.vet_id = vt.id
    WHERE vt.name = 'Maisy Smith'
    GROUP BY a.name;


    --  Details for most recent visit: animal information, vet information, and date of visit.
    SELECT a.name AS animal_name, v.visit_date, ve.name AS vet_name
    FROM visits v
    JOIN animals a ON v.animal_id = a.id
    JOIN vets ve ON v.vet_id = ve.id
    ORDER BY v.visit_date DESC
    LIMIT 1;



    --  How many visits were with a vet that did not specialize in that animal's species?
    SELECT COUNT(*) AS mismatched_specialty_count
    FROM visits v
    JOIN animals a ON v.animal_id = a.id
    JOIN vets ve ON v.vet_id = ve.id
    LEFT JOIN specializations s ON ve.id = s.vet_id AND a.species_id = s.species_id
    WHERE s.species_id IS NULL;


    --  What specialty should Maisy Smith consider getting? Look for the species she gets the most.
    SELECT s.name AS specialty_name, COUNT(*) AS visit_count
    FROM visits v
    JOIN animals a ON v.animal_id = a.id
    JOIN vets ve ON v.vet_id = ve.id
    JOIN specializations sp ON ve.id = sp.vet_id
    JOIN species s ON sp.species_id = s.id
    WHERE a.name = 'Maisy Smith'
    GROUP BY s.name
    ORDER BY visit_count DESC
    LIMIT 1;
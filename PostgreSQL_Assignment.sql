-- Active: 1768835019972@@127.0.0.1@5432@conservation_db@public

CREATE table rangers(
    ranger_id SERIAL PRIMARY KEY,
    ranger_name VARCHAR(50),
    region VARCHAR(50)
)

alter TABLE rangers 
RENAME COLUMN  ranger_name TO name;


CREATE table species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50),
    scientific_name VARCHAR(50),
    discovery_date DATE,
    conservaton_status VARCHAR(50)
)

create Table sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id int REFERENCES rangers(ranger_id),
    species_id int REFERENCES species(species_id),
    sighting_time TIMESTAMP,
    location VARCHAR(50),
    notes VARCHAR(50)
)


insert into rangers(ranger_name, region) values 
('John Smith', 'Northwest'),
('Alice Green', 'Northern Hills'),
('Bob White ', 'River Delta '),
('Carol King  ', 'Mountain Range'),
('Eve Brown', 'Southwest'),
('Frank Davis', 'Northern Hills'),
('Grace Miller', 'River Delta'),
('Henry Clark', 'Mountain Range'),
('Ivy Taylor', 'Southwest'),
('Jack Wilson', 'Northern Hills'),
('Kate Anderson', 'River Delta');

INSERT INTO species(common_name, scientific_name, discovery_date, conservaton_status) VALUES
('Lion', 'Panthera leo', '2000-01-01', 'Endangered'),
('Tiger', 'Panthera tigris', '2001-02-02', 'Endangered'),
('Elephant', 'Elephas maximus', '2002-03-03', 'Endangered'),
('Giraffe', 'Giraffa camelopardalis', '2003-04-04', 'Endangered'),
('Panda', 'Ailurus fulgens', '2004-05-05', 'Endangered'),
('Jaguar', 'Panthera onca', '2005-06-06', 'Endangered'),
('Koala', 'Phascolarctos cinereus', '2006-07-07', 'Endangered'),
('Polar Bear', 'Ursus maritimus', '2007-08-08', 'Endangered'),
('Zebra', 'Equus quagga', '2008-09-09', 'Endangered'),
('Hippopotamus', 'Hippopotamus amphibius', '2009-10-10', 'Endangered');

INSERT INTO sightings(sighting_id,species_id,ranger_id,location,sighting_time,notes) VALUES 
(1, 1, 1, 'Mountain Range', '2023-01-01 10:00:00', 'Lion spotted near the mountain range'),
(2, 2, 2, 'River Delta', '2023-02-02 11:00:00', 'Tiger seen in the river delta'),
(3, 3, 3, 'Northern Hills', '2023-03-03 12:00:00', 'Elephant spotted in the northern hills'),
(4, 3, 4, 'Southwest', '2023-04-04 13:00:00', 'Giraffe seen in the southwest'), 
(5, 5, 5, 'Mountain Range', '2023-05-05 14:00:00', 'Panda spotted in the mountain range'),
(6, 8, 6, 'River Delta', '2023-06-06 15:00:00', 'Jaguar seen in the river delta'),
(7, 7, 7, 'Northern Hills', '2023-07-07 16:00:00', 'Koala spotted in the northern hills'),
(8, 7, 8, 'Southwest', '2023-08-08 17:00:00', 'Polar Bear seen in the southwest'),
(9, 3, 9, 'Mountain Range', '2023-09-09 18:00:00', 'Zebra spotted in the mountain range'),  
(10, 10, 10, 'River Delta', '2023-10-10 19:00:00', 'Hippopotamus seen in the river delta'),
(11, 1, 1, 'Mountain Range', '2023-01-01 10:00:00', 'Lion spotted near the mountain range'),
(12, 2, 2, 'River Delta', '2023-02-02 11:00:00', 'Tiger seen in the river delta'),
(13, 3, 3, 'Northern Hills', '2023-03-03 12:00:00', 'Elephant spotted in the northern hills'),
(14, 3, 4, 'Southwest', '2023-04-04 13:00:00', 'Giraffe seen in the southwest'), 
(15, 5, 5, 'Mountain Range', '2023-05-05 14:00:00', 'Panda spotted in the mountain range');


-- -problem 1
INSERT INTO rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- -problem 2

SELECT count(DISTINCT species_id) FROM sightings


-- -problem 3

SELECT * from sightings
where location ILIKE '%pass%'

-- -problem 4

SELECT name, count(sighting_id) as total_sightings FROM rangers
JOIN sightings USING (ranger_id)
GROUP BY NAME


-- -problem 5
SELECT common_name FROM species
LEFT JOIN sightings USING (species_id)
WHERE sighting_id IS NULL


-- -Problem 6
SELECT common_name, sighting_time,name from sightings
JOIN species USING (species_id)
JOIN rangers USING (ranger_id)
ORDER BY sighting_time DESC
LIMIT 2

-- -problem 7
update species
set conservation_status = 'Historic'
where extract(year from discovery_date) < 1800


-- -problem 8

SELECT sighting_id, 
CASE 
    WHEN extract(HOUR FROM sighting_time) < 12 THEN 'Morning'
    when extract(HOUR FROM sighting_time) BETWEEN 12 and 17 THEN 'Afternoon'
    ELSE 'Evening'
    END as time_of_day
 from sightings;


-- problem 9
DELETE FROM rangers
where not EXISTS (
    SELECT 1
    from sightings
    WHERE sightings.ranger_id = rangers.ranger_id
   
);

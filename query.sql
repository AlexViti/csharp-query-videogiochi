-- ------ Query su singola tabella
-- ********************************

-- 1- Selezionare tutte le software house americane (3)

SELECT * FROM software_houses WHERE country = 'United States';

-- 2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)

SELECT * FROM players WHERE city = 'Rogahnland';

-- 3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)

SELECT * FROM players WHERE name LIKE '%a';

-- 4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)

SELECT * FROM reviews WHERE player_id = 800;

-- 5- Contare quanti tornei ci sono stati nell'anno 2015 (9)

SELECT COUNT(*) AS [tournament in 2015] FROM tournaments WHERE year = 2015;

-- 6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)

SELECT * FROM awards WHERE description like '%facere%';

-- 7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)

SELECT DISTINCT videogame_id FROM category_videogame WHERE category_id = 2 OR category_id = 6;

-- 8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)

SELECT * FROM reviews WHERE rating BETWEEN 2 AND 4;

-- 9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)

SELECT * FROM videogames WHERE YEAR(release_date) = 2020;

-- 10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da stelle, mostrandoli una sola volta (443)

SELECT DISTINCT videogame_id FROM reviews WHERE rating = 5;
 
-- *********** BONUS ***********
-- 
-- 11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3)

SELECT COUNT(*) AS review_number, AVG(rating) AS avg_rating FROM reviews WHERE videogame_id = 412;
-- 
-- 12- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)

SELECT COUNT(*) AS [videogames released in 2018 by Nintendo] FROM videogames WHERE YEAR(release_date) = 2018 AND software_house_id = 1; 

-- ------ Query con group by
-- **************************************************

-- 1- Contare quante software house ci sono per ogni paese (3)

SELECT COUNT(*) AS [software houses], country FROM software_houses GROUP BY country ORDER BY [software houses] DESC;

-- 2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)

SELECT videogame_id, COUNT(*) AS [reviews number] FROM reviews GROUP BY videogame_id;

-- 3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)

SELECT pegi_label_id, COUNT(*) AS [number of videogames] FROM pegi_label_videogame GROUP BY pegi_label_id;

-- 4- Mostrare il numero di videogiochi rilasciati ogni anno (11)

SELECT YEAR(release_date) AS [year], COUNT(*) AS [videogames number] FROM videogames GROUP BY YEAR(release_date);

-- 5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)

SELECT device_id, COUNT(*) AS videogames FROM device_videogame GROUP BY device_id;

-- 6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)

SELECT videogame_id, AVG(CAST(rating AS DECIMAL(1,0))) AS ratingAVG FROM reviews GROUP BY videogame_id ORDER BY ratingAVG DESC;

-- ------ Query con join
-- ********************************************************************

-- 1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)

SELECT DISTINCT p.id, p.name, p.lastname, p.city FROM reviews AS r INNER JOIN players AS p ON r.player_id = p.id;

-- 2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)

SELECT DISTINCT v.id, v.name
FROM tournaments as t
INNER JOIN tournament_videogame as tv ON t.id = tv.tournament_id
INNER JOIN videogames as v ON tv.videogame_id = v.id
WHERE t.year = 2016;


-- 3- Mostrare le categorie di ogni videogioco (1718)

SELECT v.id AS videogame_id, v.name AS videogame_name, v.release_date, c.id AS category_id, c.name AS category_name
FROM videogames AS v
INNER JOIN category_videogame AS cv ON v.id = cv.videogame_id
INNER JOIN categories AS c ON cv.category_id = c.id;

-- 4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)

SELECT DISTINCT sh.id, sh.name, sh.city, sh.country
FROM software_houses AS sh
INNER JOIN videogames AS v ON sh.id = v.software_house_id
WHERE YEAR(v.release_date) > 2020;

-- 5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)

SELECT a.name, av.year, v.name AS videogame, sh.name AS [software house]
FROM award_videogame AS av
INNER JOIN videogames AS v ON av.videogame_id = v.id
INNER JOIN software_houses AS sh ON v.software_house_id = sh.id
INNER JOIN awards AS a ON av.award_id = a.id;

-- 6- Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)

SELECT DISTINCT v.id, c.name, pl.name
FROM categories AS c
INNER JOIN category_videogame AS cv ON c.id = cv.category_id
INNER JOIN pegi_label_videogame AS plv ON cv.videogame_id = plv.videogame_id
INNER JOIN pegi_labels AS pl ON plv.pegi_label_id = pl.id
INNER JOIN reviews AS r ON plv.videogame_id = r.videogame_id
INNER JOIN videogames AS v ON r.videogame_id = v.id
WHERE r.rating >= 4;

-- 7- Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)

SELECT DISTINCT v.id, v.name
FROM videogames AS v
INNER JOIN tournament_videogame AS tv ON v.id = tv.videogame_id
INNER JOIN tournaments AS t ON tv.tournament_id = t.id
INNER JOIN player_tournament AS pt ON t.id = pt.tournament_id
INNER JOIN players AS p ON pt.player_id = p.id
WHERE p.name LIKE 'S%';

-- 8- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)

SELECT t.city
FROM tournaments AS t
INNER JOIN tournament_videogame AS tv ON t.id = tv.tournament_id
INNER JOIN award_videogame AS av ON tv.videogame_id = av.videogame_id
INNER JOIN awards AS a ON av.award_id = a.id
WHERE a.name = 'Gioco dell''anno' AND av.year = 2018;

-- 9- Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)

SELECT DISTINCT p.id, p.name, p.lastname, p.city
FROM players AS p
INNER JOIN player_tournament AS pt ON p.id = pt.player_id
INNER JOIN tournaments AS t ON pt.tournament_id = t.id
INNER JOIN tournament_videogame AS tv ON t.id = tv.tournament_id
INNER JOIN videogames AS v ON tv.videogame_id = v.id
INNER JOIN award_videogame AS av ON v.id = av.videogame_id
INNER JOIN awards AS a ON av.award_id = a.id
WHERE a.name = 'Gioco più atteso' AND t.year = 2019 AND av.year = 2018;

-- *********** BONUS ***********
-- 
-- 10- Selezionare i dati della prima software house che ha rilasciato un gioco, assieme ai dati del gioco stesso (software house id : 5)

SELECT sh.*, v.*
FROM videogames AS v
INNER JOIN software_houses AS sh ON v.software_house_id = sh.id
WHERE release_date =(
	SELECT MIN(release_date)
	FROM videogames
)

-- 11- Selezionare i dati del videogame (id, name, release_date, totale recensioni) con più recensioni (videogame id : 398)

SELECT v.id, v.name, v.release_date, r.totale_recensioni
FROM videogames AS v
INNER JOIN (
	SELECT videogame_id, COUNT(*) AS totale_recensioni
	FROM reviews
	GROUP BY videogame_id
) AS r ON v.id = r.videogame_id
WHERE r.totale_recensioni = (
	SELECT MAX(totale_recensioni)
	FROM (
		SELECT videogame_id, COUNT(*) AS totale_recensioni
		FROM reviews
		GROUP BY videogame_id
	) AS r2
)
-- 
-- 12- Selezionare la software house che ha vinto più premi tra il 2015 e il 2016 (software house id : 1)
-- 
-- 13- Selezionare le categorie dei videogame i quali hanno una media recensioni inferiore a 1.5 (10)
-- ```
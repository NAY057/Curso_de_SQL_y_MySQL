SELECT nationality, COUNT(book_id), 
SUM(IF(year < 1950, 1, 0)) AS "<1950" 
SUM(IF(year >= 1950 and year < 1990, 1, 0)) AS "<1990" 
SUM(IF(year >= 1990 and year < 2000, 1, 0)) AS "<2000"
SUM(IF(year >= 2000, 1, 0)) AS "<hoy"
FROM books AS b
JOIN authors AS a
ON a.author_id = b.author_id
WHERE a.nationality IS NOT NULL
GROUP BY nationality;


UPDATE authors
SET nationality = "GBR"
WHERE nationality = "ENG";
fait = LOAD '../resources/data/faits/' USING PigStorage(';') AS(annee:chararray, mois:chararray, departement:chararray, fait:chararray, nombre:int);
filtered_fait = FOREACH fait GENERATE annee, departement, nombre;
dept_group = GROUP filtered_fait BY (annee, departement);
sum = FOREACH dept_group GENERATE FLATTEN(group) AS (annee, departement), SUM(filtered_fait.nombre) AS sum_fait;
filtered_sum = FOREACH sum GENERATE departement, sum_fait;
sum_group = GROUP filtered_sum BY departement;
avg = FOREACH sum_group GENERATE group, AVG(filtered_sum.sum_fait) as average;
ordered_dept = ORDER avg BY average DESC;
first_dept = LIMIT ordered_dept 10;
STORE first_dept INTO 'sum_results' USING PigStorage (';');

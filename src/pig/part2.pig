fait = LOAD 'src/resources/data/faits/' USING PigStorage(';') AS(annee:chararray, mois:chararray, departement:chararray, fait:chararray, nombre:int);
filtered_fait = FOREACH fait GENERATE annee, departement, nombre;
dept_group = GROUP filtered_fait BY (annee, departement);
sum = FOREACH dept_group GENERATE FLATTEN(group) AS (annee, departement), SUM(filtered_fait.nombre) AS sum_fait;
pop = LOAD 'src/resources/data/pop/' USING PigStorage(';') AS(
annee:chararray, 
departement:chararray, 
ensemble_0_19:int,
ensemble_20_39:int,
ensemble_40_59:int,
ensemble_60_74:int,
ensemble_75_plus:int,
ensemble_total:int,
hommes_0_19:int,
hommes_20_39:int,
hommes_40_59:int,
hommes_60_74:int,
hommes_75_plus:int,
hommes_total:int,
femmes_0_19:int,
femmes_20_39:int,
femmes_40_59:int,
femmes_60_74:int,
femmes_75_plus:int,
femmes_total:int
);
filtered_pop = FOREACH pop GENERATE annee, departement, ensemble_total;
joined = JOIN sum BY (annee, departement), filtered_pop BY (annee, departement);
filtered_join = FOREACH joined GENERATE sum::annee AS annee, sum::departement AS departement, (float)sum::sum_fait AS sum_fait, (float)filtered_pop::ensemble_total AS population;
crime_ratio = FOREACH filtered_join GENERATE departement, sum_fait/population AS ratio;
ratio_group = GROUP crime_ratio BY departement;
avg = FOREACH ratio_group GENERATE group AS departement, AVG(crime_ratio.ratio)*100.0 as average_ratio;
ordered_dept = ORDER avg BY average_ratio DESC;
first_dept = LIMIT ordered_dept 10;
STORE first_dept INTO 'ratio_results' USING PigStorage (';');

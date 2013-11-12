pop = LOAD '/home/thomas/Pig/txt/Pop/pop-1975.txt' using PigStorage('\t') AS(departement:chararray,c11:int,c12:int,c13:int,c14:int,c15:int,Total1:int,c21:int,c22:int,c23:int,c24:int,c25:int,Total2:int,c31:int,c32:int,c33:int,c34:int,c35:int,Total3:int);
pop= filter pop by departement!='';
STORE pop INTO 'pop.bz';
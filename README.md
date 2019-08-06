# formacao-engenheiro-de-dados
 Atividades do curso Formação Engenheiro de Dados do Prof. Fernando Amaral

Uma VM Cloudera foi utilizada durante o curso.

# Modelagens relacionais e dimensionais (Postgresql)

$ sudo -u postgres psql

postgres=# \connect ed

ed=# select * from pg_tables where schemaname = 'relacional'; 

ed=# select * from pg_tables where schemaname = 'dimensional';

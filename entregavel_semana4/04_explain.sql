EXPLAIN ANALYZE
SELECT *
FROM ticket
WHERE id_veiculo = 15;

EXPLAIN ANALYZE
SELECT *
FROM ticket
WHERE id_vaga = 3;
-- Os índices foram criados corretamente, porém o EXPLAIN ANALYZE ainda apresenta Seq Scan
-- nas consultas realizadas. Isso ocorre porque as tabelas possuem uma quantidade relativamente 
-- pequena de registros, tornando a leitura sequencial da tabela uma opção mais eficiente para o SGBD.
-- Atualmente, o banco possui 18 veículos, 102 tickets e 30 vagas. Devido a esse baixo volume de dados, 
-- o PostgreSQL pode considerar que não há vantagem significativa em utilizar os índices durante as 
-- consultas analisadas.
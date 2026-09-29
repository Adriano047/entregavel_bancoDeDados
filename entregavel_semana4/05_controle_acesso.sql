CREATE ROLE role_admin;
CREATE ROLE role_consulta;

GRANT SELECT, INSERT, UPDATE, DELETE
ON veiculo, vaga, ticket
TO role_admin;

GRANT SELECT
ON veiculo, vaga, ticket
TO role_consulta;
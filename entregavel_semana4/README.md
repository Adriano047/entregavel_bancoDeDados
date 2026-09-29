# Banco de Dados — Sistema de Estacionamento

## 1. Estrutura do Banco de Dados

O banco de dados foi desenvolvido para representar um sistema de estacionamento, sendo composto pelas tabelas `veiculo`, `vaga` e `ticket`.

A tabela `veiculo` armazena os dados dos veículos cadastrados:

* `id`: utiliza `SERIAL` como identificador numérico gerado automaticamente e `PRIMARY KEY`, garantindo que cada veículo possua um identificador único.
* `nome_motorista`: utiliza `VARCHAR(100)` para armazenar o nome do motorista, com limite de 100 caracteres.
* `placa`: utiliza `VARCHAR(7)`, considerando o formato das placas dos veículos. A coluna também possui `NOT NULL` e `UNIQUE`, garantindo que toda placa seja informada e que não existam veículos cadastrados com a mesma placa.
* `modelo`: utiliza `VARCHAR(50)` para armazenar o modelo do veículo.
* `cor`: utiliza `VARCHAR(30)` para armazenar a cor do veículo.
* `criado_em`: utiliza `TIMESTAMPTZ` para armazenar a data e hora do cadastro, utilizando `CURRENT_TIMESTAMP` como valor padrão.

A tabela `vaga` representa as vagas disponíveis no estacionamento:

* `id`: utiliza `SERIAL` como identificador único e `PRIMARY KEY`.
* `numero_vaga`: utiliza `VARCHAR(3)` para representar o número da vaga e possui `UNIQUE`, evitando números de vaga duplicados.
* `andar`: utiliza `INT`, pois representa um número inteiro, e possui uma restrição `CHECK (andar > 0)` para impedir valores inválidos.
* `status`: utiliza o tipo `ENUM` `status_vaga`, criado especificamente para permitir apenas os valores `LIVRE` e `OCUPADA`. O valor padrão é `LIVRE`.

A tabela `ticket` registra a entrada e saída dos veículos:

* `id`: utiliza `SERIAL` e `PRIMARY KEY` para identificar cada ticket.
* `data_hora_entrada`: utiliza `TIMESTAMP` para registrar o momento de entrada do veículo e possui `NOT NULL`.
* `data_hora_saida`: utiliza `TIMESTAMP`, podendo permanecer nulo enquanto o veículo ainda estiver no estacionamento.
* `id_veiculo`: utiliza `INT` e funciona como chave estrangeira para a tabela `veiculo`.
* `id_vaga`: utiliza `INT` e funciona como chave estrangeira para a tabela `vaga`.

As chaves estrangeiras garantem a integridade dos relacionamentos entre veículos, vagas e tickets.

---

## 2. Estratégia de Indexação

Foram criados dois índices na tabela `ticket`:

```sql
CREATE INDEX id_ticket_veiculo
ON ticket(id_veiculo);

CREATE INDEX id_ticket_vaga
ON ticket(id_vaga);
```

O primeiro índice foi criado para otimizar consultas que buscam o histórico de tickets de um determinado veículo, utilizando a coluna `id_veiculo`.

O segundo índice foi criado para otimizar consultas relacionadas ao histórico de utilização de uma determinada vaga, utilizando a coluna `id_vaga`.

Para verificar se os índices estavam sendo utilizados pelo PostgreSQL, foi utilizado o comando `EXPLAIN ANALYZE`:

```sql
EXPLAIN ANALYZE
SELECT *
FROM ticket
WHERE id_veiculo = 15;

EXPLAIN ANALYZE
SELECT *
FROM ticket
WHERE id_vaga = 3;
```

Nas consultas realizadas, o PostgreSQL apresentou `Seq Scan` em vez de `Index Scan`.

Isso não significa que os índices foram criados incorretamente. Atualmente, o banco possui aproximadamente **18 veículos, 102 tickets e 30 vagas**. Devido ao baixo volume de registros, o PostgreSQL pode considerar que realizar uma leitura sequencial da tabela possui um custo menor do que utilizar o índice.

Portanto, os índices foram criados com o objetivo de melhorar consultas sobre `id_veiculo` e `id_vaga`, mas sua utilização efetiva depende da avaliação do otimizador de consultas do PostgreSQL.

---

## 3. Transações

Foram utilizadas transações para garantir que operações relacionadas ao registro de entrada de um veículo sejam executadas de forma conjunta.

No primeiro caso, quando um novo veículo é cadastrado, também é criado um ticket e o status da vaga é alterado para `OCUPADA`.

A operação é iniciada com:

```sql
BEGIN;
```

e finalizada com:

```sql
COMMIT;
```

Dessa forma, as operações realizadas dentro da transação são confirmadas em conjunto.

O processo consiste em:

1. Cadastrar o veículo;
2. Criar o ticket de entrada;
3. Alterar o status da vaga para `OCUPADA`;
4. Confirmar as alterações com `COMMIT`.

Também foi criada uma segunda transação para o caso em que o veículo já está cadastrado. Nesse cenário, não é necessário inserir novamente o veículo. É criado apenas um novo ticket associado ao veículo existente e a vaga utilizada é marcada como `OCUPADA`.

Essa abordagem garante que as operações relacionadas à entrada de um veículo sejam agrupadas em uma única transação.

---

## 4. Controle de Acesso

Para implementar o controle de acesso, foram criadas duas `ROLEs` com diferentes níveis de permissão:

```sql
CREATE ROLE role_admin;

CREATE ROLE role_consulta;
```

A `role_admin` recebe permissões para consultar, inserir, atualizar e excluir dados:

```sql
GRANT SELECT, INSERT, UPDATE, DELETE
ON veiculo, vaga, ticket
TO role_admin;
```

Já a `role_consulta` recebe somente permissão de leitura:

```sql
GRANT SELECT
ON veiculo, vaga, ticket
TO role_consulta;
```

Dessa forma, diferentes usuários podem receber diferentes níveis de acesso de acordo com suas funções.

A estratégia segue o princípio do **menor privilégio**, pois um usuário que necessita apenas consultar informações não precisa receber permissões para inserir, alterar ou excluir dados.

Também é possível utilizar `REVOKE` para remover uma permissão concedida anteriormente. Por exemplo:

```sql
REVOKE DELETE
ON ticket
FROM role_admin;
```

Nesse caso, a `role_admin` deixaria de possuir permissão para excluir registros da tabela `ticket`.

---

## 5. Resumo

O banco de dados utiliza tipos de dados e restrições adequados para representar as informações de veículos, vagas e tickets. Foram utilizadas `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `CHECK` e `ENUM` para garantir a integridade dos dados.

Foram criados índices sobre as colunas `id_veiculo` e `id_vaga` da tabela `ticket`, visando melhorar consultas relacionadas ao histórico de veículos e vagas. A utilização dos índices foi analisada através do `EXPLAIN ANALYZE`.

Também foram implementadas transações para agrupar operações relacionadas à entrada de veículos, garantindo que o cadastro do ticket e a alteração do status da vaga sejam tratados conjuntamente.

Por fim, foram criadas `ROLEs` com diferentes níveis de permissão, permitindo aplicar o princípio do menor privilégio no acesso às tabelas do banco de dados.

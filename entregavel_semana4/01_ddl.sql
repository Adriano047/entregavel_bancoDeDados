create table veiculo (
    id SERIAL PRIMARY KEY,
    nome_motorista varchar(100) not null,
	placa varchar(7) not null unique,
	modelo varchar(50) not null,
	cor varchar(30) not null,
    criado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
CREATE TYPE status_vaga AS ENUM ('LIVRE', 'OCUPADA');
create table vaga (
    id SERIAL PRIMARY KEY,
	numero_vaga varchar(3) UNIQUE,
	andar INT CHECK (andar > 0),
    status status_vaga DEFAULT 'LIVRE'
);

CREATE TABLE ticket (
    id SERIAL PRIMARY KEY,
    data_hora_entrada TIMESTAMP NOT NULL,
    data_hora_saida TIMESTAMP,
    id_veiculo INT NOT NULL,
    id_vaga INT NOT NULL,

    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id),
    FOREIGN KEY (id_vaga) REFERENCES vaga(id)
);
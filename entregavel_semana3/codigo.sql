create table veiculo (
	id int primary key,
	nome_motorista varchar(100) not null,
	placa varchar(7) not null unique,
	modelo varchar(50) not null,
	cor varchar(30) not null
);

create table vaga (
	id varchar(3) primary key,
	andar int
);

create table ticket (
	id uuid primary key,
	data_hora_entrada TIMESTAMP not null,
	data_hora_saida TIMESTAMP,
	id_veiculo int not null,
	id_vaga varchar(3) not null,
	
	foreign key (id_veiculo) references veiculo(id),
	foreign key (id_vaga) references vaga(id)
)
INSERT INTO veiculo (id, nome_motorista, placa, modelo, cor) VALUES (1,  'João Paulo', 'TRA7R24', 'Fiat 500', 'cinza');
INSERT INTO veiculo (id, nome_motorista, placa, modelo, cor) VALUES (2, 'Nelsinho Morro', 'BRA5Z52', 'BMW M3', 'preta');
INSERT INTO veiculo (id, nome_motorista, placa, modelo, cor) VALUES (3, 'Inacio Flavio', 'CAL4A12', 'UNO', 'prata');
INSERT INTO vaga (id, andar) VALUES ('B17', 2);
INSERT INTO vaga (id, andar) VALUES ('C03', 3);
INSERT INTO vaga (id, andar) VALUES ('A17', 1);
INSERT INTO ticket (id, data_hora_entrada , data_hora_saida, id_veiculo, id_vaga) VALUES ('550e8400-e29b-41d4-a716-446655440000', '2026-08-31 08:00:00', NULL, 1, 'A17');
INSERT INTO ticket (id, data_hora_entrada , data_hora_saida, id_veiculo, id_vaga) VALUES ('6ba7b810-9dad-41d1-80b4-00c04fd430c8', '2026-08-31 09:30:00', '2026-08-31 11:00:00', 2, 'C03');
INSERT INTO ticket (id, data_hora_entrada , data_hora_saida, id_veiculo, id_vaga) VALUES ('f47ac10b-58cc-4372-a567-0e02b2c3d479', '2026-08-31 10:00:00', NULL, 3, 'B17');

select t.id, v.placa, vg.id AS vaga, vg.andar, t.data_hora_entrada
FROM ticket t JOIN veiculo v ON t.id_veiculo = v.id
JOIN vaga vg ON t.id_vaga = vg.id;

select v.placa, v.modelo, t.data_hora_entrada
FROM ticket t JOIN veiculo v ON t.id_veiculo = v.id WHERE t.data_hora_saida IS NULL;




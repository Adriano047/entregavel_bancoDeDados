
-- Registrar o veiculo, criar o ticket e mudar o status de vaga para ocupada
BEGIN;
INSERT INTO veiculo(nome_motorista, placa, modelo, cor)
    VALUES('Tarsio Samir', 'ZXY1234', 'Civic', 'Preto')

RETURNING id; 
INSERT INTO ticket(data_hora_entrada, id_veiculo, id_vaga)
    VALUES(CURRENT_TIMESTAMP, 15, 3);

UPDATE vaga SET status = 'OCUPADA' WHERE id = 3;
COMMIT;

-- Caso o veiculo ja tenha sido registrado então apenas garantir em criar 
-- o titulo e mudar o status da vaga
BEGIN;
INSERT INTO ticket(data_hora_entrada, id_veiculo, id_vaga)
    VALUES(CURRENT_TIMESTAMP, 1, 5);

UPDATE vaga SET status = 'OCUPADA' WHERE id = 5;
COMMIT;


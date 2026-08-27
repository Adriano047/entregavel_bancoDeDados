CREATE TABLE Veiculo (
    id UUID PRIMARY KEY, 
    nome_motorista VARCHAR(100),
    placa VARCHAR(7),
    modelo VARCHAR(100),
    cor VARCHAR(100)

);
CREATE TABLE Vaga (
    codigo VARCHAR(5) PRIMARY KEY,
    andar INTEGER,
);

CREATE TABLE Ticket (
    id UUID PRIMARY KEY, 
    data_hora_entrada DATA NOT NULL
    data_hora_saida DATA,
    id_veiculo UUID,
    id_vaga UUID,
    FOREIGN KEY (id_veiculo) REFERENCES Veiculo(id)
    FOREIGN KEY (id_vaga) REFERENCES Vaga(id)

);
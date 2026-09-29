-- mostra o historico desse veiculo
CREATE INDEX id_ticket_veiculo
ON ticket(id_veiculo);

-- Mostra o historico da vaga
CREATE INDEX id_ticket_vaga
ON ticket(id_vaga);

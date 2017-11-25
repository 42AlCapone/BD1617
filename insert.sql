USE `4patas`;
-- Pesquisa das consultas de um médico entre duas datas
DELIMITER $$
CREATE PROCEDURE procedureInsertConsulta(IN dia DATE,IN horaInicio TIME,IN horaFim TIME, IN nome_m VARCHAR(64), IN nome_animal VARCHAR(64))
Begin
	SET @idMedico = (SELECT id_médico FROM médico WHERE médico.nome = nome_m);
    
	IF (SELECT COUNT(*) FROM Consulta AS C 
		WHERE (C.data_consulta = dia) 
	      AND (C.Médico_id_médico = @idMedico)
          AND (uMax(horaInicio,C.hora_início) < uMin(horaFim,C.hora_fim)))=0 
    THEN	
			SET @idConsulta = (SELECT MAX(id_consulta) FROM consulta)+1;
            SET @idAnimal = (SELECT id_animal FROM animal WHERE animal.nome = nome_animal);
			INSERT INTO Consulta(id_consulta, data_consulta, hora_início, hora_fim, preço, Médico_id_médico,Animal_id_animal) VALUES(@idConsulta,dia,horaInicio,horaFim,0,@idMedico,@idAnimal);
	
    END IF;
END; $$

DELIMITER //
create function uMax(val1 TIME, val2 TIME)
returns TIME
begin
  if (val1 > val2) then
    return val1;
  else return val2;
  end if;
end; //

DELIMITER !!
create function uMin(val1 TIME, val2 TIME)
returns TIME
begin
  if (val1 > val2) then
    return val2;
  else return val1;
  end if;
end; !!

SET @dia = '2017-08-08';
SET @horaInicio = '13:30';
SET @horaFim = '14:00';
SET @nome_m = 'Manuel Campos';
SET @nome_animal = 'Paquito';
CALL procedureInsertConsulta(@dia,@horaInicio,@horaFim,@nome_m,@nome_animal);

DROP PROCEDURE procedureInsertConsulta;
DROP FUNCTION uMax;
DROP FUNCTION uMin;
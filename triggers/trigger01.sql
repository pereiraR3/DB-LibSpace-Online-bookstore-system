-- Trigger elaborada para gerar automaticamente a agregação fraca 'Oferta'

CREATE OR REPLACE FUNCTION create_generate_oferta()
RETURNS TRIGGER AS $$
BEGIN 

	INSERT INTO oferta (id_livro, id_editora, preco)
		VALUES (NEW.id, NEW.id_editora, NEW.preco);

	RETURN NEW;

END;

$$ LANGUAGE plpgsql; 

CREATE TRIGGER create_generate_oferta
AFTER INSERT ON livro 
FOR EACH ROW 
EXECUTE PROCEDURE create_generate_oferta()
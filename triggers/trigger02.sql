-- Trigger elaborada para verificar a disponibilidade de um item, de acordo com a quantidade escolhida.

CREATE OR REPLACE FUNCTION verificar_disponibilidade_item()
RETURNS TRIGGER AS $$
BEGIN
	
    IF (SELECT quantidade FROM livro WHERE id = (SELECT id_livro FROM oferta WHERE id = NEW.id_oferta)) < NEW.quantidade THEN
        RAISE EXCEPTION 'Quantidade insuficiente no estoque';
    END IF;
    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificar_disponibilidade_item_trigger
BEFORE INSERT ON item_carrinho
FOR EACH ROW
EXECUTE FUNCTION verificar_disponibilidade_item();

-- TESTADO (100%)
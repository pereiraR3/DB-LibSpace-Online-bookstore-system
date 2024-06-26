-- Trigger elaborada para atualizar a quantidade de livro, de acordo com um pedido com status = True (ou seja, quando ocorre a venda)

CREATE OR REPLACE FUNCTION atualizar_quantidade_livro()
RETURNS TRIGGER AS $$
DECLARE
    items_vendidos CURSOR (key BIGINT) FOR SELECT * FROM item_carrinho ic WHERE ic.id_carrinho = key; 
    item RECORD;
    quantidade_vendida INTEGER;
    livro_id BIGINT;
BEGIN
    IF (TG_OP = 'UPDATE' AND NEW.status = TRUE) THEN
	
        OPEN items_vendidos(OLD.id_carrinho);
        LOOP
            FETCH items_vendidos INTO item;
            EXIT WHEN NOT FOUND;

            SELECT id_livro
            INTO livro_id
            FROM oferta o
            WHERE o.id = item.id_oferta;

            UPDATE livro
            SET quantidade = quantidade - item.quantidade
            WHERE id = livro_id;

        END LOOP;

        CLOSE items_vendidos;

    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualizar_quantidade_livro_trigger
AFTER UPDATE ON pedido
FOR EACH ROW
EXECUTE FUNCTION atualizar_quantidade_livro();

-- TESTADO (100%)
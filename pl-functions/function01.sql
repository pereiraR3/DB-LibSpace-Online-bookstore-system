-- Criação de pedido de acordo com a entidade carrinho com status TRUE

CREATE OR REPLACE FUNCTION create_generate_pedido(user_id BIGINT)
RETURNS VOID AS $$
DECLARE 
    all_items_carrinho CURSOR (key INTEGER) FOR SELECT * FROM item_carrinho WHERE id_carrinho = key; 
    id_carrinho_ativo INTEGER;
    valor_total MONEY := 0;
    item RECORD;
BEGIN 

    SELECT id 
    INTO id_carrinho_ativo
    FROM carrinho c
    WHERE c.id_user = user_id AND c.status = TRUE;

    FOR item IN all_items_carrinho(id_carrinho_ativo) LOOP 
        valor_total := valor_total + (item.preco_unitario * item.quantidade);
    END LOOP;

    INSERT INTO pedido (id_user, id_carrinho, valor_total)
    VALUES (user_id, id_carrinho_ativo, valor_total);

END;
$$ LANGUAGE plpgsql;

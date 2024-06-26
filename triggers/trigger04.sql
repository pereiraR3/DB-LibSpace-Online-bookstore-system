-- Trigger para verificar se o usuário já avaliou o livro ou não

CREATE OR REPLACE FUNCTION verificar_unicidade_avaliacao()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se o usuário já avaliou o livro
    IF EXISTS (SELECT 1 FROM avaliacao WHERE id_user = NEW.id_user AND id_livro = NEW.id_livro) THEN
        RAISE EXCEPTION 'Usuário já avaliou este livro';
    END IF;

    -- Verifica se o usuário comprou o livro
    IF NOT EXISTS (
        SELECT 1
        FROM pedido p
        JOIN item_carrinho ic ON p.id_carrinho = ic.id_carrinho
        JOIN oferta o ON ic.id_oferta = o.id
        WHERE p.id_user = NEW.id_user AND o.id_livro = NEW.id_livro AND p.status = TRUE 
    ) THEN
        RAISE EXCEPTION 'Usuário não comprou este livro';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificar_unicidade_avaliacao_trigger
BEFORE INSERT ON avaliacao
FOR EACH ROW
EXECUTE FUNCTION verificar_unicidade_avaliacao();


-- TESTADO (100%)
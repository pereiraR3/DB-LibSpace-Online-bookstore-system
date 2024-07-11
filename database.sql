-- Create table users
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    cpf CHAR(11) UNIQUE NOT NULL,
    nome VARCHAR(60) NOT NULL, 
    senha TEXT NOT NULL, 
    email VARCHAR(120) UNIQUE NOT NULL,
    url_foto TEXT,
    url_website TEXT, 
    bio VARCHAR(2000) NOT NULL,
    role VARCHAR(20) NOT NULL
);

-- Create table endereco
CREATE TABLE endereco (
    id BIGSERIAL PRIMARY KEY, 
    id_user BIGINT NOT NULL,
    cep BIGINT NOT NULL,
    rua VARCHAR(120) NOT NULL,
    numero SMALLINT NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    estado VARCHAR(60) NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    CONSTRAINT fk_user_in_endereco FOREIGN KEY (id_user) REFERENCES users (id) ON DELETE CASCADE
);

-- Create table editora
CREATE TABLE editora (
    id BIGSERIAL PRIMARY KEY, 
    nome VARCHAR(120) NOT NULL,
    cnpj BIGINT UNIQUE NOT NULL,
    cep BIGINT NOT NULL, 
    telefone CHAR(11) NOT NULL, 
    email VARCHAR(120) UNIQUE NOT NULL,
    url_website TEXT
);

-- Create table livro
CREATE TABLE livro (
    id BIGSERIAL PRIMARY KEY, 
    id_editora BIGINT,
    preco MONEY NOT NULL,   
    titulo VARCHAR(120) NOT NULL, 
    quantidade SMALLINT NOT NULL,
    autor_nome VARCHAR(160) NOT NULL,
    ano_publicacao SMALLINT NOT NULL,
    capa_url TEXT NOT NULL,
    CONSTRAINT fk_editora_in_livro FOREIGN KEY (id_editora) REFERENCES editora (id) ON DELETE SET NULL
);

-- Create table livro_fisico
CREATE TABLE livro_fisico (
    id_livro BIGINT PRIMARY KEY, 
    numero_de_paginas SMALLINT NOT NULL,
    peso SMALLINT NOT NULL,
    tipo_capa VARCHAR(60) NOT NULL,
    dimensao_altura SMALLINT NOT NULL,
    dimensao_largura SMALLINT NOT NULL,
    dimensao_profundidade SMALLINT NOT NULL,
    CONSTRAINT fk_livro_in_livrofisico FOREIGN KEY (id_livro) REFERENCES livro (id) ON DELETE CASCADE
);

-- Create table livro_ebook
CREATE TABLE livro_ebook (
    id_livro BIGINT PRIMARY KEY, 
    tamanho_arquivo SMALLINT NOT NULL,
    formato_arquivo VARCHAR(40) NOT NULL,
    CONSTRAINT fk_livro_in_livroebook FOREIGN KEY (id_livro) REFERENCES livro (id) ON DELETE CASCADE
);

-- Create table livro_audiobook
CREATE TABLE livro_audiobook (
    id_livro BIGINT PRIMARY KEY, 
    tamanho_arquivo SMALLINT NOT NULL,
    formato_arquivo VARCHAR(40) NOT NULL,
    narrador VARCHAR(120) NOT NULL, 
    url_download TEXT NOT NULL,
    CONSTRAINT fk_livro_in_livroaudiobook FOREIGN KEY (id_livro) REFERENCES livro (id) ON DELETE CASCADE
);

-- Create table avaliacao
CREATE TABLE avaliacao (
    id BIGSERIAL PRIMARY KEY, 
    id_user BIGINT NOT NULL,
    id_livro BIGINT NOT NULL, 
    nota SMALLINT CHECK(nota IN (0, 1, 2, 3, 4, 5)) NOT NULL,
    comentario VARCHAR(1000) NOT NULL,
    data_avaliacao DATE DEFAULT CURRENT_DATE, 
    CONSTRAINT fk_user_in_avaliacao FOREIGN KEY (id_user) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_livro_in_avaliacao FOREIGN KEY (id_livro) REFERENCES livro (id) ON DELETE CASCADE
);

-- Create table categoria
CREATE TABLE categoria (
    id BIGSERIAL PRIMARY KEY, 
    nome VARCHAR(60) NOT NULL
);

-- Create table genero
CREATE TABLE genero (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(60) NOT NULL
);

-- Create table livro_possui_categoria
CREATE TABLE livro_possui_categoria (
    id_livro BIGINT NOT NULL,
    id_categoria BIGINT NOT NULL,
    CONSTRAINT uq_idlivro_e_idcategoria UNIQUE (id_livro, id_categoria), 
    CONSTRAINT fk_livro_in_livro_possui_categoria FOREIGN KEY (id_livro) REFERENCES livro (id) ON DELETE CASCADE,
    CONSTRAINT fk_categoria_in_livro_possui_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id) ON DELETE CASCADE
);

-- Create table livro_possui_genero
CREATE TABLE livro_possui_genero (
    id_livro BIGINT NOT NULL,
    id_genero BIGINT NOT NULL,
    CONSTRAINT uq_idlivro_e_idgenero UNIQUE (id_livro, id_genero), 
    CONSTRAINT fk_livro_in_livro_possui_categoria FOREIGN KEY (id_livro) REFERENCES livro (id) ON DELETE CASCADE,
    CONSTRAINT fk_categoria_in_livro_possui_categoria FOREIGN KEY (id_genero) REFERENCES genero (id) ON DELETE CASCADE
);

-- Create table oferta
CREATE TABLE oferta (
    id BIGSERIAL PRIMARY KEY NOT NULL, 
    id_livro BIGINT NOT NULL,
    id_editora BIGINT DEFAULT NULL,
    preco MONEY NOT NULL,
    desconto DECIMAL(5, 2) DEFAULT 0,
    CONSTRAINT uq_livro_e_id UNIQUE (id, id_livro),
    CONSTRAINT fk_livro_in_oferta FOREIGN KEY (id_livro) REFERENCES livro (id) ON DELETE CASCADE,
    CONSTRAINT fk_editora_in_oferta FOREIGN KEY (id_editora) REFERENCES editora (id) ON DELETE SET NULL
);

-- Create table carrinho
CREATE TABLE carrinho (
    id BIGSERIAL PRIMARY KEY, 
    id_user BIGINT NOT NULL,
    data_criacao DATE DEFAULT CURRENT_DATE,
    status BOOLEAN DEFAULT TRUE NOT NULL,
    CONSTRAINT fk_user_in_carrinho FOREIGN KEY (id_user) REFERENCES users (id) ON DELETE CASCADE
);

-- Create table item_carrinho
CREATE TABLE item_carrinho (
    id BIGSERIAL PRIMARY KEY, 
    id_user BIGINT NOT NULL,
    id_oferta BIGINT NOT NULL,
    id_carrinho BIGINT NOT NULL,
    quantidade SMALLINT CHECK(quantidade > 0)NOT NULL,
    preco_unitario MONEY NOT NULL,
    CONSTRAINT uq_user_oferta_carrinho UNIQUE (id_user, id_oferta, id_carrinho),
    CONSTRAINT fk_user_in_item_carrinho FOREIGN KEY (id_user) REFERENCES users (id) ON DELETE CASCADE, 
    CONSTRAINT fk_oferta_in_item_carrinho FOREIGN KEY (id_oferta) REFERENCES oferta (id) ON DELETE CASCADE,
    CONSTRAINT fk_carrinho_in_item_carrinho FOREIGN KEY (id_carrinho) REFERENCES carrinho (id) ON DELETE CASCADE
);

-- Create table pedido
CREATE TABLE pedido (
    id BIGSERIAL PRIMARY KEY, 
    id_user BIGINT NOT NULL,
    id_carrinho BIGINT NOT NULL,
    valor_total MONEY NOT NULL,
    status BOOLEAN DEFAULT FALSE, 
    data_pedido DATE DEFAULT CURRENT_DATE, 
    CONSTRAINT fk_user_in_pedido FOREIGN KEY (id_user) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_carrinho_in_pedido FOREIGN KEY (id_carrinho) REFERENCES carrinho (id) ON DELETE CASCADE
);

-- Create table pagamento
CREATE TABLE pagamento (
    id BIGSERIAL PRIMARY KEY, 
    id_pedido BIGINT NOT NULL,
    valor MONEY NOT NULL,
    metodo_pagamento VARCHAR(100) NOT NULL,
    data_pagamento DATE DEFAULT CURRENT_DATE, 
    CONSTRAINT fk_pedido_in_pagamento FOREIGN KEY (id_pedido) REFERENCES pedido (id) ON DELETE CASCADE
);

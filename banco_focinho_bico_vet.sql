
CREATE DATABASE IF NOT EXISTS focinho_bico_vet;
USE focinho_bico_vet;

-- ==========================================
-- 1. TUTORES
-- ==========================================
CREATE TABLE tutores (
    id_tutor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    endereco VARCHAR(200)
);

-- ==========================================
-- 2. ANIMAIS
-- ==========================================
CREATE TABLE animais (
    id_animal INT AUTO_INCREMENT PRIMARY KEY,
    id_tutor INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    especie VARCHAR(50) NOT NULL,
    raca VARCHAR(50),
    sexo ENUM('Macho', 'Femea') NOT NULL,
    data_nascimento DATE,
    peso DECIMAL(6,2),
    observacoes TEXT,
    FOREIGN KEY (id_tutor) REFERENCES tutores(id_tutor)
);

-- ==========================================
-- 3. ESPECIALIDADES
-- ==========================================
CREATE TABLE especialidades (
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

-- ==========================================
-- 4. VETERINARIOS
-- ==========================================
CREATE TABLE veterinarios (
    id_veterinario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    crmv VARCHAR(30) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100)
);

-- ==========================================
-- 5. VETERINARIO x ESPECIALIDADE
-- ==========================================
CREATE TABLE veterinario_especialidade (
    id_veterinario INT NOT NULL,
    id_especialidade INT NOT NULL,
    PRIMARY KEY (id_veterinario, id_especialidade),
    FOREIGN KEY (id_veterinario)
        REFERENCES veterinarios(id_veterinario),
    FOREIGN KEY (id_especialidade)
        REFERENCES especialidades(id_especialidade)
);

-- ==========================================
-- 6. AGENDAMENTOS
-- ==========================================
CREATE TABLE agendamentos (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    id_animal INT NOT NULL,
    id_veterinario INT NOT NULL,
    data_hora DATETIME NOT NULL,
    motivo VARCHAR(200),
    status ENUM('Agendado', 'Confirmado', 'Realizado',
                'Cancelado', 'Faltou') DEFAULT 'Agendado',
    UNIQUE (id_veterinario, data_hora),
    FOREIGN KEY (id_animal) REFERENCES animais(id_animal),
    FOREIGN KEY (id_veterinario)
        REFERENCES veterinarios(id_veterinario)
);

-- ==========================================
-- 7. CONSULTAS
-- ==========================================
CREATE TABLE consultas (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_animal INT NOT NULL,
    id_veterinario INT NOT NULL,
    id_agendamento INT UNIQUE,
    data_consulta DATETIME NOT NULL,
    diagnostico TEXT,
    observacoes TEXT,
    FOREIGN KEY (id_animal) REFERENCES animais(id_animal),
    FOREIGN KEY (id_veterinario)
        REFERENCES veterinarios(id_veterinario),
    FOREIGN KEY (id_agendamento)
        REFERENCES agendamentos(id_agendamento)
);

-- ==========================================
-- 8. PROCEDIMENTOS (CATALOGO)
-- ==========================================
CREATE TABLE procedimentos (
    id_procedimento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    valor DECIMAL(10,2) NOT NULL
);

-- ==========================================
-- 9. PROCEDIMENTOS REALIZADOS
-- ==========================================
CREATE TABLE procedimentos_realizados (
    id_realizacao INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    id_procedimento INT NOT NULL,
    id_veterinario INT NOT NULL,
    data_realizacao DATETIME NOT NULL,
    observacoes TEXT,
    FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta),
    FOREIGN KEY (id_procedimento)
        REFERENCES procedimentos(id_procedimento),
    FOREIGN KEY (id_veterinario)
        REFERENCES veterinarios(id_veterinario)
);

-- ==========================================
-- 10. EXAMES (CATALOGO)
-- ==========================================
CREATE TABLE exames (
    id_exame INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    valor DECIMAL(10,2) NOT NULL
);

-- ==========================================
-- 11. EXAMES SOLICITADOS
-- ==========================================
CREATE TABLE exames_solicitados (
    id_exame_solicitado INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    id_exame INT NOT NULL,
    data_solicitacao DATE NOT NULL,
    data_realizacao DATE,
    resultado TEXT,
    status ENUM('Solicitado', 'Realizado', 'Cancelado')
        DEFAULT 'Solicitado',
    FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta),
    FOREIGN KEY (id_exame) REFERENCES exames(id_exame)
);

-- ==========================================
-- 12. MEDICAMENTOS
-- ==========================================
CREATE TABLE medicamentos (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fabricante VARCHAR(100),
    descricao TEXT,
    valor DECIMAL(10,2)
);

-- ==========================================
-- 13. PRESCRICOES
-- ==========================================
CREATE TABLE prescricoes (
    id_prescricao INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT NOT NULL,
    id_medicamento INT NOT NULL,
    dosagem VARCHAR(100) NOT NULL,
    frequencia VARCHAR(100) NOT NULL,
    duracao VARCHAR(100),
    instrucoes TEXT,
    FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta),
    FOREIGN KEY (id_medicamento)
        REFERENCES medicamentos(id_medicamento)
);

-- ==========================================
-- 14. VACINAS (CATALOGO / ESQUEMA)
-- ==========================================
CREATE TABLE vacinas (
    id_vacina INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    intervalo_reforco_dias INT,
    valor DECIMAL(10,2) NOT NULL
);

-- ==========================================
-- 15. APLICACOES DE VACINAS
-- ==========================================
CREATE TABLE aplicacoes_vacinas (
    id_aplicacao INT AUTO_INCREMENT PRIMARY KEY,
    id_animal INT NOT NULL,
    id_vacina INT NOT NULL,
    id_veterinario INT NOT NULL,
    data_aplicacao DATE NOT NULL,
    dose VARCHAR(50) NOT NULL,
    proxima_dose DATE,
    lote VARCHAR(50),
    observacoes TEXT,
    FOREIGN KEY (id_animal) REFERENCES animais(id_animal),
    FOREIGN KEY (id_vacina) REFERENCES vacinas(id_vacina),
    FOREIGN KEY (id_veterinario)
        REFERENCES veterinarios(id_veterinario)
);

-- ==========================================
-- 16. FATURAS
-- ==========================================
CREATE TABLE faturas (
    id_fatura INT AUTO_INCREMENT PRIMARY KEY,
    id_tutor INT NOT NULL,
    data_emissao DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Aberta', 'Parcial', 'Paga', 'Cancelada')
        DEFAULT 'Aberta',
    FOREIGN KEY (id_tutor) REFERENCES tutores(id_tutor)
);

-- ==========================================
-- 17. ITENS DAS FATURAS
-- ==========================================
CREATE TABLE itens_fatura (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_fatura INT NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    valor_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    id_consulta INT,
    id_realizacao INT,
    id_exame_solicitado INT,
    id_aplicacao INT,
    FOREIGN KEY (id_fatura) REFERENCES faturas(id_fatura),
    FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta),
    FOREIGN KEY (id_realizacao)
        REFERENCES procedimentos_realizados(id_realizacao),
    FOREIGN KEY (id_exame_solicitado)
        REFERENCES exames_solicitados(id_exame_solicitado),
    FOREIGN KEY (id_aplicacao)
        REFERENCES aplicacoes_vacinas(id_aplicacao)
);

-- ==========================================
-- 18. PAGAMENTOS
-- ==========================================
CREATE TABLE pagamentos (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_fatura INT NOT NULL,
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor DECIMAL(10,2) NOT NULL,
    forma_pagamento ENUM('Dinheiro', 'Cartao', 'Convenio', 'Pix')
        NOT NULL,
    observacoes VARCHAR(200),
    FOREIGN KEY (id_fatura) REFERENCES faturas(id_fatura)
);

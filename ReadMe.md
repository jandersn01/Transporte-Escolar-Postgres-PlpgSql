# Projeto de Gerenciamento de Transporte Público Escolar

Este projeto visa gerenciar o transporte público escolar oferecido por um município para estudantes de ensino superior que necessitam se deslocar até outra cidade para assistir aulas em três turnos: manhã, tarde e noite. O sistema controla e armazena dados relevantes de alunos, instituições, ônibus, motoristas, rotas e reservas, garantindo eficiência e organização.

## Modelos

### Modelo Conceitual
![App Screenshot](https://raw.githubusercontent.com/jandersn01/Transporte-Escolar-Postgres-PlpgSql/refs/heads/main/imgs/imageconceitual.png)


### Modelo Lógico
- **URL da Imagem do Modelo Lógico**: [Insira aqui a URL da imagem do modelo lógico]

## Estrutura do Banco de Dados

### Tabelas Principais
- **Instituição**: Armazena informações das instituições de ensino.
- **Aluno**: Contém dados dos alunos que utilizam o transporte.
- **Ônibus**: Registra os ônibus disponíveis e sua capacidade.
- **Motorista**: Armazena informações dos motoristas contratados.
- **Rota**: Define as rotas de ônibus, incluindo pontos de partida e chegada.
- **Reserva**: Gerencia as reservas feitas pelos alunos.
- **Confirmação**: Registra a confirmação de presença dos alunos no ônibus.

### Relacionamentos
- **Vinculado**: Relaciona Instituição e Aluno.
- **Sedia**: Relaciona Instituição e Campus.
- **Realiza**: Relaciona Ônibus e Rota.
- **Dirige**: Relaciona Motorista e Ônibus.
- **Faz**: Relaciona Aluno e Reserva.
- **Possui**: Relaciona Instituição e Rota.
- **Acontece**: Relaciona Rota e Turno.

## Funcionalidades Principais
- **Registro de Reservas**: Os alunos podem reservar vagas em ônibus para um determinado turno e data.
- **Confirmação de Presença**: Os alunos confirmam sua presença no ônibus passando o cartão acadêmico.
- **Controle de Vagas**: O sistema verifica a disponibilidade de vagas antes de confirmar uma reserva.
- **Listas de Frequência**: Emite listas de frequência e controle para monitoramento.
- **Informações de Rota**: Fornece detalhes sobre rotas, motoristas responsáveis e horários.

## Scripts do Banco de Dados
O banco de dados foi implementado utilizando PostgreSQL. Abaixo estão os principais comandos para criação das tabelas:

```sql
CREATE TABLE Instituicao (
    IDInstituicao serial  NOT NULL,
    NomeInstituicao VARCHAR(50)  NOT NULL,
    CONSTRAINT PKINSTITUICAO PRIMARY KEY (IDINSTITUICAO)
);

CREATE TABLE Rota (
    IDRota SERIAL  NOT NULL ,
    Descricao VARCHAR  NOT NULL,
    Inicio VARCHAR  NOT NULL,
    Fim VARCHAR  NOT NULL,
    CONSTRAINT PKROTA PRIMARY KEY (IDROTA),
    CONSTRAINT CKINICIOFIM CHECK(INICIO <> FIM)
);

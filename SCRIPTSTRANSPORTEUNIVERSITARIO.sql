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

CREATE TABLE Onibus (
    IDOnibus SERIAL  NOT NULL ,
    Capacidade INT NOT NULL,
	CONSTRAINT PKONIBUS PRIMARY KEY (IDONIBUS)
);

CREATE TABLE Motorista (
    IDMotorista SERIAL  NOT NULL ,
    Salario NUMERIC  NOT NULL,
    PeriodoContrato DATE  NOT NULL,
    DataAdmissao DATE  NOT NULL,
    IDonibus INT NOT NULL,
	CONSTRAINT PKMOTORISTA PRIMARY KEY (IDMOTORISTA),
	CONSTRAINT FKONIBUS FOREIGN KEY (IDONIBUS) REFERENCES ONIBUS(IDONIBUS)
	ON DELETE CASCADE
);
ALTER TABLE motorista add Nome VARCHAR (40);

CREATE TABLE Aluno (
    IDAluno SERIAL NOT NULL,
    Nome VARCHAR NOT NULL,
    Curso VARCHAR NOT NULL,
    Turno VARCHAR NOT NULL,
    Data_de_cadastro DATE NOT NULL,
    Validade_cadastro DATE NOT NULL,
    IDInstituicao INT NOT NULL,
    QrCode INT UNIQUE NOT NULL,
	CONSTRAINT PKALUNO PRIMARY KEY (IDALUNO),
	CONSTRAINT FKALUNOINSTITUICAO FOREIGN KEY (IDINSTITUICAO) REFERENCES INSTITUICAO(IDINSTITUICAO)
	ON DELETE CASCADE
	
);

CREATE TABLE Turno (
	 IDturno SERIAL NOT NULL,
    Turnodesc VARCHAR NOT NULL,
    CONSTRAINT PKTURNO PRIMARY KEY (IDTURNO)
);

CREATE TABLE Reserva (
    IdReserva SERIAL NOT NULL,
    Turno VARCHAR NOT NULL,
    IndoPara VARCHAR NOT NULL,
    VOLTA BOOLEAN ,
    DataReserva DATE NOT NULL,
    Esperando_em VARCHAR NOT NULL DEFAULT 'MUNICIPIO INICIAL',
    IDOnibus INT NOT NULL,
	CONSTRAINT PKRESERVA PRIMARY KEY (IDRESERVA),
	CONSTRAINT FKONIBUS FOREIGN KEY (IDONIBUS) REFERENCES ONIBUS(IDONIBUS)
	ON DELETE CASCADE
);

CREATE TABLE Confirmacao_reserva (
    IDCheck_in SERIAL NOT NULL,
    Presente BOOLEAN,
    IdReserva INT,
	CONSTRAINT PKCONFIRMACAORESERVA PRIMARY KEY (IDCHECK_IN),
	CONSTRAINT FKRESERVA FOREIGN KEY (IDRESERVA) REFERENCES RESERVA(IDRESERVA)
	ON DELETE CASCADE
);
CREATE TABLE Campus (
	IDCampus SERIAL NOT NULL UNIQUE,
    Cidade VARCHAR NOT NULL ,
    Bairro VARCHAR NOT NULL,
    Rua VARCHAR NOT NULL,
    Numero INT ,
    IDInstituicao INT NOT NULL,
	CONSTRAINT FKINSTITUICAO FOREIGN KEY (IDINSTITUICAO) REFERENCES INSTITUICAO(IDINSTITUICAO),
    CONSTRAINT PKCAMPUS PRIMARY KEY (IDCampus, IDInstituicao)
);

CREATE TABLE Contato_motorista (
    IDMotorista INT NOT NULL,
    Telefone INT,
    Email VARCHAR,
	CONSTRAINT FKAMOTORISTA FOREIGN KEY (IDMOTORISTA) REFERENCES MOTORISTA(IDMOTORISTA),
	CONSTRAINT PKCONTATOMOTORISTA PRIMARY KEY (IDMOTORISTA)
);

CREATE TABLE Contato_Aluno (
    IDAluno INT NOT NULL,
    Email VARCHAR,
    Telefone INT,
	CONSTRAINT FKALUNO FOREIGN KEY (IDALUNO) REFERENCES ALUNO(IDALUNO),
	CONSTRAINT PKCONTATOALUNO PRIMARY KEY (IDALUNO)
);

CREATE TABLE Rota_Instituicao (
    IDRota INT NOT NULL,
    IDInstituicao INT NOT NULL,
	IDCAMPUS INT NOT NULL,
    CONSTRAINT PKROTAINST PRIMARY KEY (IDRota, IDInstituicao),
	CONSTRAINT FKROTA FOREIGN KEY (IDROTA) REFERENCES ROTA(IDROTA)  ON DELETE SET NULL,
	CONSTRAINT FKINSTITUICAO FOREIGN KEY (IDINSTITUICAO) REFERENCES INSTITUICAO (IDINSTITUICAO) ON DELETE SET NULL,
	CONSTRAINT FKCAMPUS FOREIGN KEY (IDCAMPUS) REFERENCES CAMPUS(IDCAMPUS)
);



CREATE TABLE Onibus_realiza_rota (
    IDRota INT NOT NULL,
    IDOnibus INT NOT NULL,
    HoraInicio TIME NOT NULL,
    HoraFim TIME DEFAULT NULL,
    Data_viagem DATE NOT NULL,
	CONSTRAINT FKROTA FOREIGN KEY (IDRota) REFERENCES ROTA(IDRota ), 
	CONSTRAINT FKONIBUS FOREIGN KEY (IDOnibus) REFERENCES ONIBUS(IDOnibus),
    CONSTRAINT PKONIBUS_R_ROTA PRIMARY KEY (IDOnibus, IDRota)
);

CREATE TABLE Aluno_Reserva (
    IdReserva INT NOT NULL,
    IDAluno INT NOT NULL,
	CONSTRAINT FKALUNO FOREIGN KEY (IDALUNO) REFERENCES ALUNO(IDALUNO),
	CONSTRAINT FKRESERVA FOREIGN KEY (IDRESERVA) REFERENCES RESERVA(IDRESERVA)
	ON DELETE CASCADE,
    CONSTRAINT PKALUNORESERVA PRIMARY KEY (IDAluno, IdReserva)
);

CREATE TABLE ROTA_TURNO (
    IDturno INT NOT NULL,
    IDRota INT NOT NULL,
	CONSTRAINT FKROTA FOREIGN KEY (IDRota) REFERENCES ROTA(IDRota ), 
	CONSTRAINT FKTURNO FOREIGN KEY (IDTURNO) REFERENCES TURNO(IDTURNO), 
    CONSTRAINT PKROTATURNO PRIMARY KEY (IDturno, IDRota)
);

CREATE TABLE Aluno_confirmacao(
    IDCheck_in INT,
    IDAluno INT,
    QrCode INT UNIQUE,
	CONSTRAINT FKALUNO FOREIGN KEY (IDALUNO) REFERENCES ALUNO(IDALUNO),
	CONSTRAINT FKCONFIRMACAO FOREIGN KEY (IDCheck_in) REFERENCES Confirmacao_reserva(IDCheck_in),
    CONSTRAINT PKALUNOCONF_I PRIMARY KEY (IDAluno, IDCheck_in)
);
alter table aluno_confirmacao
drop constraint if exists aluno_confirmacao_qrcode_key;
alter table Aluno_confirmacao add data_ date;

/*Inserts Instituição*/
INSERT INTO Instituicao (NomeInstituicao)
VALUES ('Universidade Federal da Paraíba (UFPB)');
INSERT INTO Instituicao (NomeInstituicao)
VALUES ('Universidade de Ensino Superior do IPE (UNIPE)');
INSERT INTO Instituicao (NomeInstituicao)
VALUES ('Instituto Federal da Paraíba (IFPB)');
INSERT INTO Instituicao (NomeInstituicao)
VALUES ('Faculdade Maurício de Nassau');
INSERT INTO Instituicao (NomeInstituicao) 
VALUES ('Centro Universitario - UNIESP');
INSERT INTO Instituicao (NomeInstituicao) 
VALUES ('Universidade Estadual da Paraíba - UEPB'); 
INSERT INTO Instituicao (NomeInstituicao) 
VALUES ('Faculdade Internacional da Paraíba - FPB'); 
select * from instituicao;

/*INSERTS DE CAMPUS*/
INSERT INTO Campus (idcampus,Cidade, Bairro, Rua, Numero, IDInstituicao)
VALUES 
(default,'João Pessoa', 'Cristo', 'Horacio Trajano de Oliveira', 1823, 6), 
(default,'Cabedelo', 'Morada Nova', 'BR-230', 0, 5),
(default,'João Pessoa', 'Tambiá', 'Av. Monsenhor Walfredo Leal', 1253, 7),
(default,'João Pessoa', 'Mangabeira', 'Av. Hilton Souto Maior', 1233, 1), 
(default,'João Pessoa', 'Castelo Branco', 'Rua Campus I', 123, 1),
(default,'João Pessoa', 'Água Fria', 'BR-230', 456, 2),
(default,'João Pessoa', 'Jaguaribe', 'Av.Primeiro de Maio', 789, 3),
(default,'João Pessoa', 'Epitácio Pessoa', 'Avenida Principal', 1011, 4);
select * from campus;

/*INSERTS DE ROTA */
INSERT INTO Rota (Descricao, Inicio, Fim)
VALUES 
('UFPB - UNIPE - MUNICIPIO INICIAL', 'João Pessoa', 'Municipio Inicial'),
('UNIPE - UFPB', 'Municipio Inicial', 'João Pessoa'),
('IFPB - NASSAU', 'Municipio Inicial', 'João Pessoa'),
('UEPB - FPB', 'Municipio Inicial', 'João Pessoa'),
('UFPB MANGABEIRA - UNIESP ', 'Municipio Inicial', 'Cabedelo'),
('NASSAL - IFPB - MUNICIPIO INICIAL', 'João Pessoa', 'Municipio Inicial'),
('FPB - UEPB - MUNICIPIO INICIAL', 'João Pessoa', 'Municipio Inicial'),
('UNIESP - UFPB MANGABEIRA - MUNICIPIO INICIAL', 'CABEDELO', 'Municipio Inicial');
select * from rota;

/*INSERT ONIBUS */
INSERT INTO Onibus (idonibus, Capacidade)
VALUES 
(default,15),
(default,20),
(default,20),
(default,20),
(default,30),
(default,30);
select * from onibus;

/*INSERT MOTORISTA*/
INSERT INTO Motorista (Salario, PeriodoContrato, DataAdmissao, IDOnibus, Nome)
VALUES 
(3000.00, '2028-10-09', '2020-03-10', 1, 'José Pereira'),
(2900.00, '2028-10-09', '2020-03-10', 2, 'Camilo Souza Lima'),
(2500.00, '2025-12-31', CURRENT_DATE, 3, 'Severino Ramos Lins'),
(2300.00, '2025-11-30', CURRENT_DATE, 4, 'Thiago Marques Moura'),
(2600.00, '2026-01-31', CURRENT_DATE, 5, 'Maria José da Penha' ),
(2400.00, '2026-02-15', CURRENT_DATE, 6, 'João Raimundo Lopes de Sousa Filho');
select * from motorista;

/*INSERTS DE ALUNO*/
INSERT INTO Aluno (Nome, Curso, Turno, Data_de_cadastro, Validade_cadastro, IDInstituicao, QrCode)
VALUES 
('Alan Pereira', 'Design de Interiores', 'Manhã', '2024-06-01', '2024-12-30', 5, 567890),
('Jéssica Pereira', 'Gastronomia', 'Tarde', '2024-06-01', '2024-12-30', 6, 567897),
('Gabriel Sousa', 'Moda', 'Noite', '2024-06-01', '2024-12-30', 7, 567892),
('João Silva', 'Engenharia', 'Manhã', '2024-06-01', '2024-12-30', 1, 123456),
('Maria Oliveira', 'Administração', 'Tarde', '2024-06-01', '2024-12-30', 2, 234567),
('Pedro Lima', 'Informática', 'Noite', '2024-06-01', '2024-12-30', 3, 345678),
('Ana Souza', 'Direito', 'Integral', '2024-06-01', '2024-12-30', 4, 456789);
INSERT INTO Aluno (Nome, Curso, Turno, Data_de_cadastro, Validade_cadastro, IDInstituicao, QrCode)
VALUES 
('Alan Pereira', 'Design de Interiores', 'Manhã', '2024-06-01', '2024-12-30', 5, 100001),
('Jéssica Pereira', 'Gastronomia', 'Tarde', '2024-06-01', '2024-12-30', 6, 100002),
('Gabriel Sousa', 'Moda', 'Noite', '2024-06-01', '2024-12-30', 7, 100003),
('João Silva', 'Engenharia', 'Manhã', '2024-06-01', '2024-12-30', 1, 100004),
('Maria Oliveira', 'Administração', 'Tarde', '2024-06-01', '2024-12-30', 2, 100005),
('Pedro Lima', 'Informática', 'Noite', '2024-06-01', '2024-12-30', 3, 100006),
('Ana Souza', 'Direito', 'Integral', '2024-06-01', '2024-12-30', 4, 100007),
('Carlos Mendes', 'Psicologia', 'Manhã', '2024-06-01', '2024-12-30', 1, 100008),
('Bruna Costa', 'Enfermagem', 'Tarde', '2024-06-01', '2024-12-30', 2, 100009),
('Ricardo Silva', 'Arquitetura', 'Noite', '2024-06-01', '2024-12-30', 3, 100010),
('Sofia Lima', 'Nutrição', 'Manhã', '2024-06-01', '2024-12-30', 4, 100011),
('Lucas Ferreira', 'Biomedicina', 'Tarde', '2024-06-01', '2024-12-30', 5, 100012),
('Juliana Almeida', 'Pedagogia', 'Noite', '2024-06-01', '2024-12-30', 6, 100013),
('Mateus Ribeiro', 'Farmácia', 'Integral', '2024-06-01', '2024-12-30', 7, 100014),
('Renata Gomes', 'Fisioterapia', 'Manhã', '2024-06-01', '2024-12-30', 1, 100015),
('Paulo Oliveira', 'Odontologia', 'Tarde', '2024-06-01', '2024-12-30', 2, 100016),
('Isabela Rocha', 'Jornalismo', 'Noite', '2024-06-01', '2024-12-30', 3, 100017),
('Vitor Costa', 'História', 'Manhã', '2024-06-01', '2024-12-30', 4, 100018),
('Fernanda Alves', 'Geografia', 'Tarde', '2024-06-01', '2024-12-30', 5, 100019),
('Thiago Martins', 'Matemática', 'Noite', '2024-06-01', '2024-12-30', 6, 100020),
('Beatriz Pereira', 'Física', 'Manhã', '2024-06-01', '2024-12-30', 7, 100021),
('Rafael Santos', 'Química', 'Tarde', '2024-06-01', '2024-12-30', 1, 100022),
('Daniela Araújo', 'Engenharia Civil', 'Noite', '2024-06-01', '2024-12-30', 2, 100023),
('André Farias', 'Engenharia Elétrica', 'Integral', '2024-06-01', '2024-12-30', 3, 100024),
('Bianca Lopes', 'Engenharia Mecânica', 'Manhã', '2024-06-01', '2024-12-30', 4, 100025),
('Gustavo Nunes', 'Ciências Contábeis', 'Tarde', '2024-06-01', '2024-12-30', 5, 100026),
('Letícia Ramos', 'Medicina', 'Noite', '2024-06-01', '2024-12-30', 6, 100027),
('Eduardo Xavier', 'Veterinária', 'Manhã', '2024-06-01', '2024-12-30', 7, 100028),
('Marina Barros', 'Filosofia', 'Tarde', '2024-06-01', '2024-12-30', 1, 100029),
('Rodrigo Franco', 'Letras', 'Noite', '2024-06-01', '2024-12-30', 2, 100030),
('Camila Teixeira', 'Artes Cênicas', 'Manhã', '2024-06-01', '2024-12-30', 3, 100031),
('Fábio Moraes', 'Educação Física', 'Tarde', '2024-06-01', '2024-12-30', 4, 100032),
('Patrícia Santos', 'Ciências Biológicas', 'Noite', '2024-06-01', '2024-12-30', 5, 100033),
('Leandro Reis', 'Engenharia de Produção', 'Integral', '2024-06-01', '2024-12-30', 6, 100034),
('Sabrina Andrade', 'Engenharia Química', 'Manhã', '2024-06-01', '2024-12-30', 7, 100035),
('Felipe Macedo', 'Engenharia Ambiental', 'Tarde', '2024-06-01', '2024-12-30', 1, 100036),
('Débora Lima', 'Marketing', 'Noite', '2024-06-01', '2024-12-30', 2, 100037),
('Carolina Duarte', 'Ciências Sociais', 'Manhã', '2024-06-01', '2024-12-30', 3, 100038),
('Fernando Carvalho', 'Economia', 'Tarde', '2024-06-01', '2024-12-30', 4, 100039),
('Raquel Souza', 'Publicidade e Propaganda', 'Noite', '2024-06-01', '2024-12-30', 5, 100040),
('Marcos Tavares', 'Relações Internacionais', 'Integral', '2024-06-01', '2024-12-30', 6, 100041),
('Vanessa Mendes', 'Turismo', 'Manhã', '2024-06-01', '2024-12-30', 7, 100042),
('Renan Freitas', 'Hotelaria', 'Tarde', '2024-06-01', '2024-12-30', 1, 100043),
('Natália Assis', 'Serviço Social', 'Noite', '2024-06-01', '2024-12-30', 2, 100044),
('César Vieira', 'Teologia', 'Manhã', '2024-06-01', '2024-12-30', 3, 100045),
('Joana Faria', 'Astronomia', 'Tarde', '2024-06-01', '2024-12-30', 4, 100046),
('Guilherme Pires', 'Ciência da Computação', 'Noite', '2024-06-01', '2024-12-30', 5, 100047),
('Sara Lima', 'Sistemas de Informação', 'Integral', '2024-06-01', '2024-12-30', 6, 100048),
('Leonardo Brito', 'Geologia', 'Manhã', '2024-06-01', '2024-12-30', 7, 100049),
('Rita Gomes', 'Engenharia de Software', 'Tarde', '2024-06-01', '2024-12-30', 1, 100050);
INSERT INTO Aluno (Nome, Curso, Turno, Data_de_cadastro, Validade_cadastro, IDInstituicao, QrCode)
VALUES 
('Laura Martins', 'Administração', 'Tarde', '2024-09-01', '2024-12-30', 6, 100051),
('Thiago Lima', 'Direito', 'Tarde', '2024-09-01', '2024-12-30', 6, 100052),
('Ana Clara Silva', 'Economia', 'Tarde', '2024-09-01', '2024-12-30', 6, 100053),
('Pedro Henrique', 'Engenharia Civil', 'Tarde', '2024-09-01', '2024-12-30', 6, 100054),
('Juliana Costa', 'Psicologia', 'Tarde', '2024-09-01', '2024-12-30', 6, 100055),
('Carlos Alberto', 'Nutrição', 'Tarde', '2024-09-01', '2024-12-30', 6, 100056),
('Fernanda Lima', 'Fisioterapia', 'Tarde', '2024-09-01', '2024-12-30', 6, 100057),
('Roberta Alves', 'Enfermagem', 'Tarde', '2024-09-01', '2024-12-30', 6, 100058),
('Marcos Vinícius', 'Matemática', 'Tarde', '2024-09-01', '2024-12-30', 6, 100059),
('Camila Oliveira', 'Ciências Contábeis', 'Tarde', '2024-09-01', '2024-12-30', 6, 100060),
('Andréa Santos', 'Artes Cênicas', 'Tarde', '2024-09-01', '2024-12-30', 6, 100061),
('Vinícius Freitas', 'Turismo', 'Tarde', '2024-09-01', '2024-12-30', 6, 100062),
('Lúcia Rodrigues', 'Hotelaria', 'Tarde', '2024-09-01', '2024-12-30', 6, 100063);
INSERT INTO Aluno (Nome, Curso, Turno, Data_de_cadastro, Validade_cadastro, IDInstituicao, QrCode)
VALUES 
('Daniela Silva', 'Engenharia de Produção', 'Tarde', '2024-09-01', '2024-12-30', 6, 100064);
INSERT INTO Aluno (Nome, Curso, Turno, Data_de_cadastro, Validade_cadastro, IDInstituicao, QrCode)
VALUES 
('Laura Martins', 'Artes Plásticas', 'Noite', '2024-09-14', '2025-03-31', 1, 100065),
('Bruno Almeida', 'Design Gráfico', 'Noite', '2024-09-14', '2025-03-31', 1, 100066),
('Camila Ferreira', 'Letras', 'Noite', '2024-09-14', '2025-03-31', 1, 100067),
('Felipe Cardoso', 'Administração Pública', 'Noite', '2024-09-14', '2025-03-31', 1, 100068),
('Tatiane Ribeiro', 'Engenharia de Computação', 'Noite', '2024-09-14', '2025-03-31', 1, 100069),
('Igor Santana', 'Matemática Aplicada', 'Noite', '2024-09-14', '2025-03-31', 1, 100070),
('Viviane Costa', 'Geografia', 'Noite', '2024-09-14', '2025-03-31', 1, 100071),
('Thiago Souza', 'Filosofia', 'Noite', '2024-09-14', '2025-03-31', 1, 100072),
('Ana Clara Silva', 'Arquitetura e Urbanismo', 'Noite', '2024-09-14', '2025-03-31', 1, 100073),
('Marcos Lima', 'Engenharia Civil', 'Noite', '2024-09-14', '2025-03-31', 1, 100074);
select * from aluno;

/*INSERT DE TURNO */
INSERT INTO Turno (Turnodesc)
VALUES 
('Manhã'),
('Tarde'),
('Noite');
select * from turno;

/*INSERT ROTA_INSTITUICAO*/
INSERT INTO Rota_Instituicao (IDRota, IDInstituicao,IDCAMPUS)
VALUES 
(1,1,5),
(1,2,6),
(2,1,5),
(2,2,6),
(3,3,7),
(3,4,8),
(4,6,1),
(4,7,3),
(5,5,2),
(5,1,4),
(6,4,8),
(6,3,7),
(7,7,3),
(7,6,1),
(8,5,2),
(8,1,4);
SELECT * FROM  Rota_Instituicao;

/*INSERT DE ROTA_TURNO*/
INSERT INTO ROTA_TURNO (IDturno, IDRota)
VALUES 
(1,1),
(1,2),
(1,3),
(1,6),
(2,2),
(2,1),
(2,3),
(2,6),
(2,4),
(2,7),
(2,5),
(2,8),
(3,2),
(3,1),
(3,3),
(3,6),
(3,4),
(3,7);
SELECT * FROM ROTA_TURNO;

/*INSERT ONIBUS_REALIZA_ROTA*/
INSERT INTO Onibus_realiza_rota (IDRota, IDOnibus, HoraInicio,HORAFIM, Data_viagem)
VALUES 
(2,2, '06:00:00','07:30:00' ,CURRENT_DATE),
(1,2,'11:00:00','12:30:00' ,CURRENT_DATE),
(3,3,'06:00:00','07:30:00' ,CURRENT_DATE),
(6,3,'11:00:00','12:30:00' ,CURRENT_DATE),
(1,4,'17:30:00','18:30:00', CURRENT_DATE),
(2,4,'11:10:00','13:00:00', CURRENT_DATE),
(3,5,'11:10:00','13:00:00',CURRENT_DATE),
(6,5,'17:30:00','18:30:00',CURRENT_DATE),
(4,1,'11:10:00','13:00:00',CURRENT_DATE),
(7,1,'17:30:00','18:30:00',CURRENT_DATE),
(5,6,'11:10:00','13:00:00',CURRENT_DATE),
(8,6,'17:30:00','18:30:00',CURRENT_DATE),
(2,3,'17:30:00','18:30:00', CURRENT_DATE),
(1,3,'21:30:00','22:30:00', CURRENT_DATE),
(3,1,'17:30:00','18:30:00',CURRENT_DATE),
(6,1,'21:30:00','22:30:00',CURRENT_DATE),
(4,2,'17:30:00','18:30:00',CURRENT_DATE),
(7,2,'21:30:00','22:30:00',CURRENT_DATE);
 select * from Onibus_realiza_rota;


/*Inserts de Reserva*/
INSERT INTO Reserva (Turno, IndoPara, VOLTA, DataReserva, Esperando_em, IDOnibus)
VALUES 
('Manhã', 'IFPB', False, CURRENT_DATE,'Municipio Inicial', 3),
('Manhã', 'IFPB', False, CURRENT_DATE,'Municipio Inicial', 3),
('Manhã', 'IFPB', False, CURRENT_DATE,'Municipio Inicial', 3),
('Manhã', 'Nassal', False, CURRENT_DATE,'Municipio Inicial', 3),
('Manhã', 'Nassal', False, CURRENT_DATE,'Municipio Inicial', 3),
('Manhã', 'Nassal', False, CURRENT_DATE,'Municipio Inicial', 3),--
('Manhã', 'Municipio Inicial', True, CURRENT_DATE,'IFPB', 3),
('Manhã', 'Municipio Inicial', True, CURRENT_DATE,'IFPB', 3),
('Manhã', 'Municipio Inicial', True, CURRENT_DATE,'IFPB', 3),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UFPB Castelo Branco', 4),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UFPB Castelo Branco', 4),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UFPB Castelo Branco', 4),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UFPB Castelo Branco', 4),
('Tarde', 'UNIPE', FALSE, CURRENT_DATE, DEFAULT, 4),
('Tarde', 'UNIPE', FALSE, CURRENT_DATE, DEFAULT, 4),
('Tarde', 'UNIPE', FALSE, CURRENT_DATE, DEFAULT, 4),
('Tarde', 'UNIPE', FALSE, CURRENT_DATE, DEFAULT, 4),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'UEPB', FALSE, CURRENT_DATE, DEFAULT, 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UEPB', 1),
('Tarde', 'UFPB Mangabeira', false, CURRENT_DATE,'Municipio Inicial', 6),
('Tarde', 'UNIESP', false, CURRENT_DATE,'Municipio Inicial', 6),
('Tarde', 'UNIESP', false, CURRENT_DATE,'Municipio Inicial', 6),
('Tarde', 'UNIESP', false, CURRENT_DATE,'Municipio Inicial', 6),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UFPB Mangabeira', 6),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UNIESP', 6),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UNIESP', 6),
('Tarde', 'Municipio Inicial', True, CURRENT_DATE,'UNIESP', 6),
('Noite', 'UFPB Castelo Branco', FALSE, CURRENT_DATE, DEFAULT, 3),
('Noite', 'UFPB Castelo Branco', FALSE, CURRENT_DATE, DEFAULT, 3),
('Noite', 'UFPB Castelo Branco', FALSE, CURRENT_DATE, DEFAULT, 3),
('Noite', 'UFPB Castelo Branco', FALSE, CURRENT_DATE, DEFAULT, 3),
('Noite', 'UFPB Castelo Branco', FALSE, CURRENT_DATE, DEFAULT, 3),
('Noite', 'UFPB Castelo Branco', FALSE, CURRENT_DATE, DEFAULT, 3),
('Noite', 'UFPB Castelo Branco', FALSE, CURRENT_DATE, DEFAULT, 3),
('Noite', 'UFPB Castelo Branco', FALSE, CURRENT_DATE, DEFAULT, 3),
('Noite', 'UFPB Castelo Branco', FALSE, CURRENT_DATE, DEFAULT, 3),
('Noite', 'UFPB Castelo Branco', FALSE, CURRENT_DATE, DEFAULT, 3),
('Noite', 'Municipio Inicial', TRUE, CURRENT_DATE, 'UFPB Castelo Branco', 3),
('Noite', 'Municipio Inicial', TRUE, CURRENT_DATE, 'UFPB Castelo Branco', 3),
('Noite', 'Municipio Inicial', TRUE, CURRENT_DATE, 'UFPB Castelo Branco', 3),
('Noite', 'Municipio Inicial', TRUE, CURRENT_DATE, 'UFPB Castelo Branco', 3),
('Noite', 'Municipio Inicial', TRUE, CURRENT_DATE, 'UFPB Castelo Branco', 3),
('Noite', 'Municipio Inicial', TRUE, CURRENT_DATE, 'UFPB Castelo Branco', 3),
('Noite', 'Municipio Inicial', TRUE, CURRENT_DATE, 'UFPB Castelo Branco', 3),
('Noite', 'Municipio Inicial', TRUE, CURRENT_DATE, 'UFPB Castelo Branco', 3),
('Noite', 'Municipio Inicial', TRUE, CURRENT_DATE, 'UFPB Castelo Branco', 3),
('Noite', 'Municipio Inicial', TRUE, CURRENT_DATE, 'UFPB Castelo Branco', 3);
select * from reserva;

/**INSERTS DE ALUNO_RESERVA*/
INSERT INTO Aluno_Reserva (IdReserva, IDAluno)
VALUES 
(1, 38),
(2, 45),
(3, 52),
(4, 18),
(5, 25),
(6, 32), 
(7, 38),
(8, 45),
(9, 52), 
(10, 29),
(11, 36),
(12, 43),
(13, 50), 
(14, 5),
(15, 12),
(16, 16),
(17, 23), 
(18, 58),
(19, 59),
(20, 60),
(21, 61),
(22, 62),
(23, 63),
(24, 64),
(25, 65),
(26, 66),
(27, 67),
(28, 68),
(29, 69),
(30, 70),
(31, 71),
(32, 9),
(33, 58),
(34, 59),
(35, 60),
(36, 61),
(37, 62),
(38, 63),
(39, 64),
(40, 65),
(41, 66),
(42, 67),
(43, 68),
(44, 69),
(45, 70),
(46, 71),
(47, 9), 
(48, 57), 
(49, 19),
(50, 26),
(51, 33), 
(52, 57), 
(53, 19),
(54, 26),
(55, 33), 
(56, 72),
(57, 73),
(58, 74),
(59, 75),
(60, 76),
(61, 77),
(62, 78),
(63, 79),
(64, 80),
(65, 81), 
(66, 72),
(67, 73),
(68, 74),
(69, 75),
(70, 76),
(71, 77),
(72, 78),
(73, 79),
(74, 80),
(75, 81);
select * from aluno_reserva;

/*INSERTS DE CONFIRMACAO_RESERVA*/
INSERT INTO Confirmacao_reserva (Presente, IdReserva)
VALUES 
(TRUE, 1),
(FALSE, 2),
(TRUE, 3),
(FALSE, 4),
(TRUE, 5),
(FALSE, 6),
(TRUE, 7),
(FALSE, 8),
(TRUE, 9),
(FALSE, 10),
(TRUE, 11),
(FALSE, 12),
(TRUE, 13),
(FALSE, 14),
(TRUE, 15),
(FALSE, 16),
(TRUE, 17),
(FALSE, 18),
(TRUE, 19),
(FALSE, 20),
(TRUE, 21),
(FALSE, 22),
(TRUE, 23),
(FALSE, 24),
(TRUE, 25),
(FALSE, 26),
(TRUE, 27),
(FALSE, 28),
(TRUE, 29),
(FALSE, 30),
(TRUE, 31),
(FALSE, 32),
(TRUE, 33),
(FALSE, 34),
(TRUE, 35),
(FALSE, 36),
(TRUE, 37),
(FALSE, 38),
(TRUE, 39),
(FALSE, 40),
(TRUE, 41),
(FALSE, 42),
(TRUE, 43),
(FALSE, 44),
(TRUE, 45),
(FALSE, 46),
(TRUE, 47),
(FALSE, 48),
(TRUE, 49),
(FALSE, 50),
(TRUE, 51),
(FALSE, 52),
(TRUE, 53),
(FALSE, 54),
(TRUE, 55),
(FALSE, 56),
(TRUE, 57),
(FALSE, 58),
(TRUE, 59),
(FALSE, 60),
(TRUE, 61),
(FALSE, 62),
(TRUE, 63),
(FALSE, 64),
(TRUE, 65),
(FALSE, 66),
(TRUE, 67),
(FALSE, 68),
(TRUE, 69),
(FALSE, 70),
(TRUE, 71),
(FALSE, 72),
(TRUE, 73),
(FALSE, 74),
(TRUE, 75);
select * from confirmacao_reserva;

/*INSERTS DE CONTATO_MOTORISTA*/
INSERT INTO Contato_motorista (IDMotorista, Telefone, Email)
VALUES
(1, 83999199, 'motorista15@exemplo.com'),
(2, 83995999, 'motorista14@exemplo.com'),
(3, 83999999, 'motorista1@exemplo.com'),
(4, 83988888, 'motorista2@exemplo.com'),
(5, 83775777, 'motorista3@exemplo.com'),
(6, 83966666, 'motorista4@exemplo.com');

/*INSERTS DE CONTATO_ALUNO*/
INSERT INTO Contato_Aluno (IDAluno, Email, Telefone)
VALUES 
(1, 'aluno1@exemplo.com', 83910001),
(2, 'aluno2@exemplo.com', 83910002),
(3, 'aluno3@exemplo.com', 83910003),
(4, 'aluno4@exemplo.com', 83910004),
(5, 'aluno5@exemplo.com', 83910005),
(6, 'aluno6@exemplo.com', 83910006),
(7, 'aluno7@exemplo.com', 83910007),
(8, 'aluno8@exemplo.com', 83910008),
(9, 'aluno9@exemplo.com', 83910009),
(10, 'aluno10@exemplo.com', 83910010),
(11, 'aluno11@exemplo.com', 83910011),
(12, 'aluno12@exemplo.com', 83910012),
(13, 'aluno13@exemplo.com', 83910013),
(14, 'aluno14@exemplo.com', 83910014),
(15, 'aluno15@exemplo.com', 83910015),
(16, 'aluno16@exemplo.com', 83910016),
(17, 'aluno17@exemplo.com', 83910017),
(18, 'aluno18@exemplo.com', 83910018),
(19, 'aluno19@exemplo.com', 83910019),
(20, 'aluno20@exemplo.com', 83910020),
(21, 'aluno21@exemplo.com', 83910021),
(22, 'aluno22@exemplo.com', 83910022),
(23, 'aluno23@exemplo.com', 83910023),
(24, 'aluno24@exemplo.com', 83910024),
(25, 'aluno25@exemplo.com', 83910025),
(26, 'aluno26@exemplo.com', 83910026),
(27, 'aluno27@exemplo.com', 83910027),
(28, 'aluno28@exemplo.com', 83910028),
(29, 'aluno29@exemplo.com', 83910029),
(30, 'aluno30@exemplo.com', 83910030),
(31, 'aluno31@exemplo.com', 83910031),
(32, 'aluno32@exemplo.com', 83910032),
(33, 'aluno33@exemplo.com', 83910033),
(34, 'aluno34@exemplo.com', 83910034),
(35, 'aluno35@exemplo.com', 83910035),
(36, 'aluno36@exemplo.com', 83910036),
(37, 'aluno37@exemplo.com', 83910037),
(38, 'aluno38@exemplo.com', 83910038),
(39, 'aluno39@exemplo.com', 83910039),
(40, 'aluno40@exemplo.com', 83910040),
(41, 'aluno41@exemplo.com', 83910041),
(42, 'aluno42@exemplo.com', 83910042),
(43, 'aluno43@exemplo.com', 83910043),
(44, 'aluno44@exemplo.com', 83910044),
(45, 'aluno45@exemplo.com', 83910045),
(46, 'aluno46@exemplo.com', 83910046),
(47, 'aluno47@exemplo.com', 83910047),
(48, 'aluno48@exemplo.com', 83910048),
(49, 'aluno49@exemplo.com', 83910049),
(50, 'aluno50@exemplo.com', 83910050),
(51, 'aluno51@exemplo.com', 83910051),
(52, 'aluno52@exemplo.com', 83910052),
(53, 'aluno53@exemplo.com', 83910053),
(54, 'aluno54@exemplo.com', 83910054),
(55, 'aluno55@exemplo.com', 83910055),
(56, 'aluno56@exemplo.com', 83910056),
(57, 'aluno57@exemplo.com', 83910057),
(58, 'aluno58@exemplo.com', 83910058),
(59, 'aluno59@exemplo.com', 83910059),
(60, 'aluno60@exemplo.com', 83910060),
(61, 'aluno61@exemplo.com', 83910061),
(62, 'aluno62@exemplo.com', 83910062),
(63, 'aluno63@exemplo.com', 83910063),
(64, 'aluno64@exemplo.com', 83910064),
(65, 'aluno65@exemplo.com', 83910065),
(66, 'aluno66@exemplo.com', 83910066),
(67, 'aluno67@exemplo.com', 83910067),
(68, 'aluno68@exemplo.com', 83910068),
(69, 'aluno69@exemplo.com', 83910069),
(70, 'aluno70@exemplo.com', 83910070),
(71, 'aluno71@exemplo.com', 83910071),
(72, 'aluno72@exemplo.com', 83910072),
(73, 'aluno73@exemplo.com', 83910073),
(74, 'aluno74@exemplo.com', 83910074),
(75, 'aluno75@exemplo.com', 83910075),
(76, 'aluno76@exemplo.com', 83910076),
(77, 'aluno77@exemplo.com', 83910077),
(78, 'aluno78@exemplo.com', 83910078),
(79, 'aluno79@exemplo.com', 83910079),
(80, 'aluno80@exemplo.com', 83910080),
(81, 'aluno81@exemplo.com', 83910081);

/*INSERTS DE ALUNO_CONFIRMACAO*/

INSERT INTO Aluno_confirmacao (IDCheck_in, IDAluno, QrCode)
VALUES 
(1, 38, 100031),
(3, 52, 100045),
(5, 25, 100018),
(7, 38, 100031),
(9, 52, 100045),
(11, 36, 100029),
(13, 50, 100043),
(15, 12, 100005),
(17, 23, 100016),
(19, 59, 100052),
(21, 61, 100054),
(23, 63, 100056),
(25, 65, 100058),
(27, 67, 100060),
(29, 69, 100062),
(31, 71, 100064),
(33, 58, 100051),
(35, 60, 100053),
(37, 62, 100055),
(39, 64, 100057),
(41, 66, 100059),
(43, 68, 100061),
(45, 70, 100063),
(47, 9, 100002),
(49, 19, 100012),
(51, 33, 100026),
(53, 19, 100012),
(55, 33, 100026),
(57, 73, 100066),
(59, 75, 100068),
(61, 77, 100070),
(63, 79, 100072),
(65, 81, 100074),
(67, 73, 100066),
(69, 75, 100068),
(71, 77, 100070),
(73, 79, 100072),
(75, 81, 100074);
SELECT * FROM ALUNO_CONFIRMACAO;


--------------------------------------Querys: 

/*Consulta simples com filtros, a finalidade é conhecer quais foram as reservas feitas 
para o turno da noite*/
select * from reserva 
where turno like 'N%';

/*Consulta elaborada com o intuito de saber quais são os alunos que fizeram reserva de ida para uma instituição
fora do municipio inicial para o dia atual, em qual onibus irão embarcar e o motorista responsável. Essa 
query poderia ser util num contexto de segurança.*/
SELECT A.Nome AS Estudante , O.IDOnibus, M.nome as "Motorista", R.IndoPara, R.DataReserva
FROM Reserva R
INNER JOIN Aluno_Reserva AR ON R.IdReserva = AR.IdReserva
INNER JOIN Aluno A ON AR.IDAluno = A.IDAluno
INNER JOIN Onibus O ON R.IDOnibus = O.IDOnibus
INNER JOIN Motorista M ON O.IDOnibus = M.IDOnibus
WHERE R.DataReserva = CURRENT_DATE AND Indopara <> 'Municipio Inicial';

/*Consulta elaborada com o intuito de saber quais são os alunos que fizeram reserva de volta para
o municipio inicial para o dia atual, em qual onibus irão embarcar e o motorista responsável.*/
SELECT A.Nome AS Estudante, O.IDOnibus, M.nome as Motorista, R.IndoPara, R.DataReserva
FROM Reserva R
INNER JOIN Aluno_Reserva AR ON R.IdReserva = AR.IdReserva
INNER JOIN Aluno A ON AR.IDAluno = A.IDAluno
INNER JOIN Onibus O ON R.IDOnibus = O.IDOnibus
INNER JOIN Motorista M ON O.IDOnibus = M.IDOnibus
WHERE R.DataReserva = CURRENT_DATE AND Indopara = 'Municipio Inicial';

/*Consulta para saber quantos passageiros estao previstos para pegarem um onibus para uma instituicao.
qual motorista vai levar, para onde, em qual onibus, horas e data*/
SELECT current_date as DATA_VIAGEM , M.IDMOTORISTA, M.NOME, R.DESCRICAO, O.IDONIBUS, ORR.HORAINICIO,ORR.HORAFIM,
COUNT(CASE WHEN VOLTA = FALSE AND RE.TURNO = 'Tarde' or RE.TURNO = 'TARDE'  THEN RE.IDRESERVA END)
AS QNT_PASSAGEIROS FROM MOTORISTA M JOIN ONIBUS O ON M.IDONIBUS = O.IDONIBUS JOIN ONIBUS_REALIZA_ROTA ORR
ON O.IDONIBUS = ORR.IDONIBUS JOIN ROTA R ON R.IDROTA = ORR.IDROTA JOIN RESERVA RE ON ORR.IDONIBUS = RE.IDONIBUS
WHERE HORAINICIO ='11:10:00'
GROUP BY M.IDMOTORISTA,
R.DESCRICAO, O.IDONIBUS,ORR.HORAINICIO,ORR.HORAFIM;


-- LEFT JOIN
/*Consulta para listar todos os alunos que fizeram reservas e têm essas reservas confirmadas,
ajudando a acompanhar a alocação de alunos e suas confirmações.*/
SELECT A.Nome as "Reservado_por", CR.Presente as "Presente"
FROM Aluno A
INNER JOIN Aluno_Reserva AR ON A.IDAluno = AR.IDAluno
INNER JOIN Reserva R ON AR.IdReserva = R.IdReserva
LEFT JOIN Confirmacao_reserva CR ON R.IdReserva = CR.IdReserva
WHERE CR.Presente IS NOT NULL AND CR.Presente is true; 

/*GROUP BY -> ELABORADA COM O INTUITO DE SABER QUANTAS INSTITUIÇÕES 
ESTÃO NA ROTA*/
SELECT COUNT(*) AS "QNTD_INSTITUICOES", 'Estão na Rota ' || R.IDROTA AS ROTA
FROM Instituicao I
INNER JOIN ROTA_INSTITUICAO R ON R.IDINSTITUICAO = I.IDINSTITUICAO
JOIN ROTA RT ON R.IDROTA = RT.IDROTA
GROUP BY R.IDROTA;

/* A consulta identifica ônibus com mais de uma reserva indo para uma instituição por turno,
exibindo a capacidade e ordenando pela quantidade de reservas !!!!!!!!!!!!*/
SELECT o.IDOnibus, o.Capacidade, r.Turno, COUNT(CASE WHEN VOLTA = FALSE THEN R.IDRESERVA END) AS TotalReservas
FROM Reserva r
JOIN Onibus o ON r.IDOnibus = o.IDOnibus
GROUP BY o.IDOnibus, o.Capacidade, r.Turno
HAVING COUNT(r.IdReserva) <> 0
ORDER BY TotalReservas DESC;

/* consulta para retornar os e-mails e telefones de contato tanto dos motoristas quanto dos alunos, 
unificando as duas tabelas Contato_motorista e Contato_Aluno.*/
SELECT 'Motorista' AS Perfil, Email, Telefone
FROM Contato_motorista
UNION
SELECT 'Aluno' AS Perfil, Email, Telefone
FROM Contato_Aluno;

--------------------------------- Subquerys --
/* consulta retorna os ônibus que têm menos de 50% de suas vagas reservadas, 
permitindo identificar veículos com baixa ocupação */
SELECT o.IDOnibus, o.Capacidade, 
       (SELECT COUNT(r.IdReserva) 
        FROM Reserva r 
        WHERE r.IDOnibus = o.IDOnibus) AS TotalReservas
FROM Onibus o
WHERE o.Capacidade / 2 > (SELECT COUNT(r.IdReserva) 
                          FROM Reserva r 
                          WHERE r.IDOnibus = o.IDOnibus);


/*Numero de confirmações por instituição.*/
SELECT NomeInstituicao, NumeroConfirmacoes
FROM (
    SELECT I.NomeInstituicao, COUNT(CR.IDCheck_in) AS NumeroConfirmacoes
    FROM Instituicao I
    INNER JOIN Aluno A ON I.IDInstituicao = A.IDInstituicao
    INNER JOIN Aluno_Reserva AR ON A.IDAluno = AR.IDAluno
    INNER JOIN Reserva R ON AR.IdReserva = R.IdReserva
    INNER JOIN Confirmacao_reserva CR ON R.IdReserva = CR.IdReserva
    WHERE CR.Presente = TRUE
    GROUP BY I.IDInstituicao, I.NomeInstituicao
) AS Subconsulta
ORDER BY NumeroConfirmacoes DESC;


-----------------------------------VISÕES:
/*visão que permite inserir novos alunos*/
CREATE OR REPLACE VIEW InserirAlunoView AS
SELECT Nome, Curso, Turno,data_de_cadastro,validade_cadastro, IDInstituicao, QrCode
FROM Aluno;

select * from InserirAlunoView

INSERT INTO InserirAlunoView (Nome, Curso, Turno,data_de_cadastro,validade_cadastro,IDInstituicao, QrCode)
VALUES ('Janderson', 'Sistemas para internet', 'Vespertino','2020-07-01','2024-12-30' ,3, 10081);

--------------------------------- view robusta

/*Essa view mostra informações sobre motoristas responsáveis por determinadas
rotas em diferentes turnos. Ela exibe o nome do motorista, o ônibus que ele conduz,
a rota, a instituição relacionada, o campus (com bairro e cidade)
e a descrição do turno. Tudo é organizado por nome do motorista e turno.*/
create or replace view Motorista_encarregado_rota_turno as
SELECT distinct m.nome, o.idonibus, r.descricao AS Rota,
i.nomeinstituicao AS Instituicao, c.bairro as Campus, c.cidade, t.turnodesc
FROM rota r
INNER JOIN rota_instituicao ri ON r.idrota = ri.idrota
INNER JOIN instituicao i ON ri.idinstituicao = i.idinstituicao join campus c on ri.idcampus = c.idcampus
join onibus_realiza_rota orr on orr.idrota = r.idrota 
join onibus o on o.idonibus = orr.idonibus join
motorista m on m.idonibus = o.idonibus join
rota_turno rt on r.idrota = rt.idrota join turno t on rt.idturno =t.idturno
order by m.nome, t.turnodesc asc;
select * from Motorista_encarregado_rota_turno;


/*View de frequencia, com o intuito de saber quais alunos confirmaram sua reserva no turno da tarde
e quem não confirmou num determinado dia*/
create or replace view Frequencia_Tarde_15092024 as
select a.idaluno, a.nome, r.idreserva ,'15-09-2024' AS datareserva, r.indopara, r.esperando_em,r.idonibus,
cr.presente from aluno a join aluno_reserva ar on a.idaluno = ar.idaluno join reserva r on ar.idreserva = r.idreserva
join confirmacao_reserva cr on r.idreserva = cr.idreserva
where r.datareserva = current_date and r.turno = 'Tarde' order by a.idaluno asc;
select * from Frequencia_Tarde_15092024;

---------------------------------------------ÍNDICES:

/*O índice em HORAINICIO acelera a filtragem de registros 
baseada na hora de início.*/
CREATE INDEX idx_onibus_realiza_rota_horainicio 
ON ONIBUS_REALIZA_ROTA (HORAINICIO);

/*INDICE AUXILIA A TABELA RESERVA A ENCONTRAR RESERVAS FEITAS PARA UMA DETERMINADA DATA*/
CREATE INDEX INDX_RESERVA
ON  RESERVA(DATARESERVA);
SELECT * FROM RESERVA;

/*O índice idx_onibus_capacidade melhora a eficiência da comparação feita
no WHERE.*/
CREATE INDEX idx_onibus_capacidade ON Onibus (Capacidade);



------------------------------------MELHORIA DE CONSULTAS 
/*EXCLUIR A SUBCONSULTA PARA OTMIZAR A QUERY É UMA FORMA DE MELHORAR ELA. INTEGRANDO
TODAS AS SUBCONSULTAS NUMA UNINCA QUERY.*/
SELECT o.IDOnibus, o.Capacidade, COUNT(r.IdReserva) AS TotalReservas
FROM Onibus o LEFT JOIN Reserva r ON o.IDOnibus = r.IDOnibus
GROUP BY o.IDOnibus, o.Capacidade
HAVING o.Capacidade / 2 > COUNT(r.IdReserva);

/*A subconsulta é desnecessária, diminuindo o desempenho 
da query*/
SELECT I.NomeInstituicao, COUNT(CR.IDCheck_in) AS NumeroConfirmacoes
FROM Instituicao I
JOIN Aluno A ON I.IDInstituicao = A.IDInstituicao JOIN Aluno_Reserva AR ON A.IDAluno = AR.IDAluno
JOIN Reserva R ON AR.IdReserva = R.IdReserva
JOIN Confirmacao_reserva CR ON R.IdReserva = CR.IdReserva
WHERE CR.Presente = TRUE
GROUP BY I.NomeInstituicao
ORDER BY NumeroConfirmacoes DESC;


--------------------------------FUNCTIONS
/*Função que checa a disponibilidade de vagas num onibus em algum turno.*/
CREATE OR REPLACE FUNCTION DisponibilidadedeVagas(f_turno VARCHAR, f_volta boolean, f_idonibus int)
returns boolean as $$
declare
retorno boolean;
f_onibuscapcidade int;
f_reservados int;
begin
select into f_onibuscapcidade capacidade from onibus where idonibus = f_idonibus;
select count(*) into f_reservados from reserva
where turno = f_turno and volta = f_volta and idonibus =  f_idonibus ;
if f_reservados < f_onibuscapcidade then
retorno = true;
else
retorno = false;
end if;
return retorno;
end$$ language 'plpgsql';

/*Passar o cartão com QrCode. criada para registrar aluno_confirmacao*/
create or replace function PassarCartao(f_qrcode int)
returns varchar as $$
declare 
sefez_reserva int;
f_idreserva int; 
f_idcheckin int;
begin
select idaluno into sefez_reserva from aluno where qrcode = f_qrcode;
select idreserva into f_idreserva from aluno_reserva where idaluno = sefez_reserva;
select cr.idcheck_in into f_idcheckin from confirmacao_reserva cr where cr.idreserva =
f_idreserva and cr.presente = true;

if sefez_reserva is null then
raise exception 'Qrcode invalido!';
elsif f_idreserva is null then 
raise exception 'Reserva nunca feita';
else 	
	insert into aluno_confirmacao(idcheck_in, idaluno, qrcode, data_)
	values (f_idcheckin,sefez_reserva,f_qrcode, current_date);
	return 'Você Passou o cartão. Presença confirmada com sucesso';
end if;
end $$ language 'plpgsql';


/*Função que retorna o número total de alunos matriculados em cada instituição 
Esta função fornece a contagem total de alunos 
matriculados em cada instituição, ajudando a analisar a popularidade das universidades e a alocar os ônibus adequadamente.*/
CREATE OR REPLACE FUNCTION TotalAlunosPorInstituicao()
RETURNS TABLE(nome_instituicao VARCHAR, total_alunos BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT i.nomeinstituicao AS nome_instituicao, COUNT(a.IDAluno) AS total_alunos
    FROM Aluno a
    INNER JOIN Instituicao i ON a.IDInstituicao = i.IDInstituicao
    GROUP BY i.nomeinstituicao;
END;
$$ LANGUAGE plpgsql;

------------------------------PROCEDURE
/*Procedure que insere uma nova reserva no banco , incluindo tratamento de exceção*/
CREATE OR REPLACE PROCEDURE InserirReserva(
	r_id_aluno INT,
	r_turno VARCHAR,
	r_indo_para VARCHAR,
	r_volta boolean,
	r_datareserva DATE,
	r_esperando_em Varchar,
    r_id_onibus INT   
)
language 'plpgsql' AS $$
declare
p_idreserva int;
p_idaluno int;
p_idonibus int;
BEGIN
	select into strict  p_idonibus idonibus from onibus where idonibus = r_id_onibus;
	select into strict	p_idaluno idaluno from aluno where idaluno =  r_id_aluno;
	INSERT INTO Reserva (turno,IndoPara, volta, DataReserva, esperando_em, IDOnibus )
	VALUES ( r_turno ,r_indo_para,r_volta,
				r_datareserva,r_esperando_em,p_idonibus) returning idreserva into p_idreserva ;
				
		insert into aluno_reserva (idreserva, idaluno)
		values (p_idreserva,p_idaluno);
		RAISE NOTICE 'RESERVA FEITA!';
EXCEPTION
    WHEN no_data_found THEN
        RAISE EXCEPTION 'IDOnibus ou IDaluno não corresponde com nenhum registro de onibus ou aluno existente';
END $$;


----------------------triggers
/*TRIGGER QUE NAO PERMITE A INSERÇÃO CASO NÃO HAJA MAIS VAGAS*/ 
create or replace function requisitosInsercao()
returns trigger as $$
DECLARE
AUTORIZACAO BOOLEAN;
begin
autorizacao = DisponibilidadedeVagas(new.turno,new.volta,new.idonibus);
if AUTORIZACAO = true then
	return new;
else 
	raise exception 'Não há mais vagas!';
END IF;
	EXCEPTION 
	WHEN RAISE_EXCEPTION THEN
		RAISE EXCEPTION 'Não há mais vagas!';
		RETURN NULL;
end $$ language 'plpgsql';


create trigger reserva_insert
before insert on reserva for each row
execute function requisitosInsercao();

/*Haja em vista que não estamos trabalhando de fato com uma aplicação completa,
é interessante esse trigger que simula inserções de confirmações de presença de um aluno nas
tabelas confirmacao_reserva imediatamente
após quando uma reserva é feita.*/
create or replace function insereconfreserva()
returns trigger as $$
declare
f_idreserva int;
f_idaluno int ;
f_idcheck_in int;
begin
select into f_idreserva max(idreserva) from reserva;
select a.idaluno into f_idaluno from aluno a
join aluno_reserva ar on ar.idaluno = a.idaluno 
where ar.idreserva = f_idreserva;
insert into confirmacao_reserva (presente, idreserva)
values(True,f_idreserva);
return new;
end $$ language 'plpgsql';

create trigger insere_conf_reserva
after insert on reserva
for each row execute function insereconfreserva();


/*Trigger que impede que o estudate reserve mais de uma reserva de ida em um turno. impedindo que um estudante
alocaque sozinho todo o 
onibus*/
create or replace function verifica_reserva()
returns trigger as $$
declare
verificacao int;
begin
select ar.idaluno into verificacao from aluno_reserva ar
join reserva r on ar.idreserva = r.idreserva
where r.turno = new.turno and r.volta = new.volta;
if verificacao is null then
	return new;
else
	raise exception 'Você não pode realizar outra reserva do tipo volta = % para o mesmo turno 
	pois você já está reservado para outra viagem. Tente Fazer uma reserva de volta para casa desta vez!', new.volta;
	return null;
end if;
end $$ language 'plpgsql';

create trigger trigger_verifica_reserva
before insert on reserva for each row
execute function verifica_reserva();


/*TESTANDO A PROCEDURE, todos os TRIGGER E A FUNCTION PARA CHECAR CAPACIDADE*/
call InserirReserva(1000,'Noite','UFPB',false,current_date,'Municipio Inicial',88); -- cai na excecao da procedure.
call InserirReserva(10,'Noite','UFPB',false,current_date,'Municipio Inicial',5); -- !funciona, viola o trigger trigger_verifica_reserva ;
call InserirReserva(39,'Tarde','UEPB',false,current_date,'Municipio Inicial',1); -- ! funciona pois nao ha mais vagas;
call InserirReserva(40,'Tarde','UFPB',false,current_date,'Municipio Inicial',5);  -- funciona.
/*select a.qrcode from aluno a join aluno_reserva ar on a.idaluno = ar.idaluno
join confirmacao_reserva cr on ar.idreserva = cr.idreserva where cr.idcheck_in = (select max(idcheck_in) from confirmacao_reserva);*/
select PassarCartao(100003);
SELECT * FROM RESERVA;
SELECT * FROM ALUNO_RESERVA;
select * from confirmacao_reserva;


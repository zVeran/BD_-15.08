-- drop database db_b2;
create database db_b2;
use db_b2;

create table tbl_funcionario(
	funcId int auto_increment primary key,
    funcNome char(100) not null,
    FuncEmail varchar(200) not null 
);

-- drop procedure spInsertFuncionario
DELIMITER $$
create procedure spInsertFuncionario(vFuncNome char(100), vFuncEmail varchar(200))
begin
	insert into tbl_funcionario values (default, vFuncNome, vFuncEmail);
end
$$

CALL spInsertFuncionario("José Mario", "jose@escola.com");
CALL spInsertFuncionario("Antonio Pedro", "ant@escola.com");
CALL spInsertFuncionario("Monica Cascão", "moc@escola.com");


create table tb_FuncionarioHistorico LIKE tbl_funcionario;

describe tb_FuncionarioHistorico;

alter table tb_FuncionarioHistorico modify FuncId int not null;

alter table tb_FuncionarioHistorico DROP PRIMARY KEY;

alter table tb_funcionarioHistorico add Atualizacao datetime;
alter table tb_funcionarioHistorico add Situacao char(20);

ALTER TABLE tb_FuncionarioHistorico
ADD CONSTRAINT pk_id_FuncHistorico PRIMARY KEY(FuncId, Atualizacao, Situacao);

Delimiter //
Create trigger TRG_FuncHistoricoInsert after insert on tbl_funcionario
for each row
begin
	Insert into tb_FuncionarioHistorico
    set FuncId = New.FuncId,
	FuncNome = New.FuncNome,
        FuncEmail = New.FuncEmail,
	Atualizacao = current_timestamp(),
	Situacao = "Novo";
end;
//
CALL spInsertFuncionario("Will Jr", "willj@escola.com");
-- truncate tbl_funcionario;
-- select * from tb_FuncionarioHistorico;
-- truncate tb_FuncionarioHistorico;

Delimiter //
Create trigger TRG_FuncHistoricoDelete before delete on tbl_funcionario
for each row
begin
	Insert into tb_FuncionarioHistorico
    set 		FuncId	= 	Old.FuncId,
			  FuncNome	= 	Old.FuncNome,
             FuncEmail 	= 	Old.FuncEmail,
		 Atualizacao	= 	current_timestamp(),
	  Situacao 	= 	"Excluído";
end;
//

delete from tbl_funcionario where FuncId = 3;
-- select * from tbl_funcionario;

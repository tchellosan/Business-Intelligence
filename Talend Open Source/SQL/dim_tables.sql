--dim_fp_funcionario (scd1)
create table "dim_fp_funcionario" 
	(	"sk_funcionario" number not null enable, 
		"cod_funcionario" varchar2(10 byte), 
		"nome_funcionario" varchar2(20 byte), 
		"sobrenome_funcionario" varchar2(40 byte), 
		constraint "dim_fp_funcionario_dim_key_pk" primary key ("sk_funcionario"));
	create index "nfuncionario_idx" on "dim_fp_funcionario" ("cod_funcionario");

-- dim_cargo (scd2)
create table "dim_fp_cargo" 
	(	"sk_cargo" number not null enable, 
		"cod_cargo" varchar2(10 byte), 
		"des_cargo" varchar2(40 byte),
		"dtc_inicio" date, 
		"dtc_fim" date, 
		constraint "dim_fp_cargo_dim_key_pk" primary key ("sk_cargo"));
	create index "ncargo_idx" on "dim_fp_cargo" ("cod_cargo");

-- dim_fp_departamento (scd2)
create table "dim_fp_departamento" 
	(	"sk_departamento" number not null enable, 
		"cod_departamento" varchar2(10 byte), 
		"des_departamento" varchar2(40 byte), 
		"dtc_inicio" date, 
		"dtc_fim" date, 
		constraint "dim_fp_departamento_dim_key_pk" primary key ("sk_departamento"));
	create index "ndepartamento_idx" on "dim_fp_departamento" ("cod_departamento");

-- dim_fp_divisao (scd2)
create table "dim_fp_divisao" 
	(	"sk_divisao" number not null enable, 
		"cod_divisao" varchar2(10 byte), 
		"des_divisao" varchar2(40 byte), 
		"dtc_inicio" date, 
		"dtc_fim" date, 
		constraint "dim_fp_divisao_dim_key_pk" primary key ("sk_divisao"));
	create index "ndivisao_idx" on "dim_fp_divisao" ("cod_divisao");

-- dim_fp_tempo
create table "dim_fp_tempo" 
	(	"sk_tempo" number not null enable, 
		"des_data_dia" varchar2(25 byte), 
		"dtc_data" date,
		"num_ano" number(4,0), 
		"num_mes" number(3,0), 
		"num_dia" number(3,0), 
		"num_quadrimestre" number(3,0), 
		"num_trimestre" number(2,0), 
		"des_quinzena" varchar2(12 byte), 
		"des_quadrimestre" varchar2(12 byte), 
		"num_bimestre" number(3,0), 
		"des_bimestre" varchar2(12 byte), 
		"des_ano_mes" varchar2(8 byte), 
		"des_dia" varchar2(7 byte), 
		"num_semestre" number(3,0), 
		"des_mes_ano_numerico" varchar2(7 byte), 
		"des_trimestre" varchar2(12 byte), 
		"ind_final_semana" char(1 byte), 
		"des_mes" varchar2(15 byte), 
		"num_quinzena" number(3,0), 
		"des_mes_ano_completo" varchar2(30 byte), 
		"des_semestre" varchar2(12 byte), 
		"num_nivel" number(1,0), 
		"des_mes_ano" varchar2(8 byte), 
		constraint "dim_fp_tempo_dim_key_pk" primary key ("sk_tempo"));
	create index "fptempo_idx" on "dim_fp_tempo" ("des_data_dia");
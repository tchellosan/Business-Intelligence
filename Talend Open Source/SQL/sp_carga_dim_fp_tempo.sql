create or replace procedure "sp_carga_dim_fp_tempo"("ano_inicial" in number,  "ano_final" in number)    is 

        dtc_dia date;
        dtr_data date;
        dtc_dia2 varchar(25);
        dia smallint;
        quinzena smallint;
        mes smallint;
        ano smallint;
        dtr_ano_mes int;
        dtr_ano_mes2 varchar(8);
                dtc_mes_ano varchar(8);
                dtc_mes_ano_completo varchar(30);
                dtc_mes_ano_numerico varchar(7);
        nom_quinzena varchar (12);
        nom_mes varchar (15);
        nom_dia varchar (7);
        num_bimestre smallint ;
        num_trimestre smallint ;
        num_quadrimestre smallint ;
        nom_trimestre varchar (12) ;
                nom_bimestre varchar (12) ;
        nom_quadrimestre varchar (12) ;
        num_semestre smallint ;
        nom_semestre varchar (12);
        sts_fim_de_semana char (1);
        num_nivel smallint;
        mes_ant smallint:=0;
        num_trimestre_ant smallint:=0 ;
        num_bimestre_ant smallint:=0 ;
        num_quadrimestre_ant smallint:=0 ;
        num_semestre_ant smallint:=0 ;
        ano_ant smallint:=0;
        num_dia_semana smallint;
        ano_inicio number;
        cont number:=1;
-- main body
begin
   
ano_inicio := ano_inicial;

select ( to_date('01/01/' || ano_inicio,'dd/mm/yyyy') ) into dtc_dia  from dual;

--select dtc_dia2 = substring(convert(char(10),dtc_dia),7,4) + substring(convert(char(10),dtc_dia),4,2) + substring(convert(char(10),dtc_dia),1,2)

delete dim_fp_tempo;

while ano_inicio <= ano_final loop



    dia := extract (day from dtc_dia);
    mes := extract (month from dtc_dia);
    ano := extract (year from dtc_dia);

    num_trimestre := to_char(dtc_dia,'q');
        
    nom_trimestre := num_trimestre || 'º tri/' || ano;

    dtr_ano_mes := (ano*100) + mes;
     
    dtc_dia2 := to_char((dtr_ano_mes*100) + dia);

    /* coloca o bimestre */
    if (mes <= 2) then
        num_bimestre := 1;
    elsif (mes >2 and mes< 5) then
        num_bimestre := 2;
        elsif (mes >=5 and mes< 7) then
        num_bimestre := 3;
    elsif (mes >=7 and mes< 9) then
        num_bimestre := 4;
   elsif (mes >=9 and mes<11) then
        num_bimestre := 5;
    else  
        num_bimestre := 6;
    end if;


        nom_bimestre := num_bimestre || 'º bim/' ||  ano;

    /* coloca o quadrimestre */
    if (num_bimestre <= 2) then
        num_quadrimestre := 1;
    elsif (num_bimestre >2  and num_bimestre <5) then
        num_quadrimestre := 2;
        else 
         num_quadrimestre := 3;
    end if;

        nom_quadrimestre := num_quadrimestre || 'º qim/' || ano;

        /* coloca o semestre */
    if (num_trimestre < 3) then
        num_semestre := 1;
    else
        num_semestre := 2;
    end if;

    nom_semestre := num_semestre || 'º sem/' ||  ano;

    num_dia_semana :=  to_char(dtc_dia,'d');


    if num_dia_semana = 1 or num_dia_semana = 7 then
        sts_fim_de_semana := 1;
    else
        sts_fim_de_semana := 0;
    end if; 

    select case mes
                when 1 then 'janeiro'
                when 2 then 'fevereiro'
                when 3 then 'março'
                when 4 then 'abril'
                when 5 then 'maio'
                when 6 then 'junho'
                when 7 then 'julho'
                when 8 then 'agosto'
                when 9 then 'setembro'
                when 10 then 'outubro'
                when 11 then 'novembro'
                when 12 then 'dezembro'
            end into nom_mes from dual;


        if (dia <16) then
        quinzena := 1;
    else  
        quinzena := 2;
    end if;

    nom_quinzena := quinzena || 'º quin/' || substr(nom_mes,1,3);

    select   case num_dia_semana
                when 1 then 'domingo'
                when 2 then 'segunda'
                when 3 then 'terça'
                when 4 then 'quarta'
                when 5 then 'quinta'
                when 6 then 'sexta'
                when 7 then 'sábado'
            end into nom_dia from dual;

        if (mes <10) then
       dtc_mes_ano_numerico:='0'||to_char(mes)||'/'||substr(to_char(dtr_ano_mes),1,4);
    else  
       dtc_mes_ano_numerico:=to_char(mes)||'/'||substr(to_char(dtr_ano_mes),1,4);
    end if;

        dtc_mes_ano:=substr(nom_mes,1,3)||'/'||substr(to_char(dtr_ano_mes),1,4);
        dtc_mes_ano_completo:=nom_mes||'/'||substr(to_char(dtr_ano_mes),1,4);
                      
    num_nivel  := 1;
    dtr_ano_mes2 := to_char(dtr_ano_mes);
    dtr_data:= to_date(dtc_dia2,'yyyymmdd');

    insert into dim_fp_tempo (dtc_data,num_ano, num_dia, num_mes, sk_tempo, des_ano_mes,des_mes_ano_numerico,des_mes_ano_completo,des_mes_ano,des_data_dia,des_dia, des_mes, des_quinzena, des_semestre, des_trimestre, num_nivel, num_quinzena, num_semestre, num_trimestre, ind_final_semana, des_bimestre, des_quadrimestre, num_bimestre, num_quadrimestre)
    values ( dtr_data,ano, dia, mes, cont,dtr_ano_mes2,dtc_mes_ano_numerico,dtc_mes_ano_completo,dtc_mes_ano,dtc_dia2,nom_dia, nom_mes, nom_quinzena, nom_semestre, nom_trimestre, num_nivel, quinzena, num_semestre, num_trimestre, sts_fim_de_semana, nom_bimestre, nom_quadrimestre, num_bimestre, num_quadrimestre);
    cont := cont + 1;
        commit;
           if (mes_ant != mes) then
        mes_ant := mes;
        num_nivel := 2;
            insert into dim_fp_tempo (dtc_data,num_ano, num_dia, num_mes, sk_tempo,des_ano_mes,des_mes_ano_numerico,des_mes_ano_completo,des_mes_ano,des_data_dia,des_dia, des_mes, des_quinzena, des_semestre, des_trimestre, num_nivel, num_quinzena, num_semestre, num_trimestre, ind_final_semana, des_bimestre, des_quadrimestre, num_bimestre, num_quadrimestre)
        values ( null,ano, null, mes, cont,dtr_ano_mes2,dtc_mes_ano_numerico,dtc_mes_ano_completo,dtc_mes_ano, null, null,nom_mes, null, nom_semestre, nom_trimestre, num_nivel, null, num_semestre, num_trimestre, 0, nom_bimestre, nom_quadrimestre, num_bimestre, num_quadrimestre);
        cont := cont + 1;
                commit;
    end if;
                
    /* acrescenta um dia à data */
    dtc_dia := dtc_dia + 1;
    --select dtc_dia2 = substring(convert(char(10),dtc_dia),7,4) + substring(convert(char(10),dtc_dia),4,2) + substring(convert(char(10),dtc_dia),1,2)
    /* atualiza a condição de saída do loop */
    ano_inicio := extract (year from dtc_dia); 
end loop;                        


   exception
        when others then 
            null;
end;
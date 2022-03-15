
CREATE OR REPLACE FUNCTION getOneTuple() 
RETURNS record 
LANGUAGE plpgsql
AS
$function$

    declare
        res record ;
    begin
        select into res * from client ; 
        return res ;
    end;
$function$;


CREATE OR REPLACE FUNCTION getOneTupleTable() 
RETURNS SETOF client 
LANGUAGE plpgsql
AS 
$function$
    begin 
        return query select * from client ;
    end;
    $function$;


CREATE OR REPLACE FUNCTION lesClients() 
RETURNS SETOF client 
LANGUAGE plpgsql
AS $function$
declare
            res client%ROWTYPE ;
        begin
            for res in select * from client
            loop
                return next res ;
            end loop ;
            return;
        end;
    $function$;

CREATE OR REPLACE FUNCTION nb_operation_compte_mois()
RETURNS  INTEGER 
LANGUAGE plpgsql
AS $function$
DECLARE 
  num_mois INTEGER ;
  num_annee INTEGER ;
  num_compte INTEGER ;
  id_type INTEGER ;

    begin 
    raise info 'debut fonction'
    Select Into num_mois , num_annee , num_compte, id_type count(id_operation) from operation 
    Inner Join compte on num_compte.compte=num_compte.operation 
    Where
  
    raise info 'fin fonction'
    end;

    $function$


CREATE OR REPLACE FUNCTION creer_id_internet()
RETURNS SETOF client
LANGUAGE plpgsql ;
AS $function$
DECLARE
id_internet char(1);
nom_client character varying(30);
prenom_client character varying(30);
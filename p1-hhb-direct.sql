
CREATE OR REPLACE FUNCTION getOneTuple() RETURNS record 
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
AS $function$
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
    $function$
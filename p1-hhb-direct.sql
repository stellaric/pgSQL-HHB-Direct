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

DROP FUNCTION IF EXISTS nb_operation_compte_mois(mois int, annee int, numcompte int, typecompte int);
CREATE OR REPLACE FUNCTION nb_operation_compte_mois(mois int, annee int, numcompte int, typecompte int) RETURNS integer AS
$$
    DECLARE
        curseur CURSOR FOR select num_compte, id_type, date from operation ;
        resultat RECORD ;
        unMois int;
        uneAnnee int;
        res integer := 0;
    BEGIN
        FOR resultat IN curseur LOOP
            unMois := extract(month from resultat.date);
            uneAnnee := extract(year from resultat.date);
            IF uneAnnee = annee AND unMois = mois AND resultat.num_compte = numcompte AND resultat.id_type = typecompte THEN
                res:=res+1;
            end if;
        end loop;
        return res ;
    END;
$$
LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS creer_id_internet(nom varchar, prenom varchar);
CREATE OR REPLACE FUNCTION creer_id_internet(nom varchar, prenom varchar) RETURNS varchar AS
$function$
    DECLARE
        curseur CURSOR FOR select count(num_client) as num_client,identifiant_internet from client group by identifiant_internet;
        resultat RECORD ;
        newID integer:=0;
        idInternet varchar;
        mdpInternet varchar;
    BEGIN
        idInternet := substring(prenom from '^[A-Z]')|| lower(nom);
        FOR resultat IN curseur LOOP
            newID:= count(resultat.num_client);
            IF resultat.identifiant_internet = idInternet THEN
                idInternet := idInternet||newID;
            end if;
        end loop;
        mdpInternet := idInternet;
        return idInternet ||'/'|| mdpInternet ;
    END;
$function$
LANGUAGE plpgsql;



DROP FUNCTION IF EXISTS creer_date(mois integer, annee integer);
CREATE OR REPLACE FUNCTION creer_date(mois integer, annee integer) RETURNS void AS
$function$
    DECLARE
        nbJours integer;
        jour integer := 01;
        uneDate date;
    BEGIN
        IF mois=04 or mois=06 or mois=09 or mois=11 THEN
            nbJours := 30;
        ELSIF mois=01 or mois=03 or mois=05 or mois=07 or mois=08 or mois=10 or mois=12 THEN
            nbJours := 31;
        ELSIF mois = 02 and annee%4 = 0 THEN
            nbJours := 29;
        ELSE
            nbJours := 28;
        END IF;
        WHILE jour <= nbJours LOOP
            uneDate := annee||'-'||mois||'-'||jour;
            INSERT INTO date(date) VALUES (uneDate);
            jour:=jour+1;
        END LOOP;
    END;
$function$
LANGUAGE plpgsql;

-- TD HHB-Direct Langage PL/pgSQL  |  Exercice 5

DROP FUNCTION IF EXISTS creer_user_client();
CREATE OR REPLACE FUNCTION creer_user_client() RETURNS void AS
$function$
    DECLARE
        curseur CURSOR FOR select num_client, identifiant_internet, mdp_internet from client;
        curseur1 CURSOR FOR select usename from pg_user;
        identifiant varchar;
        mdp varchar;
        resultat RECORD ;
        resultat1 RECORD ;
        booléen boolean;
    BEGIN
        FOR resultat IN curseur LOOP
            identifiant:=resultat.identifiant_internet;
            mdp:=resultat.mdp_internet;
            FOR resultat1 IN curseur1 LOOP
                IF identifiant = resultat1.usename THEN
                    booléen := false;
                ELSE
                    booléen := true;
                end if;
            end loop;
            IF booléen = true THEN
                INSERT INTO pg_user (usename) VALUES (identifiant);
            end if;
        end loop;
    END;
$function$
LANGUAGE plpgsql;


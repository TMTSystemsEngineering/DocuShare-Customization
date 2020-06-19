-- FUNCTION: public.tmt_dsobject_insert()
DROP TRIGGER tmt_dsobject_insert ON public.dsobject_table;
DROP FUNCTION public.tmt_dsobject_insert();

CREATE FUNCTION public.tmt_dsobject_insert()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
declare
    parts varchar(32)[];
    leader varchar(80);
    trailer varchar(32);
begin
if NEW.handle_class = 2 then
    parts := string_to_array(NEW.document_dcn, '.');
    if (array_length(parts, 1) >= 5) then
        leader := parts[1] || '.' || parts[2] || '.' || parts[3] || '.' || parts[4] || '.' || parts[5];
        trailer := '\.[A-Z0-9]{4,5}';

        if exists (select 1 from tmt_dcn_issued as T where (T.dcn = leader or T.dcn similar to (leader || trailer) ) and T.date_uploaded is null) then
            update tmt_dcn_issued 
               set date_uploaded = localtimestamp
                 , ds_doc_handle='Document-' || NEW.handle_index 
             where dcn = leader or dcn similar to (leader || trailer) ;
        elseif exists (select 1 from tmt_dcn_issued as T where (T.dcn = leader or T.dcn similar to (leader || trailer) ) and T.date_uploaded is not null) then
            NEW.object_summary := 'This document''s DCN ' || NEW.document_dcn || ' duplicates an existing document''s. ' || OLD.object_summary;
            NEW.document_dcn := 'DUPLICATE';
        else
            -- Cannot upload a document to a DCN that was never reserved
            NEW.object_summary := 'This document''s DCN ' || NEW.document_dcn || ' has not been issued. ' || OLD.object_summary;
            NEW.document_dcn := 'INVALID';
        end if;
    else
        NEW.object_summary := 'This document''s DCN ' || NEW.document_dcn || ' is structurally invalid. ' || OLD.object_summary;
        NEW.document_dcn := 'INVALID';
    end if;
end if;
return NEW;
end;
$BODY$;

ALTER FUNCTION public.tmt_dsobject_insert()
    OWNER TO docushare_admin;

CREATE TRIGGER tmt_dsobject_insert
    BEFORE INSERT
    ON public.dsobject_table
    FOR EACH ROW
    WHEN ((new.handle_class = (2)::numeric))
    EXECUTE PROCEDURE public.tmt_dsobject_insert();
CREATE FUNCTION public.tmt_dsobject_update()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
begin
if OLD.handle_class = 2 then
    if OLD.object_isdeleted = 0 and NEW.object_isdeleted = 1 then
        -- Sent to trash
        update tmt_dcn_issued set date_uploaded = NULL, ds_doc_handle = NULL where dcn = OLD.document_dcn;
    elseif OLD.object_isdeleted = 1 and NEW.object_isdeleted = 0 then
        -- Retrieved from trash
        update tmt_dcn_issued set date_uploaded = OLD.object_create_date, ds_doc_handle = 'Document-' || OLD.handle_index where dcn = OLD.document_dcn;
    end if;

    if OLD.document_dcn != NEW.document_dcn then
        -- unlink old DCN from this document
		update tmt_dcn_issued set date_uploaded = NULL, ds_doc_handle = NULL where dcn = OLD.document_dcn;
		-- link new DCN to this document
		update tmt_dcn_issued set date_uploaded = NEW.object_create_date, ds_doc_handle = 'Document-' || NEW.handle_index where dcn = NEW.document_dcn;
	end if;
end if;
return NEW;
end;
$BODY$;

ALTER FUNCTION public.tmt_dsobject_update()
    OWNER TO docushare_admin;

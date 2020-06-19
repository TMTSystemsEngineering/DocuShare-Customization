-- FUNCTION: public.tmt_dsobject_update()
DROP TRIGGER tmt_dsobject_update ON public.dsobject_table;
DROP FUNCTION public.tmt_dsobject_update();

CREATE FUNCTION public.tmt_dsobject_update()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
declare
    oldParts varchar(32)[];
	newParts varchar(32)[];
	yearCalc integer;
begin
	-- if not a document, then just return NEW (i.e. "proceed")
	if OLD.handle_class != 2 then 
		return NEW;
	end if;

	-- if the DCN is unchanged, then just return NEW (i.e. "proceed")
	if OLD.document_dcn = NEW.document_dcn then 
		return NEW;
	end if;

	-- user changed the DCN. See if the new DCN is already in use
	if exists (select 1 from tmt_dcn_issued as T where T.dcn = NEW.document_dcn and T.ds_doc_handle != ('Document-' || cast(NEW.handle_index as varchar))) then
		NEW.object_summary := 'Attempt to change document''s DCN to a value already in use: ' || NEW.document_dcn || '. '  || COALESCE(OLD.object_summary, '');
		-- undo the user's change to the DCN
		NEW.document_dcn := OLD.document_dcn;
	end if;

	-- Break the DCN into constituent parts
	oldParts := string_to_array(OLD.document_dcn, '.');
	newParts := string_to_array(NEW.document_dcn, '.');

	-- update the existing document's record
	if exists (select 1 from tmt_dcn_issued as T where T.dcn = OLD.document_dcn) then
		if (array_length(newParts, 1) = 6) then
			yearCalc = COALESCE (cast (newParts[4] as integer), 1900);
			update tmt_dcn_issued
				set title                   = COALESCE (NEW.object_title, '')
				  , keywords                = COALESCE (NEW.object_keywords, '')
				  , telescope               = COALESCE (newParts[1], '')
				  , group_category          = COALESCE (newParts[2], '')
				  , document_type           = COALESCE (newParts[3], '')
				  , year                    = CASE WHEN yearCalc < 80 THEN yearCalc + 2000 WHEN yearCalc < 100 THEN yearCalc + 1900 ELSE yearCalc END
				  , sequence_number         = COALESCE (cast (newParts[5] as integer), 0)
				  , document_version        = COALESCE (substring (newParts[6] from 1 for 3), '')
				  , version_sequence_number = COALESCE (cast (substring (newparts[6] from 4 for 2) as integer), 0)
				  , dcn                     = NEW.document_dcn
				  , ds_doc_handle           = 'Document-' || NEW.handle_index
				  , date_uploaded           = CURRENT_TIMESTAMP
				where dcn = OLD.document_dcn;
		else
			update tmt_dcn_issued
				set title                   = COALESCE (NEW.object_title, '')
				  , keywords                = COALESCE (NEW.object_keywords, '')
				  , dcn                     = NEW.document_dcn
				  , ds_doc_handle           = 'Document-' || NEW.handle_index
				  , date_uploaded           = CURRENT_TIMESTAMP
				where dcn = OLD.document_dcn;
			NEW.object_summary := 'This document''s DCN ' || NEW.document_dcn || ' is structurally invalid. '  || COALESCE(OLD.object_summary, '');
		end if;
	end if;
	return NEW;
end;
$BODY$;

ALTER FUNCTION public.tmt_dsobject_update()
    OWNER TO docushare_admin;

CREATE TRIGGER tmt_dsobject_update
    BEFORE UPDATE 
    ON public.dsobject_table
    FOR EACH ROW
    WHEN ((old.handle_class = (2)::numeric))
    EXECUTE PROCEDURE public.tmt_dsobject_update();

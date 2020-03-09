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
        -- Change of the final component ("DRF01", "REL02", etc.) is allowed, but otherwise change is not allowed
        if split_part(OLD.document_dcn, '.', 1) != split_part(NEW.document_dcn, '.', 1)
        or split_part(OLD.document_dcn, '.', 2) != split_part(NEW.document_dcn, '.', 2)
        or split_part(OLD.document_dcn, '.', 3) != split_part(NEW.document_dcn, '.', 3)
        or split_part(OLD.document_dcn, '.', 4) != split_part(NEW.document_dcn, '.', 4)
        or split_part(OLD.document_dcn, '.', 5) != split_part(NEW.document_dcn, '.', 5) then
	    NEW.document_dcn := OLD.document_dcn;
	end if;
    end if;
end if;
return NEW;
end;

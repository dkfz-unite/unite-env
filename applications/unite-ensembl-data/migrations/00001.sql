ALTER TABLE `object_xref`
ADD INDEX `ensembl_object_type_xref_id` (`ensembl_object_type`, `xref_id`);
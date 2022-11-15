SELECT DISTINCT text,
                functions.source_id,
                REGEXP_REPLACE(links.value, '\/([\-a-zA-Z\d]*)\/([_\.\-a-zA-Z\d]*)\/.*', '/\1/\2/')
  FROM functions,
       links
 WHERE functions.source_id = links.id
 ORDER BY source_id;
SELECT DISTINCT TEXT, REGEXP_REPLACE(links.value, '^.*/([^/]*?)(\.[^/.]+)?$', '\1\2')
  FROM links,
       FUNCTIONS
           INNER JOIN (SELECT DISTINCT source_id, INDEX
                         FROM tokens
                       EXCEPT
       (SELECT DISTINCT id, source_id
          FROM tokens
         WHERE token IN ('PLpgSQL_stmt_execsql', 'PLpgSQL_stmt_loop',
                         'PLpgSQL_stmt_return', 'PLpgSQL_row',
                         'PLpgSQl_stmt_fors', 'PLpgSQL_exception', 'PLpgSQL_exception_block',
                         'PLpgSQL_raise_option',
                         'PLpgSQL_rec', 'PLpgSQL_recfield', 'PLpgSQL_stmt_dynexecute', 'PLpgSQL_stmt_dynfors',
                         'PLpgSQL_stmt_getdiag', 'PLpgSQL_stmt_perform', 'PLpgSQL_stmt_raise',
                         'PLpgSQL_stmt_return_next', 'PLpgSQL_stmt_return_query', 'WRITE')
         UNION
       (SELECT DISTINCT source_id, INDEX
          FROM tokens
         WHERE token = 'return_trigger'
         UNION
        SELECT DISTINCT source_id, INDEX
          FROM tokens
         WHERE token = 'PLpgSQL_stmt_return_next'
            OR token = 'PLpgSQL_stmt_return_query'
         UNION
        SELECT DISTINCT source_id, index
          FROM functions
         WHERE LOWER(text) LIKE '%insert%'
            OR LOWER(text) LIKE '%update%'
            OR LOWER(text) LIKE '%delete%'))) AS t
                      ON FUNCTIONS.source_id = t.source_id AND FUNCTIONS.index = t.index
 WHERE links.id = t.source_id;
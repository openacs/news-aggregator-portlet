<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="select_items">
      <querytext>
	select s.source_id, 
               s.link, 
               s.description,
               s.title, 
               to_char(last_scanned, 'YYYY-MM-DD HH24:MI:SS') as last_scanned,
               to_char(creation_date, 'YYYY-MM-DD HH24') as sort_date,
	       feed_url, 
	       item_id, 
               i.title as item_title, 
               i.link as item_link, 
               i.description as item_description
        from na_sources s, na_items i
	where s.source_id = i.source_id
        and   deleted_p = '0'
	and   package_id in ([join $list_of_package_ids ", "])
        and   rownum <= 10
	order by creation_date desc
</querytext>
</fullquery>

</queryset>

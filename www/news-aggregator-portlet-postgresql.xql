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
               (select site_node__url(site_nodes.node_id)
               from site_nodes
               where site_nodes.object_id = package_id) as url,
               feed_url,
               item_id,
               i.title as item_title,
               i.link as item_link,
               i.description as item_description
        from   na_sources s left outer join 
               na_items i on (s.source_id = i.source_id)
        where  deleted_p = '0'
	and    package_id in ([join $list_of_package_ids ", "])
        order  by creation_date desc
        limit  10
</querytext>
</fullquery>

</queryset>

ad_page_contract {
    The display logic for the news aggregator portlet
    @author Simon Carstensen (simon@bcuni.net)
} {
    item_id:integer,notnull,optional,multiple
} -properties {

}

set user_id [ad_conn user_id]
set write_p [permission::permission_p -object_id $user_id -privilege write]

array set config $cf
set shaded_p 0

set list_of_package_ids $config(package_id)
set one_instance_p [ad_decode [llength $list_of_package_ids] 1 1 0]

set package_id [lindex $list_of_package_ids 0]
set aggregator_id [db_string get_aggregator_id {
    select min(aggregator_id)
      from na_aggregators
     where package_id = :package_id
} -default ""]

if {$aggregator_id eq ""} {
    # We have a problem!
    return -code error "There should be an aggregator"
}

set subscription_url [export_vars -base "[lindex [site_node::get_url_from_object_id -object_id $package_id] 0]subscriptions" -url {aggregator_id}]

db_multirow -extend {
    content
    url
} items select_items [subst {
    select s.source_id,
           s.link,
           s.description,
           s.title,
           to_char(last_scanned, 'YYYY-MM-DD HH24:MI:SS') as last_scanned,
           to_char(creation_date, 'YYYY-MM-DD HH24') as sort_date,
           (select site_nodes.node_id
           from site_nodes
           where site_nodes.object_id = package_id) as node_id,
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
    fetch first 10 rows only
}] {
    set url [site_node::get_url -node_id $node_id]
    set text_only [ad_string_truncate -len 300 -- $item_description]
    if {[info exists item_title] && $item_tytle ne "" && ![string equal -nocase $item_title $text_only] } {
        set content "<a href=\"$item_link\">$item_title</a>. $text_only"
    } else {
        set content $text_only
    }
}

ad_page_contract {
    The display logic for the news aggregator portlet
    @author Simon Carstensen (simon@bcuni.net)
} {
    item_id:integer,notnull,optional,multiple
} -properties {

}

set user_id [ad_conn user_id]
set write_p [ad_permission_p $user_id write]

array set config $cf	
set shaded_p 0

set list_of_package_ids $config(package_id)
set one_instance_p [ad_decode [llength $list_of_package_ids] 1 1 0]

db_multirow -extend content items select_items {} {
    set text_only [string_truncate -len 300 $item_description]
    if {[exists_and_not_null item_title] && ![string equal -nocase $item_title $text_only] } {
        set content "<a href=\"$item_link\">$item_title</a>. $text_only"
    } else {
        set content $text_only
    }
}

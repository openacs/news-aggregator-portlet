ad_page_contract {
    The display logic for the news aggregator portlet

    @author Simon Carstensen (simon@bcuni.net)
} -properties {
    
}


array set config $cf
set user_id [ad_conn user_id]
set list_of_package_ids $config(package_id)

if {[llength $list_of_package_ids] > 1} {
    # We have a problem!
    return -code error "There should be only one instance of news aggregator for admin purposes"
}        

set package_id [lindex $list_of_package_ids 0]        
set aggregator_id [db_string get_aggregator_id "select aggregator_id from na_aggregators where package_id = :package_id" -default ""]

if {$aggregator_id eq ""} {
    # We have a problem!
    return -code error "There should be an aggregator"
}

set url [export_vars -base "[lindex [site_node::get_url_from_object_id -object_id $package_id] 0]subscriptions" -url {aggregator_id}]


ad_return_template 

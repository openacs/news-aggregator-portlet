ad_library {

    Procedures to support the news aggregator admin portlet

    @creation-date Mar 2003
    @author simon@bcuni.net

}

namespace eval news_aggregator_admin_portlet {}

ad_proc -private news_aggregator_admin_portlet::get_my_name {
} {
    return "news_aggregator_admin_portlet"
}



ad_proc -public news_aggregator_admin_portlet::get_pretty_name {} {
    Get portlet pretty name
} {
    return "#news-aggregator-portlet.news_aggregator_admin_portlet_pretty_name#"
}



ad_proc -private news_aggregator_admin_portlet::my_package_key {
} {
    return "news-aggregator-portlet"
}



ad_proc -public news_aggregator_admin_portlet::link {} {
    Get portlet link
} {
    return ""
}



ad_proc -public news_aggregator_admin_portlet::add_self_to_page {
    {-portal_id:required}
    {-page_name ""}
    {-package_id:required}
} {
    Adds a news-aggregator admin PE to the given portal
    
    @param portal_id The page to add self to
    @param package_id The package_id of the news-aggregator package
    
    @return element_id The new element's id
} {
    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -key package_id \
                -value $package_id
           ]
}



ad_proc -public news_aggregator_admin_portlet::remove_self_from_page {
    {-portal_id:required}
} {
    Removes a news-aggregator admin PE from the given page
} {
    portal::remove_element \
        -portal_id $portal_id \
        -portlet_name [get_my_name]
}



ad_proc -public news_aggregator_admin_portlet::show {
    cf
} {
    Show portlet
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "news-aggregator-admin-portlet"
    
}

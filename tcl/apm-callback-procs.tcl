ad_library {
    Procedures for initializing service contracts etc. for the
    news aggregator portlet package. Should only be executed 
    once upon installation.
    
    @creation-date 8 May 2003
    @author Simon Carstensen (simon@collaboraid.biz)
    @cvs-id $Id$
}


namespace eval news_aggregator_portlet {}
namespace eval news_aggregator_admin_portlet {}

ad_proc -private news_aggregator_portlet::after_install {} {
    Create the datasources needed by the news aggregator portlet.
} {
    
    db_transaction {
	set ds_id [portal::datasource_new \
                   -name "news_aggregator_portlet" \
                   -description "News Aggregator Portlet"]

	portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value t

	portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value t

        portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value f

        portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

	register_portal_datasource_impl
        
        news_aggregator_admin_portlet::after_install

    }
}



ad_proc -private news_aggregator_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the news-aggregator portlet.
} {
    set spec {
        name "news_aggregator_portlet"
	contract_name "portal_datasource"
	owner "news-aggregator-portlet"
        aliases {
	    GetMyName news_aggregator_portlet::get_my_name
	    GetPrettyName  news_aggregator_portlet::get_pretty_name
	    Link news_aggregator_portlet::link
	    AddSelfToPage news_aggregator_portlet::add_self_to_page
	    Show news_aggregator_portlet::show
	    Edit news_aggregator_portlet::edit
	    RemoveSelfFromPage news_aggregator_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}



ad_proc -private news_aggregator_portlet::uninstall {} {
    News Aggregator Portlet package uninstall proc
} {
    unregister_implementations

    news_aggregator_admin_portlet::unregister_implementations
}



ad_proc -private news_aggregator_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "news_aggregator_portlet"
}



ad_proc -private news_aggregator_admin_portlet::after_install {} {
    Create the datasources needed by the news aggregator portlet.
} {
    
    db_transaction {
	set ds_id [portal::datasource_new \
                   -name "news_aggregator_admin_portlet" \
                   -description "News Aggregator Admin Portlet"]

	portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value f

	portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value f

        portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value t

        portal::datasource_set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

	register_portal_datasource_impl
    }
}



ad_proc -private news_aggregator_admin_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the news-aggregator admin portlet.
} {
    set spec {
        name "news_aggregator_admin_portlet"
	contract_name "portal_datasource"
	owner "news-aggregator-portlet"
        aliases {
	    GetMyName news_aggregator_admin_portlet::get_my_name
	    GetPrettyName  news_aggregator_admin_portlet::get_pretty_name
	    Link news_aggregator_admin_portlet::link
	    AddSelfToPage news_aggregator_admin_portlet::add_self_to_page
	    Show news_aggregator_admin_portlet::show
	    Edit news_aggregator_admin_portlet::edit
	    RemoveSelfFromPage news_aggregator_admin_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}



ad_proc -private news_aggregator_admin_portlet::before_uninstall {} {
    News Aggregator Portlet package uninstall proc
} {
    unregister_implementations
}



ad_proc -private news_aggregator_admin_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "news_aggregator_admin_portlet"
}

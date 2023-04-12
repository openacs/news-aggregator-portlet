ad_library {

    Automated tests for the news-aggregator-portlet package.

}

aa_register_case -procs {
    news_aggregator_admin_portlet::show
    news_aggregator_portlet::show
    news_aggregator::aggregator::new
} -cats {
    api
    smoke
} news_aggregator_render_portlet {
    Test the rendering of the portlets
} {
    aa_run_with_teardown -rollback -test_code {
        set package_id [site_node::instantiate_and_mount \
                            -package_key news-aggregator \
                            -node_name __test_news_aggregator_portlet]

        set aggregator_id [news_aggregator::aggregator::new \
                               -aggregator_name __test_aggregator \
                               -description {A Test Aggregator} \
                               -package_id $package_id \
                               -public_p true]

        foreach shaded_p {true false} {
            set cf [list \
                        package_id $package_id \
                        shaded_p $shaded_p \
                       ]

            foreach portlet {news_aggregator_admin_portlet news_aggregator_portlet} {
                set section_name $portlet
                if {$shaded_p} {
                    append section_name " (shaded)"
                }
                aa_section $section_name

                set portlet [acs_sc::invoke \
                                 -contract portal_datasource \
                                 -operation Show \
                                 -impl $portlet \
                                 -call_args [list $cf]]

                aa_log "Portlet returns: [ns_quotehtml $portlet]"

                aa_false "No error was returned" {
                    [string first "Error in include template" $portlet] >= 0
                }

                aa_false "No unresolved message keys" {
                    [string first "MESSAGE KEY MISSING: " $portlet] >= 0
                }

                aa_true "Portlet contains something" {
                    [string length [string trim $portlet]] > 0
                }
            }
        }
    }
}

aa_register_case -procs {
    news_aggregator_admin_portlet::link
    news_aggregator_portlet::link
    news_aggregator_admin_portlet::get_pretty_name
    news_aggregator_portlet::get_pretty_name
} -cats {
    api
    production_safe
} news_aggregator_portlet_links_names {
    Test diverse link and name procs.
} {
    aa_equals "News_Aggregator admin portlet link" \
        [news_aggregator_admin_portlet::link] ""
    aa_equals "News_Aggregator portlet link" \
        [news_aggregator_portlet::link] ""
    aa_equals "News_Aggregator admin portlet pretty name" \
        [news_aggregator_admin_portlet::get_pretty_name] "#news-aggregator-portlet.news_aggregator_admin_portlet_pretty_name#"
    aa_equals "News_Aggregator portlet pretty name" \
        [news_aggregator_portlet::get_pretty_name] "#news-aggregator-portlet.news_aggregator_portlet_pretty_name#"
}

aa_register_case -procs {
    news_aggregator_portlet::get_my_name
    news_aggregator_portlet::add_self_to_page
    news_aggregator_portlet::remove_self_from_page
    news_aggregator_admin_portlet::get_my_name
    news_aggregator_admin_portlet::add_self_to_page
    news_aggregator_admin_portlet::remove_self_from_page
} -cats {
    api
} news_aggregator_portlet_add_remove_from_page {
    Test add/remove portlet procs.
} {
    #
    # Helper proc to check portal elements
    #
    proc portlet_exists_p {portal_id portlet_name} {
        return [db_0or1row portlet_in_portal {
            select 1 from dual where exists (
              select 1
                from portal_element_map pem,
                     portal_pages pp
               where pp.portal_id = :portal_id
                 and pp.page_id = pem.page_id
                 and pem.name = :portlet_name
            )
        }]
    }
    #
    # Start the tests
    #
    aa_run_with_teardown -rollback -test_code {
        #
        # Create a community.
        #
        # As this is running in a transaction, it should be cleaned up
        # automatically.
        #
        set community_id [dotlrn_community::new -community_type dotlrn_community -pretty_name foo]
        if {$community_id ne ""} {
            aa_log "Community created: $community_id"
            set portal_id [dotlrn_community::get_portal_id -community_id $community_id]
            set package_id [dotlrn::instantiate_and_mount $community_id [news_aggregator_portlet::my_package_key]]
            #
            # news_aggregator_portlet
            #
            set portlet_name [news_aggregator_portlet::get_my_name]
            #
            # Add portlet.
            #
            news_aggregator_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id -param_action ""
            aa_true "Portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Remove portlet.
            #
            news_aggregator_portlet::remove_self_from_page -portal_id $portal_id -package_id $package_id
            aa_false "Portlet is in community portal after removal" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Add portlet.
            #
            news_aggregator_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id -param_action ""
            aa_true "Portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"

            #
            # news_aggregator_admin_portlet
            #
            set portlet_name [news_aggregator_admin_portlet::get_my_name]
            aa_log "Exists? [portlet_exists_p $portal_id $portlet_name]"
            #
            # Add portlet.
            #
            news_aggregator_admin_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id
            aa_true "Portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Remove portlet.
            #
            news_aggregator_admin_portlet::remove_self_from_page -portal_id $portal_id
            aa_false "Portlet is in community portal after removal" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Add portlet.
            #
            news_aggregator_admin_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id
            aa_true "Portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"
        } else {
            aa_error "Community creation failed"
        }
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

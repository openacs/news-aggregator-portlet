<if @shaded_p@ ne "t">

  <if @items:rowcount@ gt 0>

    <table cellspacing=1 cellpadding=0 border=0>
	<tr>
        <td bgcolor="#cccccc">
          <table cellspacing=1 cellpadding=5 border=0 width="100%">
            <multiple name="items">
	      <group column="sort_date">
                <tr bgcolor="#f5f5f5">
                    <td><b><a href="@items.link@">@items.title@</a>, @items.last_scanned@</b></td>
                    <td><a href="@items.feed_url@">RSS</a></td>
                </tr>
                <group column="source_id">
                  <tr bgcolor="#ffffff">
                      <td>
                        @items.content@
                        <if @items.item_link@ not nil>
                          <a href="@items.item_link@">#</a>
                        </if>
                      </td>
                      <td>&nbsp;</td>
                    </tr>
                  </group>
                </group>
	      </multiple>
            </table>
          </td>
        </tr>
    </table>

  <if @items:rowcount@ eq 0>
    <small>No Feeds.</small>
  </if>

  <if @write_p@ eq 1>
    <p>
      <b>&raquo;</b> <a href="@items.url@subscriptions">Add or remove subscriptions</a>
    </p>
  </if>

  </if>
  <else>
    <small>No Items</small>
  </else>

</if>
<else>
&nbsp;
</else>

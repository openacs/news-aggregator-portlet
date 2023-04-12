<if @shaded_p;literal@ false>

  <if @items:rowcount@ gt 0>

    <multiple name="items">
      <div><b>@items.item_display_date@</b></div>
      <ul style="margin-top:0px;margin-bottom:5px;">
        <group column="item_sort_date">
          <li><a href="@items.item_link@" target="_blank">@items.item_title@</a></li>
        </group>
      </ul>
    </multiple>

  </if>
  <else>
    <small>#news-aggregator.No_items#</small>
  </else>

</if>
<else>
  <small>
    #new-portal.when_portlet_shaded#
  </small>
</else>

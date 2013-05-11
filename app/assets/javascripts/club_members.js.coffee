@Router['club_members'] =
  show: ->
    $('.facebook-share').click (e) ->
      e.preventDefault()
      fb_publish $(@).data("name"), $(@).data("orgname"), $(@).data("uid")
    
    $(".organization button").click ->
      $("#club_member_organization_id").val $(this).data('id')

    # Club Leader.
    merge_types = []
    $("input[type='checkbox']").click ->
      if $(this).is ':checked'
        merge_types.push $(this).data('type')
      else
        index = merge_types.indexOf $(this).data('type')
        merge_types.splice index, 1        

      console.log merge_types
      refreshMergeButton merge_types
    
    refreshMergeButton = (merge_types) ->  
      if merge_types.length == 2        
        # Make sure both email and facebook account are selected.
        if merge_types.indexOf("email") != -1 && merge_types.indexOf("facebook") != -1
          enableMerge()
        else
          disableMerge()
      else
        disableMerge()  
        
    enableMerge = ->
      $(".grey-btn").removeAttr("disabled");

    disableMerge  = ->    
      $(".grey-btn").attr("disabled", "disabled");

    refreshMergeButton merge_types
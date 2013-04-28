@Router['club_members'] =
  show: ->
    $('.facebook-share').click (e) ->
      e.preventDefault()
      fb_publish $(@).data("name"), $(@).data("orgname"), $(@).data("uid")
    

    $(".organization button").click ->
      $("#club_member_organization_id").val $(this).data('id')
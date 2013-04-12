@Router['club_members'] =
  show: ->
    $(".organization button").click ->
      $("#club_member_organization_id").val $(this).data('id')
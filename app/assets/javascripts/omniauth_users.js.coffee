@Router['omniauth_users'] =
  show: ->
    $(".organization button").click ->
      $("#omniauth_user_organization_id").val $(this).data('id')
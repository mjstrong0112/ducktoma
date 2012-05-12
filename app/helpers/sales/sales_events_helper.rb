module Sales::SalesEventsHelper
  def adoption_row adoption
    adoption.user == current_user ? klass = 'blue_highlight' : klass = ''
    fields = [adoption.user.email,
              adoption.adopter_info.full_name,
              number_to_currency(adoption.dollar_fee)]

    content_tag :tr, class: klass {
      raw(
        fields.collect do |field|
          content_tag :td, field
        end.join
      )
    }
  end
end

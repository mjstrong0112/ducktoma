class RegenDucksMailer < ActionMailer::Base
  default :from => "duckrace@rrsertoma.org"

  def success
    mail(:to => "ducksale@rrsertoma.org", :subject => "Ducks regenerated successfully!")
  end

  def error
    mail(:to => "ducksale@rrsertoma.org", :subject => "Ducks did not regenerate.")
  end

end
desc "Regenerate Duck Numbers"
task :regen_ducks => :environment do
  begin
    # Set invalid adoptions to have a number of -1 since they no longer count.
    Adoption.invalid.each do |adoption|
      adoption.ducks.each do |duck|
        duck.number = -1
        duck.save
      end
    end

    # Regenerate the duck numbers of valid adoptions so that there
    # will be no gaps in the numbers.
    duck_count = 1
    Adoption.valid.order('number asc').each do |adoption|
      adoption.ducks.each do |duck|
        duck.number = duck_count
        duck.save

        duck_count += 1
      end
    end
    
    RegenDucksMailer.success.deliver
  rescue
    # If anything goes wrong send a not successful email
    RegenDucksMailer.error.deliver
  end
  
end
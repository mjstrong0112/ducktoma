task import_chrs_data: :environment do
  require 'csv'
  url = "#{Rails.root}/lib/assets/chrs_band_info.csv"

  org = Organization.find_by_name "CRHB - Cedar Ridge High Band"

  CSV.parse(File.read(url), headers: true) do |row|
    name = [ row["First Name"], row["Last Name"] ].join(" ")
    c = ClubMember.new(
      name: name,
      email: row["E-Mail Address"],
      title: row["Instrument"],
      password: row["First Name"] + row["Last Name"] + "CHRB",
      password_confirmation: row["First Name"] + row["Last Name"] + "CHRB"      
    )

    c.organization = org

    $stderr.puts "Could not save #{name}: " + c.errors.full_messages.join(", ") if !c.save
  end
end
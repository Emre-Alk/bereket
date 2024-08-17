class PdfGenerationJob < ApplicationJob
  queue_as :default

  def perform(donation_id)
    # Do something later
    # cerfa for 1 donation
    donation = Donation.find(donation_id)
    donator = donation.donator
    return unless donation

    amount = donation.amount.to_f / 100
    data = {
      asso: {
        identity: {
          name: donation.place.asso.name,
          nra: donation.place.asso.code_nra,
          object: 'association a but non lucratif', # to be added in the asso table 'donation.place.asso.objet'
          regime: AssoType.find(donation.place.asso.asso_type_id).name,
          signature: donation.place.asso.signature
        },
        place: {
          street_no: donation.place.street_no,
          address: donation.place.address,
          zip_code: donation.place.zip_code || '69000',
          city: donation.place.city,
          country: donation.place.country
        }
      },
      donator: {
        first_name: donator.first_name,
        last_name: donator.last_name
      },
      donation: {
        amount: ,
        amount_human: amount.humanize(locale: :fr),
        occured_on: donation.occured_on.to_date.strftime('%d     %m     %Y') # whitespace to fit template
      },
      today: Date.today.strftime('%d  %m  %Y'), # whitespace to fit template
      receipt: '1234567890' # create a table to store receipt id and donation id. Legaly following order during the year (to be checked)
    }

    pdf_compiled = PdfGenerator.new(data).generate
    return unless pdf_compiled

    puts '👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍'

    donator.cerfa.attach(
      io: StringIO.new(pdf_compiled),
      filename: 'cerfa_11580_05',
      content_type: 'application/pdf',
    )

    puts '✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅'
  end
end

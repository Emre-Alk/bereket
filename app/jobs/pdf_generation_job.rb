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
          object: donation.place.asso.objet,
          regime: donation.place.asso.asso_type.name,
          signature: donation.place.asso.signature
        },
        place: {
          street_no: donation.place.street_no,
          address: donation.place.address,
          zip_code: donation.place.zip_code,
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
      receipt: "#{donation.id}-#{donation.created_at.to_i}"
    }

    pdf_compiled = PdfGenerator.new(data).generate
    return unless pdf_compiled

    # puts '👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍'

    upload_response = Cloudinary::Uploader.upload(
      StringIO.new(pdf_compiled),
      public_id: 'cerfa_11580_05',
      folder: "#{Rails.env}/donator/#{donator.id}/cerfa",
      resource_type: :auto, # :raw any non-image/video types
      overwrite: true
    )
    # puts '👊👊👊👊👊👊👊👊👊👊👊👊👊'

    # puts upload_response
    # puts upload_response['secure_url']

    # puts '👊👊👊👊👊👊👊👊👊👊👊👊👊'

    file = URI.parse(upload_response['secure_url']).open

    donator.cerfa.attach(
      io: file,
      filename: "cerfa_11580_05_donator_#{donator.id}.pdf",
      content_type: 'application/pdf'
    )

    donator.save

    # puts '✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅'
  end
end

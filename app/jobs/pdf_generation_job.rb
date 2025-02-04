class PdfGenerationJob < ApplicationJob
  queue_as :default

  def perform(donation_id, options = {})
    # Do something later
    # cerfa for 1 donation
    donation = Donation.find(donation_id)
    return unless donation

    donator = donation.donator

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
        first_name: options[:content].present? ? options[:content][:first_name] : donator.first_name, # bc if visitor, record is empty
        last_name: options[:content].present? ? options[:content][:last_name] : donator.last_name, # bc if visitor, record is empty
        address: options[:content].present? ? options[:content][:address] : donator.address,
        city: options[:content].present? ? options[:content][:city] : donator.city,
        zip_code: options[:content].present? ? options[:content][:zip_code] : donator.zip_code,
        country: 'France'
      },
      donation: {
        amount: ,
        amount_human: amount.humanize(locale: :fr),
        occured_on: donation.occured_on.to_date.strftime('%d     %m     %Y'), # whitespace to fit template
        mode: donation.mode
      },
      today: Date.today.strftime('%d  %m  %Y'), # whitespace to fit template
      receipt: "#{donation.id}-#{donation.created_at.to_i}"
    }

    service_pdf = PdfGenerator.new(data).generate
    return unless service_pdf

    # puts '👍👍👍👍👍👍👍👍👍👍👍👍👍👍👍'

    # upload_response = Cloudinary::Uploader.upload(
    #   StringIO.new(service_pdf),
    #   public_id: 'cerfa_11580_05',
    #   folder: "#{Rails.env}/donator/#{donator.id}/cerfa",
    #   resource_type: :auto, # :raw any non-image/video types (ex: xls)
    #   overwrite: true
    # )

    # file = URI.parse(upload_response['secure_url']).open

    # donator.cerfa.attach(
    #   io: file,
    #   filename: "cerfa_11580_05_000#{donator.id}000#{donation.id}.pdf",
    #   content_type: 'application/pdf'
    # )

    filename = "cerfa_11580_05_#{Time.now.to_i}"

    donator.cerfa.attach(
      io: StringIO.new(service_pdf),
      filename: "#{filename}.pdf",
      content_type: 'application/pdf',
      metadata: { overwrite: true },
      key: "donator/#{donator.id}/cerfa/#{filename}"
    )
  end
end

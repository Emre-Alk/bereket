class PdfsController < ApplicationController
  def generate
    # get all the associations the donator donated to
    # per association, sum the donations
    # pack all cerfa per association into one pdf

    # for an individual donation
    # 'donator = current_user.donator" no need of this line because donator can be retrieve from donation
    donation = Donation.find(params[:don_id])
    donator = donation.donator
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

    # for donations over a time interval - works but not finished
    # donations = donator.donations
    # donations_per_place = donations.group_by(&:place)
    # donations_per_asso = donations_per_place.map { |place, dons| [place.asso, dons.sum(&:amount)] }

    # creating a data hash object that gathers all data that will fill the placeholders in the cerfa template.
    # allow receipt:
    # for each donation via a button in history table
    # over a period via a date interval selection (via form)

    # data = {
    #   asso: {
    #     identity: {
    #       name: donations_per_asso[0].name,
    #       rna: donations_per_asso[0].rna,
    #       objet: donations_per_asso[0].objet,
    #       regime: donations_per_asso[0].asso_type_id,
    #     },
    #     place: {
    #       street_no: donations_per_asso[0].street_no,
    #       address: donations_per_asso[0].address,
    #       zip_code: '69000', # to be added in the place table
    #       city: donations_per_asso[0].city
    #     }
    #   },
    #   donator: {
    #     first_name: donator.first_name,
    #     last_name: donator.last_name,
    #   },
    #   donation: {
    #     amount: donations_per_asso[1],
    #     #start_date:
    #     #end_date:
    #   }
    # }

    # creating an instance of PdfGenerator model (method coded as service worker)
    # pass in the data hash
    pdf_generator = PdfGenerator.new(data)

    # calling the generate method coded in the model instance
    # this will overlay a 'calque' pdf containing our data at the right location to superpose onto the template
    # the output is a completed pdf as binary string
    cerfa_completed = pdf_generator.generate

    # as the pdf is in binary string, we need to use "send_data"
    # we don't use send_file because the file is not saved in our filesystem.
    # :type enables to convert binary to pdf,
    # :disposition 'inline', stream pdf into the browser directly (can also do as attachment)
    # :filename to name the streamed file for the user
    # raise
    send_data(
      cerfa_completed,
      filename: "cerfa_11580_05_#{donation.place.asso.id}_#{donation.occured_on.to_date.strftime('%d%m%Y')}",
      type: 'application/pdf',
      disposition: 'inline'
    )
  end
end

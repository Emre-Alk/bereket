class PdfsController < ApplicationController
  def generate
    # get all the associations the donator donated to
    # per association, sum the donations
    # pack all cerfa per association into one pdf

    donator = current_user.donator

    # for an individual donation
    donation = Donation.find(params[:id])

    # for donations over a time interval






    donations = donator.donations
    donations_per_place = donations.group_by(&:place)
    donations_per_asso = donations_per_place.map { |place, dons| [place.asso, dons.sum(&:amount)] }
    raise

    # creating a data hash object that gathers all data that will fill the placeholders in the cerfa template.
    # allow receipt:
    # for each donation via a button in history table
    # over a period via a date interval selection (via form)

    data = {
      asso: {
        identity: {
          name: donations_per_asso[0].name,
          rna: donations_per_asso[0].rna,
          objet: donations_per_asso[0].objet,
          regime: donations_per_asso[0].asso_type_id,
        },
        place: {
          street_no: donations_per_asso[0].street_no,
          address: donations_per_asso[0].address,
          zip_code: '69000', # to be added in the place table
          city: donations_per_asso[0].city
        }
      },
      donator: {
        first_name: donator.first_name,
        last_name: donator.last_name,
      },
      donation: {
        amount: donations_per_asso[1],
        #start_date:
        #end_date:

      }


    }
    # creating an instance of PdfGenerator model (method coded as service worker)
    # pass into the data hash
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
    send_data cerfa_completed, filename: "cerfa_11580_05", type: 'application/pdf', disposition: 'inline'
    #TO DO: add date to date and user name to file name
  end
end

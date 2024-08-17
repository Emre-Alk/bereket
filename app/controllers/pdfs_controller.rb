class PdfsController < ApplicationController
  def generate
    # cerfa for 1 donation
    # 'donator = current_user.donator" no need of this line because donator can be retrieve from donation
    # donation = Donation.find(params[:don_id]) # before Job
    # donator = donation.donator # before Job
    # amount = donation.amount.to_f / 100 # before Job
    # data = {...} # before Job

    # for donations over a time interval (works but not finished):
    # get all the associations the donator donated to
    # per association, sum the donations
    # pack all cerfa per association into one pdf

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
    # pdf_generator = PdfGenerator.new(data) # before Job
    donation = Donation.find(params[:don_id])
    cerfa = donation.donator.cerfa
    # cerfa_old.purge if cerfa_old.attached?

    PdfGenerationJob.perform_later(params[:don_id])

    # calling the generate method coded in the model instance
    # this will overlay a 'calque' pdf containing our data at the right location to superpose onto the template
    # the output is a completed pdf as binary string
    # cerfa_completed = pdf_generator.generate # before Job

    # as the pdf is in binary string, we need to use "send_data"
    # we don't use send_file because the file is not saved in our filesystem.
    # :type enables to convert binary to pdf,
    # :disposition 'inline', stream pdf into the browser directly (can also do as attachment)
    # :filename to name the streamed file for the user
    # render file: ActiveStorage::Blob.url(cerfa.blob.key, disposition: :inline)
    # render file: Rails.application.routes.url_helpers.url_for(cerfa, only_path: true)
    # render pdf: cerfa, location: ActiveStorage::Blob.service.path_for(cerfa.blob.key)
    # ############ this send data is working
    # send_data(
    #   cerfa.download,
    #   filename: "#{cerfa.filename}",
    #   type: cerfa.content_type,
    #   disposition: 'inline'
    # )
    # ###########
    # redirect_to place_path(id: 1, don_id: 2)
    redirect_to cerfa_path
  end

  def view_pdf
    donator = current_user.donator.reload
    cerfa = donator.cerfa
    send_data(
        cerfa.download,
        filename: "#{cerfa.filename}",
        type: cerfa.content_type,
        disposition: 'inline'
      )

    # send_data(
    #   cerfa.download,
    #   filename: "#{cerfa.filename}_#{donation.place.asso.id}_#{donation.occured_on.to_date.strftime('%d%m%Y')}",
    #   type: cerfa.content_type,
    #   disposition: 'inline'
    # )
  end
end

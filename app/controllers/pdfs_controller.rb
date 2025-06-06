require 'open-uri'

class PdfsController < ApplicationController
  before_action :set_donator
  before_action :set_donation, except: %i[download_pdf]
  skip_before_action :authenticate_user!, only: %i[view_pdf download_pdf]

  def generate
    # cerfa for 1 donation
    # 'donator = current_user.donator" no need of this line because donator can be retrieve from donation
    # donation = Donation.find(params[:id]) # before Job
    # donator = donation.donator # before Job
    # amount = donation.amount.to_f / 100 # before Job
    # data = {...} # before Job

    # # creating an instance of PdfGenerator model (method coded as service worker)
    # # pass in the data hash

    # pdf_generator = PdfGenerator.new(data) # before Job

    # # calling the generate method coded in the model instance
    # # this will overlay a 'calque' pdf containing our data at the right location to superpose onto the template
    # # the output is a completed pdf as binary string

    # cerfa_completed = pdf_generator.generate

    # as the pdf is in binary string, we need to use "send_data"
    # we don't use send_file because the file is not saved in our filesystem.
    # :type enables to convert binary to pdf,
    # :disposition 'inline', stream pdf into the browser directly (can also do as attachment)
    # :filename to name the streamed file for the user

    # # notice:
    # # with job in background, the send_data here will send the previously attached pdf
    # # because the job might not have finished yet.
    # # So a refresh of the page displaying pdf would be necessary to display the last pdf generated (ie, wait job done)

    # send_data(
    #   cerfa.download,
    #   filename: cerfa.filename.to_s,
    #   type: cerfa.content_type.to_s,
    #   disposition: 'inline'
    # )

    # # ------------- (later) feature: 1 cerfa for all donation over a period of time --------
    # # for donations over a time interval (works but not finished):
    # # get all the associations the donator donated to
    # # per association, sum the donations
    # # pack all cerfa per association into one pdf

    # donations = donator.donations
    # donations_per_place = donations.group_by(&:place)
    # donations_per_asso = donations_per_place.map { |place, dons| [place.asso, dons.sum(&:amount)] }

    # # creating a data hash object that gathers all data that will fill the placeholders in the cerfa template.
    # # allow receipt:
    # # for each donation via a button in history table
    # # over a period via a date interval selection (via form)

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
    # -------------------
    puts '✅✅✅✅✅✅'
    puts params
    puts '✅✅✅✅✅✅'
    if params[:content].present?
      # info donator when on the fly (via AJAX)
      data = {
        first_name: params[:content][:first_name].presence || 'aucune valeur',
        last_name: params[:content][:last_name].presence || 'aucune valeur',
        address: params[:content][:address].presence || 'aucune valeur',
        zip_code: params[:content][:zip_code].presence || 'aucune valeur',
        city: params[:content][:city].presence || 'aucune valeur',
        country: params[:content][:country].presence || 'aucune valeur'
      }
    end

    respond_to do |format|
      format.html
      format.json do
        if params[:content] || @donator.completed?
          PdfGenerationJob.perform_later(params[:id], content: data)
          token = @donation.generate_token_for(:cerfa_access)
          render json: {
            message: 'job enqueued',
            token:,
            # url: download_donator_donation_path(@donator, @donation, request.params.merge(format: :pdf)),
            url: download_donator_donation_path(@donator, @donation),
            filename: "cerfa_11580_05_000#{@donator.id}000#{@donation.id}.pdf"
          }
        else
          render json: { message: 'Profile uncomplete', status: :not_found, donator_id: params[:donator_id] }
        end
      end
    end
    # jid = pdf_job.provider_job_id # code to get the jid of a job from sidekiq
    # Sidekiq::Queue.new.find_job(jid) # code to find a given job in the queue using his jid
  end

  def view_pdf
    # to be removed if confirmed that all is ok with download_pdf on success page
    # @donation = Donation.find_by_token_for(:cerfa_access, params[:token])
    # return unless @donation

    @cerfa = @donator.cerfa
    #  need as ajax bc cause infinite refresh
    send_data(
      @cerfa.download,
      filename: @cerfa.filename.to_s,
      type: @cerfa.content_type.to_s,
      disposition: 'attachment'
    )
  end

  # def cerfa_inline
  #   # not used. see comment JS controller
  #   # @pdf_inline = cerfa_donator_donation_path(donator_id: @donator, id: @donation)
  #   @pdf_url = url_for(@donator.cerfa) if @donator.cerfa.attached?
  #   render layout: 'pdf_viewer'
  # end

  def download_pdf
    donation = Donation.find_by_token_for(:cerfa_access, params[:token]) || Donation.find_by(checkout_session_id: params[:token])
    return unless donation

    respond_to do |format|
      if donation
        cerfa = @donator.cerfa
        format.html
        format.json do
          send_data(
            cerfa.download,
            filename: cerfa.filename.to_s,
            type: cerfa.content_type.to_s,
            disposition: 'attachment'
          )
        end
      else
        format.html
        format.json { render json: { message: 'unauthorized', status: :forbidden } }
      end
    end
  end

  private

  def set_donator
    @donator = Donator.find(params[:donator_id])
  end

  def set_donation
    @donation = Donation.find(params[:id])
  end

end

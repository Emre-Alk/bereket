class Assos::SignaturesController < AssosController
  # Signature can be handle directly in the asso controller instead of a dedicated controller.
  # in terms of code, nothing changes, just copy paste.
  # in terms of app, related view, routes, test, helpers, etc... should be deleted
  # exact list => check what is created by the cmd 'rails g controller'

  # Instead of new and create, only 'create' can be suffisant.
  # because 'signature' in routes is a single resource.
  # by convention, for single resources, create handles new/edit/update in one action.
  # the display of the form can be done in a asso profile 'edit' (and new for fisrt time at asso creation)
  # So user can edit his signature among the rest of his profile.
  # then, the submission of the form would hit the 'assos/signatures#create' with POST

  # set a max size for signature (avoid someone to fill hole canvas with pen)
  MAX_SIGNATURE_SIZE = 500.kilobytes

  def new
    @asso = current_user.asso
  end

  def create
    # set current user
    @asso = current_user.asso
    # check DataURL (see private)
    # then, decode the base64 string into png and write it inside IO object to carry it here
    # attach image to model and this either store it in :local 'app/storage/...' or in :cloundinary by
    # active storage (depending on how i configured it)
    if valid_signature_data_url?(params[:signature_data])
      signature_io = decode_base64_image(params[:signature_data])
      @asso.signature.attach(
        io: signature_io,
        filename: "signature_#{@asso.id}.png",
        content_type: "image/png"
      )
      flash[:success] = "Signature saved successfully."
      puts '✅✅✅✅✅✅'
    else
      puts '❗️❗️❗️❗️❗️❗️❗️'
      flash[:error] = "Invalid or too large signature."
    end
    redirect_to asso_root_path
  end

  private

  def valid_signature_data_url?(data_url)
    data_url.present? &&
      data_url.size <= MAX_SIGNATURE_SIZE &&
      data_url.match(/^data:image\/png;base64,[A-Za-z0-9+\/=]+$/)
  end

  def decode_base64_image(data_url)
    content_type = data_url.match(/^data:(.*?);base64,/)[1] # index 1: first captured group (if multiple group)
    base64_data = data_url.split(',')[1]
    decoded_data = Base64.decode64(base64_data)
    # IO is a stream input/output object (ex. File is a subclass of IO)
    # StringIO is an IO-like but for string. This is a tempory object used as trasient to handle from the decoded image
    # and pass it to the method 'create' where image is attached to model.
    # Once done, It will be automatically cleaned up by Ruby’s garbage collector after the request is completed and it’s no longer referenced.
    # StringIO.new(decoded_data).tap do |file|
    #   file.content_type = content_type
    #   file.original_filename = "signature.png" # this is a tempory file so the name does not matter
    # end
    StringIO.new(decoded_data)
  end

end

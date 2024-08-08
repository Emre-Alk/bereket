class PdfsController < ApplicationController
  def generate
    # creating a data hash object that gathers all data that will fill the placeholders in the cerfa template.
    data = {
      user_name: current_user.last_name,
      user_email: current_user.email
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
    send_data cerfa_completed, filename: "cerfa_done.pdf", type: 'application/pdf', disposition: 'inline'
  end
end

class PrintController < ApplicationController
  def index
  end

  def print_files
    uploads = params[:uploads]
    printers = params[:printers]
    copies = params[:copies]

    uploads.each_index do |index|
      file = uploads[index][:file]
      PrintJob.new(file, printers[index], copies[index]).execute
    end
    
    flash[:notice] = "Ok."
    redirect_to :action => :index
  end
end
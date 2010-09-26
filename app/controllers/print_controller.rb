class PrintController < ApplicationController
  before_filter :require_at_least_one_file, :only => [:print_files]
  
  def index
  end

  def print_files
    @uploads = params[:uploads] || []
    @printers = params[:printers] || []
    @copies = params[:copies] || []
    
    unless each_job_is_sufficiently_specified?
      flash[:error] = "Please specify a printer and the number of copies for each file."
      render :index and return
    end

    print_all_files
    
    flash[:notice] = "Files were printed successfully."
    redirect_to :action => :index
  end
  
  private
  
  def require_at_least_one_file
    unless params[:uploads]
      flash[:error] = "Please submit at least one file to print."
      render :index
      return false
    end
  end

  def each_job_is_sufficiently_specified?
    @printers.size == @copies.size and @printers.size >= @uploads.size
  end
  
  def print_all_files
    @uploads.each_index do |index|
        file = @uploads[index][:file]
        PrintJob.new(file, @printers[index], @copies[index]).execute
    end
  end
end
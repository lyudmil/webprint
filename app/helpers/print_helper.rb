require File.join(Rails.root, 'config/printers')

module PrintHelper
  def printer_options
    options_for_select($INSTALLED_PRINTERS)
  end
end

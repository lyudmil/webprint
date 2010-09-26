class PrintJob
    def initialize file, printer, number_of_copies
        @file = file
        @printer = printer
        @number_of_copies = number_of_copies
    end

    def execute
        unless @file.blank?
            upload_file
            call_print_script
        end
    end

    def upload_file
        File.open(upload_path, "wb") { |file| file.write(@file.read) }
    end

    def call_print_script
        printer_param = "/n:#{@printer}"
        number_of_copies_param = "/#:#{@number_of_copies}"
        system("prfile32", "/q", "/e", printer_param, number_of_copies_param, upload_path)
    end

    def upload_path
        File.join(Rails.root, "uploads", @file.original_filename)
    end
end

class PrintJob
    def initialize file, printer, number_of_copies
        @file = file
        @printer = printer
        @number_of_copies = number_of_copies
        @validation_errors = []
    end

    def execute
        unless @file.blank?
            upload_file
            call_print_script
        end
    end

    def valid?
        validate
        @validation_errors.empty?
    end

    def validation_errors
        @validation_errors
    end

    private

    def validate
        validate_file
        validate_number_of_copies
    end

    def validate_file
        if not @file.original_filename.downcase =~ /.*\.plt/
            @validation_errors.push "File must be a PLT."
        end
    end

    def validate_number_of_copies
        if not @number_of_copies.to_i <= 12
            @validation_errors.push "Number of copies must be no more than 12."
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

require "test_helper"
require "flexmock/test_unit"

class PrintJobTest < Test::Unit::TestCase
    def setup
        @invalid_file = flexmock(:original_filename => "some.jpg")
        @valid_file = flexmock(:original_filename => "project.plt")
        @capitalized_valid_file = flexmock(:original_filename => "PROJECT.PLT")
    end

    def test_not_valid_unless_plt
        print_job = PrintJob.new(@invalid_file, "printer", "1")
        assert (not print_job.valid?)
        assert_equal ["File must be a PLT."], print_job.validation_errors

        print_job = PrintJob.new(@valid_file, "printer", 1)
        assert print_job.valid?

        print_job = PrintJob.new(@capitalized_valid_file, "printer", 1)
        assert print_job.valid?
    end

    def test_not_valid_if_copies_greater_than_12
        print_job = PrintJob.new(@valid_file, "printer", "13")
        assert (not print_job.valid?)
        assert_equal ["Number of copies must be no more than 12."], print_job.validation_errors

        print_job = PrintJob.new(@valid_file, "printer", "12")
        assert print_job.valid?

        print_job = PrintJob.new(@valid_file, "printer", "11")
        assert print_job.valid?
    end

    def test_validation_errors
        print_job = PrintJob.new(@invalid_file, "printer", "13")
        assert (not print_job.valid?)
        assert_equal ["File must be a PLT.", "Number of copies must be no more than 12."], print_job.validation_errors
    end

    def test_prints_the_file
        print_job = PrintJob.new(fixture_file_upload("/files/test.jpg", "image/jpg"), "printer", "1")
        flexmock(print_job).should_receive(:system).with(
                "prfile32", "/q", "/e", "/n:printer", "/#:1", File.join(Rails.root, "uploads/test.jpg")
        ).once
        print_job.execute
    end
end

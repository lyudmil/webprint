require "test_helper"
require "flexmock/test_unit"

class PrintJobTest < Test::Unit::TestCase
    def test_prints_the_file
        print_job = PrintJob.new(fixture_file_upload("/files/test.jpg", "image/jpg"), "printer", "1")
        flexmock(print_job).should_receive(:system).with(
                "prfile32", "/q", "/e", "/n:printer", "/#:1", File.join(Rails.root, "uploads/test.jpg")
        ).once
        print_job.execute
    end
end

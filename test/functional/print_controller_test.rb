require "test_helper"
require "flexmock/test_unit"

class PrintControllerTest < ActionController::TestCase
  def setup
    File.delete("uploads/test.jpg") if File.exists?("uploads/test.jpg")
  end

  test "can upload a file" do
    post :print_files, :uploads => [{:file => fixture_file_upload("/files/test.jpg", "image/jpg")}],
            :printers => ["printer"],
            :copies => ["1"]
    assert_exists "uploads/test.jpg"
    assert_equal "Files were printed successfully.", flash[:notice]
    assert_redirected_to :controller => :print, :action => :index
  end

  test "can upload several files" do
    post :print_files, :uploads => [
            {:file => fixture_file_upload("/files/test.jpg", "image/jpg")},
            {:file => fixture_file_upload("/files/test2.jpg", "image/jpg")}
    ],
            :printers => ["printer1", "printer2"],
            :copies => ["1", "1"]
    assert_exists "uploads/test.jpg", "uploads/test2.jpg"
  end

  test "will ignore blank uploads" do
    post :print_files, :uploads => [
            {:file => fixture_file_upload("/files/test.jpg", "image/jpg")},
            {:file => ""}
    ],
            :printers => ["printer1", "printer1"],
            :copies => ["1", "1"]
    assert_exists "uploads/test.jpg"
    assert_redirected_to :controller => :print, :action => :index
  end
  
  test "does not blow up if no files submitted" do
    post :print_files, :printers => ["printer1"], :copies => ["1"]
    
    assert_template :index
    assert_equal "Please submit at least one file to print.", flash[:error]
  end
  
  test "does not blow up if no printers submitted" do
    post :print_files, :uploads => {:file => fixture_file_upload("/files/test.jpg", "image/jpg")}, :copies => ["1"]
    
    assert_template :index
    assert_equal "Please specify a printer and the number of copies for each file.", flash[:error]
  end
  
  test "does not blow up if no copies submitted" do
    post :print_files, :uploads => {:file => fixture_file_upload("/files/test.jpg", "image/jpg")}, 
          :printers => ["printer1"]
          
    assert_template :index
    assert_equal "Please specify a printer and the number of copies for each file.", flash[:error]
  end
  
  test "does not continue unless there is a printer and copies specified for each file" do
    post :print_files, :uploads => [
            {:file => fixture_file_upload("/files/test.jpg", "image/jpg")},
            {:file => fixture_file_upload("/files/test.jpg", "image/jpg")}
            ], 
          :printers => ["printer1"],
          :copies => ["1", "1"]
          
    assert_template :index
    assert_equal "Please specify a printer and the number of copies for each file.", flash[:error]
  end
  
  def assert_exists *file_paths
    file_paths.each do |file_path|
      assert File.exists?(file_path), "File failed to upload"
    end
  end
end

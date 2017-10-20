FactoryGirl.define do
  factory :uploaded_file, aliases: [:pdf_upload], class: Hyrax::UploadedFile do
    user
    file File.open('spec/fixtures/files/pdf-sample.pdf')
  end
end

# frozen_string_literal: true
FactoryBot.define do
  factory :uploaded_file, aliases: [:pdf_upload], class: Hyrax::UploadedFile do
    user
    file File.open('spec/fixtures/files/pdf-sample.pdf')
  end
  factory :uploaded_jpg_file, aliases: [:jpg_upload], class: Hyrax::UploadedFile do
    user
    file File.open('spec/fixtures/files/jpg-sample.jpg')
  end
  factory :uploaded_xls_file, aliases: [:xls_upload], class: Hyrax::UploadedFile do
    user
    file File.open('spec/fixtures/files/xls-sample.xlsx')
  end
end

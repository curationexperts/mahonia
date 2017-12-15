# frozen_string_literal: true
module MeshHelper
  def import_mesh_terms
    m = Qa::Authorities::MeshTools::MeshImporter.new
    File.open(file_fixture('mesh_terms.txt')) do |f|
      m.import_from_file(f)
    end
  end
end

# frozen_string_literal: true

require Qa::Engine.root.join('lib', 'qa', 'authorities', 'mesh')

module Qa
  module Authorities
    ##
    # Monkeypatch the built in MESH authority to downcase terms.
    #
    # @see https://github.com/samvera/questioning_authority/issues/158
    class Mesh
      def search(query)
        Qa::SubjectMeshTerm
          .where('term_lower LIKE ?', "#{query.to_s.downcase}%")
          .limit(10)
          .map { |t| { id: t.term_id, label: t.term } }
      end
    end
  end
end

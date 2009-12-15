# A Label, (or Project, Folder, Bucket, Tag, Collection, Notebook, etc.) is a
# name under which to group a set of related documents, purely for
# organizational purposes.
class Label < ActiveRecord::Base

  belongs_to :account

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :account_id

  before_validation :set_document_ids

  named_scope :alphabetical, {:order => :title}

  # Instead of having a join table, Labels serialize their comma-separated
  # document ids. Split them back apart.
  def split_document_ids
    document_ids.nil? ? [] : document_ids.split(',').map(&:to_i).uniq
  end

  def to_json(opts={})
    attributes.to_json
  end

  private

  # Before saving a label, we ensure that it doesn't reference any duplicates.
  def set_document_ids
    self.document_ids = split_document_ids.join(',')
  end

end
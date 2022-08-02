class RemoveFollowerdIdFromRelationships < ActiveRecord::Migration[6.1]
  def change
    remove_column :relationships, :followerd_id, :integer
  end
end

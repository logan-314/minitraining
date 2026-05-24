class AddSubmissionUserIdToFollowings < ActiveRecord::Migration[7.1]
  def up
    add_column :followings, :submission_user_id, :integer
    add_index :followings, :submission_user_id
    
    # Syntaxe standard compatible SQLite et Postgres pour une table vide au départ
    execute("UPDATE followings SET submission_user_id = (SELECT user_id FROM submissions WHERE submissions.id = followings.submission_id)")
  end

  def down
    remove_index :followings, :submission_user_id
    remove_column :followings, :submission_user_id
  end
end

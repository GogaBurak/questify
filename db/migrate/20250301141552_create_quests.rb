class CreateQuests < ActiveRecord::Migration[8.0]
  def change
    # TODO: implement when migrating to postgres
    # create_enum :quest_status, %w[in_progress discarded completed]

    create_table :quests do |t|
      t.string :title
      t.text :description
      # t.enum :status, enum_type: "quest_status", null: false, default: :in_progress
      t.string :status, default: "in_progress"
      t.integer :reward
      t.references :game_session, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end

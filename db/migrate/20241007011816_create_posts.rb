class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :source, foreign_key: true, null: false
      t.string :guid
      t.string :title
      t.text :description
      t.datetime :publish_date
      t.string :link

      t.timestamps
    end
  end
end

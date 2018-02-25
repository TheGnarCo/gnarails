class CreateJobPostings < ActiveRecord::Migration[5.1]
  def change
    create_table :job_postings do |t|
      t.string :title, null: false
      t.integer :status, null: false, default: 0
      t.text :description
      t.datetime :posted_at, null: false

      t.timestamps
    end
  end
end

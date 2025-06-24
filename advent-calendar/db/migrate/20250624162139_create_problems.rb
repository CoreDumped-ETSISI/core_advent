class CreateProblems < ActiveRecord::Migration[8.0]
  def change
    create_table :problems do |t|
      t.string :title
      t.string :correct_answer
      t.datetime :lock_time
      t.datetime :unlock_time

      t.timestamps
    end
  end
end

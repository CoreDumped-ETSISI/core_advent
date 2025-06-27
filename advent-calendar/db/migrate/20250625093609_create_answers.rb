class CreateAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.boolean :correct
      t.string :answer_text
      t.references :problem
      t.timestamps
    end
  end
end

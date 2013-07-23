class AddProfessorDevise < ActiveRecord::Migration
  def self.up
    drop_table(:professors)
    create_table(:professors) do |t|
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
      t.string :name,		    :null => false, :default => ""
      t.string :phone_number,        :null => false, :default => ""
      t.string :about
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
    end
  end
  
  def self.down
    drop_table :professors
  end
end

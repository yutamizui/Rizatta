class AddSecretCodeToBranches < ActiveRecord::Migration[6.1]
  def change
    add_column :branches, :secret_code, :string
  end
end

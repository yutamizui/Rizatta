class RemoveSecretCodeFromCompanies < ActiveRecord::Migration[6.1]
  def change
    remove_column :companies, :secret_code, :string
  end
end

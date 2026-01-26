class AddDeviseToUsers < ActiveRecord::Migration[7.2]
  def up
    change_table :users do |t|
      ## Database authenticatable
      # 既に email カラムはあるので追加しない
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at
    end

    # 既存 email を Devise 要件に合わせる
    change_column_default :users, :email, ""
    change_column_null :users, :email, false

    # index は既にある可能性があるので存在チェック付き
    add_index :users, :email, unique: true unless index_exists?(:users, :email, unique: true)
    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

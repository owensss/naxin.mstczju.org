class AddGroupQuestsToForms < ActiveRecord::Migration
	def change
		add_column :forms , :tg_q1, :text
		add_column :forms , :tg_q2, :text
		add_column :forms , :tg_q3, :text
		add_column :forms , :tg_q4, :text

		add_column :forms , :og_q1, :text
		add_column :forms , :og_q2, :text
		add_column :forms , :og_q3, :text

		add_column :forms , :pg_q1, :text
		add_column :forms , :pg_q2, :text
		add_column :forms , :pg_q3, :text

		add_column :forms , :cg_q1, :text
		add_column :forms , :cg_q2, :text
		add_column :forms , :cg_q3, :text

		remove_column :forms , :q1, :text
		remove_column :forms , :q2, :text
		remove_column :forms , :q3, :text
		remove_column :forms , :q4, :text
	end
end

module Migrations
    class InitializeModels < Sequel::Migration
        #NOTE: Just a heads up. The separate creation of content using a
        #      virtual table allows for them to be searched using sqlite's
        #      full text search. That means FTS3 must be enabled.
        def up
            DB.create_table(:users) do
                varchar :username, :null => false, :unique => true
                varchar :email
                varchar :name
                varchar :password, :null => false
                primary_key :id, :null => false
            end
            DB.create_table(:auth_levels) do
                varchar :name, :null => false, :unique => true
                primary_key :id, :null => false
            end
            DB.create_table(:auth_levels_users) do
                foreign_key :user_id, :table => :users, :null => false
                foreign_key :auth_level_id, :table => :auth_levels, :null => false
                primary_key [:user_id, :auth_level_id]
            end
            DB.create_table(:notes) do
                primary_key :id, :null => false
                text :title, :null => false
                timestamp :created, :null => false
                timestamp :modified, :null => false
                foreign_key :user_id, :null => false, :table => :users
            end
            DB << 'CREATE VIRTUAL TABLE `notes_contents` USING FTS3(`content` text NOT NULL, noteid INTEGER NOT NULL)'
            DB.create_table(:tags) do
                varchar :name, :null => false
                primary_key :id, :null => false
            end
            DB.create_table(:notes_tags) do
                foreign_key :note_id, :table => :notes, :null => false
                foreign_key :tag_id, :table => :tags, :null => false
                primary_key [:tag_id, :note_id]
            end
            DB.create_table(:links) do
                varchar :url, :null => false, :unique => true
                varchar :title, :null => false
                text :description
                integer :score, :null => false, :default => 0
                primary_key :id, :null => false
            end
            DB.create_table(:links_tags) do
                foreign_key :link_id, :table => :links, :null => false
                foreign_key :tag_id, :table => :tags, :null => false
                primary_key [:link_id, :tag_id]
            end
            DB.create_table(:projects) do
                primary_key :id, :null => false
                varchar :title, :null => false, :unique => true
                text :description, :null => false
                varchar :rss
                varchar :website
                boolean :public, :null => false, :default => false
                foreign_key :user_id, :null => false, :table => :users
            end
            DB.create_table(:projects_tags) do
                foreign_key :project_id, :null => false
                foreign_key :tag_id, :null => false
                primary_key [:project_id, :tag_id]
            end
            DB.create_table(:codes) do
                text :code, :null => false
                varchar :summary, :null => false
                timestamp :created, :null => false
                foreign_key :user_id, :null => false, :table => :users
                primary_key :id
            end
            DB.create_table(:codes_tags) do
                foreign_key :code_id, :null => false
                foreign_key :tag_id
                primary_key [:code_id, :tag_id]
            end
            DB[:users] << {:username => 'spox', :password => '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8'}
        end
        def down
            [:projects, :links_tags, :links, :articles, :notes_tags,
             :tags, :notes_contents, :notes, :auth_levels_users, :auth_levels, :users
            ].each do |name|
                DB.drop_table(name)
            end
        end
    end
end
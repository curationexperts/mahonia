namespace :hyrax do
  desc 'Ensure Hyrax default admin set exists'
  task :ensure_default_admin_set do
    on roles(:all) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'hyrax:default_admin_set:create'
        end
      end
    end
  end
end

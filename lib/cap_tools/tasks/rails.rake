namespace :assets do
  desc 'Run the precompile task locally and rsync with shared'
  task :precompile do

    run_locally do
			with rails_env: :production do
				execute *%w(rm -rf public/assets/*)
				rake 'assets:precompile'
				execute *%w(rm assets.tgz) if Dir['assets.tgz'].any?
				execute *%w(tar zcvf assets.tgz public/assets/)
				execute *%w(mv assets.tgz public/assets/)
			end
    end
  end

  desc 'Upload precompiled assets'
  task :upload_assets do
    on roles(:app) do
      upload! "public/assets/assets.tgz", "#{release_path}/assets.tgz"
      within release_path do
        execute *%w(tar zxvf assets.tgz)
        execute  *%w(rm assets.tgz)
      end
    end
  end
end

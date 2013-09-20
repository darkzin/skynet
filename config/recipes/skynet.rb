namespace :skynet do
  desc "copy upload data to latest release directory."
  task :copy_upload, roles: :web do
    if previous_release
      run "#{try_sudo} cp -r #{previous_release}/public/uploads/* #{latest_release}/public/uploads/"
    else
      logger.important "no previous release to copy to, copy upload data skipped."
    end
  end

  after "deploy:update", "skynet:copy_upload"

  desc "copy database.yml to latest release directory."
  task :database_config, roles: :web do
    if previous_release
      run "#{try_sudo} cp #{previous_release}/config/database.yml #{latest_release}/config/"
    else
      logger.important "no previous release to copy to, copy upload data skipped."
    end
  end

  after "deploy:update", "skynet:database_config"
end

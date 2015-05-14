namespace :finc_account_manager do
  desc 'Sync with finc account manager'
  task :sync_user => :environment do
    User.where(finc_user_id: nil).find_each do |u|
      begin
        if finc_user_id = u.get_finc_user_id_from_finc_app['finc_user_id']
          u.update!(finc_user_id: finc_user_id)
        end
      rescue => e
        Airbrake.notify(e)
      end
    end
  end
end

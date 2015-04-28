namespace :catalog do
  desc "Import data on path"
  task :import, [:path] => :environment do |task, args|
    path = Pathname.new(args[:path])
    Catalog.import_path(path)
  end
end

Merb.logger.info("Loaded DEVELOPMENT Environment...")
Merb::Config.use { |c|
  c[:exception_details] = true
  c[:reload_classes] = true
  c[:reload_time] = 0.5
  c[:log_auto_flush ] = true
  c[:log_level] = :debug

  c[:isbndb_key] = "6S2BUFOE"
}

DataMapper.setup(:default, "sqlite3:/tmp/community_shelf.db")
DataObjects::Sqlite3.logger = DataObjects::Logger.new(Merb.log_file, 0)
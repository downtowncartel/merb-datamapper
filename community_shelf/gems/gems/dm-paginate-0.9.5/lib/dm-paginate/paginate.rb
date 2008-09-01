module DataMapper
  class Collection
    def paginate(page, limit)
      offset, count = (page - 1) * limit, self.count
      pages = (count / limit) + ((count % limit) == 0 ? 0 : 1)

      return all(:limit => limit, :offset => offset), {:count => count, :page => page, :pages => pages }
    end
  end
end
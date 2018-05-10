-- local db = SQLite3.new('test.db')
local db = SQLite3.new('sys/lua/LuaSQLite3/test.db')

-- local result = db
--   :orderBy('name', 'desc')
--   :get('users')
--
-- for _, row in pairs(result) do
--   print(row.id, row.name, row.level, row.exp)
-- end

User = SQLite_lib.class(function()
  self = dbObject.new()
  self.dbTable = 'users'
end)

local user = User.new()
dbObject.test()

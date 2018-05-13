local class = SQLite_lib.class
local classExtends = SQLite_lib.classExtends

-- local db = SQLite3.new('test.db')
local db = SQLite3.new('sys/lua/LuaSQLite3-Wrapper/test.db')

-- local result = db
--   :orderBy('name', 'desc')
--   :get('users')
--
-- for _, row in pairs(result) do
--   print(row.id, row.name, row.level, row.exp)
-- end

User = classExtends(dbObject, {
  dbTable = 'users',
}, function()
  function self:__construct()
    self.name = 'Unknown'
    self.level = 1
    self.exp = 0
  end
end)

print( User.byId(1).name )

-- local users = User.get()
-- for _, user in pairs(users) do
--   print(user.id, user.name, user.level, user.exp)
-- end

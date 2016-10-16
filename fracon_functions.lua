-- snippet by Ronin for split a string into on array/table
-- сниппет от Ronin'a для разделения строки в массивы/таблицы

function string.split(text, sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        text:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields;
end 

--[[ пример использования:
args = string.split("Hello world", " ");
print(args[1]); -- this would print "Hello"
print(args[2]); -- this would print "world" 
]]--
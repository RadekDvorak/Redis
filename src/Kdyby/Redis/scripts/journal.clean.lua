
local conds = readArgs(ARGV)

if conds["all"] ~= nil then
    -- redis.call('multi')
    for i, value in pairs(redis.call('keys', "Nette.Journal:*")) do
        redis.call('del', value)
    end
    -- redis.call('exec')

    return redis.status_reply("Ok")
end

local entries = {}
if conds["tags"] ~= nil then
    for i, tag in pairs(conds["tags"]) do
        local found = tagEntries(tag)
        if #found > 0 then
            cleanEntry(found)
            for i, key in pairs(found) do
                entries[#entries + 1] = key
            end
        end
    end
end

if conds["priority"] ~= nil then
    local found = priorityEntries(conds["priority"])
    if #found > 0 then
        cleanEntry(found)
        for i, key in pairs(found) do
            entries[#entries + 1] = key
        end
    end
end

return entries

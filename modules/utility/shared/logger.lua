local logger = {}

local colors = {
    default = "^7",
    error = "^1",
    success = "^2",
    warn = "^3",
    info = "^5"
}

local resourceName = ("[^6%s^7]"):format(GetCurrentResourceName())

local function formatMessage(prefix, message, ...)
    local args = {...}
    
    for i = 1, #args do
        if type(args[i]) == "table" then
            args[i] = json.encode(args[i])
        else
            args[i] = tostring(args[i])
        end
    end
    
    local fullMessage = tostring(message)
    if #args > 0 then
        fullMessage = fullMessage .. " " .. table.concat(args, " ")
    end
    
    return ("%s %s%s%s"):format(resourceName, prefix, fullMessage, colors.default)
end

function logger:error(message, ...)
    print(formatMessage(colors.error, "[ERROR] "..message, ...))
end

function logger:success(message, ...)
    print(formatMessage(colors.success, "[SUCCESS] "..message, ...))
end

function logger:warn(message, ...)
    print(formatMessage(colors.warn, "[WARNING] "..message, ...))
end

function logger:info(message, ...)
    print(formatMessage(colors.info, "[INFO] "..message, ...))
end

return logger
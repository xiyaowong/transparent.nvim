local path = vim.fn.stdpath("data") .. package.config:sub(1, 1) .. "transparent_cache"

return {
    read = function()
        local exists, lines = pcall(vim.fn.readfile, path)
        vim.g.transparent_enabled = exists and #lines > 0 and vim.trim(lines[1]) == "true"
    end,

    write = function()
        vim.fn.writefile({ tostring(vim.g.transparent_enabled) }, path)
    end,
}

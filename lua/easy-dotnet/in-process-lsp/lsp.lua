local logger = require("easy-dotnet.logger")
local constants = require("easy-dotnet.constants")
local ms = vim.lsp.protocol.Methods

local M = {}

vim.lsp.commands["easy-dotnet.importMissingUsings"] = function(command)
  local bufnr = command.arguments and command.arguments[1]
  require("easy-dotnet.in-process-lsp.import-missing-namespaces").run(bufnr)
end

function M.enable()
  vim.lsp.config[constants.lsp_in_process_client_name] = {
    filetypes = { "cs" },
    cmd = function()
      return {
        request = function(method, params, callback) require("easy-dotnet.in-process-lsp.import-missing-namespaces").install(method, params, callback) end,
      }
    end,
    handlers = {
      [ms.initialize] = function(params, callback)
        callback(nil, {
          capabilities = {},
          serverInfo = {
            name = constants.lsp_in_process_client_name,
          },
        })
      end,
    },
  }

  vim.lsp.enable(constants.lsp_in_process_client_name)
end

return M

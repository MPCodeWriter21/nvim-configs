local options = require "plugins.configs.nvimtree"

options["filters"]["custom"] = {
    "__pycache__",
    "crash_report.log",
    "poetry.lock"
}

return options

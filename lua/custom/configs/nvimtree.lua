local options = require "plugins.configs.nvimtree"

options["filters"]["custom"] = {
    "__pycache__",
    "crash_report.log",
    "poetry.lock"
}
options["filesystem_watchers"]["ignore_dirs"] = {
    "/.ccls-cache", "/build", "/node_modules", "/target",
    ".*__pycache__.*", "/.venv"
}

return options

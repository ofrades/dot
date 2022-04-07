local pickers = require("telescope.pickers")
local finders = require("telescope.finders")

local entry_display = require("telescope.pickers.entry_display")
local conf = require("telescope.config").values
local utils = require("telescope.utils")

local function prepare_environment_variables()
	local items = {}
	for key, value in pairs(os.execute("npx jest --listTests --json")) do
		table.insert(items, { key, value })
	end
	return items
end

-- our picker function: colors
local colors = function(opts)
	opts = opts or {}
	pickers.new(opts, {
		prompt_title = "colors",
		finder = finders.new_table({
			results = prepare_environment_variables(),
			entry_maker = function(entry)
				local columns = vim.o.columns
				local width = conf.width
					or conf.layout_config.width
					or conf.layout_config[conf.layout_strategy].width
					or columns
				local telescope_width
				if width > 1 then
					telescope_width = width
				else
					telescope_width = math.floor(columns * width)
				end
				local env_name_width = math.floor(columns * 0.05)
				local env_value_width = 22

				-- NOTE: the width calculating logic is not exact, but approx enough
				local displayer = entry_display.create({
					separator = " ▏",
					items = {
						{ width = env_value_width },
						{ width = telescope_width - env_name_width - env_value_width },
						{ remaining = true },
					},
				})

				local function make_display()
					-- concatenating multiline env values
					local concatenated_width = entry[2]:gsub("\r?\n", " ")
					return displayer({
						{ entry[1] },
						{ concatenated_width },
					})
				end

				return {
					value = entry,
					display = make_display,
					ordinal = string.format("%s %s", entry[1], entry[2]),
				}
			end,
		}),
		sorter = conf.generic_sorter(opts),
	}):find()
end

-- to execute the function
colors()

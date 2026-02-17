return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")
		mc.setup()

		local set = vim.keymap.set

		-- Add or skip cursor above/below the main cursor.
		set({ "n", "x" }, "<leader>mk", function()
			mc.lineAddCursor(-1)
		end, { desc = "Add new cursor above" })
		set({ "n", "x" }, "<leader>mj", function()
			mc.lineAddCursor(1)
		end, { desc = "Add new cursor bellow" })
		set({ "n", "x" }, "<leader>mK", function()
			mc.lineSkipCursor(-1)
		end, { desc = "Skip new cursor above" })
		set({ "n", "x" }, "<leader>mJ", function()
			mc.lineSkipCursor(1)
		end, { desc = "Skip new cursor bellow" })

		-- Add or skip adding a new cursor by matching word/selection
		set({ "n", "x" }, "<leader>mu", function()
			mc.matchAddCursor(-1)
		end, { desc = "Add new cursor above, by matching" })
		set({ "n", "x" }, "<leader>mU", function()
			mc.matchSkipCursor(-1)
		end, { desc = "Add new cursor bellow, by matching" })
		set({ "n", "x" }, "<leader>md", function()
			mc.matchAddCursor(1)
		end, { desc = "Skip new cursor above, by matching" })
		set({ "n", "x" }, "<leader>mD", function()
			mc.matchSkipCursor(1)
		end, { desc = "Skip new cursor bellow, by matching" })

		-- Add and remove cursors with control + left click.
		set("n", "<c-leftmouse>", mc.handleMouse)
		set("n", "<c-leftdrag>", mc.handleMouseDrag)
		set("n", "<c-leftrelease>", mc.handleMouseRelease)

		-- Disable and enable cursors.
		set({ "n", "x" }, "<leader>mc", mc.toggleCursor, { desc = "Tooggle multi cursor" })

		-- Mappings defined in a keymap layer only apply when there are
		-- multiple cursors. This lets you have overlapping mappings.
		mc.addKeymapLayer(function(layerSet)
			-- Select a different cursor as the main one.
			layerSet({ "n", "x" }, "<left>", mc.prevCursor, { desc = "Previous cursor" })
			layerSet({ "n", "x" }, "<right>", mc.nextCursor, { desc = "Next cursor" })
			layerSet({ "n", "x" }, "<leader>h", mc.prevCursor, { desc = "Previous cursor" })
			layerSet({ "n", "x" }, "<leader>l", mc.nextCursor, { desc = "Next cursor" })

			-- Delete the main cursor.
			layerSet({ "n", "x" }, "<leader>mx", mc.deleteCursor, { desc = "Delete main cursor" })

			-- Enable and clear cursors using escape.
			layerSet("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				else
					mc.clearCursors()
				end
			end, { desc = "Clear all cursors" })
		end)

		-- Customize how cursors look.
		local hl = vim.api.nvim_set_hl
		hl(0, "MultiCursorCursor", { reverse = true })
		hl(0, "MultiCursorVisual", { link = "Visual" })
		hl(0, "MultiCursorSign", { link = "SignColumn" })
		hl(0, "MultiCursorMatchPreview", { link = "Search" })
		hl(0, "MultiCursorDisabledCursor", { reverse = true })
		hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
		hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
	end,
}

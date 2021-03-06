--[[
	Musket mod for Minetest
	Copyright (C) 2019 BrunoMine (https://github.com/BrunoMine)
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
	
	Make translation files
  ]]

-- Modpath
local modpath = minetest.get_modpath("musket")

-- Make translation files musket.*.tr
do
	local file_to_tb = function(file)
		local msgid = nil
		local msgstr = nil
		local tb = {}
		for line in io.lines(file) do
			
			-- Iniciando 'msgid'
			-- Starting 'msgid'
			if string.sub(line, 1, 5) == "msgid" then
				
				-- Escrever no catalogo a anterior
				-- Write in the catalog the previous
				if msgid ~= nil and msgstr ~= nil then
					if msgid ~= "" then
						tb[msgid] = msgstr
					end
					msgid = nil
					msgstr = nil
				end
				
				if line == "msgid \"\"" then
					msgid = ""
				else
					msgid = string.sub(line, 8, (string.len(line)-1))
				end
				
			-- Continuando 'msgid'
			-- Continuing 'msgid'
			elseif string.sub(line, 1, 1) == "\"" and msgstr == nil and msgid ~= nil then
				msgid = msgid .. string.sub(line, 2, (string.len(line)-1))
			
			-- Iniciando 'msgstr'
			-- Starting 'msgstr'
			elseif string.sub(line, 1, 6) == "msgstr" then
			
				if line == "msgstr \"\"" then
					msgstr = ""
				else
					msgstr = string.sub(line, 9, (string.len(line)-1))
				end
			
			-- Continuando 'msgstr'
			-- Continuing 'msgstr'
			elseif string.sub(line, 1, 1) == "\"" and msgstr ~= nil then
				msgstr = msgstr .. string.sub(line, 2, (string.len(line)-1))
			
			end
			
			
		end
		
		-- Escrever ultima
		-- Write last
		if msgid ~= nil and msgstr ~= nil then
			if msgid ~= "" then
				tb[msgid] = msgstr
			end
			msgid = nil
			msgstr = nil
		end
		
		return tb
	end	
	
	local list = minetest.get_dir_list(modpath.."/locale")
	for _,file in ipairs(list) do
		
		if string.match(file, "~") == nil then
			
			-- Traduções ".po"
			-- Translations ".po"
			if string.match(file, ".pot") == nil and string.match(file, ".po") then
				
				local lang_code = string.gsub(file, ".po", "")
				
				local en_to_lang = file_to_tb(modpath.."/locale/"..file)
				
				-- Novo arquivo
				-- New file
				local new_file = "### File generated by musket from "..file.."\n# textdomain: musket\n"
				for en,lang in pairs(en_to_lang) do
					new_file = new_file .. en .. "=" .. lang .. "\n"
				end
				-- Escrever arquivo
				-- Write file 
				local saida = io.open(modpath.."/locale/musket."..lang_code..".tr", "w")
				saida:write(new_file)
				io.close(saida)
			end
		end
	end
end


SLASH_IS1 = "/IS"

gBank_Ads = "";--"\n\n\nAutomatic inventory -> BBCode script by rexas (Emerald Dream). Download at http://rexas.net/wow or https://github.com/jejkas/InventorySale";

SlashCmdList["IS"] = function(args)
	if gBankFrame:IsShown() then
		gBankFrame:Hide();
	else
		gBankFrame:Show();
		gBank_text:SetText(gBank_getItems());
	end
end

gBankScriptFrame = CreateFrame("FRAME", "gBankScriptFrame");
function gBank_OnUpdateEvent(self, event, ...)
end

function gBank_Run()
	local str = "";
	
	for bag = -1,11 do
		for slot = 1,GetContainerNumSlots(bag) do
			local item = GetContainerItemLink(bag,slot)
			local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag,slot);
			if item
			then
				--local found, _, itemString = string.find(item, "^|%x+|Hitem\:(.+)\:%[.+%]");
				local a, b, color, d, name = string.find(item, "|c(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r")
				local id = gBank_strsplit(":",d);
				id = id[1];
				
				if name ~= "Hearthstone"
				then
					--printDebug(a .. " - " .. b .. " - " .. color .. " - " .. id .. " - " .. name .. " x " .. itemCount);
					if type(gBank_ItemList[name]) ~= "table"
					then
						gBank_ItemList[name] = {};
						gBank_ItemList[name]["amount"] = 0;
					end;
					gBank_ItemList[name]["id"] = id;
					gBank_ItemList[name]["name"] = name;
					gBank_ItemList[name]["amount"] = gBank_ItemList[name]["amount"] + itemCount;
				end;
			end
		end
	end
	--printArray(itemArr);
end;



function gBank_getItems()
	local str = "";
	if gBank_ItemList
	then
		for id, line in pairsByKeys(gBank_ItemList)
		do
			str = str .. gBank_ItemList[id]["name"] ..";".. UnitName("player") ..";".. gBank_ItemList[id]["amount"] .. ";".. gBank_ItemList[id]["id"] .. "\n";
		end
	end
	return str;
end





function gBank_ResetData()
	gBank_ItemList = {};
end





function gBank_OnLoad()
end;

function gBank_eventHandler()
	if event == "ADDON_LOADED" and arg1 == "InventorySale"
	then
		if gBank_ItemList == nil or not gBank_ItemList
		then
			gBank_ItemList = {};
		end
	end
	
end

-- Event stuff

gBankScriptFrame:SetScript("OnUpdate", gBank_OnUpdateEvent);
gBankScriptFrame:SetScript("OnEvent", gBank_eventHandler);
gBankScriptFrame:RegisterEvent("ENTER_WORLD");
gBankScriptFrame:RegisterEvent("CHAT_MSG_RAID_LEADER");
gBankScriptFrame:RegisterEvent("ADDON_LOADED");

-- Message stuff

-- DEbug

function printDebug(str)
	if str == nil
	then
		ChatFrame1:AddMessage('DEBUG: NIL value!');
	else
		ChatFrame1:AddMessage('DEBUG: '..str);
	end
end;

function printArray(arr)
	for key,value in pairs(arr)
	do
		if type(arr[key]) == "table"
		then
			printArray(arr[key]);
		else
			printDebug(key .. " = " .. arr[key]);
		end;
	end
end;

function gBank_strsplit(sep,str)
	local arr = {}
	local tmp = "";
	
	--printDebug(string.len(str));
	local chr;
	for i = 1, string.len(str)
	do
		chr = string.sub(str, i, i);
		if chr == sep
		then
			table.insert(arr,tmp);
			tmp = "";
		else
			tmp = tmp..chr;
		end;
	end
	table.insert(arr,tmp);
	
	return arr
end

    function pairsByKeys (t, f)
      local a = {}
      for n in pairs(t) do table.insert(a, n) end
      table.sort(a, f)
      local i = 0      -- iterator variable
      local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
      end
      return iter
    end
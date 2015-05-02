FB = {}

local SPELL = "spell"
local PLAYER = "player"

FB.UPDATE_INTERVAL = 0.1
FB.ACTIONBAR = 1

local modules = {
	["ROGUE"] = {
		[2] = FinBtn.RogueCombat,
		[3] = FinBtn.RogueSubtlety
	},
	["PRIEST"] = {
		[3] = FinBtn.PriestShadow
	}
}

local BTNS = {}

local SKILLS;
local SKILL_ORDER;

local module;

local timeSinceUpdate;
local actionBarOffset;

local btnSize = 52

local loaded = false;

local mainFrame;

-- Slash commands and options: activate via /finbtn
-- Current options: lock, unlock
SLASH_FINBTN1 = "/finbtn"
SlashCmdList["FINBTN"] = function(message)
	print("Finisher Button: "..message)
	if message == "lock" then
		FB.MoveBtn:Disable()
		FB.MoveBtn:SetAlpha(0)
		FB.MoveBtn:EnableMouse(0)
		FinBtnDB["isLocked"] = true
	elseif message == "unlock" then
		FB.MoveBtn:Enable()
		FB.MoveBtn:SetAlpha(1)
		FB.MoveBtn:EnableMouse(1)
		FinBtnDB["isLocked"] = false
	else
		print("\tOptions: lock, unlock")
	end
end

function FB.OnLoad(self)
	if (type(FinBtnDB) ~= "table") then
		FinBtnDB = {}
		FinBtnDB["isLocked"] = false
		FinBtnDB["x"] = 1000
		FinBtnDB["y"] = 400
	end
end

function FB.OnLogin(self)
	local class, classFileName = UnitClass(PLAYER)
	local curSpec = GetSpecialization()
	
	module = modules[classFileName][curSpec]
	if (module == nil) then
		module = FinBtn.Main
	end
	
	SKILLS = module.SKILLS
	SKILL_ORDER = module.SKILL_ORDER
		
	local length = (#SKILL_ORDER * btnSize) + ((#SKILL_ORDER - 1) * 4)
	self:SetSize(length, btnSize)
	self:SetPoint("BOTTOMLEFT", FinBtnDB["x"] - (length/2), FinBtnDB["y"] - (btnSize/2))

	timeSinceUpdate = 0
	actionBarOffset = (FB.ACTIONBAR - 1)*12
	local size = 0
	for i,k in ipairs(SKILL_ORDER) do
		local frame = CreateFrame("Frame", k .. "_frame", self)
		frame:SetSize(btnSize, btnSize)
		frame:SetPoint("LEFT", self, "LEFT", (btnSize*(i-1)) + ((i-1) * 4), 0)
		size = size + btnSize
	
		local btn = CreateFrame("CheckButton", k .. "_btn", frame, "ActionBarButtonTemplate")
		btn:SetPoint("CENTER", 0, 0)
		btn:SetSize(btnSize, btnSize)
		
		local _,spellid = GetSpellBookItemInfo(SKILLS[k][SPELL])
		if (spellid == nil) then
			spellid = SKILLS[k]["id"]
		end
		PickupSpell(spellid)
		PlaceAction(i + actionBarOffset)
		btn:SetAttribute("action",i + actionBarOffset)
		BTNS[k] = btn		
	end
	
	FB.MoveBtn = CreateFrame("Button", "FB_MoveBtn", self)
	FB.MoveBtn:SetSize(16,16)
	FB.MoveBtn:SetPoint("BOTTOMLEFT",self,"TOPLEFT",0,4)
	local moveFrameBg = FB.MoveBtn:CreateTexture("FBFrameBackground")
	FBFrameBackground:SetTexture(64,64,64,0.5)
	FBFrameBackground:SetAllPoints()
	if (FinBtnDB["isLocked"]) then
		FB.MoveBtn:SetAlpha(0)
	else
		FB.MoveBtn:SetAlpha(1)
	end
	FB.MoveBtn:RegisterForDrag("LeftButton")
	FB.MoveBtn:SetScript("OnDragStart",FB.OnDragStart)
	FB.MoveBtn:SetScript("OnDragStop",FB.OnDragStop)
end

function FB.OnUpdate(self, elapsed)
	timeSinceUpdate = timeSinceUpdate + elapsed
	while (timeSinceUpdate > FB.UPDATE_INTERVAL) do
		module.EvaluateButtons(BTNS)
		timeSinceUpdate = timeSinceUpdate - FB.UPDATE_INTERVAL
	end
end

function FB.OnEvent(self, event, ...)
	if (event == "ADDON_LOADED" and select(1, ...) == "FinisherButton") then
		FB.OnLoad(self);	
	elseif (event == "PLAYER_ENTERING_WORLD" and not loaded) then
		FB.OnLogin(self);
		loaded = true;
	else
		if not UnitAffectingCombat(PLAYER) then
			for k,btn in pairs(BTNS) do
				ActionButton_OnEvent(btn, event, ...)
			end
		end
	end
end

function FB.OnDragStart()
	if not FinBtnDB["isLocked"] then
		mainFrame:StartMoving()
	end
end

function FB.OnDragStop()
	mainFrame:StopMovingOrSizing()
	FinBtnDB["x"], FinBtnDB["y"] = mainFrame:GetCenter()
end

--------------------------------------------------------------
-- Main Code --
mainFrame = CreateFrame("Frame", "FBMainFrame", UIParent)
mainFrame:EnableMouse(true);
mainFrame:SetMovable(true);
mainFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
mainFrame:RegisterEvent("ACTIONBAR_SHOWGRID");
mainFrame:RegisterEvent("ACTIONBAR_HIDEGRID");
mainFrame:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
mainFrame:RegisterEvent("UPDATE_BINDINGS");
mainFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
mainFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
mainFrame:RegisterEvent("ADDON_LOADED");
mainFrame:SetScript("OnUpdate", FB.OnUpdate);
mainFrame:SetScript("OnEvent", FB.OnEvent);
--------------------------------------------------------------
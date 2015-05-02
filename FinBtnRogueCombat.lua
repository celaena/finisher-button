-------------------------------------------
-- Combat Rogue Module --
-------------------------------------------
local module = {}
local moduleName = "RogueCombat";
FinBtn[moduleName] = module;

local main = FinBtn.Main

local SLICE_AND_DICE = "Slice and Dice"
local EVISCERATE = "Eviscerate"
local SINISTER_STRIKE = "Sinister Strike"
local REVEALING_STRIKE = "Revealing Strike"
local KICK = "Kick"
local CRIMSON_TEMPEST = "Crimson Tempest"
local BLADE_FLURRY = "Blade Flurry"
local KILLING_SPREE = "Killing Spree"
local ADRENALINE_RUSH = "Adrenaline Rush"
local VANISH = "Vanish"

local SIN = "Sin";
local REV =	"Rev";
local EV = "Ev";
local SND = "SnD";
local KICK = "Kick";
local KS = "KS";
local AD = "AD";
local VAN = "Van";
local CT = "CT";
local BF = "BF";

local bf_max = 8
local ct_max = 10

module.SKILLS = {
	[SND] = {
		[main.SPELL] = SLICE_AND_DICE
	},
	[EV] = {
		[main.SPELL] = EVISCERATE
	},
	[SIN] = {
		[main.SPELL] = SINISTER_STRIKE
	},
	[REV] = {
		[main.SPELL] = REVEALING_STRIKE
	},
	[KICK] = {
		[main.SPELL] = KICK
	},
	[CT] = {
		[main.SPELL] = CRIMSON_TEMPEST
	},
	[BF] = {
		[main.SPELL] = BLADE_FLURRY
	},
	[KS] = {
		[main.SPELL] = KILLING_SPREE
	},
	[AD] = {
		[main.SPELL] = ADRENALINE_RUSH
	},
	[VAN] = {
		[main.SPELL] = VANISH
	}
}

module.SKILL_ORDER = {
	SIN,
	REV,
	EV,
	SND,
	KICK,
	KS,
	AD,
	VAN,
	CT,
	BF
}

local function EvaluateButtons(buttons)
	local _,_,_,_,_,_,expiresSD,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,SLICE_AND_DICE,nil,main.PLAYER_HELPFUL)
	if (expiresSD == nil or (expiresSD - GetTime()) < 8) then
		buttons[SND]:SetAlpha(main.ON)
		buttons[EV]:SetAlpha(main.OFF)	
	else
		buttons[SND]:SetAlpha(main.OFF)
		buttons[EV]:SetAlpha(main.ON)
	end
	
	local _,_,_,_,_,_,expiresRS,_,_,_,_,_,_,_,_,_ = UnitAura(main.TARGET,REVEALING_STRIKE,nil,main.PLAYER_HARMFUL)
	if (expiresRS ~= nil) then
		buttons[SIN]:SetAlpha(main.ON)
		buttons[REV]:SetAlpha(main.OFF)
	else
		buttons[SIN]:SetAlpha(main.OFF)
		buttons[REV]:SetAlpha(main.ON)		
	end
	
	local _,_,_,_,_,_,_,_,interrupt = UnitCastingInfo(main.TARGET)
	if (interrupt == null or interrupt) then
		buttons[KICK]:SetAlpha(main.OFF)
	else
		buttons[KICK]:SetAlpha(main.ON)
	end
	
	local ctSetting = main.OFF;
	local bfSetting = main.OFF;
	local minRange, maxRange = main.rc:GetRange(main.MOUSEOVER)
	if (minRange and maxRange) then
		if (ct_max <= minRange) then
			-- Both off
		elseif (bf_max <= minRange and ct_max >= maxRange) then
			ctSetting = main.ON;
			bfSetting = main.OFF;
		else
			ctSetting = main.ON;
			bfSetting = main.ON;
		end
	end
	buttons[CT]:SetAlpha(ctSetting);
	buttons[BF]:SetAlpha(bfSetting);
end

module.EvaluateButtons = EvaluateButtons
-------------------------------------------
-- Outlaw Rogue Module --
-------------------------------------------
local module = {};
local moduleName = "RogueOutlaw";
FinBtn[moduleName] = module;

local main = FinBtn.Main;

local ADRENALINE_RUSH = "Adrenaline Rush";
local AMBUSH = "Ambush";
local BETWEEN_THE_EYES = "Between the Eyes";
local BLADE_FLURRY = "Blade Flurry"
local CANNONBALL_BARRAGE = "Cannonball Barrage";
local DEATH_FROM_ABOVE = "Death from Above";
local KICK = "Kick";
local PISTOL_SHOT = "Pistol Shot";
local ROLL_THE_BONES = "Roll the Bones";
local RUN_THROUGH = "Run Through";
local SABER_SLASH = "Saber Slash";
local VANISH = "Vanish";
local GHOSTLY_STRIKE = "Ghostly Strike";
local MARKED_FOR_DEATH = "Marked for Death";
local SLICE_AND_DICE = "Slice and Dice";
local KILLING_SPREE = "Killing Spree";

local SHARK_INFESTED_WATERS = "Shark Infested Waters";
local GRAND_MELEE = "Grand Melee";
local JOLLY_ROGER = "Jolly Roger";
local BURIED_TREASURE = "Buried Treasure";
local TRUE_BEARING = "True Bearing";
local BROADSIDES = "Broadsides";

local AR = "AR";
local AM = "Am";
local BTE = "BtE";
local BF = "BF";
local CB = "CB";
local DFA = "DfA";
local KICK = "Kick";
local PS = "PS";
local RTB = "RtB";
local RT = "RT";
local SS = "SS";
local VAN = "Van";
local GS = "GS";
local MFD = "MfD";
local SAD = "SaD";
local KS = "KS";

local bf_max = 8;

module.SKILLS = {
	[AR] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = ADRENALINE_RUSH
	},
	[AM] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = AMBUSH
	},
	[BTE] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = BETWEEN_THE_EYES
	},
	[BF] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = BLADE_FLURRY
	},
	[CB] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = CANNONBALL_BARRAGE
	},
	[DFA] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = DEATH_FROM_ABOVE
	},
	[KICK] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = KICK
	},
	[PS] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = PISTOL_SHOT
	},
	[RTB] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = ROLL_THE_BONES
	},
	[RT] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = RUN_THROUGH
	},
	[SS] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = SABER_SLASH
	},
	[VAN] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = VANISH
	},
	[GS] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = GHOSTLY_STRIKE
	},
	[MFD] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = MARKED_FOR_DEATH
	},
	[SAD] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = SLICE_AND_DICE
	},
	[KS] = {
		[main.TYPE] = main.SPELL,
		[main.NAME] = KILLING_SPREE
	}
};

module.SKILL_ORDER = {
	SS,
	PS,
	RT,
	DFA,
	RTB,
	BTE,
	KICK,
	AR,
	CB,
	VAN,
	BF
};

local function EvaluateButtons(buttons)
	local _,gcdLeft,_ = GetSpellCooldown(SABER_SLASH);
	
	local _,_,_,_,_,_,expiresJR,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,JOLLY_ROGER,nil,main.PLAYER_HELPFUL);
	local _,_,_,_,_,_,expiresBr,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,BROADSIDES,nil,main.PLAYER_HELPFUL);
	local _,_,_,_,_,_,expiresTB,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,TRUE_BEARING,nil,main.PLAYER_HELPFUL);
	local _,_,_,_,_,_,expiresGM,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,GRAND_MELEE,nil,main.PLAYER_HELPFUL);
	local _,_,_,_,_,_,expiresBT,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,BURIED_TREASURE,nil,main.PLAYER_HELPFUL);
	local _,_,_,_,_,_,expiresSIF,_,_,_,_,_,_,_,_,_ = UnitAura(main.PLAYER,SHARK_INFESTED_WATERS,nil,main.PLAYER_HELPFUL);
	local expiresRTB = expiresJR or expiresBr or expiresTB or expiresGM or expiresBT or expiresSIF;	
	if (expiresRTB == nil or (expiresRTB - GetTime()) < 8) then
		buttons[RTB]:SetAlpha(main.ON);
		buttons[RT]:SetAlpha(main.OFF);	
		buttons[BTE]:SetAlpha(main.OFF);
		buttons[DFA]:SetAlpha(main.OFF);	
	else
		buttons[RTB]:SetAlpha(main.OFF);
		buttons[RT]:SetAlpha(main.ON);
		buttons[BTE]:SetAlpha(main.ON);
		buttons[DFA]:SetAlpha(main.ON);
	end
	
	local _,_,_,_,_,_,_,_,interrupt = UnitCastingInfo(main.TARGET)
	if (interrupt == null or interrupt) then
		buttons[KICK]:SetAlpha(main.OFF)
	else
		buttons[KICK]:SetAlpha(main.ON)
	end
	
	local bfSetting = main.HALF;
	local minRange, maxRange = main.rc:GetRange(main.MOUSEOVER)
	if (minRange and maxRange) then
		if (bf_max <= minRange) then
			bfSetting = main.HALF;
		else
			bfSetting = main.ON;
		end
	end
	buttons[BF]:SetAlpha(bfSetting);
end

module.EvaluateButtons = EvaluateButtons
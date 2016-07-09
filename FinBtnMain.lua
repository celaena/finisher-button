-------------------------------------------
-- Main Module --
-------------------------------------------
FinBtn = {}

local module = {}
local moduleName = "Main";
FinBtn[moduleName] = module;

module.rc = LibStub("LibRangeCheck-2.0")

module.TYPE = "type";
module.NAME = "name"
module.SPELL = "spell"
module.MACRO = "macro"
module.ID = "id"
module.UNIT = "unit"
module.PLAYER = "player"
module.TARGET = "target"
module.MOUSEOVER = "mouseover"
module.PLAYER_HARMFUL = "PLAYER|HARMFUL"
module.PLAYER_HELPFUL = "PLAYER|HELPFUL"
module.BG = "bg"
module.ORDER = "order"

module.ON = 1
module.OFF = 0.1
module.HALF = 0.5

module.SKILLS = {};
module.SKILL_ORDER = {};

local function EvaluateButtons(buttons)
	-- Placeholder --
end

module.EvaluateButtons = EvaluateButtons
local BAIT = {
    --lureID, ItemID
    LAKE = {
        REG = {2,42870}, --guts
        ALT = {8,42876}  --minnow
    },
    FOUL = {
        REG = {3,42871}, --crawlers
        ALT = {9,42873}  --roe
    },
    RIVR = {
        REG = {4,42872}, --insects
        ALT = {6,42874}  --shad
    },
    SALT = {
        REG = {5,42869}, --worms
        ALT = {7,42875}  --chub
    }
}

FishermansFriend = {
    name = "FishermansFriend",
    delay = false,
    defaults = {
        filtered = true
    }
}

--local logger = LibDebugLogger(FishermansFriend.name)
local LAM = LibAddonMenu2


--Setting Menu
function FishermansFriend.CreateSettings()
    local panelName = "FishermansFriendSettingsPanel"

    local panelData = {
        type = "panel",
        name = "Fisherman's Friend",
        displayName = "Fisherman's Friend",
        author = "GameDude, Sem",
        registerForRefresh = true,
        registerForDefaults = true,
    }
    local panel = LAM:RegisterAddonPanel(panelName, panelData)
    local optionsData = {}
        optionsData[#optionsData + 1] = {
            type = "header",
            name = "Fisherman's Friend Settings",
        }
        optionsData[#optionsData + 1] = {
            type = "description",
            text = "You can change whether or not you want to use the alternative baits first (Shad, Chub, Fish Roe, and Minnow) over the regular baits (Worms, Guys, Insect Parts, Crawlers.",
        }
        optionsData[#optionsData + 1] = {
            type = "button",
            name = "Close Settings",
            width = "half",
            func = function()
                SCENE_MANAGER:ShowBaseScene()
            end,
        }
        optionsData[#optionsData + 1] = {
            type = "header",
            name = "Default Items"
        }
        optionsData[#optionsData + 1] = {
            type = "checkbox",
            name = "Use Alternative Baits First",
            default = true,
            width = "half",
            disabled = false,
            getFunc = function() return FishermansFriend.SavedVariables.filtered end,
            setFunc = function(value) FishermansFriend.SavedVariables.filtered = value end
        }

    LAM:RegisterOptionControls(panelName, optionsData)
end


local function FishermansFriend_OnAction()
    if FishermansFriend.delay then return end
    EVENT_MANAGER:RegisterForUpdate(FishermansFriend.name .. "Delay", 300, function()
        FishermansFriend.delay = false
        EVENT_MANAGER:UnregisterForUpdate(FishermansFriend.name .. "Delay")
    end)
    FishermansFriend.delay = true

    local _, interactableName, _, _, additionalInteractInfo, _, _, _ = GetGameCameraInteractableActionInfo()
    if additionalInteractInfo ~= ADDITIONAL_INTERACT_INFO_FISHING_NODE then return end

    regularBaitQuantity, alternativeBaitQuantity = 0, 0

    --Lake Bait needed
    if interactableName == GetString(FISHERMENSFRIEND_LAKE_FISHING_HOLE) then
        local regularBaitQuantity = FishermansFriend.GetItemQuantity(BAIT.LAKE.REG[2])
        local alternativeBaitQuantity = FishermansFriend.GetItemQuantity(BAIT.LAKE.ALT[2])

        if FishermansFriend.SavedVariables.filtered == true then
            if alternativeBaitQuantity > 0 then
                SetFishingLure(BAIT.LAKE.ALT[1])
            else
                SetFishingLure(BAIT.LAKE.REG[1])
            end
        else
            if regularBaitQuantity > 0 then
                SetFishingLure(BAIT.LAKE.REG[1])
            else
                SetFishingLure(BAIT.LAKE.ALT[1])
            end
        end

    --Salt or Mystic Bait needed
    elseif interactableName == GetString(FISHERMENSFRIEND_SALT_FISHING_HOLE) or interactableName == GetString(FISHERMENSFRIEND_MYST_FISHING_HOLE) then
        local regularBaitQuantity = FishermansFriend.GetItemQuantity(BAIT.SALT.REG[2])
        local alternativeBaitQuantity = FishermansFriend.GetItemQuantity(BAIT.SALT.ALT[2])

        if FishermansFriend.SavedVariables.filtered == true then
            if alternativeBaitQuantity > 0 then
                SetFishingLure(BAIT.SALT.ALT[1])
            else
                SetFishingLure(BAIT.SALT.REG[1])
            end
        else
            if regularBaitQuantity > 0 then
                SetFishingLure(BAIT.SALT.REG[1])
            else
                SetFishingLure(BAIT.SALT.ALT[1])
            end
        end

    --Foul or Oily Bait needed
    elseif interactableName == GetString(FISHERMENSFRIEND_FOUL_FISHING_HOLE) or interactableName == GetString(FISHERMENSFRIEND_OILY_FISHING_HOLE) then
        local regularBaitQuantity = FishermansFriend.GetItemQuantity(BAIT.FOUL.REG[2])
        local alternativeBaitQuantity = FishermansFriend.GetItemQuantity(BAIT.FOUL.ALT[2])

        if FishermansFriend.SavedVariables.filtered == true then
            if alternativeBaitQuantity > 0 then
                SetFishingLure(BAIT.FOUL.ALT[1])
            else
                SetFishingLure(BAIT.FOUL.REG[1])
            end
        else
            if regularBaitQuantity > 0 then
                SetFishingLure(BAIT.FOUL.REG[1])
            else
                SetFishingLure(BAIT.FOUL.ALT[1])
            end
        end

    --River Bait needed
    elseif interactableName == GetString(FISHERMENSFRIEND_RIVR_FISHING_HOLE) then
        local regularBaitQuantity = FishermansFriend.GetItemQuantity(BAIT.RIVR.REG[2])
        local alternativeBaitQuantity = FishermansFriend.GetItemQuantity(BAIT.RIVR.ALT[2])

        if FishermansFriend.SavedVariables.filtered == true then
            if alternativeBaitQuantity > 0 then
                SetFishingLure(BAIT.RIVR.ALT[1])
            else
                SetFishingLure(BAIT.RIVR.REG[1])
            end
        else
            if regularBaitQuantity > 0 then
                SetFishingLure(BAIT.RIVR.REG[1])
            else
                SetFishingLure(BAIT.RIVR.ALT[1])
            end
        end

    end

    --if alternativeBaitQuantity + regularBaitQuantity == 0 then
            --TODO rewrite text
    --end
end


function FishermansFriend.GetItemQuantity(itemId)
    --Source: VotansFishFillet
    function CountBag(bagId, itemId)
        local slotIndex = ZO_GetNextBagSlotIndex(bagId, nil)
        local stack, _, count
        local sum = 0
        while slotIndex do
            local i = GetItemId(bagId, slotIndex)
            if i == itemId then
                _, count = GetItemInfo(bagId, slotIndex)
                sum = sum + count
            end
            slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
        end
        return sum
    end

    local quantity = 0
    if HasCraftBagAccess then
        quantity = CountBag(BAG_VIRTUAL, itemId) + CountBag(BAG_BACKPACK, itemId)
    else
        quantity = CountBag(BAG_BACKPACK, itemId)
    end
    return quantity
end


function FishermansFriend.OnAddOnLoaded(event, addonName)
    if addonName ~= FishermansFriend.name then return end

    EVENT_MANAGER:UnregisterForEvent(FishermansFriend.name, EVENT_ADD_ON_LOADED)
    FishermansFriend.SavedVariables = ZO_SavedVars:New("FishermansFriendSavedVariables", 1, nil, FishermansFriend.defaults)
    FishermansFriend.CreateSettings()
    ZO_PreHookHandler(RETICLE.interact, "OnEffectivelyShown", FishermansFriend_OnAction)
end

EVENT_MANAGER:RegisterForEvent(FishermansFriend.name, EVENT_ADD_ON_LOADED, FishermansFriend.OnAddOnLoaded)
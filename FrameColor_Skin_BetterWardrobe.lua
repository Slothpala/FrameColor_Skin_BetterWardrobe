local info = {
    moduleName = "BetterWardrobe",
    moduleDesc = "This module has no settings. It follows the settings of the CollectionsJournal module.",
    followModule = "CollectionsJournal",
}

local module = FrameColor_CreateSkinModule(info)

local _G = _G
local SetDesaturation = SetDesaturation
local SetVertexColor = SetVertexColor
local C_Timer_After = C_Timer.After

local bw_loaded = nil

function module:OnEnable()
    self:RegisterMessage("BW_ADDON_LOADED", function()
        self:UnregisterMessage("BW_ADDON_LOADED")
        local dbObj = self:RequestData("Windows", "CollectionsJournal")
        local color1, color2, color3, color4
        local classColors = self:RequestData("ColorOverrides", "ClassColors")
        local classColor = classColors[select(2,UnitClass("player"))]
        if dbObj.classcolored1 then
            color1 = classColor
        else
            color1 = dbObj.color1
        end
        if dbObj.classcolored2 then
            color2 = classColor
        else
            color2 = dbObj.color2
        end
        if dbObj.classcolored3 then
            color3 = classColor
        else
            color3 = dbObj.color3
        end
        if dbObj.classcolored4 then
            color4 = classColor
        else
            color4 = dbObj.color4
        end
		C_Timer_After(0.5, function()
            bw_loaded = true
            self:Recolor(color1, color2, color3, color4, 1)
		 end)
    end)
end

function module:Recolor(...)
    if not bw_loaded then
        return
    end
    local color1, color2, color3, color4, desaturation = ...
    --frames
    local betterWardrobeCollectionFrame = BetterWardrobeCollectionFrame
    local filterDropdown1 = BW_DropDownList1MenuBackdrop
    local filterDropdown2 = BW_DropDownList2MenuBackdrop
    if not betterWardrobeCollectionFrame or not filterDropdown1 or not filterDropdown2 then
        return
    end
    --nine sliced frames
    for _, frame in pairs({
        betterWardrobeCollectionFrame.ItemsCollectionFrame,
        betterWardrobeCollectionFrame.SetsCollectionFrame.LeftInset,
        betterWardrobeCollectionFrame.SetsCollectionFrame.RightInset,
        betterWardrobeCollectionFrame.SetsTransmogFrame,
        filterDropdown1,
        filterDropdown2,
    }) do
        for _, texture in pairs({
            frame.NineSlice.TopEdge,
            frame.NineSlice.BottomEdge,
            frame.NineSlice.TopRightCorner,
            frame.NineSlice.TopLeftCorner,
            frame.NineSlice.RightEdge,
            frame.NineSlice.LeftEdge,
            frame.NineSlice.BottomRightCorner,
            frame.NineSlice.BottomLeftCorner,  
        }) do
            texture:SetDesaturation(desaturation)
            texture:SetVertexColor(color1.r,color1.g,color1.b,color1.a) 
        end
    end
    local bg = BetterWardrobeCollectionFrameBg
    if bg then
        bg:SetDesaturation(desaturation)
        bg:SetVertexColor(color2.r,color2.g,color2.b,color2.a)
    end
    --tabs
    local tab1, tab2, tab3, tab4 = BetterWardrobeCollectionFrameTab1, BetterWardrobeCollectionFrameTab2, BetterWardrobeCollectionFrameTab3, BetterWardrobeCollectionFrameTab4
    for _, tab in pairs({
        tab1,
        tab2,
        tab3,
        tab4,
    }) do
        for _, texture in pairs({
            tab.Left,
            tab.Middle,
            tab.Right,
        }) do
            texture:SetVertexColor(color3.r,color3.g,color3.b)
        end
    end
    --scroll bars
    local scrollBar = BetterWardrobeCollectionFrameScrollFrameScrollBar
    if not scrollBar then 
        return
    end
    for _, texture in pairs({
        scrollBar.Track.Thumb.Begin,
        scrollBar.Track.Thumb.Middle,
        scrollBar.Track.Thumb.End,
        scrollBar.Back.Texture,
        scrollBar.Forward.Texture,
        BetterWardrobeOutfitFrameScrollFrameScrollBarThumbTexture,
        BetterWardrobeOutfitFrameScrollFrameScrollBarScrollUpButton:GetNormalTexture(),
        BetterWardrobeOutfitFrameScrollFrameScrollBarScrollUpButton:GetDisabledTexture(),
        BetterWardrobeOutfitFrameScrollFrameScrollBarScrollDownButton:GetNormalTexture(),
        BetterWardrobeOutfitFrameScrollFrameScrollBarScrollDownButton:GetDisabledTexture(),
    }) do
        texture:SetVertexColor(color4.r,color4.g,color4.b,color4.a) 
    end
    local searchBox = BetterWardrobeCollectionFrameSearchBox
    if not searchBox then 
        return
    end
    local progressBar = betterWardrobeCollectionFrame.progressBar
    if not progressBar then
        return
    end
    --window specific regions
    for _,frame in pairs({
        BW_CollectionList_DropdownLeft,
        BW_CollectionList_DropdownMiddle,
        BW_CollectionList_DropdownRight,
        BW_ColectionList_DropdownLeft,
        BW_ColectionList_DropdownMiddle,
        BW_ColectionList_DropdownRight,
        BetterWardrobeCollectionFrameWeaponDropDownLeft,
        BetterWardrobeCollectionFrameWeaponDropDownMiddle,
        BetterWardrobeCollectionFrameWeaponDropDownRight,
        BW_SortDropDownLeft,
        BW_SortDropDownMiddle,
        BW_SortDropDownRight,
        BW_DBSavedSetDropdownLeft,
        BW_DBSavedSetDropdownMiddle,
        BW_DBSavedSetDropdownRight,
        searchBox.Left,
        searchBox.Middle,
        searchBox.Right,
        progressBar.border,
        BetterWardrobeOutfitDropDownLeft,
        BetterWardrobeOutfitDropDownMiddle,
        BetterWardrobeOutfitDropDownRight,
        BetterWardrobeDressUpFrameDropDownLeft,
        BetterWardrobeDressUpFrameDropDownMiddle,
        BetterWardrobeDressUpFrameDropDownRight,
    }) do 
        frame:SetDesaturation(desaturation)
        frame:SetVertexColor(color1.r,color1.g,color1.b,color1.a)
    end
    --filter buttons
    for _,frame in pairs ({  
        "BetterWardrobeCollectionFrame",
        "BetterWardrobeSetsCollectionVariantSetsButton",
    }) do
        for _,region in pairs ({
            frame.."TopLeft",
            frame.."TopRight",
            frame.."BottomLeft",
            frame.."BottomRight",
            frame.."TopMiddle",
            frame.."MiddleLeft",
            frame.."MiddleRight",
            frame.."BottomMiddle",
            frame.."MiddleMiddle",
        }) do
            local texture = _G[region]
            if not texture then 
                return
            end
            texture:SetDesaturation(desaturation)
            texture:SetVertexColor(color1.r,color1.g,color1.b,color1.a)
        end
    end
    --list drop down menu
    local dropdownList = BW_DropDownList1Backdrop
    if not dropdownList then
        return
    end
    for _, texture in pairs({
        dropdownList.TopEdge,
        dropdownList.TopRightCorner,
        dropdownList.RightEdge,
        dropdownList.BottomRightCorner,
        dropdownList.BottomEdge,
        dropdownList.BottomLeftCorner,
        dropdownList.LeftEdge,
        dropdownList.TopLeftCorner,
    }) do 
        texture:SetVertexColor(color1.r,color1.g,color1.b,color1.a)
    end
    local outfitFrame = BetterWardrobeOutfitFrame
    if not outfitFrame then
        return
    end
    for _, texture in pairs({
        outfitFrame.Border.TopEdge,
        outfitFrame.Border.TopRightCorner,
        outfitFrame.Border.RightEdge,
        outfitFrame.Border.BottomRightCorner,
        outfitFrame.Border.BottomEdge,
        outfitFrame.Border.BottomLeftCorner,
        outfitFrame.Border.LeftEdge,
        outfitFrame.Border.TopLeftCorner,
    }) do 
        texture:SetVertexColor(color1.r,color1.g,color1.b)
    end
end


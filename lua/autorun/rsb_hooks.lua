-- Client drawing hooks can be found in weapons/weapon_ttt_rsb.lua (bottom)

if SERVER then
    hook.Remove("PlayerDisconnected", "rsb_playerdisconnect")
    hook.Add("PlayerDisconnected", "rsb_playerdisconnect", function(ply)
        local rsb = ply.attachedRSB
        if(IsValid(rsb) == false) then return end

        rsb:HandleTargetLeft()
    end)

    local function ResetRSBState()
        for _, ply in pairs(player.GetAll()) do
            ply.attachedRSB = nil
        end
    end

    hook.Remove("TTTPrepareRound", "rsb_roundprep")
    hook.Add("TTTPrepareRound", "rsb_roundprep", function()
        ResetRSBState()
    end)

    hook.Remove("TTTBeginRound", "rsb_roundbegin")
    hook.Add("TTTBeginRound", "rsb_roundbegin", function()
        ResetRSBState()
    end)

    hook.Remove("TTTOnCorpseCreated", "rsb_corpsecreate")
    hook.Add("TTTOnCorpseCreated", "rsb_corpsecreate", function(corpse, ply)
        local RSB = ply.attachedRSB
        if(RSB == nil) then return end

        ply.attachedRSB = nil

        local RSBOwner = RSB.Owner
        if not RSBOwner:Alive() then return end

        RSB:HandleTargetDeath(corpse)
        corpse.unexplodedRSB = RSB
    end)

    hook.Remove("TTTCanSearchCorpse", "rsb_bodysearch")
    hook.Add("TTTCanSearchCorpse", "rsb_bodysearch", function(ply, corpse, isSecret, isLongRange, wasTraitor)
        if(corpse.unexplodedRSB == nil or corpse.unexplodedRSB.Owner != ply) then return end

        corpse.unexplodedRSB:ReclaimRSB()
        corpse.unexplodedRSB = nil
    end)
end


if SERVER then
    hook.Remove("PlayerDisconnected", "rsb_playerdisconnect")
    hook.Add("PlayerDisconnected", "rsb_playerdisconnect", function(ply)
        print(ply:Nick() .. " disconnected")
        local rsb = ply.attachedRSB
        if(IsValid(rsb) == false) then return end

        rsb:HandleTargetLeft()
    end)
end
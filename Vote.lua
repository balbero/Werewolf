if not WereWolf.IsCorrectVersion() then
    return
end

local L = WereWolf.L
local WereWolf = WereWolf
local Comm = WereWolf.Comm
local players = WereWolf.players


function WereWolf.ManageVote(designatedPlayer, votedPlayer)
    votedPlayer.hasVoted = true
    designatedPlayer.voteNb = designatedPlayer.voteNb + 1
end

function WereWolf.VoteResult()
    local player = nil
    local maxVote = 0
    for _,value in pairs(players) do
        if value.voteNb > maxVote then
            maxVote = value.voteNb
            player = value
        end
    end

    return player
end


function WereWolf.ResetVote()
    for _,value in pairs(players) do
        value.hasVoted = false
        value.voteNb = 0
    end
end
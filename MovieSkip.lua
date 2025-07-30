
local color = "|c006699ff"

local PlayMovie = MovieFrame_PlayMovie
MovieFrame_PlayMovie = function(self, movieID)
	MovieSkipWTF.replay = movieID
	if(MovieSkipWTF.skip) then
		MovieFrame_StopMovie(self)
		print(color.."MovieSkip: cinematic skipped, play with /MovieSkip replay")
	else
		PlayMovie(self, movieID)
	end
end

CinematicFrame:HookScript("OnShow", function(self, ...)
	-- No movie ID provided for Cinematics =(
	MovieSkipWTF.replay = 0	
	if(MovieSkipWTF.skip) then
		CinematicFrame_CancelCinematic()
		print(color.."MovieSkip: cinematic skipped")
	end
end)

local DefaultWTF = {
	tocv = 100000,
	skip = 0,
	replay = 0
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, ...)
	if(event == "ADDON_LOADED" and ... == "MovieSkip") then
		if(MovieSkipWTF == nil or type(MovieSkipWTF) == "boolean") then
			-- Initialize WTF on first time install
			MovieSkipWTF = DefaultWTF
		end
		-- Upgrade WTF on new build
		local v, b, d, tocv = GetBuildInfo()
		if(MovieSkipWTF.tocv < tocv) then
			MovieSkipWTF.tocv = tocv				
			MovieSkipWTF.skip = false
			print(color.."Cinematics will play for new build, skip with /MovieSkip yes")					
		end
		MovieSkipWTF.replay = 0
	end
end)

SLASH_MOVIESKIP1 = "/movieskip"
SlashCmdList["MOVIESKIP"] = function(msg)
	if(msg == "replay") then
		if(MovieSkipWTF.replay > 0) then
			PlayMovie(MovieFrame, MovieSkipWTF.replay)
		else
			print(color.."MovieSkip: unable to replay cinematic")
		end
		return
	elseif (msg == "yes") then
		MovieSkipWTF.skip = true
	elseif (msg == "no") then
		MovieSkipWTF.skip = false
	end
	
	if(MovieSkipWTF.skip) then
		print(color.."Cinematics are skipped, play with /MovieSkip no")
	else
		print(color.."Cinematics will play, skip with /MovieSkip yes")
	end
end





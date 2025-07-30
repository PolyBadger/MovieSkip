
local color = "|c006699ff"
local message = {
	skip = "Cinematic skipped, play with /MovieSkip no",
	play = "Cinematic played, skip with /MovieSkip yes",
}

StaticPopupDialogs["MovieSkipDialog"] = {
	text = "\nMovieSkip\n\n%s, do you want to play or skip cinematics?\n\n",
	button1 = "Play",
	button2 = "Skip",
	OnAccept = function()
		MovieSkipWTF.skip = false
	end,
	OnCancel = function()
		MovieSkipWTF.skip = true
	end,
}

local PlayMovie = MovieFrame_PlayMovie
MovieFrame_PlayMovie = function(self, movieID)
	MovieSkipWTF.replay = movieID
	if MovieSkipWTF.skip then
		MovieFrame_StopMovie(self)
		print(color..message.skip)
	else
		PlayMovie(self, movieID)
		print(color..message.play)
	end
end

CinematicFrame:HookScript("OnShow", function(self, ...)
	-- No movie ID provided for Cinematics =(
	MovieSkipWTF.replay = 0	
	if MovieSkipWTF.skip then
		CinematicFrame_CancelCinematic()
		print(color..message.skip)
	else
		print(color..message.play)	
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
	if event == "ADDON_LOADED" and ... == "MovieSkip" then
		if MovieSkipWTF == nil or type(MovieSkipWTF) == "boolean" then
			-- Initialize WTF on first time install
			MovieSkipWTF = DefaultWTF
		end
		-- Upgrade WTF on new build
		local v, b, d, tocv = GetBuildInfo()
		if MovieSkipWTF.tocv < tocv then
			MovieSkipWTF.tocv = tocv				
			StaticPopup_Show("MovieSkipDialog", "A new build has been installed")
		end
		MovieSkipWTF.replay = 0
	end
end)

SLASH_MOVIESKIP1 = "/movieskip"
SlashCmdList["MOVIESKIP"] = function(msg)
	if msg == "replay" then
		if MovieSkipWTF.replay > 0 then
			PlayMovie(MovieFrame, MovieSkipWTF.replay)
		else
			print(color.."MovieSkip is unable to replay cinematic")
		end
		return
	elseif msg == "yes" or msg == "skip" then
		MovieSkipWTF.skip = true
	elseif msg == "no" or msg == "play" then
		MovieSkipWTF.skip = false
	elseif MovieSkipWTF.skip then
		StaticPopup_Show("MovieSkipDialog", "Cinematics are currently skipped")
	else
		StaticPopup_Show("MovieSkipDialog", "Cinematics are currently playing")		
	end
end





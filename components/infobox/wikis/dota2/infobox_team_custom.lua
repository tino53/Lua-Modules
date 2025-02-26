---
-- @Liquipedia
-- wiki=dota2
-- page=Module:Infobox/Team/Custom
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute
--

local Class = require('Module:Class')
local Lua = require('Module:Lua')
local String = require('Module:StringUtils')
local Template = require('Module:Template')
local Variables = require('Module:Variables')

local Team = Lua.import('Module:Infobox/Team', {requireDevIfEnabled = true})

local CustomTeam = Class.new()

function CustomTeam.run(frame)
	local team = Team(frame)

	-- Override links to allow one param to set multiple links
	team.args.datdota = team.args.teamid
	team.args.dotabuff = team.args.teamid

	-- Automatic achievements
	team.args.achievements = Template.expandTemplate(frame, 'Team achievements')

	-- Automatic org people
	team.args.coach = Template.expandTemplate(frame, 'Coach of')
	team.args.director = Template.expandTemplate(frame, 'Director of')
	team.args.manager = Template.expandTemplate(frame, 'Manager of')
	team.args.captain = Template.expandTemplate(frame, 'Captain of')

	team.createBottomContent = CustomTeam.createBottomContent
	team.addToLpdb = CustomTeam.addToLpdb

	return team:createInfobox(frame)
end

function CustomTeam:createBottomContent()
--[[
	if not _team.args.disbanded then
		TODO:
		Leaving this out for now, will be a follow-up PR,
		as both the templates needs to be removed from team pages plus the templates also requires some div changes

		return Template.expandTemplate(
			mw.getCurrentFrame(),
			'Upcoming and ongoing matches of',
			{team = _team.name or _team.pagename}
		) .. Template.expandTemplate(
			mw.getCurrentFrame(),
			'Upcoming and ongoing tournaments of',
			{team = _team.name or _team.pagename}
		)
	end
--]]
end

function CustomTeam:addToLpdb(lpdbData, args)
	if not String.isEmpty(args.teamcardimage) then
		lpdbData.logo = args.teamcardimage
	elseif not String.isEmpty(args.image) then
		lpdbData.logo = args.image
	end

	lpdbData.region = Variables.varDefault('region', '')

	lpdbData.extradata.teamid = args.teamid
	lpdbData.coach = Variables.varDefault('coachid') or args.coach or args.coaches
	lpdbData.manager = Variables.varDefault('managerid') or args.manager

	return lpdbData
end

return CustomTeam

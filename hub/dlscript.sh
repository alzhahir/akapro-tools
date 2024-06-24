#!/bin/bash

# Variants
# 0 - Bukkit, 1 - BungeeCord
VARDL=0

# Hub or not
# 0 - Yes, 1 - No
# Does not apply if BungeeCord is set instead
HUBDL=0

# SpigotMC Resources IDs
# Vault - 34315
VTSPG=34315
# MultiChat
MCSPG=26204
# HubMagic
HMSPG=2021
# ViaVersion
VVSPG=19254
# ViaBackwards
VBSPG=27448

# GitHub Repos
# EssentialsX
EXGIT=EssentialsX/Essentials
# SimplePortals
SPGIT=XZot1K/SimplePortals
# CleanMoTD
CMGIT=2lstudios-mc/CleanMOTD

getGitHubLatestVer(){
        basename $(curl -fs -o/dev/null -w %{redirect_url} https://github.com/$1/releases/latest)
}

getGitHubLatestDL(){
        wget https://github.com/$1/releases/latest/
}

getLuckyDL(){
	curl -g https://ci.lucko.me/job/LuckPerms/lastSuccessfulBuild/api/json?pretty=true\&tree=artifacts\[fileName\,relativePath\]\{$1\} |\
		python3 -c "import sys, json; print(json.load(sys.stdin)['artifacts'][0]['relativePath'])"
}

getGeyserDL(){
	curl -g https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/api/json?tree=artifacts[relativePath]{0} |\
		python3 -c "import sys, json; print(json.load(sys.stdin)['artifacts'][0]['relativePath'])"
}

getFloodgateDL(){
	curl -g https://ci.opencollab.dev//job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/api/json?tree=artifacts[relativePath]{0} |\
		python3 -c "import sys, json; print(json.load(sys.stdin)['artifacts'][0]['relativePath'])"
}

getSpigotResLatestVer(){
	curl -g https://api.spiget.org/v2/resources/$1/versions/latest |\
		python3 -c "import sys, json; print(json.load(sys.stdin)['name'])"
}

getSpigotResName(){
	curl -g https://api.spiget.org/v2/resources/$1 |\
		python3 -c "import sys, json; print(json.load(sys.stdin)['name'])" |\
		awk '{print $1}'
}

setLuckyVar(){
	# LuckyPerm Variants
	# 0 = Bukkit, 1 = Bukkit Legacy, 2 = BungeeCord, 3 = Fabric
	# 4 = Forge, 5 = Nukkit, 6 = Sponge, 7 = Velocity
	LPVAR=2

	if [ $VARDL = 0 ]; then
		LPVAR=0
	else
		LPVAR=2
	fi
}

rm -r ./plugins
mkdir -p ./plugins
cd ./plugins

# Set LPVAR to appropriate values
setLuckyVar

# Independent DLs
wget https://ci.lucko.me/job/LuckPerms/lastSuccessfulBuild/artifact/$(getLuckyDL "$LPVAR") &

if [ $VARDL = 0 ]; then
	# Bukkit/Paper DLs
	if [ $HUBDL = 0 ]; then
		wget https://github.com/"${SPGIT}"/releases/download/$(getGitHubLatestVer "$SPGIT")/SimplePortals-$(getGitHubLatestVer "$SPGIT").jar &
		wget -O $(getSpigotResName "$VVSPG")-$(getSpigotResLatestVer "$VVSPG").jar https://api.spiget.org/v2/resources/"${VVSPG}"/download &
		# wget -O $(getSpigotResName "$VBSPG")-$(getSpigotResLatestVer "$VBSPG").jar https://api.spiget.org/v2/resources/"${VBSPG}"/download &
	fi
	wget https://github.com/"${EXGIT}"/releases/download/$(getGitHubLatestVer "$EXGIT")/EssentialsX-$(getGitHubLatestVer "$EXGIT").jar &
	wget https://github.com/"${EXGIT}"/releases/download/$(getGitHubLatestVer "$EXGIT")/EssentialsXChat-$(getGitHubLatestVer "$EXGIT").jar &
	wget --content-disposition https://dev.bukkit.org/projects/worldedit/files/latest &
	wget --content-disposition https://dev.bukkit.org/projects/worldguard/files/latest &
	wget --content-disposition https://dev.bukkit.org/projects/simple-voice-chat/files/latest &
	wget -O $(getSpigotResName "$VTSPG")-$(getSpigotResLatestVer "$VTSPG").jar https://api.spiget.org/v2/resources/"${VTSPG}"/download &
	wait
elif [ $VARDL = 1 ]; then
	# BungeeCord DLs
	wget -O $(getSpigotResName "$MCSPG")-$(getSpigotResLatestVer "$MCSPG").jar https://api.spiget.org/v2/resources/"${MCSPG}"/download &
	wget -O $(getSpigotResName "$HMSPG")-$(getSpigotResLatestVer "$HMSPG").jar https://api.spiget.org/v2/resources/"${HMSPG}"/download &
	wget https://github.com/"${CMGIT}"/releases/download/$(getGitHubLatestVer "$CMGIT")/CleanMoTD.jar &
	wget https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/$(getGeyserDL) &
	wget https://ci.opencollab.dev//job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/$(getFloodgateDL) &
	wait
else
	echo "Invalid variant. Exiting..."
	exit 1
fi

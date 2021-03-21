#define DCMD_PREFIX '!' //Prefix discord bot kamu
//#define DCMD_STRICT_CASE // mendefinisikan ini akan mengaktifkan case sensitif, !TEST dan !test akan mengeluarkan hasil yang berbeda
//#define DCMD_ALLOW_BOTS // mendefinisikan ini akan mengabaikan perintah yang dijalankan oleh bot
#include <discord-connector>
#include <discord-cmd> 
#include <a_samp>
#include <Pawn.CMD>
#include <sscanf2>

new DCC_Channel:logchannel;

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	logchannel = DCC_FindChannelById("814264424231600159"); //channel id yang ingin digunakan untuk audit log
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{

}

#endif

public OnGameModeInit()
{
	logchannel = DCC_FindChannelById("814264424231600159"); //channel id yang ingin digunakan untuk audit log
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	new msg[128], a[120];
	GetPlayerName(playerid, a, MAX_PLAYER_NAME);
	format(msg, sizeof(msg), "```%s[%d] telah terhubung kedalam server!```", a, playerid);
	DCC_SendChannelMessage(logchannel, msg);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	switch(reason)
	{
	    case 0:
	    {
	        new msg[128];
			format(msg, sizeof(msg), "```[LOGOUT] %s(%d) has leave from the server.(timeout/crash)```", pData[playerid][pName], playerid);
			DCC_SendChannelMessage(logchannel, msg);
		}
		case 1:
		{
	        new msg[128];
			format(msg, sizeof(msg), "```[LOGOUT] %s(%d) has leave from the server.(leaving)```", pData[playerid][pName], playerid);
			DCC_SendChannelMessage(logchannel, msg);
		}
		case 2:
		{
  			new msg[128];
			format(msg, sizeof(msg), "```[LOGOUT] %s(%d) has leave from the server.(Kick/Banned)```", pData[playerid][pName], playerid);
			DCC_SendChannelMessage(logchannel, msg);
		}
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
 	new msg[128];
    format(msg, sizeof(msg), "```[CHAT] %s says :%s```", pData[playerid][pName], text);
    DCC_SendChannelMessage(logchannel, msg);
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if (result == -1)
    {
        SendClientMessage(playerid, -1, "Unknown Command! /help for more info.");
        return 0;
    }
    new msg[128];
    format(msg, sizeof(msg), "```[CMD]: %s(%d) has used the command '%s' (%s)```", pData[playerid][pName], playerid, cmd, params);
    DCC_SendChannelMessage(logchannel, msg);
    return 1;
}

DCMD:kick(user, channel, params[]) {

    if(channel != logchannel)
        return 1;
        
    static
        reason[128];

	new otherid, playername[20];
	GetPlayerName(otherid, playername, MAX_PLAYER_NAME);
    if(sscanf(params, "us[128]", otherid, reason))
        return DCC_SendChannelMessage(channel, "/kick [playerid/PartOfName] [reason]");

    if(!IsPlayerConnected(otherid))
        return DCC_SendChannelMessage(channel, "Player not connected!");

    SendClientMessageToAllEx(-1, "Server: "GREY2_E"%s was kicked by admin Reason: %s.", playername, reason);

	new msg[128];
   	format(msg, sizeof(msg), "```Kamu telah kick %s(%d) dengan alasan %s```", playername, otherid, reason);
   	DCC_SendChannelMessage(channel, msg);
    KickEx(otherid);
 	return 1;
}

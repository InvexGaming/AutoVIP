#include <sourcemod>
#include <cstrike>

//Defines
#define VERSION "1.01"

//Global Varibales
int ServerID = -1;
Database db = null;

//Convars
ConVar cvar_autovip_serverID = null;
ConVar cvar_autovip_updateinterval = null;

public Plugin myinfo =
{
  name = "AutoVIP",
  author = "Invex | Byte",
  description = "Automatically assigns/removes VIP permissions.",
  version = VERSION,
  url = "http://www.invexgaming.com.au"
};

// Plugin Start
public void OnPluginStart()
{
  //Flags
  CreateConVar("sm_autovip_version", VERSION, "", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_CHEAT|FCVAR_DONTRECORD);
  
  //Convars
  cvar_autovip_serverID = CreateConVar("sm_autovip_serverid", "-1", "Servers ID in database");
  cvar_autovip_updateinterval = CreateConVar("sm_autovip_updateinterval", "900.0", "How often admin_simple.ini should be updated.");
  
  //Commands
  RegAdminCmd("sm_reloadvip", OnReloadVIP, ADMFLAG_RCON, "Reload VIP list.");
  RegAdminCmd("sm_reloadvips", OnReloadVIP, ADMFLAG_RCON, "Reload VIP list.");
  
  //Timer
  CreateTimer(GetConVarFloat(cvar_autovip_updateinterval), OnReloadVIPTimer, _, TIMER_REPEAT);
  
  //Create config file
  AutoExecConfig(true, "autovip");
}

public Action OnReloadVIPTimer(Handle timer, int client) {
  OnReloadVIP(0, 0);
  return Plugin_Handled;
}


//Trigger reading of database and reconstruction of admin_simple.ini
public Action OnReloadVIP(int client, int args)
{
  //Log time/date of update
  LogMessage("VIP list is being reloaded.");
 
  //Set server ID
  ServerID = GetConVarInt(cvar_autovip_serverID);
 
  //Connect to DB if not connected
  if (db == null) {
    char error[255];
    db = SQL_Connect("autovip", true, error, sizeof(error));
    
    if (db == null) {
      LogError("Failed to connect to database: %s", error);
      return Plugin_Handled;
    }
  }
  
  //Query database
  char query[1024];
  Format(query, sizeof(query), "SELECT p.name, p.description, perm.tag, t.steamid, t.username, t.userid, t.id FROM packages p INNER JOIN transactions t on p.id = t.packageid INNER JOIN permissions perm on p.permissionid = perm.id LEFT JOIN selectedservers ss on t.id = ss.transactionid WHERE p.permissionid IS NOT NULL AND p.active = (1) AND (end_date IS NULL OR UNIX_TIMESTAMP() < t.end_date) AND (ss.serverid = %d OR p.num_servers = 0) ORDER BY p.ordernum,t.id ASC", ServerID);
  
  SQL_TQuery(db, DB_Callback_Command_ReadVIPList, query);
  delete db;
  
  ReplyToCommand(client, "[AUTOVIP] VIP cache has been refreshed.");
  
  return Plugin_Handled;
}

public void DB_Callback_Command_ReadVIPList(Handle owner, Handle hndl, const char[] error, any datapack)
{
  if (hndl == null) {
    LogError("Error reading AutoVIP database at Command_ReadVIPList: %s", error);
    return;
  }
   
  //Create new admin_simple.ini.new file
  //If it exists, this will truncate it
  char admin_simple_path[PLATFORM_MAX_PATH];
  BuildPath(Path_SM, admin_simple_path, PLATFORM_MAX_PATH, "/configs/admins_simple.ini");
  File admin_simple_file = OpenFile(admin_simple_path, "w");
  
  //Write file header
  char timebuffer[512];
  FormatTime(timebuffer, sizeof(timebuffer), "%A %d %B %Y at %I:%M:%S %p", GetTime());

  WriteFileLine(admin_simple_file, "// AutoVIP v%s", VERSION);
  WriteFileLine(admin_simple_file, "// Invex Gaming");
  WriteFileLine(admin_simple_file, "// ServerID: %d", ServerID);
  WriteFileLine(admin_simple_file, "// Auto generated at: %s", timebuffer);
  WriteFileLine(admin_simple_file, "");
  
  //temp variables
  char current_package_name[64];
  
  while (SQL_FetchRow(hndl)) {
    char package_name[64], package_description[255], tag[32], steamid[32], username[64]; 
    
    SQL_FetchString(hndl, 0, package_name, sizeof(package_name));
    SQL_FetchString(hndl, 1, package_description, sizeof(package_description));
    SQL_FetchString(hndl, 2, tag, sizeof(tag));
    SQL_FetchString(hndl, 3, steamid, sizeof(steamid));
    SQL_FetchString(hndl, 4, username, sizeof(username));
    int userid = SQL_FetchInt(hndl, 5);
    int transactionid = SQL_FetchInt(hndl, 6);
    
    //Copy package name for first package or if package names now differ
    if ((strlen(current_package_name) == 0) || (!StrEqual(current_package_name, package_name))) {
      strcopy(current_package_name, sizeof(current_package_name), package_name);
      
      //Write header to file
      WriteFileLine(admin_simple_file, "");
      WriteFileLine(admin_simple_file, "// %s (%s)", package_name, tag);
      WriteFileLine(admin_simple_file, "// Desc: %s", package_description);
    }
    
    WriteFileLine(admin_simple_file, "\"%s\" \"%s\" // %s(%d), #%d", steamid, tag, username, userid, transactionid);
  }
  
  CloseHandle(admin_simple_file);
  
  //Finally, refresh sourcemod admin cache via sm_reloadadmins
  ServerCommand("sm_reloadadmins");
}

#ifndef AppChannel
  #define AppChannel "stable"
#endif
#ifndef AppVersion
  #define AppVersion "1.0.0"
#endif

#if AppChannel == "beta"
  #define MyAppName "Tabaro3 Sétif (Beta)"
  #define MyAppId "{{9B4F2C81-6E1A-4D3B-9C12-BETA00CWTS19}"
  #define MyDirName "Tabaro3SetifBeta"
  #define MyInstallerBase "Tabaro3_Setif_Beta_Setup_v" + AppVersion
#else
  #define MyAppName "Tabaro3 Sétif"
  #define MyAppId "{{8A3E1B70-5D09-4C2A-8B01-STABLECWTS19}"
  #define MyDirName "Tabaro3Setif"
  #define MyInstallerBase "Tabaro3_Setif_Setup_v" + AppVersion
#endif

[Setup]
AppId={#MyAppId}
AppName={#MyAppName}
AppVersion={#AppVersion}
AppPublisher=CWTS Sétif
DefaultDirName={autopf}\{#MyDirName}
DefaultGroupName={#MyAppName}
PrivilegesRequired=lowest
OutputDir=..\build\installer
OutputBaseFilename={#MyInstallerBase}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
; Never touch %APPDATA%\CWTS_Setif donor data on uninstall/upgrade
UninstallFilesDir={app}

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "arabic"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\tabaro3_setif.exe"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\tabaro3_setif.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\tabaro3_setif.exe"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Only remove install dir contents; %APPDATA% donor DB/photos/backups are preserved.
Type: filesandordirs; Name: "{app}"

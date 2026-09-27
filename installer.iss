; Prezzo Artigiano FIX11
#define MyAppName "Prezzo Artigiano"
#define MyAppVersion "1.0.5"
#define MyAppPublisher "Prezzo Artigiano"
#define MyAppExeName "prezzo_artigiano.exe"

[Setup]
AppId={{A7B5D0A4-2D2D-4B8E-9D70-6D5D1C2A4B21}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf64}\Prezzo Artigiano
DefaultGroupName={#MyAppName}
OutputDir=installer_output
OutputBaseFilename=Prezzo-Artigiano-Setup-FIX11
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
UninstallDisplayIcon={app}\{#MyAppExeName}
DisableProgramGroupPage=yes

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "Avvia-Prezzo-Artigiano-Diagnostica.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\Diagnostica avvio"; Filename: "{app}\Avvia-Prezzo-Artigiano-Diagnostica.bat"

[Run]
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installazione Microsoft Visual C++ Runtime..."; Flags: waituntilterminated
Filename: "{app}\{#MyAppExeName}"; Description: "Avvia {#MyAppName}"; Flags: nowait postinstall skipifsilent

; Prezzo Artigiano - Inno Setup
#define MyAppName "Prezzo Artigiano"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Prezzo Artigiano"
#define MyAppExeName "prezzo_artigiano.exe"

[Setup]
AppId={{A7B5D0A4-2D2D-4B8E-9D70-6D5D1C2A4B21}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\Prezzo Artigiano
DefaultGroupName={#MyAppName}
OutputDir=installer_output
OutputBaseFilename=Prezzo-Artigiano-Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#MyAppExeName}

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Avvia {#MyAppName}"; Flags: nowait postinstall skipifsilent

; Fichier Inno Setup Script pour l'application Flutter Windows "FScore"

[Setup]
AppName=FScore
AppVersion=1.0.0
DefaultDirName={autopf}\FScore
DefaultGroupName=FScore
UninstallDisplayIcon={app}\Runner.exe
OutputBaseFilename=FScoreSetup
Compression=lzma
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{group}\FScore"; Filename: "{app}\Runner.exe"; WorkingDir: "{app}"
Name: "{userdesktop}\FScore"; Filename: "{app}\Runner.exe"; WorkingDir: "{app}"

[Run]
Filename: "{app}\Runner.exe"; Description: "{cm:LaunchProgram,FScore}"; Flags: nowait postinstall skipifsilent

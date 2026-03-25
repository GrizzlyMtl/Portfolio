[Setup]
AppName=TP Projet Mix
AppVersion=1.0.0
DefaultDirName={autopf}\TP Projet Mix
DefaultGroupName=TP Projet Mix
OutputDir=C:\Dev\flutter_basics\installer
OutputBaseFilename=TP_Projet_Mix_Setup
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Flags: unchecked

[Files]
Source: "C:\Dev\flutter_basics\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\TP Projet Mix"; Filename: "{app}\flutter_basics.exe"
Name: "{commondesktop}\TP Projet Mix"; Filename: "{app}\flutter_basics.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\flutter_basics.exe"; Description: "Launch TP Projet Mix"; Flags: nowait postinstall skipifsilent
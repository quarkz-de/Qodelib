unit Qodelib.IOUtils;

interface

type
  TKnownFolders = record
  private
    class function GetShellFolder(const FolderId: Integer): String; static;
  public
    class function GetAppDataPath: String; static;
    class function GetCommonAppDataPath: String; static;
    class function GetProgramsPath: String; static;
  end;

implementation

uses
  Winapi.Windows, Winapi.SHFolder;

{$REGION 'TKnownFolders'}

class function TKnownFolders.GetShellFolder(const FolderId: Integer): String;
var
  LStr: array[0 .. MAX_PATH] of Char;
begin
  SetLastError(ERROR_SUCCESS);

  if SHGetFolderPath(0, FolderId, 0, 0, @LStr) = S_OK then
    Result := LStr
  else
    Result := '';
end;

class function TKnownFolders.GetAppDataPath: String;
begin
  Result := GetShellFolder(CSIDL_APPDATA);
end;

class function TKnownFolders.GetCommonAppDataPath: String;
begin
  Result := GetShellFolder(CSIDL_COMMON_APPDATA);
end;

class function TKnownFolders.GetProgramsPath: String;
begin
  Result := GetShellFolder(CSIDL_PROGRAM_FILES);
end;
  
{$ENDREGION}

end.
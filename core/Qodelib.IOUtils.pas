unit Qodelib.IOUtils;

interface

uses
  System.Types, System.IOUtils, System.StrUtils, System.Masks;

type
  TKnownFolders = record
  private
    class function GetShellFolder(const FolderId: Integer): String; static;
  public
    class function GetAppDataPath: String; static;
    class function GetCommonAppDataPath: String; static;
    class function GetProgramsPath: String; static;
  end;

  TFilenameHelper = record
  public
    class function CleanupFilename(const AFilename: String): String; static;
  end;

  TDirectoryHelper = record
  public
    class function GetFiles(const APath, AMasks: String): TStringDynArray; static;
  end;

implementation

uses
  System.SysUtils,
  Winapi.Windows, Winapi.ShlObj, Winapi.SHFolder;

{ TKnownFolders }

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
  
{ TFilenameHelper }

class function TFilenameHelper.CleanupFilename(const AFilename: String): String;
var
  Path: array[0..MAX_PATH] of WideChar;
begin
  StrPCopy(Path, AFilename);
  case PathCleanupSpec(nil, Path) of
    PCS_REPLACEDCHAR, PCS_REMOVEDCHAR, PCS_TRUNCATED:
      Result := WideString(Path);
    else
      Result := AFilename;
  end;
end;

{ TDirectoryHelper }

class function TDirectoryHelper.GetFiles(const APath,
  AMasks: String): TStringDynArray;
var
  VMaskArray: TStringDynArray;
  VPredicate: TDirectory.TFilterPredicate;
begin
  VMaskArray := SplitString(AMasks, ';');
  VPredicate :=
    function(const APath: string; const ASearchRec: TSearchRec): Boolean
    var
      VMask: string;
    begin
      for VMask in VMaskArray do
        if MatchesMask(ASearchRec.Name, VMask) then
          Exit(True);
      Exit(False);
    end;
  Result := TDirectory.GetFiles(APath, TSearchOption.soTopDirectoryOnly,
    VPredicate);
end;

end.
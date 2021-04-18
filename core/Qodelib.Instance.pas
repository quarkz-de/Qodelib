unit Qodelib.Instance;

interface

uses
  System.SysUtils, Winapi.Windows;

function CheckSingleInstance(const AId: String): Boolean;

implementation

type
  ISingleInstance = interface
    ['{20DF9827-A50C-4FA4-B252-6E88B90D4B83}']
    function CheckSingleInstance(const AId: String): Boolean;
  end;

  TSingleInstance = class(TInterfacedObject, ISingleInstance)
  private
    MutexHandle: THandle;
  public
    constructor Create;
    destructor Destroy; override;
    function CheckSingleInstance(const AId: String): Boolean;
  end;

var
  SingleInstance: ISingleInstance;

{ TSingleInstance }

function TSingleInstance.CheckSingleInstance(const AId: String): Boolean;
begin
  MutexHandle := CreateMutex(nil, True, PChar(AId));

  if MutexHandle = 0 then
    RaiseLastOSError;

  Result := GetLastError <> ERROR_ALREADY_EXISTS;
end;

constructor TSingleInstance.Create;
begin
  MutexHandle := 0;
end;

destructor TSingleInstance.Destroy;
begin
  if MutexHandle <> 0 then
    ReleaseMutex(MutexHandle);
  inherited;
end;

function CheckSingleInstance(const AId: String): Boolean;
begin
  if not Assigned(SingleInstance) then
    SingleInstance := TSingleInstance.Create;

  Result := SingleInstance.CheckSingleInstance(AId);
end;

initialization
  SingleInstance := nil;

finalization
  SingleInstance := nil;

end.
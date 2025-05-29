unit Qodelib.ManagedForms;

interface

uses
  System.Classes, System.Generics.Collections, System.Generics.Defaults,
  Vcl.Forms, Vcl.Controls,
  Qodelib.Forms;

type
  TQzManagedFormId = Integer;

  TQzManagedForm = class;
  TQzManagedFormClass = class of TQzManagedForm;

  TQzActiveFormChangedEvent = procedure (ActiveForm: TQzManagedForm) of object;

  TQzManagedFormList = class
  private
    FContainer: TWinControl;
    FForms: TDictionary<TQzManagedFormId, TQzManagedForm>;
    FOnActiveFormChanged: TQzActiveFormChangedEvent;
    function GetActiveForm: TQzManagedForm;
  protected
    procedure ActiveFormChanged(const AForm: TQzManagedForm);
  public
    constructor Create;
    destructor Destroy; override;
    function AddForm(const AFormClass: TQzManagedFormClass): TQzManagedForm;
    function GetForm(const AFormId: TQzManagedFormId): TQzManagedForm;
    function ShowForm(const AFormId: TQzManagedFormId): TQzManagedForm;
    procedure FontChanged;
    procedure ThemeChanged;
    property ActiveForm: TQzManagedForm read GetActiveForm;
    property Container: TWinControl read FContainer write FContainer;
    property OnActiveFormChanged: TQzActiveFormChangedEvent
      read FOnActiveFormChanged write FOnActiveFormChanged;
  end;

  TQzManagedForm = class(TQzForm)
  private
    FManagedForms: TQzManagedFormList;
    procedure ActiveFormChangedEvent(ActiveForm: TQzManagedForm);
  protected
    function GetFormId: TQzManagedFormId; virtual; abstract;
    function GetImageIndex: Integer; virtual;
    procedure FontChanged; virtual;
    procedure ThemeChanged; virtual;
    procedure ActiveFormChanged(ActiveForm: TQzManagedForm); virtual;
    procedure RegisterForms; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property FormId: TQzManagedFormId read GetFormId;
    property ImageIndex: Integer read GetImageIndex;
    property ManagedForms: TQzManagedFormList read FManagedForms;
  end;

implementation

{ TQzManagedForm }

procedure TQzManagedForm.ActiveFormChanged(ActiveForm: TQzManagedForm);
begin

end;

procedure TQzManagedForm.ActiveFormChangedEvent(ActiveForm: TQzManagedForm);
begin
  ActiveFormChanged(ActiveForm);
end;

constructor TQzManagedForm.Create(AOwner: TComponent);
begin
  inherited;

  FManagedForms := TQzManagedFormList.Create;
  FManagedForms.OnActiveFormChanged := ActiveFormChangedEvent;

  RegisterForms;
end;

destructor TQzManagedForm.Destroy;
begin
  FManagedForms.Free;
  inherited;
end;

procedure TQzManagedForm.FontChanged;
begin
  ManagedForms.FontChanged;
end;

function TQzManagedForm.GetImageIndex: Integer;
begin
  Result := -1;
end;

procedure TQzManagedForm.RegisterForms;
begin

end;

procedure TQzManagedForm.ThemeChanged;
begin
  ManagedForms.ThemeChanged;
end;

{ TQzManagedFormList }

procedure TQzManagedFormList.ActiveFormChanged(const AForm: TQzManagedForm);
begin
  if Assigned(FOnActiveFormChanged) then
    FOnActiveFormChanged(AForm);
end;

function TQzManagedFormList.AddForm(
  const AFormClass: TQzManagedFormClass): TQzManagedForm;
begin
  Result := AFormClass.Create(Container);
  Result.Parent := Container;
  Result.Align := alClient;
  Result.Visible := false;
  FForms.Add(Result.FormId, Result);
end;

constructor TQzManagedFormList.Create;
begin
  FContainer := nil;
  FForms := TDictionary<TQzManagedFormId, TQzManagedForm>.Create;
end;

destructor TQzManagedFormList.Destroy;
begin
  FForms.Free;
  inherited;
end;

procedure TQzManagedFormList.FontChanged;
var
  Form: TQzManagedForm;
begin
  for Form in FForms.Values do
    Form.FontChanged;
end;

function TQzManagedFormList.GetActiveForm: TQzManagedForm;
var
  Form, SubForm: TQzManagedForm;
begin
  Result := nil;
  for Form in FForms.Values do
    if (Form <> nil) and (Form.Visible) then
      begin
        Result := Form;
        SubForm := Form.ManagedForms.ActiveForm;
        if SubForm <> nil then
          Result := SubForm;

        Break;
      end;
end;

function TQzManagedFormList.GetForm(
  const AFormId: TQzManagedFormId): TQzManagedForm;
var
  Form: TQzManagedForm;
begin
  Result := nil;
  for Form in FForms.Values do
    if Form.FormId = AFormId then
      begin
        Result := Form;
        Break;
      end;
end;

function TQzManagedFormList.ShowForm(const AFormId: TQzManagedFormId): TQzManagedForm;
var
  Form: TQzManagedForm;
begin
  Result := nil;
  for Form in FForms.Values do
    begin
      if (Form.FormId = AFormId) then
        begin
          Form.Visible := true;
          Form.Activate;
          ActiveFormChanged(Form);
          Result := Form;
        end
      else if Form.Visible then
        begin
          Form.Deactivate;
          Form.Visible := false;
        end;
    end;
end;

procedure TQzManagedFormList.ThemeChanged;
var
  Form: TQzManagedForm;
begin
  for Form in FForms.Values do
    Form.ThemeChanged;
end;

end.
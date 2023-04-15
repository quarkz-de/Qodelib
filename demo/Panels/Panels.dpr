program Panels;

uses
  Vcl.Forms,
  Panels.Main in 'Panels.Main.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 Modern Light');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

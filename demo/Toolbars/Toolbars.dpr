program Toolbars;

uses
  Vcl.Forms,
  Toolbars.Main in 'Toolbars.Main.pas' {Form1},
  Qodelib.NavigationView in '..\..\vcl\Qodelib.NavigationView.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

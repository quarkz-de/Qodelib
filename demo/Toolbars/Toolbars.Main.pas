unit Toolbars.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.ImageList,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.ImgList,
  Vcl.VirtualImageList,
  Qodelib.NavigationView, Vcl.ExtCtrls, Vcl.WinXCtrls, Vcl.VirtualImage;

type
  TForm1 = class(TForm)
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    SplitView1: TSplitView;
    Panel1: TPanel;
    imBurgerButton: TVirtualImage;
    QzNavigationView2: TQzNavigationView;
    QzNavigationView1: TQzNavigationView;
    procedure imBurgerButtonClick(Sender: TObject);
    procedure QzNavigationView1ButtonClicked(Sender: TObject; Index: Integer);
    procedure QzNavigationView2ButtonClicked(Sender: TObject; Index: Integer);
    procedure SplitView1Closed(Sender: TObject);
    procedure SplitView1Opened(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.imBurgerButtonClick(Sender: TObject);
begin
  SplitView1.Opened := not SplitView1.Opened;
end;

procedure TForm1.QzNavigationView1ButtonClicked(Sender: TObject; Index:
    Integer);
begin
  QzNavigationView2.ItemIndex := -1;
end;

procedure TForm1.QzNavigationView2ButtonClicked(Sender: TObject; Index:
    Integer);
begin
  QzNavigationView1.ItemIndex := -1;
end;

procedure TForm1.SplitView1Closed(Sender: TObject);
begin
  QzNavigationView1.ButtonOptions := QzNavigationView1.ButtonOptions - [nboShowCaptions];
  QzNavigationView2.ButtonOptions := QzNavigationView2.ButtonOptions - [nboShowCaptions];
end;

procedure TForm1.SplitView1Opened(Sender: TObject);
begin
  QzNavigationView1.ButtonOptions := QzNavigationView1.ButtonOptions + [nboShowCaptions];
  QzNavigationView2.ButtonOptions := QzNavigationView2.ButtonOptions + [nboShowCaptions];
end;

end.

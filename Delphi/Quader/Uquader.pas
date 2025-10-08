unit Uquader;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TQuaderberchnung = class(TForm)
    LabelSideA: TLabel;
    LabelSideB: TLabel;
    LabelSideC: TLabel;
    LabelVolume: TLabel;
    LabelSurface: TLabel;
    LabelSideCube: TLabel;
    EditSideA: TEdit;
    EditSideB: TEdit;
    EditSideC: TEdit;
    EditVolume: TEdit;
    EditSurface: TEdit;
    EditSideCube: TEdit;
    ButtonCalculate: TButton;
    ButtonEnd: TButton;
    procedure ButtonEndClick(Sender: TObject);
    procedure ButtonCalculateClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Quaderberchnung: TQuaderberchnung;

implementation

{$R *.dfm}

procedure TQuaderberchnung.ButtonCalculateClick(Sender: TObject);
var a, b, c :real;
begin

end;

procedure TQuaderberchnung.ButtonEndClick(Sender: TObject);
begin
close;
end;

end.

program Rechner;

uses
  Vcl.Forms,
  URechner in 'URechner.pas' {aa};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Taa, aa);
  Application.Run;
end.

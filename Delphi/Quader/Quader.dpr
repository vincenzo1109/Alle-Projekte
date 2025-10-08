program Quader;

uses
  Vcl.Forms,
  Uquader in 'Uquader.pas' {Quaderberchnung};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TQuaderberchnung, Quaderberchnung);
  Application.Run;
end.

program dbtrprnpDXE7;

uses
  Forms,
  main in 'main.pas' {FMain},
  dbtreeqr in 'dbtreeqr.pas' {QRListForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TQRListForm, QRListForm);
  Application.Run;
end.

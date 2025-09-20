program WorldTimeD102Tokyo;

uses
  Forms,
  uWorldTime in 'uWorldTime.pas' {frmWorldTime};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'World Time';
  Application.CreateForm(TfrmWorldTime, frmWorldTime);
  Application.Run;
end.

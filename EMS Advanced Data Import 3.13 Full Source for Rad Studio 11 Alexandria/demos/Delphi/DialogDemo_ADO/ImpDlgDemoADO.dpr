program ImpDlgDemoADO;

uses
  Forms,
  ImpDlgADO in 'ImpDlgADO.pas' {fImpDlgADO};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TImpDlgADO, fImpDlgADO);
  Application.Run;
end.

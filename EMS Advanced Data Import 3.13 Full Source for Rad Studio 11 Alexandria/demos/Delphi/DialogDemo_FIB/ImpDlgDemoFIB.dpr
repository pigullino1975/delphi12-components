program ImpDlgDemoFIB;

uses
  Forms,
  ImpDlgFIBF in 'ImpDlgFIBF.pas' {fmImpDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmImpDlg, fmImpDlg);
  Application.Run;
end.

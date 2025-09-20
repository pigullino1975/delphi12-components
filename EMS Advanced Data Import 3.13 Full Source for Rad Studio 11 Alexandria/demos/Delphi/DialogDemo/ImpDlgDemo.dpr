program ImpDlgDemo;

uses
  Forms,
  ImpDlgF in 'ImpDlgF.pas' {fmImpDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmImpDlg, fmImpDlg);
  Application.Run;
end.

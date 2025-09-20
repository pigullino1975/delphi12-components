program ImpDlgDemoIBX;

uses
  Forms,
  ImpDlgIBXF in 'ImpDlgIBXF.pas' {fmImpDlgIBX};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmImpDlgIBX, fmImpDlgIBX);
  Application.Run;
end.

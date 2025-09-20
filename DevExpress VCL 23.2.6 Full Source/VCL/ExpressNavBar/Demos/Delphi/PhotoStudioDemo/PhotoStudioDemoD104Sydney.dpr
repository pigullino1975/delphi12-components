program PhotoStudioDemoD104Sydney;

uses
  Forms,
  PhotoStudioMain in 'PhotoStudioMain.pas' {frmMain};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

program DesktopDemoD102Tokyo;

uses
  Forms,
  DesktopDemoMain in 'DesktopDemoMain.pas' {DesktopDemoMainForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDesktopDemoMainForm, DesktopDemoMainForm);
  Application.Run;
end.

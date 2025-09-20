program DesktopDemo;

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

uses
  SysUtils,
  Forms,
  Dialogs,
  cxLookAndFeels,
  dxDirectX.D2D.Types,
  DesktopDemoLauncher in 'DesktopDemoLauncher.pas',
  DesktopDemoMain in 'DesktopDemoMain.pas' {DesktopDemoMainForm},
  DesktopDemoData in 'DesktopDemoData.pas' {dmData: TDataModule};

{$R *.res}
{$R ..\Common\dxDPIAwareManifestPM2.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmData, dmData);
  if TfmDemoLauncher.Execute then
    Application.CreateForm(TDesktopDemoMainForm, DesktopDemoMainForm);
  Application.Run;
end.

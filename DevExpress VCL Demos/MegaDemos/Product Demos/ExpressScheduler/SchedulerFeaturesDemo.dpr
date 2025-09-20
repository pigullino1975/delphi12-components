program SchedulerFeaturesDemo;

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

uses
  Forms,
  Windows,
  Classes,
  SysUtils,
  Registry,
  dxProgress in 'dxProgress.pas' {frmProgress},
  dxCustomEditor in 'dxCustomEditor.pas' {cxSchedulerEventCustomEditor},
  SelectStorageUnit in 'SelectStorageUnit.pas' {SelectStorage},
  dxDemoUtils in '..\Common\dxDemoUtils.pas',
  dxAboutDemo in '..\Common\dxAboutDemo.pas' {dxAboutDemoForm},
  dxExportProgressDialog in '..\Common\dxExportProgressDialog.pas',
  dxDemoBaseMainForm in '..\Common\dxDemoBaseMainForm.pas' {frmMainBase},
  dxDemoObjectInspector in '..\Common\dxDemoObjectInspector.pas' {frmInspector},
  dxDemoPrintFrame in '..\Common\dxDemoPrintFrame.pas' {frmPrinting: TFrame},
  Main in 'Main.pas' {frmMain},
  WebServiceDemoSetupForm in 'WebServiceDemoSetupForm.pas' {WebServiceDemoSetupWizard};

{$R *.res}
{$R ..\Common\dxDPIAwareManifestPM2.res}

begin
  if not HasJet then
  begin
    MessageBox(0, PChar(ThereIsNoMDACMessage), nil, MB_ICONERROR);
    Halt;
  end;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressScheduler Features Demo';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

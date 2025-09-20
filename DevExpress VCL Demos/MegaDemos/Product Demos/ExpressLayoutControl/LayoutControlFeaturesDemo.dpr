program LayoutControlFeaturesDemo;

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

uses
  Forms,
  cxFilter,
  AboutDemoForm in 'AboutDemoForm.pas' {frmAboutDemoForm},
  cxEditorsDemoMain in 'cxEditorsDemoMain.pas' {frmEditorsDemoMain},
  dxDemoUtils in '..\Common\dxDemoUtils.pas',
  dxAboutDemo in '..\Common\dxAboutDemo.pas' {dxAboutDemoForm};

{$R *.res}
{$R ..\Common\dxDPIAwareManifestPM2.res}

begin
  cxFilter.dxFilterCriteriaDisplayStyle := fcdsTokens;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressLayout Control';
  Application.CreateForm(TfrmEditorsDemoMain, frmEditorsDemoMain);
  Application.Run;
end.

program LocalizationDemo;

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

uses
  Forms,
  cxFilter,
  LocalizationDemoMain in 'LocalizationDemoMain.pas' {Form1},
  LocalizationDemoRes in 'LocalizationDemoRes.pas',
  dxDemoUtils in '..\Common\dxDemoUtils.pas',
  dxAboutDemo in '..\Common\dxAboutDemo.pas' {dxAboutDemoForm};

{$R *.res}
{$R ..\Common\dxDPIAwareManifestPM2.res}

begin
  cxFilter.dxFilterCriteriaDisplayStyle := fcdsTokens;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

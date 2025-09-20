program StandardReportLinkDXE7;

uses
  Forms,
  StandardRLMain in 'StandardRLMain.pas' {StandardRLMainForm},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Title := 'Report Links Demo - Standard Components';
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TStandardRLMainForm, StandardRLMainForm);
  Application.Run;
end.

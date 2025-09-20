program WebServiceDemoD104Sydney;

uses
  Forms,
  WebServiceDemoMain in 'WebServiceDemoMain.pas' {WebServiceDemoMainForm},
  DemoUtils in '..\Common\DemoUtils.pas',
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {DemoBasicMainForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas',
  WebServiceDemoSetupForm in 'WebServiceDemoSetupForm.pas' {WebServiceDemoSetupWizard};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressScheduler WebServiceDemoD104Sydney';
  Application.CreateForm(TWebServiceDemoMainForm, WebServiceDemoMainForm);
  Application.Run;
end.

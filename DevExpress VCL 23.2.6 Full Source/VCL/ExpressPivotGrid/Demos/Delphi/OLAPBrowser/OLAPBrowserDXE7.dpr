program OLAPBrowserDXE7;

uses
  Forms,
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {frmDemoBasicMain},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  OLAPBrowserMain in 'OLAPBrowserMain.pas' {frmOlapBrowser},
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmOlapBrowser, frmOlapBrowser);
  Application.Run;
end.

program UnboundExternalDemoDXE7;

uses
  Forms,
  DemoBasicMain in '..\Common\DemoBasicMain.pas' {frmDemoBasicMain},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  UnboundExternalMain in 'UnboundExternalMain.pas' {frmUnboundExternal},
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmUnboundExternal, frmUnboundExternal);
  Application.Run;
end.

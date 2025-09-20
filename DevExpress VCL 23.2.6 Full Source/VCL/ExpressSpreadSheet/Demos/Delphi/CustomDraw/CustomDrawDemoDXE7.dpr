program CustomDrawDemoDXE7;

uses
  Forms,
  CustomDrawDemoMain in 'CustomDrawDemoMain.pas' {frmCustomDraw},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\Common\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCustomDraw, frmCustomDraw);
  Application.Run;
end.

program CustomFunctionDemoD102Tokyo;

uses
  Forms,
  CustomFunctionDemoMain in 'CustomFunctionDemoMain.pas' {frmCustomDraw},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\Common\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCustomFunction, frmCustomFunction);
  Application.Run;
end.

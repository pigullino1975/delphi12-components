program TokenEditDemoD102Tokyo;

uses
  Forms,
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  DemoUtils in '..\DemoUtils.pas',
  TokenEditDemoMain in 'TokenEditDemoMain.pas' {dxTokenEditDemoForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdxTokenEditDemoForm, dxTokenEditDemoForm);
  Application.Run;
end.

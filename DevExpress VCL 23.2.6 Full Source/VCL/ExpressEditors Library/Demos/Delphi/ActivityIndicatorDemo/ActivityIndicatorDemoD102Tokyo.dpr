program ActivityIndicatorDemoD102Tokyo;

uses
  Forms,
  BaseForm in '..\BaseForm.pas',
  DemoUtils in '..\DemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas',
  ActivityIndicatorDemoMain in 'ActivityIndicatorDemoMain.pas' {dxActivityIndicatorDemoForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdxActivityIndicatorDemoForm, dxActivityIndicatorDemoForm);
  Application.Run;
end.

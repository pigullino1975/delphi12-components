program BarCodeDemoD104Sydney;

uses
  Forms,
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  DemoUtils in '..\DemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas',
  BarCodeDemoMain in 'BarCodeDemoMain.pas' {dxBarCodeDemoForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdxBarCodeDemoForm, dxBarCodeDemoForm);
  Application.Run;
end.

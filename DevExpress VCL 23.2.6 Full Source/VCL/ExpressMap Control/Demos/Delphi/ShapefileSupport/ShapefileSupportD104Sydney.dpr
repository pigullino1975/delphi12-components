program ShapefileSupportD104Sydney;

uses
  Forms,
  BasicDemoMain in '..\Common\BasicDemoMain.pas' {frmBasicDemoMain},
  DemoUtils in '..\Common\DemoUtils.pas',
  SkinDemoUtils in '..\Common\SkinDemoUtils.pas',
  ShapefileSupportDemoMain in 'ShapefileSupportDemoMain.pas' {ShapefileSupportDemoMainForm};

  {$R *.res}

begin
  Application.Title := 'Shapefile Support';
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TShapefileSupportDemoMainForm, ShapefileSupportDemoMainForm);
  Application.Run;
end.

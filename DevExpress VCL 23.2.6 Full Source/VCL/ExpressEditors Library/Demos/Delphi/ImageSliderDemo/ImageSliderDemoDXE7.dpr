program ImageSliderDemoDXE7;

uses
  Forms,
  ImageSliderDemoMain in 'ImageSliderDemoMain.pas' {frmImageSlider},
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  DemoUtils in '..\DemoUtils.pas',
  BaseForm in '..\BaseForm.pas' {fmBaseForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressEditors ImageSlider Demo';
  Application.CreateForm(TfrmImageSlider, frmImageSlider);
  Application.Run;
end.

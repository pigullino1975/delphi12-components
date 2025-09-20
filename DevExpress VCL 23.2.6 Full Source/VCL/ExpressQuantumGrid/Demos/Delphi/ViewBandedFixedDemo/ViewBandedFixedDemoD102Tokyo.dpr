program ViewBandedFixedDemoD102Tokyo;

uses
  Forms,
  ViewBandedFixedMain in 'ViewBandedFixedMain.pas' {ViewBandedFixedDemoMainForm},
  ViewBandedFixedMainData in 'ViewBandedFixedMainData.pas' {ViewBandedFixedDemoDMMain: TDataModule},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid ViewBandedFixed Demo';
  Application.CreateForm(TViewBandedFixedDemoMainForm, ViewBandedFixedDemoMainForm);
  Application.CreateForm(TViewBandedFixedDemoDMMain, ViewBandedFixedDemoDMMain);
  Application.Run;
end.

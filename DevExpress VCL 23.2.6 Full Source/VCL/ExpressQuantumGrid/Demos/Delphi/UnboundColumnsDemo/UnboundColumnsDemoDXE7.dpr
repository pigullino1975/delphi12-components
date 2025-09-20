program UnboundColumnsDemoDXE7;

uses
  Forms,
  UnboundColumnsDemoMain in 'UnboundColumnsDemoMain.pas' {UnboundColumnsDemoMainForm},
  UnboundColumnsDemoData in 'UnboundColumnsDemoData.pas' {UnboundColumnsDemoDataDM: TDataModule},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid UnboundColumns Demo';
  Application.CreateForm(TUnboundColumnsDemoDataDM, UnboundColumnsDemoDataDM);
  Application.CreateForm(TUnboundColumnsDemoMainForm, UnboundColumnsDemoMainForm);
  Application.Run;
end.

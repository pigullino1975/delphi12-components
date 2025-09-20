program UnboundSimpleDemoD104Sydney;

uses
  Forms,
  UnboundSimpleDemoMain in 'UnboundSimpleDemoMain.pas' {UnboundSimpleDemoMainForm},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid UnboundSimple Demo';
  Application.CreateForm(TUnboundSimpleDemoMainForm, UnboundSimpleDemoMainForm);
  Application.Run;
end.

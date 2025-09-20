program ViewTableSimpleDemoD102Tokyo;

uses
  Forms,
  ViewTableSimpleDemoMain in 'ViewTableSimpleDemoMain.pas' {ViewTableSimpleDemoMainForm},
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  ViewTableSimpleDemoData in 'ViewTableSimpleDemoData.pas' {ViewTableSimpleDemoMainDM: TDataModule};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid ViewTableSimple Demo';
  Application.CreateForm(TViewTableSimpleDemoMainForm, ViewTableSimpleDemoMainForm);
  Application.CreateForm(TViewTableSimpleDemoMainDM, ViewTableSimpleDemoMainDM);
  Application.Run;
end.

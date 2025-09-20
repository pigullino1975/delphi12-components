program CellLevelMultiselectDemoD102Tokyo;

uses
  Forms,
  CellLevelMultiselectDemoMain in 'CellLevelMultiselectDemoMain.pas' {CellLevelMultiselectDemoMainForm},
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  BaseForm in '..\BaseForm.pas' {fmBaseForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid CellLevelMultiselect Demo';
  Application.CreateForm(TCellLevelMultiselectDemoMainForm, CellLevelMultiselectDemoMainForm);
  Application.Run;
end.

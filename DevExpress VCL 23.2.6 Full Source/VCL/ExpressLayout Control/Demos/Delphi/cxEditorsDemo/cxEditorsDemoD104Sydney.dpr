program cxEditorsDemoD104Sydney;

uses
  Forms,
  DemoDM in '..\common\DemoDM.pas' {dmDemo: TDataModule},
  BasicDemoMain in '..\common\BasicDemoMain.pas' {frmBasicDemoMain},
  AboutDemoForm in '..\common\AboutDemoForm.pas' {frmAboutDemoForm},
  cxEditorsDemoMain in 'cxEditorsDemoMain.pas' {frmEditorsDemoMain};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmDemo, dmDemo);
  Application.CreateForm(TfrmEditorsDemoMain, frmEditorsDemoMain);
  Application.Run;
end.

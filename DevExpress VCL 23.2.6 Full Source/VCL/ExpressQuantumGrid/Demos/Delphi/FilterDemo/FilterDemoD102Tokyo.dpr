program FilterDemoD102Tokyo;

uses
  Forms,
  FilterDemoMain in 'FilterDemoMain.pas' {frmMain},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid Filter Demo';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

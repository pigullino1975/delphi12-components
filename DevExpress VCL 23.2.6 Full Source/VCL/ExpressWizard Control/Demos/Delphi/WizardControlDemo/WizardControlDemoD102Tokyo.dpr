program WizardControlDemoD102Tokyo;

uses
  Forms,
  WizardControlDemoMainForm in 'WizardControlDemoMainForm.pas' {frmWizardControlDemoMain},
  WizardControlDemoSetupForm in 'WizardControlDemoSetupForm.pas' {frmWizardControlDemoSetup};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmWizardControlDemoMain, frmWizardControlDemoMain);
  Application.Run;
end.

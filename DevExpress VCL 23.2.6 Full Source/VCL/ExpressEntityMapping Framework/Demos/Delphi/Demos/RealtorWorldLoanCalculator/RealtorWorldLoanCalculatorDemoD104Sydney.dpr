program RealtorWorldLoanCalculatorDemoD104Sydney;

uses
  Forms,
  RealtorWorldLoanCalculator in 'RealtorWorldLoanCalculator.pas' {frmLoanCalculator},
  RealtorWorld.LoanCalculator in '..\Common\RealtorWorld.LoanCalculator.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLoanCalculator, frmLoanCalculator);
  Application.Run;
end.

program FilterByCodeDemoDXE7;

uses
  Forms,
  FilterByCodeDemoMain in 'FilterByCodeDemoMain.pas' {FilterByCodeDemoMainForm},
  FilterByCodeDemoData in 'FilterByCodeDemoData.pas' {FilterByCodeDemoMainDM: TDataModule},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid FilterByCode Demo';
  Application.CreateForm(TFilterByCodeDemoMainForm, FilterByCodeDemoMainForm);
  Application.CreateForm(TFilterByCodeDemoMainDM, FilterByCodeDemoMainDM);
  Application.Run;
end.

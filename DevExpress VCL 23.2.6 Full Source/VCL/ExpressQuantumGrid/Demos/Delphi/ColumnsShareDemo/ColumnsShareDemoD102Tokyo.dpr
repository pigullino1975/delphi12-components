program ColumnsShareDemoD102Tokyo;

uses
  Forms,
  ColumnsShareDemoMain in 'ColumnsShareDemoMain.pas' {ColumnsShareDemoMainForm},
  ColumnsShareDemoData in 'ColumnsShareDemoData.pas' {ColumnsShareDemoMainDM: TDataModule},
  ColumnsShareDemoLookupCustomize in 'ColumnsShareDemoLookupCustomize.pas' {ColumnsShareDemoLookupCustomizeForm},
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
  BaseForm in '..\BaseForm.pas' {fmBaseForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid Columns Share Demo ';
  Application.CreateForm(TColumnsShareDemoMainForm, ColumnsShareDemoMainForm);
  Application.CreateForm(TColumnsShareDemoMainDM, ColumnsShareDemoMainDM);
  Application.Run;
end.

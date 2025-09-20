program ConditionalFormattingDemoDXE7;

{$I cxVer.inc}

uses
  Forms,
  ConditionalFormattingDemoMain in 'ConditionalFormattingDemoMain.pas' {ConditionalFormattingDemoMainForm},
  AboutDemoForm in '..\AboutDemoForm.pas' {formAboutDemo},
  BaseForm in '..\BaseForm.pas' {fmBaseForm},
  SkinDemoUtils in '..\SkinDemoUtils.pas',
{$IFDEF EXPRESSBARS}
  ConditionalFormattingDemoPopupMenuHelper in 'ConditionalFormattingDemoPopupMenuHelper.pas' {ConditionalFormattingPopupMenuHelper},
{$ENDIF}
  ConditionalFormattingDemoData in 'ConditionalFormattingDemoData.pas' {ConditionalFormattingDemoMainDM: TDataModule};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressQuantumGrid ConditionalFormatting Demo';
  Application.CreateForm(TConditionalFormattingDemoMainForm, ConditionalFormattingDemoMainForm);
  Application.CreateForm(TConditionalFormattingDemoMainDM, ConditionalFormattingDemoMainDM);
  Application.Run;
end.

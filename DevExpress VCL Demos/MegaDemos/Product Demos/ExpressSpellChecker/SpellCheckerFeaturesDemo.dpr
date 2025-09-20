program SpellCheckerFeaturesDemo;

{$SETPEOSVERSION 5.0}
{$SETPESUBSYSVERSION 5.0}

uses
  Forms,
  MegaDemoMain in 'MegaDemoMain.pas' {fmMain},
  AddDictionaryForm in 'AddDictionaryForm.pas' {fmAddDictionary},
  dxDemoUtils in '..\Common\dxDemoUtils.pas',
  dxAboutDemo in '..\Common\dxAboutDemo.pas' {dxAboutDemoForm};

{$R *.res}
{$R ..\Common\dxDPIAwareManifestPM2.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ExpressSpellChecker Features Demo';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmAddDictionary, fmAddDictionary);
  Application.Run;
end.

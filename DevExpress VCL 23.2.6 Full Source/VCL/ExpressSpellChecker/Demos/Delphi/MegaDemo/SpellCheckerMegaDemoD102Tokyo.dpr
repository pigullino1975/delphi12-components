program SpellCheckerMegaDemoD102Tokyo;

uses
  Forms,
  MegaDemoMain in 'MegaDemoMain.pas' {fmMain},
  AddDictionaryForm in 'AddDictionaryForm.pas' {fmAddDictionary},
  DemoUtils in '..\Common\DemoUtils.pas';

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmAddDictionary, fmAddDictionary);
  Application.Run;
end.

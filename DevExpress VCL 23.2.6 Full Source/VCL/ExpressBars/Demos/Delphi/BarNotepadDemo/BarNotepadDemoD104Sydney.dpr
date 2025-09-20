program BarNotepadDemoD104Sydney;

uses
  Forms,
  NotepadMainForm in '..\Common\NotepadMainForm.pas' {frmNotepadMain},
  NotepadChildForm in '..\Common\NotepadChildForm.pas' {frmNotepadChild},
  BarNotepadMainForm in 'BarNotepadMainForm.pas' {frmBarsNotepadMain},
  EBarsDemoRating in '..\Common\EBarsDemoRating.pas' {EBarsDemoRatingForm},
  EBarsUtils in '..\Common\EBarsUtils.pas' {dmCommonData},
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmCommonData, dmCommonData);
  Application.CreateForm(TfrmBarsNotepadMain, frmBarsNotepadMain);
  Application.Run;
end.

program NotesDemoDXE7;

uses
  Forms,
  AboutDemoForm in '..\Common\AboutDemoForm.pas' {formAboutDemo},
  EBarsUtils in '..\Common\EBarsUtils.pas' {dmCommonData: TDataModule},
  EBarsDemoRating in '..\Common\EBarsDemoRating.pas' {EBarsDemoRatingForm},
  NotepadChildForm in '..\Common\NotepadChildForm.pas' {frmNotepadChild},
  NotepadMainForm in '..\Common\NotepadMainForm.pas' {frmNotepadMain},
  NotesMainForm in 'NotesMainForm.pas' {fmNotesMainForm};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmCommonData, dmCommonData);
  Application.CreateForm(TfmNotesMainForm, fmNotesMainForm);
  Application.Run;
end.

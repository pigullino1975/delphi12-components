program PuzzleDemoDXE7;

uses
  Forms,
  Puzzle in 'Puzzle.pas' {frmPuzzle};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'PuzzleDemoDXE7';
  Application.CreateForm(TfrmPuzzle, frmPuzzle);
  Application.Run;
end.

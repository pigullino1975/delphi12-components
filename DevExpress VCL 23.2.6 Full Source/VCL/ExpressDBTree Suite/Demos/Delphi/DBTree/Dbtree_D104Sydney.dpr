program Dbtree_D104Sydney;

uses
  Forms,
  dbtree in 'dbtree.pas' {Form1},
  tree in 'tree.pas' {Form2},
  dbgridv in 'dbgridv.pas' {Form3};

  {$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

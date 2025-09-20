Unit QRDemo1;

{ Andy Preston, Apollo Developments, http://www.apollod.omnia.co.uk/aa/ }

{ Demo program for numbers as words Quick-Reports component }

{ Copyright (C) 1999  Andy Preston }

{ This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public }
{ License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later }
{ version. }

{ This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty }
{ of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. }

{ You should have received a copy of the GNU General Public License along with this program; if not, write to the }
{ Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA. }

Interface

Uses
  Classes, Controls, Forms, StdCtrls, DB, DBTables;

Type
  TMainForm=Class (TForm)
    DataTbl : TTable;
    Procedure FormShow (Sender : TObject);
  End;

Var
  MainForm : TMainForm;

Implementation

Uses
  QRDemo2;

{$R *.DFM}

Procedure TMainForm.FormShow (Sender : TObject);
Begin
  RepForm.Report.Preview;
  Close;
End;

End.
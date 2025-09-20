Unit demo1;

{ Andy Preston, Apollo Developments, http://www.apollod.omnia.co.uk/aa/ }

{ Demo program for numbers as words routines }

{ Copyright (C) 1999, 2000  Andy Preston }

{ This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public }
{ License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later }
{ version. }

{ This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty }
{ of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. }

{ You should have received a copy of the GNU General Public License along with this program; if not, write to the }
{ Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA. }

Interface

Uses
  Classes, Controls, Forms, StdCtrls, ExtCtrls;

Type
  TForm1 = Class (TForm)
    NumLbl : TGroupBox;
    NumBox : TEdit;
    NumBtn : TButton;
    CurrELbl : TGroupBox;
    CurEBox : TEdit;
    CurEBtn : TButton;
    CurrILbl : TGroupBox;
    MajorBox : TEdit;
    MinorBox : TEdit;
    CurIBtn : TButton;
    NumText : TMemo;
    GenderBox : TRadioGroup;
    EuroBoxE: TCheckBox;
    EuroBoxI: TCheckBox;
    Procedure NumBtnClick (Sender : TObject);
    Procedure CurEBtnClick (Sender : TObject);
    Procedure CurIBtnClick (Sender : TObject);
    Procedure FormShow (Sender : TObject);
  End;

Var
  Form1 : TForm1;

Implementation

{$R *.DFM}

Uses
  Windows, SysUtils, NumWords, NumW;

Procedure TForm1.FormShow (Sender : TObject);
Begin
  { Leave this line commented out and numwords will work in your default locale. }
  { You can un-comment this line and experiment with other countries / languages }
//   InWords.SelectLocale (54, LANG_SPANISH);

  GenderBox.Items.Clear;
  If InWords.HasGender (genMale) Then GenderBox.Items.Add ('Male');
  If InWords.HasGender (genFemale) Then GenderBox.Items.Add ('Female');
  If InWords.HasGender (genNeuter) Then GenderBox.Items.Add ('Neuter');
  GenderBox.Enabled := (GenderBox.Items.Count > 0);
  If GenderBox.Enabled Then Begin
    GenderBox.Columns := GenderBox.Items.Count;
    GenderBox.ItemIndex := 0;
  End;
End;

Procedure TForm1.NumBtnClick (Sender : TObject);
Var
  Gender : TGender;
  GenStr : String;
Begin
  Gender := genNeuter;
  If GenderBox.Enabled Then Begin
    GenStr := GenderBox.Items [GenderBox.ItemIndex];
    If GenStr = 'Male' Then Gender := genMale
    Else If GenStr = 'Female' Then Gender := genFemale
    Else If GenStr = 'Neuter' Then Gender := genNeuter;
  End;
  NumText.Text := InWords.Number (StrToInt (NumBox.Text), Gender);
End;

Procedure TForm1.CurEBtnClick (Sender : TObject);
Begin
  NumText.Text := InWords.EMoney (StrToFloat (CurEBox.Text), EuroBoxE.Checked);
End;

Procedure TForm1.CurIBtnClick (Sender : TObject);
Begin
  NumText.Text := InWords.IMoney (StrToInt (MajorBox.Text), StrToInt (MinorBox.Text), EuroBoxI.Checked);
End;

End.
//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "BaseForm.h"
#include "AboutDemoForm.h"
#include "DemoUtils.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "cxControls"
#pragma link "cxClasses"
#pragma link "cxLookAndFeels"
#pragma link "cxGraphics"
#pragma link "cxLookAndFeelPainters"
#pragma link "dxShellDialogs"
#pragma link "cxControls"
#pragma link "cxGraphics"
#pragma link "cxLookAndFeelPainters"
#pragma link "dxLayoutContainer"
#pragma link "dxLayoutControl"
#pragma link "dxLayoutLookAndFeels"
#pragma resource "*.dfm"
TfmBaseForm *fmBaseForm;
//---------------------------------------------------------------------------
__fastcall TfmBaseForm::TfmBaseForm(TComponent* Owner)
	: TForm(Owner)
{
  FLookAndFeelController = new TcxLookAndFeelController(this);
}
//---------------------------------------------------------------------------

void __fastcall TfmBaseForm::miExitClick(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------

void __fastcall TfmBaseForm::miAboutClick(TObject *Sender)
{
  ShowAboutDemoForm();
}
//---------------------------------------------------------------------------


void __fastcall TfmBaseForm::FormCreate(TObject *Sender)
{
  SetDefaultLookAndFeel();
  AddLookAndFeelMenu();
  OpenDialog->Filter = "PDF Files (*.pdf)|*.pdf";
  SaveDialog->Filter = "PDF Files (*.pdf)|*.pdf";
}
//---------------------------------------------------------------------------

void __fastcall TfmBaseForm::AddLookAndFeelMenu()
{
  mmMain->Items->Insert(mmMain->Items->IndexOf(miAbout),
	CreateLookAndFeelMenuItems(mmMain->Items, FLookAndFeelController));
}
//---------------------------------------------------------------------------

TcxLookAndFeelKind __fastcall TfmBaseForm::GetDefaultLookAndFeelKind()
{
  return(lfOffice11);
}

bool __fastcall TfmBaseForm::IsNativeDefaultStyle()
{
  return(true);
}

void __fastcall TfmBaseForm::SetDefaultLookAndFeel()
{
  FLookAndFeelController->NativeStyle = IsNativeDefaultStyle();
  FLookAndFeelController->Kind = GetDefaultLookAndFeelKind();
}
//---------------------------------------------------------------------------


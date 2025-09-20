#include <vcl.h>
#pragma hdrstop
#include "FixedColumnsDemoMain.h"
#include "AboutDemoForm.h"
#pragma link "dxCore"
#pragma resource "*.dfm"

TfrmMain *frmMain;

__fastcall TfrmMain::TfrmMain(TComponent* Owner)
  : TfmBaseForm(Owner)
{
}

void TfrmMain::ChangeFixedKind(TcxCustomGridColumn *AColumn, TcxGridColumnFixedKind AKind)
{
	if (AColumn->FixedKind != AKind)
	{
		switch (AKind)
		{
			case
				fkLeft:
					if (tvTableView->VisibleColumnCountByFixedKind[fkLeft] > 0)
					{
						int AIndex = tvTableView->VisibleColumnCountByFixedKind[fkLeft] - 1;
						AColumn->Index = tvTableView->VisibleColumns[AIndex]->Index + 1;
					}
					else
						AColumn->Index = tvTableView->VisibleColumns[0]->Index;
				fkRight:
					if (tvTableView->VisibleColumnCountByFixedKind[fkRight] > 0)
					{
						int AIndex = tvTableView->VisibleColumnCount - tvTableView->VisibleColumnCountByFixedKind[fkRight];
						AColumn->Index = tvTableView->VisibleColumns[AIndex]->Index - 1;
					}
					else
						AColumn->Index = tvTableView->VisibleColumns[tvTableView->VisibleColumnCount - 1]->Index;
		}
		AColumn->FixedKind = AKind;
	}
}

void TfrmMain::PopulateColumnComboBox()
{
	TStringList *AList = new TStringList();
	PopulateSortedColumns(AList);
	for (int I = 0; I < AList->Count; I++)
	{
		TcxImageComboBoxItem *AItem = cbColumn->Properties->Items->Add();
		AItem->Value = I;
		AItem->Description = AList->Strings[I];
		AItem->Tag = (TdxNativeInt)AList->Objects[I];
		TcxCustomGridColumn *AColumn = (TcxCustomGridColumn*)AItem->Tag;
		AItem->ImageIndex = AColumn->HeaderImageIndex;
		if (AColumn->VisibleIndex == 0)
			cbColumn->ItemIndex = I;
	}
	delete AList;
}

void TfrmMain::PopulateSortedColumns(TStringList *AList)
{
	for (int I = 0; I < tvTableView->ColumnCount; I++)
	{
		AList->AddObject(tvTableView->Columns[I]->Caption, tvTableView->Columns[I]);
	}
	AList->Sort();
}

TcxCustomGridColumn* TfrmMain::GetComboBoxColumn()
{
	TcxImageComboBoxItem *AItem = cbColumn->Properties->Items->Items[cbColumn->ItemIndex];
	return (TcxCustomGridColumn*)AItem->Tag;
}

void __fastcall TfrmMain::FormCreate(TObject *Sender)
{
	String APath = ExtractFilePath(Application->ExeName) + "..\\..\\Data\\";
	cdsCustomers->LoadFromFile(APath + "Customers2.xml");
	tvTableView->DataController->Groups->FullExpand();
	tvTableView->Controller->GoToFirst();
	PopulateColumnComboBox();
}

void __fastcall TfrmMain::cbColumnPropertiesEditValueChanged(TObject *Sender)
{
	cbFixStyle->ItemIndex = (Integer)GetComboBoxColumn()->FixedKind;
}

void __fastcall TfrmMain::cbFixStylePropertiesEditValueChanged(TObject *Sender)
{
	ChangeFixedKind(GetComboBoxColumn(), (TcxGridColumnFixedKind)cbFixStyle->ItemIndex);
}

void __fastcall TfrmMain::seFixedSeparatorWidthPropertiesEditValueChanged(TObject *Sender)
{
	tvTableView->OptionsView->FixedColumnSeparatorWidth = seFixedSeparatorWidth->Value;
}

void __fastcall TfrmMain::cbHighlightFixedColumnsPropertiesEditValueChanged(TObject *Sender)
{
	tvTableView->OptionsView->HighlightFixedColumns = cbHighlightFixedColumns->Checked;
}

void __fastcall TfrmMain::pbFixedColumnOverlayColorPaint(TObject *Sender)
{
	TPaintBox *APaintBox = (TPaintBox*)Sender;
	TRect ARect = APaintBox->ClientRect;
	FrameRectByColor(APaintBox->Canvas->Handle, ARect, clWindowFrame);
	ARect = cxRectInflate(ARect, -1);
	cxDrawTransparencyCheckerboard(APaintBox->Canvas->Handle, ARect, 6);	
	if ((tvTableView->OptionsView->FixedColumnHighlightColor != TdxAlphaColors::Default) && 
		(tvTableView->OptionsView->FixedColumnHighlightColor != TdxAlphaColors::Empty))
	{
		dxGPPaintCanvas()->BeginPaint(APaintBox->Canvas->Handle, ARect);
		TColor AColor = dxAlphaColorToColor(tvTableView->OptionsView->FixedColumnHighlightColor);
		dxGPPaintCanvas()->FillRectangle(ARect, dxColorToAlphaColor(AColor));
		dxGPPaintCanvas()->EndPaint();
	}
}

void __fastcall TfrmMain::pbFixedColumnOverlayColorClick(TObject *Sender)
{
	cdFixedColumnOverlayColor->Color = tvTableView->OptionsView->FixedColumnHighlightColor;
	if (cdFixedColumnOverlayColor->Execute())
	{
		TColor AColor = dxAlphaColorToColor(cdFixedColumnOverlayColor->Color);
		tvTableView->OptionsView->FixedColumnHighlightColor = dxColorToAlphaColor(AColor, 20);
		bool AWasButtonVisible = btnResetFixedColumnHightlightColor->Visible;
		btnResetFixedColumnHightlightColor->Visible = (tvTableView->OptionsView->FixedColumnHighlightColor != TdxAlphaColors::Default) &&
			(tvTableView->OptionsView->FixedColumnHighlightColor != TdxAlphaColors::Empty);
		if (!AWasButtonVisible && btnResetFixedColumnHightlightColor->Visible)
			pbFixedColumnOverlayColor->Width = pbFixedColumnOverlayColor->Width - btnResetFixedColumnHightlightColor->Width - 4;
		pbFixedColumnOverlayColor->Invalidate();
	}
}

void __fastcall TfrmMain::btnResetFixedColumnHightlightColorClick(TObject *Sender)
{
	tvTableView->OptionsView->FixedColumnHighlightColor = TdxAlphaColors::Default;
	btnResetFixedColumnHightlightColor->Visible = False;
	pbFixedColumnOverlayColor->Width = cbColumn->Width;
	pbFixedColumnOverlayColor->Invalidate();
}

void __fastcall TfrmMain::acFixedClick(TObject *Sender)
{
	TAction *AButton = (TAction*)Sender;
	ChangeFixedKind(FPopupColumn, (TcxGridColumnFixedKind)AButton->Tag);
}

void __fastcall TfrmMain::gpmPopupMenuPopup(TComponent *ASenderMenu, TcxCustomGridHitTest* AHitTest, int X, int Y, bool &AllowPopup)
{
	if (AHitTest->HitTestCode() == htColumnHeader)
	{
		FPopupColumn = ((TcxGridColumnHeaderHitTest*)AHitTest)->Column;
		int AItemIndex = (Integer)FPopupColumn->FixedKind;
		TAction* AAction = (TAction*)acHeaderPopup->Actions[AItemIndex];
		AAction->Checked = True;
	}
}

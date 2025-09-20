unit GroupingOptionsFormUnit;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, dxSpreadSheetCore, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxLayoutLookAndFeels, cxClasses, dxLayoutContainer, dxLayoutControl,
  Menus, dxLayoutControlAdapters, StdCtrls, cxButtons, dxLayoutcxEditAdapters, cxContainer, cxEdit, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, dxForms;

type

  { TfrmGroupingOptions }

  TfrmGroupingOptions = class(TdxForm)
    btnCancel: TcxButton;
    btnOk: TcxButton;
    cbbColumns: TcxComboBox;
    cbbRows: TcxComboBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutItem4: TdxLayoutItem;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutItem6: TdxLayoutItem;
    LayoutLookAndFeelList: TdxLayoutLookAndFeelList;
    lcMain: TdxLayoutControl;
    lcMainGroup_Root: TdxLayoutGroup;
  public
    procedure Load(ASheet: TdxSpreadSheetTableView);
    procedure Save(ASheet: TdxSpreadSheetTableView);
  end;

implementation

{$R *.dfm}

{ TfrmGroupingOptions }

procedure TfrmGroupingOptions.Load(ASheet: TdxSpreadSheetTableView);
begin
  cbbRows.ItemIndex := Ord(ASheet.Rows.Groups.ExpandButtonPosition);
  cbbColumns.ItemIndex := Ord(ASheet.Columns.Groups.ExpandButtonPosition);
end;

procedure TfrmGroupingOptions.Save(ASheet: TdxSpreadSheetTableView);
begin
  ASheet.Columns.Groups.ExpandButtonPosition := TdxSpreadSheetTableItemGroupExpandButtonPosition(cbbColumns.ItemIndex);
  ASheet.Rows.Groups.ExpandButtonPosition := TdxSpreadSheetTableItemGroupExpandButtonPosition(cbbRows.ItemIndex);
end;

end.

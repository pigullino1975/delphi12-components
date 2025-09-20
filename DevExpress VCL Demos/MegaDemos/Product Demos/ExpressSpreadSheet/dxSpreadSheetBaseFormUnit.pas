unit dxSpreadSheetBaseFormUnit;

{$I cxVer.inc}

interface

uses
{$IFDEF DELPHI16}
  System.UITypes,
{$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxSpreadSheetCustomFormUnit, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, 
  cxEdit, Menus, dxLayoutcxEditAdapters, dxLayoutControlAdapters, dxCore,
  dxCoreClasses, dxHashUtils, dxSpreadSheetCore, dxSpreadSheetCoreHistory, dxSpreadSheetConditionalFormatting,
  dxSpreadSheetConditionalFormattingRules, dxSpreadSheetClasses, dxSpreadSheetContainers, dxSpreadSheetFormulas,
  dxSpreadSheetHyperlinks, dxSpreadSheetFunctions, dxSpreadSheetGraphics, dxSpreadSheetPrinting, dxSpreadSheetTypes,
  dxSpreadSheetUtils, dxBarBuiltInMenu, dxSpreadSheet, dxLayoutContainer, cxClasses, StdCtrls, cxButtons,
  cxMemo, cxTextEdit, cxMaskEdit, cxDropDownEdit, ExtCtrls, dxLayoutControl, dxSpreadSheetFormattedTextUtils, cxRichEdit,
  Vcl.ExtActns, System.Actions, Vcl.ActnList, Vcl.StdActns, dxSpreadSheetCoreStyles, dxSpreadSheetCoreStrs,
  dxSpreadSheetStyles, cxTrackBar, dxZoomTrackBar, dxSpreadSheetFormulaBar, dxSpreadSheetCoreFormulas, cxSplitter;

type
  TdxSpreadSheetDemoUnitForm = class(TdxSpreadSheetDemoCustomForm)
    SpreadSheet: TdxSpreadSheet;
    ActionList1: TActionList;
    FormatRichEditBold1: TRichEditBold;
    FormatRichEditItalic1: TRichEditItalic;
    FormatRichEditUnderline1: TRichEditUnderline;
    FormatRichEditStrikeOut1: TRichEditStrikeOut;
    ztbBook: TdxZoomTrackBar;
    liZoom: TdxLayoutItem;
    procedure ztbBookPropertiesChange(Sender: TObject);
  protected
    function GetSpreadSheet: TdxCustomSpreadSheet; override;
    procedure DoSpreadSheetLayoutChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{ TdxSpreadSheetDemoUnitForm1 }

constructor TdxSpreadSheetDemoUnitForm.Create(AOwner: TComponent);
begin
  inherited;
  ztbBook.Properties.Max := dxSpreadSheetMaximumZoomFactor;
  ztbBook.Properties.Min := dxSpreadSheetMinimumZoomFactor;
end;

procedure TdxSpreadSheetDemoUnitForm.DoSpreadSheetLayoutChanged;
begin
  inherited;
  ztbBook.Position := SpreadSheet.ActiveSheetAsTable.Options.ZoomFactor;
end;

function TdxSpreadSheetDemoUnitForm.GetSpreadSheet: TdxCustomSpreadSheet;
begin
  Result := SpreadSheet;
end;

procedure TdxSpreadSheetDemoUnitForm.ztbBookPropertiesChange(Sender: TObject);
begin
  SpreadSheet.ActiveSheetAsTable.Options.ZoomFactor := ztbBook.Position;
  liZoom.Caption := IntToStr(ztbBook.Position) + '%';
end;

end.

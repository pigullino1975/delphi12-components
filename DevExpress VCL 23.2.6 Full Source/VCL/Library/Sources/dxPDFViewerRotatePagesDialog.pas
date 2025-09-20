{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressPDFViewer                                         }
{                                                                    }
{           Copyright (c) 2015-2024 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSPDFVIEWER AND ALL              }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxPDFViewerRotatePagesDialog;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxButtons, cxClasses, dxForms,
  dxLayoutLookAndFeels, dxLayoutControlAdapters, dxLayoutContainer, dxLayoutControl, dxPDFViewer,
  dxLayoutcxEditAdapters, cxContainer, cxEdit, cxLabel, dxPDFDocument, cxGeometry, dxPDFUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit;

type
  { TdxPDFViewerRotatePagesDialogForm }

  TdxPDFViewerRotatePagesDialogFormClass = class of TdxPDFViewerRotatePagesDialogForm;
  TdxPDFViewerRotatePagesDialogForm = class(TdxForm)
  {$REGION 'for internal use'}
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    btnOk: TcxButton;
    dxLayoutItem1: TdxLayoutItem;
    lgPageRange: TdxLayoutGroup;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeel1: TdxLayoutCxLookAndFeel;
    btnCancel: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    cbRotation: TcxComboBox;
    liRotation: TdxLayoutItem;
    lrbPageRangeAll: TdxLayoutRadioButtonItem;
    lrbPageRangeSelectedPages: TdxLayoutRadioButtonItem;
    lrbPageRangeCustom: TdxLayoutRadioButtonItem;
    lrbPageRangeCurrentPage: TdxLayoutRadioButtonItem;
    cbPageNumbers: TcxComboBox;
    liPageNumbers: TdxLayoutItem;
    liPageOrientation: TdxLayoutItem;
    cbPageOrientation: TcxComboBox;
    liCustomPageRange: TdxLayoutItem;
    edPageRanges: TcxTextEdit;
    lgPageSubset: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbPageNumbersPropertiesChange(Sender: TObject);
    procedure lrbPageRangeCustomClick(Sender: TObject);
    procedure edPageRangesKeyPress(Sender: TObject; var Key: Char);
    procedure edPageRangesPropertiesValidate(Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure cbPageOrientationPropertiesChange(Sender: TObject);
    procedure edPageRangesPropertiesChange(Sender: TObject);
    procedure edPageRangesPropertiesEditValueChanged(Sender: TObject);
  {$ENDREGION}
  strict private
    FDocumentPageIndexes: TIntegerDynArray;
    FPagesToRotate: TIntegerDynArray;
    FSelectedPages: TIntegerDynArray;
    FViewer: TdxPDFCustomViewer;
    //
    function GetPageCount: Integer;
    function GetPagesToRotate(const APageIndexes: TIntegerDynArray): TIntegerDynArray;
    function GetPagesToRotateCount: Integer;
    function GetRotationAngle: TcxRotationAngle;
  protected
    procedure ApplyLocalizations; virtual;
    procedure Initialize(AViewer: TdxPDFCustomViewer; const ASelectedPageIndexes: array of Integer); virtual;
    procedure UpdateControls; virtual;
    procedure UpdatePageRangeGroupCaption; virtual;
    //
    property PageCount: Integer read GetPageCount;
    property PagesToRotate: TIntegerDynArray read FPagesToRotate;
    property RotationAngle: TcxRotationAngle read GetRotationAngle;
    property SelectedPages: TIntegerDynArray read FSelectedPages;
    property Viewer: TdxPDFCustomViewer read FViewer;
  public
    class function Execute(AOwner: TComponent; AViewer: TdxPDFCustomViewer; const ASelectedPageIndexes: array of Integer): Boolean;
  end;

var
  dxPDFViewerRotatePagesDialogFormClass: TdxPDFViewerRotatePagesDialogFormClass = TdxPDFViewerRotatePagesDialogForm;

procedure ShowRotatePagesDialog(AViewer: TdxPDFCustomViewer; const ASelectedPageIndexes: array of Integer); 

implementation

uses
  IOUtils, Math, dxCore, dxCoreGraphics, cxDateUtils, dxPDFTypes, dxPrintUtils, dxPrintingStrs, dxPDFViewerDialogsStrs;

const
  dxThisUnitName = 'dxPDFViewerRotatePagesDialog';

{$R *.dfm}

type
  TdxPDFViewerAccess = class(TdxPDFCustomViewer);
  TdxPDFDocumentAccess = class(TdxPDFDocument);

procedure ShowRotatePagesDialog(AViewer: TdxPDFCustomViewer; const ASelectedPageIndexes: array of Integer);
begin
  if AViewer.IsDocumentLoaded then
    dxPDFViewerRotatePagesDialogFormClass.Execute(GetParentForm(AViewer), AViewer, ASelectedPageIndexes);
end;

{ TdxPDFViewerPasswordDialogForm }

procedure TdxPDFViewerRotatePagesDialogForm.cbPageNumbersPropertiesChange(Sender: TObject);
begin
  UpdatePageRangeGroupCaption;
end;

procedure TdxPDFViewerRotatePagesDialogForm.cbPageOrientationPropertiesChange(Sender: TObject);
begin
  UpdatePageRangeGroupCaption;
end;

procedure TdxPDFViewerRotatePagesDialogForm.edPageRangesKeyPress(Sender: TObject; var Key: Char);

  function IsValidKey(AKey: Char): Boolean;
  begin
    Result := dxCharInSet(AKey, ['0'..'9']);
    if not Result and (Text <> '') then
      Result := (AKey = cPageSeparator) or (AKey = cPageRangeSeparator) or (AKey = dxVKBack);
  end;

begin
  lrbPageRangeCustom.Checked := True;
  if not IsValidKey(Key) then
  begin
    MessageBeep(MB_ICONHAND);
    Key := #0;
  end;
end;

procedure TdxPDFViewerRotatePagesDialogForm.edPageRangesPropertiesChange(Sender: TObject);
begin
  UpdatePageRangeGroupCaption;
end;

procedure TdxPDFViewerRotatePagesDialogForm.edPageRangesPropertiesEditValueChanged(Sender: TObject);
begin
  UpdatePageRangeGroupCaption;
end;

procedure TdxPDFViewerRotatePagesDialogForm.edPageRangesPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  APageIndexes: TIntegerDynArray;
begin
  try
    Error := dxDecodePageIndexes(edPageRanges.Text, APageIndexes);
  except
    ErrorText := cxGetResourceString(@sdxPrintDialogInvalidPageRanges);
    Error := True;
  end;
  GetPagesToRotate(APageIndexes);
  Error := not TdxPDFUtils.IsPageRangeValid(APageIndexes, PageCount, True);
  if Error then
    ErrorText := Format(cxGetResourceString(@sdxPrintDialogPageNumbersOutOfRange), [1, PageCount]);
  btnOk.Enabled := not Error;
end;

class function TdxPDFViewerRotatePagesDialogForm.Execute(AOwner: TComponent; AViewer: TdxPDFCustomViewer;
  const ASelectedPageIndexes: array of Integer): Boolean;
var
  ADialog: TdxPDFViewerRotatePagesDialogForm;
begin
  ADialog := dxPDFViewerRotatePagesDialogFormClass.Create(AOwner);
  try
    ADialog.Initialize(AViewer, ASelectedPageIndexes);
    Result := ADialog.ShowModal = mrOk;
    if Result then
      dxPDFDocumentRotatePages(AViewer.Document, ADialog.PagesToRotate, ADialog.RotationAngle);
  finally
    ADialog.Free;
  end;
end;

procedure TdxPDFViewerRotatePagesDialogForm.ApplyLocalizations;
begin
  Caption := cxGetResourceString(@sdxPDFViewerRotatePagesDialogCaption);
  btnOk.Caption := cxGetResourceString(@sdxPDFViewerPasswordDialogButtonOK);
  btnCancel.Caption := cxGetResourceString(@sdxPDFViewerPasswordDialogButtonCancel);

  liRotation.CaptionOptions.Text := cxGetResourceString(@sdxPDFViewerRotatePagesRotation);
  cbRotation.Properties.Items.Add(cxGetResourceString(@sdxPDFViewerRotatePagesClockwise90DegreesDirection));
  cbRotation.Properties.Items.Add(cxGetResourceString(@sdxPDFViewerRotatePagesCounterclockwise90DegreesDirection));
  cbRotation.Properties.Items.Add(cxGetResourceString(@sdxPDFViewerRotatePages180DegreesDirection));
  cbRotation.ItemIndex := 0;

  lrbPageRangeAll.CaptionOptions.Text := cxGetResourceString(@sdxPrintDialogAll);
  lrbPageRangeSelectedPages.CaptionOptions.Text := cxGetResourceString(@sdxPrintDialogSelection);
  lrbPageRangeCurrentPage.CaptionOptions.Text := cxGetResourceString(@sdxPrintDialogCurrentPage);
  lrbPageRangeCustom.CaptionOptions.Text := cxGetResourceString(@sdxPrintDialogPages);

  lgPageSubset.CaptionOptions.Text := cxGetResourceString(@sdxPDFViewerRotatePagesPageSubset);
  edPageRanges.Hint := cxGetResourceString(@sdxPrintDialogRangeLegend);
  liPageNumbers.CaptionOptions.Text := cxGetResourceString(@sdxPDFViewerRotatePagesPageNumbersSubset);
  cbPageNumbers.Properties.Items.Add(cxGetResourceString(@sdxPDFViewerRotatePagesAllPagesSubset));
  cbPageNumbers.Properties.Items.Add(cxGetResourceString(@sdxPDFViewerRotatePagesOddPagesSubset));
  cbPageNumbers.Properties.Items.Add(cxGetResourceString(@sdxPDFViewerRotatePagesEvenPagesSubset));
  cbPageNumbers.ItemIndex := 0;

  liPageOrientation.CaptionOptions.Text := cxGetResourceString(@sdxPDFViewerRotatePagesPageOrientation);
  cbPageOrientation.Properties.Items.Add(RemoveAccelChars(cxGetResourceString(@sdxPDFViewerRotatePagesAllOrientationSubset)));
  cbPageOrientation.Properties.Items.Add(RemoveAccelChars(cxGetResourceString(@sdxPDFViewerRotatePagesPortraitOrientationSubset)));
  cbPageOrientation.Properties.Items.Add(RemoveAccelChars(cxGetResourceString(@sdxPDFViewerRotatePagesLandscapeOrientationSubset)));
  cbPageOrientation.ItemIndex := 0;
end;

procedure TdxPDFViewerRotatePagesDialogForm.Initialize(AViewer: TdxPDFCustomViewer;
  const ASelectedPageIndexes: array of Integer);
var
  I, L: Integer;
begin
  FViewer := AViewer;

  L := Length(ASelectedPageIndexes);
  SetLength(FSelectedPages, L);
  cxCopyData(@ASelectedPageIndexes[0], @FSelectedPages[0], 0, 0, L * SizeOf(Integer));

  SetLength(FDocumentPageIndexes, PageCount);
  for I := 0 to PageCount - 1 do
    FDocumentPageIndexes[I] := I + 1;
  SetLength(FPagesToRotate, 0);
  SetControlLookAndFeel(Self, TdxPDFViewerAccess(FViewer).DialogsLookAndFeel);
  edPageRanges.ShowHint := True;
  ApplyLocalizations;
  lrbPageRangeSelectedPages.Visible := Length(FSelectedPages) > 1;
  lrbPageRangeCurrentPage.Visible := Length(FSelectedPages) = 1;

  lrbPageRangeAll.Checked := True;
  lrbPageRangeSelectedPages.Checked := lrbPageRangeSelectedPages.Visible;
  lrbPageRangeCurrentPage.Checked := lrbPageRangeCurrentPage.Visible;

  UpdatePageRangeGroupCaption;
end;

procedure TdxPDFViewerRotatePagesDialogForm.lrbPageRangeCustomClick(Sender: TObject);
begin
  UpdateControls;
end;

procedure TdxPDFViewerRotatePagesDialogForm.UpdateControls;
begin
  lgPageSubset.Enabled := not lrbPageRangeCurrentPage.Checked;
  edPageRanges.Enabled := lrbPageRangeCustom.Checked;
  UpdatePageRangeGroupCaption;
end;

procedure TdxPDFViewerRotatePagesDialogForm.UpdatePageRangeGroupCaption;
var
  APagesToRotateCount: Integer;
begin
  APagesToRotateCount := GetPagesToRotateCount;
  lgPageRange.CaptionOptions.Text := Format(cxGetResourceString(@sdxPDFViewerRotatePagesPageRange),
    [APagesToRotateCount, Viewer.PageCount]);
  btnOk.Enabled := APagesToRotateCount > 0;
end;

function TdxPDFViewerRotatePagesDialogForm.GetPagesToRotateCount: Integer;
var
  APageIndexes: TIntegerDynArray;
begin
  if lrbPageRangeAll.Checked then
    APageIndexes := FDocumentPageIndexes
  else
    if lrbPageRangeSelectedPages.Checked then
      APageIndexes := FSelectedPages
    else
      if lrbPageRangeCurrentPage.Checked then
      begin
        SetLength(APageIndexes, 1);
        APageIndexes[0] := FSelectedPages[Length(FSelectedPages) - 1];
      end
      else
        try
          dxDecodePageIndexes(edPageRanges.Text, APageIndexes);
        except
          SetLength(APageIndexes, 0);
        end;
  if TdxPDFUtils.IsPageRangeValid(APageIndexes, PageCount, False) then
    FPagesToRotate := GetPagesToRotate(APageIndexes)
  else
     SetLength(FPagesToRotate, 0);
  Result := Length(FPagesToRotate);
end;

function TdxPDFViewerRotatePagesDialogForm.GetRotationAngle: TcxRotationAngle;
const
  RotationAngleMap: array[0..2] of TcxRotationAngle = (raPlus90, raMinus90, ra180);
begin
  Result := RotationAngleMap[cbRotation.ItemIndex];
end;

function TdxPDFViewerRotatePagesDialogForm.GetPageCount: Integer;
begin
  Result := Viewer.PageCount;
end;

function TdxPDFViewerRotatePagesDialogForm.GetPagesToRotate(const APageIndexes: TIntegerDynArray): TIntegerDynArray;
var
  APageNumbers: TdxPageNumbers;
  APageOrientationSubset: TdxPageOrientationSubset;
begin
  APageNumbers := TdxPageNumbers(IfThen(lrbPageRangeCurrentPage.Checked, 0, cbPageNumbers.ItemIndex));
  APageOrientationSubset := TdxPageOrientationSubset(IfThen(lrbPageRangeCurrentPage.Checked, 0, cbPageOrientation.ItemIndex));
  Result := dxPDFDocumentGetPagesToRotate(Viewer.Document, APageIndexes, APageNumbers, APageOrientationSubset, True);
end;

procedure TdxPDFViewerRotatePagesDialogForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if TranslateKey(Key) = VK_ESCAPE then
    Close
end;

end.

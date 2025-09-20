{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library classes                   }
{                                                                    }
{           Copyright (c) 2000-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
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

unit cxImageListEditorView;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Variants, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls, ComCtrls, CommCtrl,
  Menus, ImgList, ToolWin,
  cxGraphics, cxClasses, cxImageListEditor, ActnList, Dialogs, ExtDlgs, cxImageList, dxGDIPlusClasses, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxLayoutContainer, dxLayoutControlAdapters, dxLayoutControl, cxContainer,
  cxEdit, dxLayoutcxEditAdapters, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxColorComboBox, cxButtons, dxListView,
  dxCoreGraphics, dxSkinInfo, dxSkinsStrs, dxSkinsCore, dxShellDialogs, dxLayoutLookAndFeels, System.Actions;

type
  TcxImageListEditorFormInternalState = (eisSelectingTransparentColor);
  TcxImageListEditorFormInternalStates = set of TcxImageListEditorFormInternalState;

  TcxImageListEditorForm = class(TcxCustomImageListEditorForm)
    actAdd: TAction;
    actAddFromFile: TAction;
    actAddFromIconLibrary: TAction;
    actApply: TAction;
    actClear: TAction;
    actConvertTo32bit: TAction;
    actCopy: TAction;
    actCut: TAction;
    actDelete: TAction;
    actExport: TAction;
    actExportAsBitmap: TAction;
    actExportAsPNG: TAction;
    actExportAsSVG: TAction;
    actImport: TAction;
    actInsert: TAction;
    actlCommands: TActionList;
    actLocateInIconLibrary: TAction;
    actOK: TAction;
    actPaste: TAction;
    actReplace: TAction;
    actReplaceFromFile: TAction;
    actReplaceFromIconLibrary: TAction;
    btnApply: TcxButton;
    btnCancel: TcxButton;
    btnOK: TcxButton;
    cbBackgroundFill: TcxColorComboBox;
    cbColorPalette: TcxComboBox;
    cbGridlines: TdxLayoutCheckBoxItem;
    cbImagesSize: TcxComboBox;
    cbTransparentColor: TcxColorComboBox;
    imglSmall: TcxImageList;
    lblManifestWarning: TdxLayoutLabeledItem;
    lcMain: TdxLayoutControl;
    lcMainGroup_Root: TdxLayoutGroup;
    lgBottom: TdxLayoutGroup;
    lgClient: TdxLayoutGroup;
    lgColorSettings: TdxLayoutAutoCreatedGroup;
    lgImages: TdxLayoutGroup;
    lgPreview: TdxLayoutGroup;
    liBackgroundColor: TdxLayoutItem;
    liBtnApply: TdxLayoutItem;
    liBtnCancel: TdxLayoutItem;
    liBtnOK: TdxLayoutItem;
    liColorPalette: TdxLayoutItem;
    liImages: TdxLayoutItem;
    liImageSize: TdxLayoutItem;
    liPreview: TdxLayoutItem;
    liTransparentColor: TdxLayoutItem;
    dxlvImages: TdxListViewControl;
    miAddFromFile: TMenuItem;
    miAddFromFile1: TMenuItem;
    miAddFromIconLibrary1: TMenuItem;
    miAddFromIconLibrary2: TMenuItem;
    miClear: TMenuItem;
    miConvertTo32bit: TMenuItem;
    miCopy: TMenuItem;
    miCut: TMenuItem;
    miDelete: TMenuItem;
    miExport: TMenuItem;
    miExportAsBitmap1: TMenuItem;
    miExportAsBitmap2: TMenuItem;
    miExportAsPNG1: TMenuItem;
    miExportAsPNG2: TMenuItem;
    miExportAsSVG1: TMenuItem;
    miExportAsSVG2: TMenuItem;
    miImport: TMenuItem;
    miLine1: TMenuItem;
    miLine2: TMenuItem;
    miLocateInIconLibrary: TMenuItem;
    miPaste: TMenuItem;
    miReplaceFromDisk: TMenuItem;
    miReplaceFromFile1: TMenuItem;
    miReplaceFromIconLibrary1: TMenuItem;
    miReplaceFromIconLibrary2: TMenuItem;
    opdOpen: TdxOpenPictureDialog;
    pbPreview: TPaintBox;
    pmAdd: TPopupMenu;
    pmCommands: TPopupMenu;
    pmExport: TPopupMenu;
    pmImageLists: TPopupMenu;
    pmReplace: TPopupMenu;
    spdSave: TdxSavePictureDialog;
    dxLayoutItem1: TdxLayoutItem;
    tbbAdd: TcxButton;
    tbbClear: TcxButton;
    tbbConvertTo32bit: TcxButton;
    tbbDelete: TcxButton;
    tbbExport: TcxButton;
    tbbImport: TcxButton;
    tbbReplace: TcxButton;
    tbbShowImageTypes: TcxButton;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutItem3: TdxLayoutItem;
    dxLayoutItem4: TdxLayoutItem;
    dxLayoutItem5: TdxLayoutItem;
    dxLayoutItem6: TdxLayoutItem;
    dxLayoutItem7: TdxLayoutItem;
    dxLayoutItem8: TdxLayoutItem;
    lgCommands: TdxLayoutGroup;
    actShowImageTypes: TAction;
    dxLayoutLookAndFeelList1: TdxLayoutLookAndFeelList;
    dxLayoutCxLookAndFeelCompact: TdxLayoutCxLookAndFeel;
    dxLayoutSeparatorItem1: TdxLayoutSeparatorItem;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure cbBackgroundFillPropertiesNamingConvention(Sender: TObject; const AColor: TColor; var AColorDescription: string);
    procedure cbBackgroundFillPropertiesEditValueChanged(Sender: TObject);
    procedure cbColorPalettePropertiesEditValueChanged(Sender: TObject);
    procedure cbGridlinesClick(Sender: TObject);
    procedure cbImagesSizeChange(Sender: TObject);
    procedure cbTransparentColorChange(Sender: TObject);
    procedure lvImagesChange(Sender: TdxCustomListView; AItem: TdxListItem; AChange: TdxListItemChange);
    procedure lvImagesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure lvImagesEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure lvImagesStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure tbbShowImageTypesClick(Sender: TObject);

    procedure pbPreviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pbPreviewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pbPreviewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pbPreviewPaint(Sender: TObject);

    procedure actAddExecute(Sender: TObject);
    procedure actAddFromFileExecute(Sender: TObject);
    procedure actAddFromIconLibraryExecute(Sender: TObject);
    procedure actApplyExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure actConvertTo32bitExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actCopyUpdate(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actCutUpdate(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure actExportAsBitmapExecute(Sender: TObject);
    procedure actExportAsPNGExecute(Sender: TObject);
    procedure actExportAsSVGExecute(Sender: TObject);
    procedure actExportAsSVGUpdate(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure actImportExecute(Sender: TObject);
    procedure actInsertExecute(Sender: TObject);
    procedure actInsertUpdate(Sender: TObject);
    procedure actLocateInIconLibraryExecute(Sender: TObject);
    procedure actLocateInIconLibraryUpdate(Sender: TObject);
    procedure actOKExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actPasteUpdate(Sender: TObject);
    procedure actReplaceExecute(Sender: TObject);
    procedure actReplaceFromFileExecute(Sender: TObject);
    procedure actReplaceFromIconLibraryExecute(Sender: TObject);
    procedure actReplaceUpdate(Sender: TObject);
  strict private
    FDragImageIndex: Integer;
    FImportList: TStrings;
    FInternalState: TcxImageListEditorFormInternalStates;
    FPreviewImageList: TcxImageList;
    FSelectedColorPalette: TdxSkinColorPalettePreview;

    procedure ChangeImagesSize;
    procedure DrawFocusedItem(ACanvas: TCanvas; const ARect: TRect);
    procedure DrawGridlines;
    function ExtractImagesSize(const ASizeAsText: string): TSize;
    function GetColorFromCursorPos(X, Y: Integer): TColor;
    function GetImageListSize: TSize;
    function GetFocusedImageIndex: Integer;
    function GetFocusedImageInfo: TcxImageInfo;
    procedure SetFocusedImageIndex(AValue: Integer);

    procedure AddImages(AAddMode: TcxImageListEditorAddMode);
    procedure AddImagesFromIconLibrary(AAddMode: TcxImageListEditorAddMode);
    procedure ImportImageList(Sender: TObject);
    procedure PopulateColorPalettes;
    procedure PopulateImportItems;

    procedure UpdateActions; reintroduce;
    procedure UpdateImagesSizeIndicator;
    procedure UpdateTransparentColor(AColor: TColor); overload;
    procedure UpdateTransparentColor(X, Y: Integer); overload;
    procedure UpdateTransparentColorIndicator(AColor: TColor);
    procedure WMDropFiles(var Message: TWMDropFiles); message WM_DROPFILES;
  protected
    procedure RestorePosition; override;
    procedure StorePosition; override;
    procedure UpdateControls; override;

    property FocusedImageIndex: Integer read GetFocusedImageIndex write SetFocusedImageIndex;
    property FocusedImageInfo: TcxImageInfo read GetFocusedImageInfo;
    property ImageListSize: TSize read GetImageListSize;
    property SelectedColorPalette: TdxSkinColorPalettePreview read FSelectedColorPalette;
  public
    constructor Create(AImageListEditor: TcxImageListEditor); override;
    destructor Destroy; override;

    function GetVisualDataControl: TdxListViewControl; override;
    procedure SetImportList(AValue: TStrings); override;
  end;

implementation

{$R *.dfm}

uses
  Types, Math, ShellApi, cxLibraryConsts, cxGeometry, dxOffice11, dxCore, dxIconLibraryEditorHelpers, dxSmartImage,
  dxMessageDialog, dxCoreClasses, dxInputDialogs;

const
  dxThisUnitName = 'cxImageListEditorView';

const
  sMsgErrorInvalidImageSize = 'The specified image size is incorrect';

type
  TcxImageListAccess = class(TcxImageList);

var
  dxvEditorFormPosition: TRect;
  dxcbBackgroundFill: TColor;
  dxcbGridLines: Boolean;
  dxcbShowImageTypes: Boolean;

{ TcxImageListEditorForm }

constructor TcxImageListEditorForm.Create(AImageListEditor: TcxImageListEditor);
begin
  inherited;
  PopupMode := pmAuto;
  FPreviewImageList := TcxImageList.Create(Self);
  if IsXPManifestEnabled then
  begin
    lblManifestWarning.Visible := True;
    Width := Width + cxGetValueCurrentDPI(6{Rows} * 3{Pixel});
  end;
  PopulateColorPalettes;
end;

destructor TcxImageListEditorForm.Destroy;
begin
  FreeAndNil(FSelectedColorPalette);
  FreeAndNil(FPreviewImageList);
  inherited;
end;

function TcxImageListEditorForm.GetVisualDataControl: TdxListViewControl;
begin
  Result := dxlvImages;
end;

procedure TcxImageListEditorForm.SetImportList(AValue: TStrings);
begin
  FImportList := AValue;
  PopulateImportItems;
end;

procedure TcxImageListEditorForm.FormCreate(Sender: TObject);
begin
  FDragImageIndex := -1;
  dxlvImages.OnChange := lvImagesChange;

  pbPreview.Cursor := crcxColorPicker;
  cbBackgroundFill.ColorValue := clNone;
  cbBackgroundFill.ActiveProperties.Items.FindColorItem(clNone).Index := 0;

  Constraints.MinWidth := Width;
  Constraints.MinHeight := Height;
  DragAcceptFiles(Handle, True);

  if Supports(dxIconLibraryIntf, IdxImageCollectionEditor) then
  begin
    tbbAdd.Action := actAdd;
    tbbAdd.DropdownMenu := pmAdd;
    tbbReplace.Action := actReplace;
    tbbReplace.DropdownMenu := pmReplace;
    actAddFromIconLibrary.Visible := True;
    actReplaceFromIconLibrary.Visible := True;
  end
  else
  begin
    tbbAdd.Action := actAddFromFile;
    tbbAdd.DropdownMenu := nil;
    tbbReplace.Action := actReplaceFromFile;
    tbbReplace.DropdownMenu := nil;
    actAddFromIconLibrary.Visible := False;
    actReplaceFromIconLibrary.Visible := False;
  end;

  actLocateInIconLibrary.Visible := Supports(dxIconLibraryIntf, IdxImageCollectionEditorLocate);
end;

procedure TcxImageListEditorForm.FormDestroy(Sender: TObject);
begin
  dxlvImages.OnChange := nil;
end;

procedure TcxImageListEditorForm.FormHide(Sender: TObject);
begin
  dxcbShowImageTypes := tbbShowImageTypes.SpeedButtonOptions.Down;
  dxcbGridLines := cbGridlines.Checked;
  dxcbBackgroundFill := cbBackgroundFill.ColorValue;
end;

procedure TcxImageListEditorForm.FormShow(Sender: TObject);
begin
  if not cxRectIsEqual(dxvEditorFormPosition, cxNullRect) then
  begin
    cbBackgroundFill.ColorValue := dxcbBackgroundFill;
    cbGridlines.Checked := dxcbGridLines;
    tbbShowImageTypes.SpeedButtonOptions.Down := dxcbShowImageTypes;
    tbbShowImageTypesClick(nil);
  end;
end;

procedure TcxImageListEditorForm.cbBackgroundFillPropertiesEditValueChanged(Sender: TObject);
begin
  UpdateControls;
end;

procedure TcxImageListEditorForm.cbBackgroundFillPropertiesNamingConvention(
  Sender: TObject; const AColor: TColor; var AColorDescription: string);
begin
  if AColor = clNone then
    AColorDescription := 'Checkered pattern';
end;

procedure TcxImageListEditorForm.cbColorPalettePropertiesEditValueChanged(Sender: TObject);
var
  AData: TdxSkinInfo;
begin
  FreeAndNil(FSelectedColorPalette);
  if RootLookAndFeel.Painter.GetPainterData(AData) then
    FSelectedColorPalette := TdxSkinColorPalettePreview.Create(AData.Skin, cbColorPalette.Text);
  pbPreview.Invalidate;
end;

procedure TcxImageListEditorForm.cbGridlinesClick(Sender: TObject);
begin
  UpdateControls;
end;

procedure TcxImageListEditorForm.cbImagesSizeChange(Sender: TObject);
begin
  ChangeImagesSize;
  UpdateImagesSizeIndicator;
end;

procedure TcxImageListEditorForm.cbTransparentColorChange(Sender: TObject);
begin
  if cbTransparentColor.Focused then
    UpdateTransparentColor(cbTransparentColor.ColorValue);
end;

procedure TcxImageListEditorForm.lvImagesChange(Sender: TdxCustomListView; AItem: TdxListItem; AChange: TdxListItemChange);
begin
  UpdateControls;
end;

procedure TcxImageListEditorForm.lvImagesDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := dxlvImages.GetItemAt(X, Y) <> nil
end;

procedure TcxImageListEditorForm.lvImagesEndDrag(Sender, Target: TObject; X, Y: Integer);
var
  ATargetItem: TdxListItem;
begin
  FImageListEditor.EndUpdate;
  ATargetItem := dxlvImages.GetItemAt(X, Y);
  if ATargetItem <> nil then
    FImageListEditor.MoveImage(FDragImageIndex, ATargetItem.ImageIndex)
  else
    FocusedImageIndex := FDragImageIndex;
  FDragImageIndex := -1;
end;

procedure TcxImageListEditorForm.lvImagesStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  FImageListEditor.BeginUpdate;
  FDragImageIndex := FImageListEditor.FocusedImageIndex;
end;

procedure TcxImageListEditorForm.pbPreviewMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
  begin
    Include(FInternalState, eisSelectingTransparentColor);  
    UpdateTransparentColor(X, Y);
  end;
end;

procedure TcxImageListEditorForm.pbPreviewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if eisSelectingTransparentColor in FInternalState then
    UpdateTransparentColor(X, Y);
end;

procedure TcxImageListEditorForm.pbPreviewMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Exclude(FInternalState, eisSelectingTransparentColor);
end;

procedure TcxImageListEditorForm.pbPreviewPaint(Sender: TObject);
var
  ARect: TRect;
begin
  ARect := pbPreview.ClientRect;
  FrameRectByColor(pbPreview.Canvas.Handle, ARect, clNavy);

  InflateRect(ARect, -1, -1);
  if cxColorIsValid(cbBackgroundFill.ColorValue) then
  begin
    pbPreview.Canvas.Brush.Color := cbBackgroundFill.ColorValue;
    pbPreview.Canvas.FillRect(ARect);
  end
  else
    cxDrawTransparencyCheckerboard(pbPreview.Canvas.Handle, ARect);

  DrawFocusedItem(pbPreview.Canvas, ARect);
  if cbGridlines.Checked then
    DrawGridlines;
end;

procedure TcxImageListEditorForm.ChangeImagesSize;
var
  ASizeAsText: string;
  AValues: array of string;
begin
  if cbImagesSize.ItemIndex = 0 then
  begin
    SetLength(AValues, 2);
    AValues[0] := IntToStr(FImageListEditor.ImageHeight);
    AValues[1] := IntToStr(FImageListEditor.ImageWidth);
    while True do
    begin
      if dxInputQuery('Custom Size', ['Height:', 'Width:'], AValues) then
        ASizeAsText := AValues[1] + 'x' + AValues[0]
      else
        Exit;
      try
        ExtractImagesSize(ASizeAsText);
        Break;
      except
        on E: Exception do
          dxMessageDlg(E.Message, mtError, [mbOK], 0);
      end;
    end;
  end
  else
    ASizeAsText := cbImagesSize.Text;

  FImageListEditor.ChangeImagesSize(ExtractImagesSize(ASizeAsText));
end;

procedure TcxImageListEditorForm.DrawFocusedItem(ACanvas: TCanvas; const ARect: TRect);
var
  AFocusedImageInfo: TcxImageInfo;
begin
  if FImageListEditor.IsAnyImageSelected then
  begin
    AFocusedImageInfo := FocusedImageInfo;
    if AFocusedImageInfo.Image is TdxSmartImage then
      TdxSmartImage(AFocusedImageInfo.Image).StretchDraw(ACanvas.Handle, ARect, MaxByte, SelectedColorPalette)
    else
    begin
      FPreviewImageList.Width := FImageListEditor.ImageWidth;
      FPreviewImageList.Height := FImageListEditor.ImageHeight;
      TcxImageListAccess(FPreviewImageList).AddImageInfo(FocusedImageInfo);
      FPreviewImageList.Draw(ACanvas, ARect, 0);
      FPreviewImageList.Clear;
    end;
  end;
end;

procedure TcxImageListEditorForm.DrawGridlines;
var
  I: Integer;
  R: TRect;
begin
  R := cxRectInflate(pbPreview.ClientRect, -1, -1);
  for I := 1 to FImageListEditor.ImageWidth - 1 do
    cxFillHalfToneRect(pbPreview.Canvas, cxRectSetLeft(R,
      MulDiv(I, pbPreview.Width - 1, FImageListEditor.ImageWidth), 1), $808080, $C0C0C0);
  for I := 1 to FImageListEditor.ImageHeight - 1 do
    cxFillHalfToneRect(pbPreview.Canvas, cxRectSetTop(R,
      MulDiv(I, pbPreview.Height - 1, FImageListEditor.ImageHeight), 1), $808080, $C0C0C0);
end;

function TcxImageListEditorForm.GetColorFromCursorPos(X, Y: Integer): TColor;
begin
  if cxRectPtIn(Rect(0, 0, pbPreview.Width, pbPreview.Height), X, Y) then
  begin
    X := X * FImageListEditor.ImageWidth div pbPreview.Width;
    Y := Y * FImageListEditor.ImageHeight div pbPreview.Height;
    Result := TcxImageInfoHelper.GetPixel(FocusedImageInfo.Image, X, Y);
  end
  else
    Result := FocusedImageInfo.MaskColor;
end;

function TcxImageListEditorForm.GetFocusedImageIndex: Integer;
begin
  Result := FImageListEditor.FocusedImageIndex;
end;

function TcxImageListEditorForm.GetFocusedImageInfo: TcxImageInfo;
begin
  Result := FImageListEditor.FocusedImageInfo;
end;

function TcxImageListEditorForm.GetImageListSize: TSize;
begin
  Result := cxSize(FImageListEditor.ImageWidth, FImageListEditor.ImageHeight);
end;

function TcxImageListEditorForm.ExtractImagesSize(const ASizeAsText: string): TSize;
begin
  if not cxTryStringToSize(ASizeAsText, Result) then
    raise EInvalidArgument.Create(sMsgErrorInvalidImageSize);
end;

procedure TcxImageListEditorForm.SetFocusedImageIndex(AValue: Integer);
begin
  FImageListEditor.FocusedImageIndex := AValue;
end;

procedure TcxImageListEditorForm.AddImages(AAddMode: TcxImageListEditorAddMode);
begin
  opdOpen.Filter := cxImageFileFormats.GetFilter;
  if opdOpen.Execute then
    FImageListEditor.AddImages(opdOpen.Files, AAddMode);
end;

procedure TcxImageListEditorForm.AddImagesFromIconLibrary(AAddMode: TcxImageListEditorAddMode);
var
  AFiles: TStrings;
  AImageCollectionEditor: IdxImageCollectionEditor;
begin
  if Supports(dxIconLibraryIntf, IdxImageCollectionEditor, AImageCollectionEditor) then
  begin
    AFiles := TStringList.Create;
    try
      if AImageCollectionEditor.Execute(AFiles, ImageListSize) then
        FImageListEditor.AddImages(AFiles, AAddMode);
    finally
      AFiles.Free;
    end;
  end;
end;

procedure TcxImageListEditorForm.ImportImageList(Sender: TObject);
begin
  FImageListEditor.ImportImages(FImportList.Objects[TMenuItem(Sender).Tag] as TCustomImageList);
end;

procedure TcxImageListEditorForm.PopulateColorPalettes;
var
  AData: TdxSkinInfo;
  I: Integer;
begin
  cbColorPalette.Properties.Items.BeginUpdate;
  try
    cbColorPalette.Properties.Items.Clear;
    cbColorPalette.Properties.Items.Add('None');
    if RootLookAndFeel.Painter.GetPainterData(AData) then
    begin
      for I := 0 to AData.Skin.ColorPalettes.Count - 1 do
        cbColorPalette.Properties.Items.Add(AData.Skin.ColorPalettes[I].Name);
    end;
    cbColorPalette.ItemIndex := 0;
    cbColorPalettePropertiesEditValueChanged(nil);
  finally
    cbColorPalette.Properties.Items.EndUpdate;
  end;
  liColorPalette.Enabled := cbColorPalette.Properties.Items.Count > 1;
end;

procedure TcxImageListEditorForm.PopulateImportItems;

  procedure PopulateItem(AParentItem: TMenuItem; const APrefix: string);
  var
    AMenuItem: TMenuItem;
    I: Integer;
  begin
    AParentItem.Clear;
    for I := 0 to FImportList.Count - 1 do
    begin
      AMenuItem := TMenuItem.Create(Self);
      AMenuItem.OnClick := ImportImageList;
      AMenuItem.Caption := APrefix + FImportList[I];
      AMenuItem.Tag := I;
      AMenuItem.ImageIndex := 5;
      AParentItem.Add(AMenuItem);
    end;
  end;

begin
  PopulateItem(pmImageLists.Items, 'Import from ');
  PopulateItem(miImport, 'from ');
end;

procedure TcxImageListEditorForm.UpdateActions;
begin
  actClear.Enabled := FImageListEditor.ImagesCount > 0;
  actExport.Enabled := FImageListEditor.ImagesCount > 0;
  actExportAsBitmap.Enabled := actExport.Enabled;
  actExportAsPNG.Enabled := actExport.Enabled;

  actImport.Enabled := (FImportList <> nil) and (FImportList.Count <> 0);
  actConvertTo32bit.Enabled := FImageListEditor.ImagesCount > 0;
  actApply.Enabled := FImageListEditor.IsChanged;
end;

procedure TcxImageListEditorForm.UpdateControls;
var
  AAllowSelectTransparentColor: Boolean;
  AImageInfo: TcxImageInfo;
begin
  if FImageListEditor.IsUpdateLocked then
    Exit;

  cbGridlines.Enabled := (FImageListEditor.ImageWidth <= 48) or (FImageListEditor.ImageWidth <= 48);
  cbGridlines.Checked := cbGridlines.Checked and cbGridlines.Enabled;

  if FImageListEditor.IsAnyImageSelected then
    AImageInfo := FocusedImageInfo
  else
    AImageInfo := nil;

  AAllowSelectTransparentColor := (AImageInfo <> nil) and not (IsGlyphAssigned(AImageInfo.Mask) or AImageInfo.IsAlphaUsed);
  liPreview.Enabled := AAllowSelectTransparentColor;
  liTransparentColor.Visible := AAllowSelectTransparentColor;
  liColorPalette.Visible := (AImageInfo <> nil) and Supports(AImageInfo.Image, IdxVectorImage);

  if AAllowSelectTransparentColor then
    UpdateTransparentColorIndicator(AImageInfo.MaskColor)
  else
    UpdateTransparentColorIndicator(clNone);

  UpdateImagesSizeIndicator;
  UpdateActions;
  pbPreview.Invalidate;
end;

procedure TcxImageListEditorForm.RestorePosition;
begin
  if not cxRectIsEqual(dxvEditorFormPosition, cxNullRect) then
    SetBounds(dxvEditorFormPosition.Left, dxvEditorFormPosition.Top, dxvEditorFormPosition.Right, dxvEditorFormPosition.Bottom);
end;

procedure TcxImageListEditorForm.StorePosition;
begin
  dxvEditorFormPosition := Rect(Left, Top, Width, Height);
end;

procedure TcxImageListEditorForm.tbbShowImageTypesClick(Sender: TObject);
begin
  FImageListEditor.ShowImageTypes := tbbShowImageTypes.SpeedButtonOptions.Down;
end;

procedure TcxImageListEditorForm.UpdateImagesSizeIndicator;
var
  AImagesSizeDisplayText: string;
  ASizeIndex: Integer;
begin
  AImagesSizeDisplayText := Format('%dx%d', [FImageListEditor.ImageWidth, FImageListEditor.ImageHeight]);
  ASizeIndex := cbImagesSize.Properties.Items.IndexOf(AImagesSizeDisplayText);
  if ASizeIndex <> -1 then
    cbImagesSize.ItemIndex := ASizeIndex
  else
    cbImagesSize.Properties.Items.Add(AImagesSizeDisplayText);
end;

procedure TcxImageListEditorForm.UpdateTransparentColor(AColor: TColor);
begin
  FImageListEditor.UpdateTransparentColor(AColor);
end;

procedure TcxImageListEditorForm.UpdateTransparentColor(X, Y: Integer);
begin
  UpdateTransparentColor(GetColorFromCursorPos(X, Y));
end;

procedure TcxImageListEditorForm.UpdateTransparentColorIndicator(AColor: TColor);
begin
  cbTransparentColor.ColorValue := AColor;
end;

procedure TcxImageListEditorForm.WMDropFiles(var Message: TWMDropFiles);
var
  I, ACount: Integer;
  AFileName: array [0..MAX_PATH] of Char;
  AFiles: TStringList;
begin
  inherited;
  AFiles := TStringList.Create;
  try
    try
      ACount := DragQueryFile(Message.Drop, $FFFFFFFF, AFileName, MAX_PATH);
      for I := 0 to ACount - 1 do
      begin
        DragQueryFile(Message.Drop, I, AFileName, MAX_PATH);
        AFiles.Add(AFileName);
      end;
    finally
      DragFinish(Message.Drop);
    end;
    if AFiles.Count > 0 then
      FImageListEditor.AddImages(AFiles, amAdd);
  finally
    AFiles.Free;
  end;
end;

procedure TcxImageListEditorForm.actAddExecute(Sender: TObject);
begin
  // (don't remove this method)
end;

procedure TcxImageListEditorForm.actInsertExecute(Sender: TObject);
begin
  AddImages(amInsert);
end;

procedure TcxImageListEditorForm.actInsertUpdate(Sender: TObject);
begin
  actInsert.Enabled := FImageListEditor.IsAnyImageSelected;
end;

procedure TcxImageListEditorForm.actLocateInIconLibraryExecute(Sender: TObject);
var
  ACommand: IdxImageCollectionEditorLocate;
  AFileName: string;
  AFiles: TStrings;
begin
  if Supports(dxIconLibraryIntf, IdxImageCollectionEditorLocate, ACommand) then
  begin
    AFileName := FocusedImageInfo.FileName;
    if ACommand.Execute(AFileName) and not dxSameText(AFileName, FocusedImageInfo.FileName) then
    begin
      AFiles := TStringList.Create;
      try
        AFiles.Capacity := 1;
        AFiles.Add(AFileName);
        FImageListEditor.AddImages(AFiles, amReplace);
      finally
        AFiles.Free;
      end;
    end;
  end;
end;

procedure TcxImageListEditorForm.actLocateInIconLibraryUpdate(Sender: TObject);
begin
  actLocateInIconLibrary.Enabled := FImageListEditor.IsSingleImageSelected and (FocusedImageInfo.FileName <> '');
end;

procedure TcxImageListEditorForm.actReplaceExecute(Sender: TObject);
begin
  // (don't remove this method)
end;

procedure TcxImageListEditorForm.actDeleteExecute(Sender: TObject);
begin
  FImageListEditor.DeleteSelectedImages;
end;

procedure TcxImageListEditorForm.actDeleteUpdate(Sender: TObject);
begin
  actDelete.Enabled := FImageListEditor.IsAnyImageSelected;
end;

procedure TcxImageListEditorForm.actClearExecute(Sender: TObject);
begin
  FImageListEditor.ClearImages;
end;

procedure TcxImageListEditorForm.actImportExecute(Sender: TObject);
begin
  // (don't remove this method)
end;

procedure TcxImageListEditorForm.actApplyExecute(Sender: TObject);
begin
  FImageListEditor.ApplyChanges;
end;

procedure TcxImageListEditorForm.actOKExecute(Sender: TObject);
begin
  FImageListEditor.ApplyChanges;
end;

procedure TcxImageListEditorForm.actPasteExecute(Sender: TObject);
begin
  FImageListEditor.PasteFromClipboard;
end;

procedure TcxImageListEditorForm.actPasteUpdate(Sender: TObject);
begin
  actPaste.Enabled := FImageListEditor.CanPasteFromClipboard;
end;

procedure TcxImageListEditorForm.actExportAsBitmapExecute(Sender: TObject);
begin
  spdSave.DefaultExt := '*.bmp';
  spdSave.Filter := 'Bitmaps (*.bmp)|*.bmp';
  if spdSave.Execute then
    FImageListEditor.ExportImages(spdSave.FileName, itBMP);
end;

procedure TcxImageListEditorForm.actExportAsPNGExecute(Sender: TObject);
begin
  spdSave.DefaultExt := '*.png';
  spdSave.Filter := 'PNG (*.png)|*.png';
  if spdSave.Execute then
    FImageListEditor.ExportImages(spdSave.FileName, itPNG);
end;

procedure TcxImageListEditorForm.actExportAsSVGExecute(Sender: TObject);
begin
  spdSave.DefaultExt := '*.svg';
  spdSave.Filter := 'SVG (*.svg)|*.svg';
  if spdSave.Execute then
    FocusedImageInfo.Image.SaveToFile(spdSave.FileName);
end;

procedure TcxImageListEditorForm.actExportAsSVGUpdate(Sender: TObject);
begin
  actExportAsSVG.Visible := FImageListEditor.IsVectorImageSelected;
end;

procedure TcxImageListEditorForm.actExportExecute(Sender: TObject);
begin
  // (don't remove this method)
end;

procedure TcxImageListEditorForm.actConvertTo32bitExecute(Sender: TObject);
begin
  FImageListEditor.ConvertTo32bit;
end;

procedure TcxImageListEditorForm.actCopyExecute(Sender: TObject);
begin
  FImageListEditor.CopyToClipboard;
end;

procedure TcxImageListEditorForm.actCopyUpdate(Sender: TObject);
begin
  actCopy.Enabled := FImageListEditor.CanCopyToClipboard;
end;

procedure TcxImageListEditorForm.actCutExecute(Sender: TObject);
begin
  FImageListEditor.CutToClipboard;
end;

procedure TcxImageListEditorForm.actCutUpdate(Sender: TObject);
begin
  actCut.Enabled := FImageListEditor.CanCopyToClipboard;
end;

procedure TcxImageListEditorForm.actAddFromFileExecute(Sender: TObject);
begin
  AddImages(amAdd);
end;

procedure TcxImageListEditorForm.actAddFromIconLibraryExecute(Sender: TObject);
begin
  AddImagesFromIconLibrary(amAdd);
end;

procedure TcxImageListEditorForm.actReplaceFromFileExecute(Sender: TObject);
begin
  AddImages(amReplace);
end;

procedure TcxImageListEditorForm.actReplaceFromIconLibraryExecute(Sender: TObject);
begin
  AddImagesFromIconLibrary(amReplace);
end;

procedure TcxImageListEditorForm.actReplaceUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := FImageListEditor.IsAnyImageSelected;
end;

end.


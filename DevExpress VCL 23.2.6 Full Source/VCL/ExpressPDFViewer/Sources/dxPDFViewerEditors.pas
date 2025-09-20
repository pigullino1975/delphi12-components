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

unit dxPDFViewerEditors; // for internal use

{$I cxVer.inc}

interface

uses
  Math, SysUtils, Types, Graphics, Windows, Controls, Messages, Classes, Variants,
  dxTypeHelpers, cxGeometry, cxGraphics, cxAccessibility, cxContainer, cxEdit, cxMemo, cxListBox, cxTextEdit,
  dxGenerics, cxDropDownEdit, dxCustomTree, dxTreeView, cxControls,
  dxPDFForm, dxPDFViewer, dxPDFInteractiveFormField, dxPDFTypes, dxPDFCore;

type
  { TdxPDFViewerButtonFieldWidgetViewInfo }

  TdxPDFViewerButtonFieldWidgetViewInfo = class(TdxPDFViewerWidgetViewInfo)
  protected
    function GetAction: TdxPDFInteractiveOperation; override;
    function GetCursor: TCursor; override;
    function GetHitCode: Integer; override;
    procedure Execute(AShift: TShiftState = []); override;
  end;

  { TdxPDFViewerWidgetTextBasedEditViewInfo }

  TdxPDFViewerWidgetTextBasedEditViewInfo = class
  strict private
    FEditViewInfo: TcxCustomEditViewInfo;
    FFont: TFont;
    FWidget: TdxPDFViewerWidgetViewInfo;
    //
    procedure CalculateEditViewInfo;
  protected
    class procedure AdjustFontSize(AWidget: TdxPDFViewerWidgetViewInfo; const AText: string; AFont: TFont); static;
    //
    procedure Calculate;
    procedure DrawDropDownButton(ACanvas: TcxCanvas);
    procedure Offset(const AOffset: TPoint);
    //
    property InnerViewInfo: TcxCustomEditViewInfo read FEditViewInfo;
  public
    class procedure InitFont(AWidget: TdxPDFViewerWidgetViewInfo; AFont: TFont); static;
    class procedure UpdateFontSize(AWidget: TdxPDFViewerWidgetViewInfo; AEdit: TcxCustomEdit); static;
    constructor Create(AWidget: TdxPDFViewerWidgetViewInfo);
    destructor Destroy; override;
    //
    procedure UpdateState;
  end;

  { TdxPDFViewerTextFieldWidgetViewInfo }

  TdxPDFViewerTextFieldWidgetViewInfo = class(TdxPDFViewerWidgetViewInfo)
  strict private
    function GetField: TdxPDFTextField;
  strict protected
    function GetCursor: TCursor; override;
    function GetEditValue: Variant; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    procedure SetEditValue(const AValue: Variant); override;
    function NeedExtraSymbolWidthForEditor: Boolean; override;
  public
    function IsMultiLine: Boolean; override;
    procedure InitFont(AFont: TFont); override;
    procedure InitProperties(AProperties: TcxCustomEditProperties); override;
    procedure UpdateEditFontSize(AEdit: TcxCustomEdit); override; // for internal use
    //
    property Field: TdxPDFTextField read GetField;
  end;

  { TdxPDFViewerRadioGroupFieldItemWidgetViewInfo }

  TdxPDFViewerRadioGroupFieldItemWidgetViewInfo = class(TdxPDFViewerWidgetViewInfo)
  strict private
    function GetField: TdxPDFRadioGroupFieldItem;
    function GetGroupField: TdxPDFRadioGroupField;
  protected
    function AllowActivateByMouseDown: Boolean; override;
    function GetCursor: TCursor; override;
    function UseWindowRegion(out ARegion: TcxRegion): Boolean; override;
    procedure Execute(AShift: TShiftState = []); override;
  public
    property Field: TdxPDFRadioGroupFieldItem read GetField;
    property Group: TdxPDFRadioGroupField read GetGroupField;
  end;

  { TdxPDFViewerCheckBoxFieldWidgetViewInfo }

  TdxPDFViewerCheckBoxFieldWidgetViewInfo = class(TdxPDFViewerWidgetViewInfo)
  strict private
    function GetField: TdxPDFCheckBoxField;
  protected
    function AllowActivateByMouseDown: Boolean; override;
    function GetCursor: TCursor; override;
    function UseWindowRegion(out ARegion: TcxRegion): Boolean; override;
    procedure Execute(AShift: TShiftState = []); override;
  public
    property Field: TdxPDFCheckBoxField read GetField;
  end;

  { TdxPDFViewerChoiceFieldWidgetViewInfo }

  TdxPDFViewerChoiceFieldWidgetViewInfo = class(TdxPDFViewerWidgetViewInfo)
  strict private
    function GetField: TdxPDFChoiceField;
    procedure InitItems(AItems: TStrings);
  strict protected
    function GetCursor: TCursor; override;
    function GetEditValue: Variant; override;
    procedure SetEditValue(const AValue: Variant); override;
    //
    function GetPropertiesItems(AProperties: TcxCustomEditProperties): TStrings; virtual; abstract;
  public
    procedure InitProperties(AProperties: TcxCustomEditProperties); override;
    //
    property Field: TdxPDFChoiceField read GetField;
  end;

  { TdxPDFViewerListBoxFieldWidgetViewInfo }

  TdxPDFViewerListBoxFieldWidgetViewInfo = class(TdxPDFViewerChoiceFieldWidgetViewInfo)
  strict private
    function GetField: TdxPDFListBoxField;
  protected
    function GetCursor: TCursor; override;
    function GetEditValue: Variant; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    function GetPropertiesItems(AProperties: TcxCustomEditProperties): TStrings; override;
    procedure SetEditValue(const AValue: Variant); override;
  public
    procedure InitFont(AFont: TFont); override;
    procedure InitProperties(AProperties: TcxCustomEditProperties); override;
    //
    property Field: TdxPDFListBoxField read GetField;
  end;

  { TdxPDFComboBoxFieldWidgetViewInfo }

  TdxPDFComboBoxFieldWidgetViewInfo = class(TdxPDFViewerChoiceFieldWidgetViewInfo)
  strict private
    FEditViewInfo: TdxPDFViewerWidgetTextBasedEditViewInfo;
  protected
    function GetCursor: TCursor; override;
    function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    function GetPropertiesItems(AProperties: TcxCustomEditProperties): TStrings; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoCalculate; override;
    procedure DrawContent(ACanvas: TcxCanvas); override;
    procedure Offset(const AOffset: TPoint); override;
    procedure UpdateState; override;
  public
    procedure InitFont(AFont: TFont); override;
  end;

  { TdxPDFViewerSignatureFieldWidgetViewInfo }

  TdxPDFViewerSignatureFieldWidgetViewInfo = class(TdxPDFViewerWidgetViewInfo)
  protected
    function CanFocus: Boolean; override;
    function UseWindowRegion(out ARegion: TcxRegion): Boolean; override;
  end;

implementation

uses
  dxPDFAnnotation, dxCore;

const
  dxThisUnitName = 'dxPDFViewerEditors';

type
  TdxPDFListBox = class;

  TdxPDFChoiceFieldAccess = class(TdxPDFChoiceField);
  TdxPDFComboBoxFieldAccess = class(TdxPDFComboBoxField);
  TdxPDFRadioGroupFieldItemAccess = class(TdxPDFRadioGroupFieldItem);
  TdxPDFTextFieldAccess = class(TdxPDFTextField);
  TdxPDFViewerCellViewInfoAccess = class(TdxPDFViewerCellViewInfo);
  TdxPDFViewerViewInfoListAccess = class(TdxPDFViewerViewInfoList);
  TdxPDFViewerWidgetViewInfoAccess = class(TdxPDFViewerWidgetViewInfo);

  { TdxPDFInnerListBoxPainter }

  TdxPDFInnerListBoxPainter = class(TdxTreeViewPainter)
  protected
    function GetBackgroundColor: TColor; override;
    function GetTextColor(ANodeViewInfo: TdxTreeViewNodeViewInfo): TColor; override;
  end;

  { TdxPDFInnerListBoxNodeViewInfo }

  TdxPDFInnerListBoxNodeViewInfo = class(TdxTreeViewNodeViewInfo)
  protected
    function GetLevelOffset: Integer; override;
    function MeasureHeight(AImageSize: Integer; AExpandButtonSize: Integer;
      ACheckHeight: Integer; ATextHeight: Integer): Integer; override;
  end;

  { TdxPDFInnerListBoxViewInfo }

  TdxPDFInnerListBoxViewInfo = class(TdxTreeViewViewInfo)
  protected
    function CreateNodeViewInfo: TdxTreeViewNodeViewInfo; override;
  end;

  { TdxPDFInnerListBoxOptionsView }

  TdxPDFInnerListBoxOptionsView = class(TdxTreeViewOptionsView)
  strict private
    FOffset: Integer;
    procedure SetOffset(const Value: Integer);
  public
    property Offset: Integer read FOffset write SetOffset;
  end;

  { TdxPDFInnerListBox }

  TdxPDFInnerListBox = class(TdxInternalTreeView,
    IcxCustomInnerEdit)
  strict private
    FLockBoundsCount: Integer;
    function GetContainer: TdxPDFListBox;
    function GetOptionsView: TdxPDFInnerListBoxOptionsView;
    procedure SetOptionsView(const Value: TdxPDFInnerListBoxOptionsView);
  protected
    function CreateOptionsView: TdxTreeViewCustomOptionsView; override;
    function CreatePainter: TdxTreeViewPainter; override;
    function CreateViewInfo: TdxTreeViewViewInfo; override;
    procedure SetItems(const AStrings: TStrings);

    // IcxContainerInnerControl
    function GetControl: TWinControl;
    function GetControlContainer: TcxContainer;
    // IcxCustomInnerEdit
    function CallDefWndProc(AMsg: UINT; WParam: WPARAM; LParam: LPARAM): LRESULT;
    function CanProcessClipboardMessages: Boolean;
    function GetEditValue: TcxEditValue;
    function GetIAccessibilityHelper: IcxAccessibilityHelper;
    function GetOnChange: TNotifyEvent;
    function GetReadOnly: Boolean;
    procedure LockBounds(ALock: Boolean);
    procedure SafelySetFocus;
    procedure SetEditValue(const AValue: TcxEditValue);
    procedure SetOnChange(AValue: TNotifyEvent);
    procedure SetReadOnly(AValue: Boolean);

    property Container: TdxPDFListBox read GetContainer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DefaultHandler(var Message); override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;

    property OptionsView: TdxPDFInnerListBoxOptionsView read GetOptionsView write SetOptionsView;
  end;

  { TdxPDFListBoxProperties }

  TdxPDFListBoxProperties = class(TcxCustomEditProperties)
  strict private
    FItems: TStringList;
    FMultiSelect: Boolean;
    FOffset: Integer;
    //
    procedure SetMultiSelect(const AValue: Boolean);
    procedure SetItems(const AValue: TStringList);
    procedure SetOffset(const Value: Integer);
  protected
    procedure DoAssign(AProperties: TcxCustomEditProperties); override;
    function HasDisplayValue: Boolean; override;
  public
    class function GetContainerClass: TcxContainerClass; override;
    //
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    function CanCompareEditValue: Boolean; override;
    //
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect;
    property Items: TStringList read FItems write SetItems;
    property Offset: Integer read FOffset write SetOffset;
  end;

  { TdxPDFListBox }

  TdxPDFListBox = class(TcxCustomEdit)
  strict private
    function GetActiveProperties: TdxPDFListBoxProperties; inline;
    function GetInnerListBox: TdxPDFInnerListBox; inline;
  protected
    procedure AdjustInnerControl; override;
    procedure AdjustInnerEditPosition; override;
    function DoRefreshContainer(const P: TPoint; Button: TcxMouseButton; Shift: TShiftState;
      AIsMouseEvent: Boolean): Boolean; override;
    function GetDisplayValue: Variant; override;
    function GetInnerEditClass: TControlClass; override;
    procedure InternalSetDisplayValue(const Value: Variant); override;
    function IsEditClass: Boolean; override;
    procedure PrepareDisplayValue(const AEditValue: Variant; var DisplayValue: Variant; AEditFocused: Boolean); override;
    procedure PropertiesChanged(Sender: TObject); override;
    procedure SetInternalDisplayValue(Value: TcxEditValue); override;
    procedure SynchronizeDisplayValue; override;
    procedure SynchronizeEditValue; override;
    property InnerListBox: TdxPDFInnerListBox read GetInnerListBox;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    procedure PrepareEditValue(const ADisplayValue: Variant; out AEditValue: Variant; AEditFocused: Boolean); override;

    property ActiveProperties: TdxPDFListBoxProperties read GetActiveProperties;
  end;

  { TdxPDFAdjustFontSizeHelper }

  TdxPDFAdjustFontSizeHelper = class(TdxAdjustFontSizeHelper)
  type
    TRoundProc = function (const AValue: Single): Integer;
  strict protected const
    MinFontSize = 1;
    MaxFontSize = 10000;
    DefaultViewerZoomScaleFactor = 1;
  strict private
    FViewerZoomScaleFactor: Single;
    FMultiLine: Boolean;
    function ValidateSizeLimitation(ASize: Integer): Integer;
    function ValidateSize(ASize: Integer; const ARoundProc: TRoundProc): Integer;
    function GetInternalMinFontSize: Single;
    function GetInternalMaxFontSize: Single;
    function GetInternalFontSize: Single;
  protected
    function CompareTextSize(ATextSize, AAvailableSize: Integer): Integer; override;
    function GetMinFontSize: Integer; override;
  public
    constructor Create;
    procedure Calculate(const ABoundsSize: TSize; const AText: string; AFont: TFont);
    class procedure Execute(const ABoundsSize: TSize; const AText: string; AFont: TFont; AMultiLine: Boolean; AViewerZoomScaleFactor: Single);
    property ViewerZoomScaleFactor: Single read FViewerZoomScaleFactor write FViewerZoomScaleFactor; 
    property MultiLine: Boolean read FMultiLine write FMultiLine;
  end;

constructor TdxPDFAdjustFontSizeHelper.Create;
begin
  inherited Create;
  FViewerZoomScaleFactor := DefaultViewerZoomScaleFactor;
end;

function TdxPDFAdjustFontSizeHelper.CompareTextSize(ATextSize, AAvailableSize: Integer): Integer;
begin
  Result := ATextSize - AAvailableSize;
  if not MultiLine then
    Inc(Result, 2);
end;

function TdxPDFAdjustFontSizeHelper.GetMinFontSize: Integer;
begin
  Result := ValidateSizeLimitation(Floor(GetInternalMinFontSize));
end;

function TdxPDFAdjustFontSizeHelper.ValidateSizeLimitation(ASize: Integer): Integer;
begin
  Result := EnsureRange(ASize, MinFontSize, MaxFontSize);
end;

function TdxPDFAdjustFontSizeHelper.ValidateSize(ASize: Integer; const ARoundProc: TRoundProc): Integer;
begin
  Result := ValidateSizeLimitation(ARoundProc(EnsureRange(ASize, GetInternalMinFontSize, GetInternalMaxFontSize)));
end;

function TdxPDFAdjustFontSizeHelper.GetInternalMinFontSize: Single;
begin
  Result := ViewerZoomScaleFactor * TdxPDFInteractiveFormFieldTextState.DefaultMinFontSize
end;

function TdxPDFAdjustFontSizeHelper.GetInternalMaxFontSize: Single;
begin
  Result := ViewerZoomScaleFactor * TdxPDFInteractiveFormFieldTextState.DefaultMaxFontSize
end;

function TdxPDFAdjustFontSizeHelper.GetInternalFontSize: Single;
begin
  Result := ViewerZoomScaleFactor * TdxPDFInteractiveFormFieldTextState.DefaultFontSize;
end;

procedure TdxPDFAdjustFontSizeHelper.Calculate(const ABoundsSize: TSize; const AText: string; AFont: TFont);

  function GetActualMaxSize: Integer;
  begin
    Result := Ceil((ABoundsSize.Height) * 72 / AFont.PixelsPerInch);
    Result := ValidateSize(Result, Ceil);
    if MultiLine then
      Result := ValidateSizeLimitation(Ceil(Min(Result, GetInternalFontSize)));
  end;

begin
  Font.Assign(AFont);
  inherited Calculate(ABoundsSize, AText, MultiLine, 0, GetActualMaxSize);
  AFont.Size := ValidateSize(Font.Size, Floor);
end;

class procedure TdxPDFAdjustFontSizeHelper.Execute(const ABoundsSize: TSize; const AText: string; AFont: TFont; AMultiLine: Boolean; AViewerZoomScaleFactor: Single);
var
  AHelper: TdxPDFAdjustFontSizeHelper;
begin
  AHelper := TdxPDFAdjustFontSizeHelper.Create;
  try
    AHelper.ViewerZoomScaleFactor := AViewerZoomScaleFactor;
    AHelper.MultiLine := AMultiLine;
    AHelper.Calculate(ABoundsSize, AText, AFont);
  finally
    AHelper.Free;
  end;
end;

{ TdxPDFViewerButtonFieldWidgetViewInfo }

function TdxPDFViewerButtonFieldWidgetViewInfo.GetAction: TdxPDFInteractiveOperation;
begin
  Result := (Annotation as TdxPDFActionAnnotation).InteractiveOperation;
end;

function TdxPDFViewerButtonFieldWidgetViewInfo.GetCursor: TCursor;
begin
  Result := crHandPoint;
end;

function TdxPDFViewerButtonFieldWidgetViewInfo.GetHitCode: Integer;
begin
  Result := hcButton;
end;

procedure TdxPDFViewerButtonFieldWidgetViewInfo.Execute(AShift: TShiftState = []);
begin
  (Controller as TdxPDFViewerController).ExecuteOperation(GetAction);
end;

{ TdxPDFInnerListBoxPainter }

function TdxPDFInnerListBoxPainter.GetBackgroundColor: TColor;
begin
  Result := TdxPDFInnerListBox(TreeView).Color;
end;

function TdxPDFInnerListBoxPainter.GetTextColor(
  ANodeViewInfo: TdxTreeViewNodeViewInfo): TColor;
begin
  if ANodeViewInfo.Node.Selected then
    Result := inherited GetTextColor(ANodeViewInfo)
  else
    Result := TdxPDFInnerListBox(TreeView).Container.Style.TextColor;
end;

{ TdxPDFInnerListBoxNodeViewInfo }

function TdxPDFInnerListBoxNodeViewInfo.GetLevelOffset: Integer;
begin
  Result := inherited GetLevelOffset;
  if Node <> nil then
    Inc(Result, TdxPDFInnerListBox(TreeView).OptionsView.Offset);
end;

function TdxPDFInnerListBoxNodeViewInfo.MeasureHeight(AImageSize,
  AExpandButtonSize, ACheckHeight, ATextHeight: Integer): Integer;
begin
  Result := ATextHeight;
end;

{ TdxPDFInnerListBoxViewInfo }

function TdxPDFInnerListBoxViewInfo.CreateNodeViewInfo: TdxTreeViewNodeViewInfo;
begin
  Result := TdxPDFInnerListBoxNodeViewInfo.Create(TreeView);
end;

{ TdxPDFInnerListBoxOptionsView }

procedure TdxPDFInnerListBoxOptionsView.SetOffset(const Value: Integer);
begin
  if Offset <> Value then
  begin
    FOffset := Value;
    Changed([tvcLayout]);
  end;
end;

{ TdxPDFInnerListBox }

function TdxPDFInnerListBox.GetContainer: TdxPDFListBox;
begin
  if Parent is TdxPDFListBox then
    Result := TdxPDFListBox(Parent)
  else
    Result := nil;
end;

function TdxPDFInnerListBox.GetControl: TWinControl;
begin
  Result := Self;
end;

function TdxPDFInnerListBox.GetControlContainer: TcxContainer;
begin
  Result := Parent as TcxCustomEdit;
end;

function TdxPDFInnerListBox.CallDefWndProc(AMsg: UINT; WParam: WPARAM; LParam: LPARAM): LRESULT;
begin
  Result := CallWindowProc(DefWndProc, Handle, AMsg, WParam, LParam);
end;

function TdxPDFInnerListBox.CanProcessClipboardMessages: Boolean;
begin
  Result := False;
end;

constructor TdxPDFInnerListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderStyle := cxcbsNone;
  OptionsView.ShowRoot := False;
  OptionsView.ShowLines := False;
  OptionsView.RowSelect := True;
  ParentColor := True;
  ParentFont := True;
end;

function TdxPDFInnerListBox.CreateOptionsView: TdxTreeViewCustomOptionsView;
begin
  Result := TdxPDFInnerListBoxOptionsView.Create(Self);
end;

procedure TdxPDFInnerListBox.DefaultHandler(var Message);
begin
  if Container <> nil then
  begin
    if not Container.InnerControlDefaultHandler(TMessage(Message)) then
      inherited DefaultHandler(Message);
  end
  else
    inherited DefaultHandler(Message);
end;

function TdxPDFInnerListBox.GetEditValue: TcxEditValue;
var
  AResult: TdxIntegerList;
  I: Integer;
begin
  AResult := TdxIntegerList.Create;
  try
    AResult.Add(TopItem.Index);
    for I := 0 to SelectionCount - 1 do
      AResult.Add(Selections[I].Index);
    if FocusedNode.Selected then
    begin
      AResult.Remove(FocusedNode.Index);
      AResult.Add(FocusedNode.Index);
    end;
    Result := AResult.ToArray;
  finally
    AResult.Free;
  end;
end;

function TdxPDFInnerListBox.GetIAccessibilityHelper: IcxAccessibilityHelper;
begin
  Result := nil;
end;

function TdxPDFInnerListBox.GetOnChange: TNotifyEvent;
begin
  Result := OnSelectionChanged;
end;

function TdxPDFInnerListBox.GetOptionsView: TdxPDFInnerListBoxOptionsView;
begin
  Result := TdxPDFInnerListBoxOptionsView(inherited OptionsView);
end;

function TdxPDFInnerListBox.GetReadOnly: Boolean;
begin
  Result := False;
end;

procedure TdxPDFInnerListBox.LockBounds(ALock: Boolean);
begin
  if ALock then
    Inc(FLockBoundsCount)
  else
    Dec(FLockBoundsCount);
end;

procedure TdxPDFInnerListBox.SafelySetFocus;
begin
  SetFocus;
end;

procedure TdxPDFInnerListBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (Container <> nil) and (FLockBoundsCount = 0) then
  begin
    Container.LockAlignControls(True);
    try
      inherited SetBounds(ALeft, ATop, AWidth, AHeight);
    finally
      Container.LockAlignControls(False);
    end;
  end
  else
    inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

procedure TdxPDFInnerListBox.SetEditValue(const AValue: TcxEditValue);
var
  I: Integer;
  AIndex: Integer;
  ANode: TdxTreeViewNode;
  AFirst, ALast: Integer;
begin
  BeginSelect;
  try
    ClearSelection(True);
    AFirst := VarArrayLowBound(AValue, 1);
    ALast := VarArrayHighBound(AValue, 1);
    for I := AFirst to ALast do
    begin
      AIndex := AValue[I];
      if (AIndex >= 0) and (Root.Count > AIndex) then
      begin
        ANode := Root.Items[AIndex];
        if I = 0 then
          TopItem := ANode
        else
        begin
          if OptionsSelection.MultiSelect then
          begin
            if not ANode.Selected then
              Select(ANode, [ssCtrl], I = ALast)
          end
          else
          begin
            ANode.Focused := I = 0;
            ANode.Selected := I > 0;
          end;
        end;
      end;
    end;
  finally
    EndSelect;
  end;
end;

function TdxPDFInnerListBox.CreatePainter: TdxTreeViewPainter;
begin
  Result := TdxPDFInnerListBoxPainter.Create(Self);
end;

function TdxPDFInnerListBox.CreateViewInfo: TdxTreeViewViewInfo;
begin
  Result := TdxPDFInnerListBoxViewInfo.Create(Self);
end;

procedure TdxPDFInnerListBox.SetItems(const AStrings: TStrings);
var
  I: Integer;
begin
  Items.BeginUpdate;
  try
    Items.Clear;
    for I := 0 to AStrings.Count - 1 do
      Items.Add(Root, AStrings[I]);
  finally
    Items.EndUpdate;
  end;
end;

procedure TdxPDFInnerListBox.SetReadOnly(AValue: Boolean);
begin
// do nothing
end;

procedure TdxPDFInnerListBox.SetOnChange(AValue: TNotifyEvent);
begin
  OnSelectionChanged := AValue;
end;

procedure TdxPDFInnerListBox.SetOptionsView(
  const Value: TdxPDFInnerListBoxOptionsView);
begin
  inherited OptionsView := Value;
end;

{ TdxPDFListBox }

constructor TdxPDFListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style.TransparentBorder := False;
  Style.BorderStyle := ebsNone;
  BorderStyle := cxcbsNone;
  ParentFont := False;
end;

procedure TdxPDFListBox.InternalSetDisplayValue(const Value: Variant);
begin
  DataBinding.DisplayValue := Value;
  if not IsUserAction then
  begin
    SynchronizeEditValue;
    EditModified := False;
  end;
end;

function TdxPDFListBox.IsEditClass: Boolean;
begin
  Result := True;
end;

function TdxPDFListBox.GetActiveProperties: TdxPDFListBoxProperties;
begin
  Result := TdxPDFListBoxProperties(inherited ActiveProperties);
end;

function TdxPDFListBox.GetInnerListBox: TdxPDFInnerListBox;
begin
  Result := TdxPDFInnerListBox(InnerControl);
end;

function TdxPDFListBox.GetDisplayValue: Variant;
begin
  if InnerEdit <> nil then
    Result := InnerEdit.EditValue
  else
    Result := inherited GetDisplayValue;
end;

function TdxPDFListBox.GetInnerEditClass: TControlClass;
begin
  Result := TdxPDFInnerListBox;
end;

procedure TdxPDFListBox.AdjustInnerControl;
begin
  InnerListBox.LookAndFeel.MasterLookAndFeel := Style.LookAndFeel;
  inherited AdjustInnerControl;
end;

procedure TdxPDFListBox.AdjustInnerEditPosition;
var
  AInnerEditBounds: TRect;
begin
  AInnerEditBounds := ClientRect;
  InnerEdit.Control.SetBounds(AInnerEditBounds.Left, AInnerEditBounds.Top, AInnerEditBounds.Width, AInnerEditBounds.Height);
  AlignControls(InnerEdit.Control, AInnerEditBounds);
end;

function TdxPDFListBox.DoRefreshContainer(const P: TPoint; Button: TcxMouseButton; Shift: TShiftState;
  AIsMouseEvent: Boolean): Boolean;
begin
  Result := inherited DoRefreshContainer(P, Button, Shift, AIsMouseEvent);
  if Result then
    AdjustInnerControl;
end;

procedure TdxPDFListBox.PrepareDisplayValue(const AEditValue: Variant;
  var DisplayValue: Variant; AEditFocused: Boolean);
begin
  DisplayValue := AEditValue;
end;

procedure TdxPDFListBox.PrepareEditValue(const ADisplayValue: Variant;
  out AEditValue: Variant; AEditFocused: Boolean);
begin
  AEditValue := ADisplayValue;
end;

procedure TdxPDFListBox.PropertiesChanged(Sender: TObject);
begin
  inherited PropertiesChanged(Sender);
  InnerListBox.SetItems(ActiveProperties.Items);
  InnerListBox.OptionsSelection.MultiSelect := ActiveProperties.MultiSelect;
  InnerListBox.OptionsView.Offset := ActiveProperties.Offset;
end;

procedure TdxPDFListBox.SetInternalDisplayValue(Value: TcxEditValue);
begin
  if InnerEdit <> nil then
    InnerEdit.EditValue := Value;
end;

procedure TdxPDFListBox.SynchronizeDisplayValue;
begin
  inherited SynchronizeDisplayValue;
  DataBinding.DisplayValue := EditValue;
end;

procedure TdxPDFListBox.SynchronizeEditValue;
var
  APrevEditValue, ANewEditValue: TcxEditValue;
  ACompareEditValue, AEditValueChanged: Boolean;
begin
  ACompareEditValue := ActiveProperties.CanCompareEditValue;
  if ACompareEditValue then
    APrevEditValue := EditValue
  else
    APrevEditValue := Null;
  PrepareEditValue(DisplayValue, ANewEditValue, InternalFocused);
  InternalStoreEditValue(ANewEditValue);

  if ACompareEditValue then
    AEditValueChanged := not InternalVarEqualsExact(APrevEditValue, ANewEditValue)
  else
    AEditValueChanged := False;
  if IsUserAction then
    ModifiedAfterEnter := True
  else
    EditModified := False;
  if AEditValueChanged then
    DoEditValueChanged;
end;

class function TdxPDFListBox.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxPDFListBoxProperties;
end;

{ TdxPDFListBoxProperties }

constructor TdxPDFListBoxProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FItems := TStringList.Create;
end;

destructor TdxPDFListBoxProperties.Destroy;
begin
  FreeAndNil(FItems);
  inherited Destroy;
end;

class function TdxPDFListBoxProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TdxPDFListBox;
end;

function TdxPDFListBoxProperties.CanCompareEditValue: Boolean;
begin
  Result := True;
end;

function TdxPDFListBoxProperties.HasDisplayValue: Boolean;
begin
  Result := True;
end;

procedure TdxPDFListBoxProperties.SetMultiSelect(const AValue: Boolean);
begin
  if FMultiSelect <> AValue then
  begin
    FMultiSelect := AValue;
    Changed;
  end;
end;

procedure TdxPDFListBoxProperties.SetItems(const AValue: TStringList);
begin
  FItems.Assign(AValue);
  Changed;
end;

procedure TdxPDFListBoxProperties.SetOffset(const Value: Integer);
begin
  if Offset <> Value then
  begin
    FOffset := Value;
    Changed;
  end;
end;

procedure TdxPDFListBoxProperties.DoAssign(AProperties: TcxCustomEditProperties);
var
  AActualProperties: TdxPDFListBoxProperties absolute AProperties;
begin
  inherited DoAssign(AProperties);
  FItems.BeginUpdate;
  try
    FItems.Clear;
    FItems.Assign(AActualProperties.Items);
    FMultiSelect := AActualProperties.MultiSelect;
    FOffset := AActualProperties.Offset;
  finally
    FItems.EndUpdate;
  end;
end;

{ TdxPDFViewerChoiceFieldWidgetViewInfo }

function TdxPDFViewerChoiceFieldWidgetViewInfo.GetCursor: TCursor;
begin
  Result := GetRotatedWidgetCursor(crIBeam);
end;

function TdxPDFViewerChoiceFieldWidgetViewInfo.GetEditValue: Variant;
begin
  if (Field.ItemCount > 0) and (Field.ItemIndex <> -1) then
    Result := Field[Field.ItemIndex].Value
  else
    Result := inherited GetEditValue;
end;

procedure TdxPDFViewerChoiceFieldWidgetViewInfo.InitProperties(AProperties: TcxCustomEditProperties);
begin
  inherited InitProperties(AProperties);
  AProperties.ImmediatePost := Field.ImmediatePost;
  InitItems(GetPropertiesItems(AProperties));
end;

procedure TdxPDFViewerChoiceFieldWidgetViewInfo.SetEditValue(const AValue: Variant);
begin
  Field.ItemIndex := Field.IndexOf(AValue);
end;

function TdxPDFViewerChoiceFieldWidgetViewInfo.GetField: TdxPDFChoiceField;
begin
  Result := inherited Field as TdxPDFChoiceField;
end;

procedure TdxPDFViewerChoiceFieldWidgetViewInfo.InitItems(AItems: TStrings);
var
  I: Integer;
begin
  AItems.BeginUpdate;
  try
    AItems.Clear;
    for I := 0 to Field.ItemCount - 1 do
      AItems.Add(Field[I].Value);
  finally
    AItems.EndUpdate;
  end;
end;

{ TdxPDFViewerTextFieldWidgetViewInfo }

function TdxPDFViewerTextFieldWidgetViewInfo.GetCursor: TCursor;
begin
  Result := GetRotatedWidgetCursor(crIBeam);
end;

function TdxPDFViewerTextFieldWidgetViewInfo.GetEditValue: Variant;
begin
  Result := Field.Text;
end;

function TdxPDFViewerTextFieldWidgetViewInfo.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  if IsMultiLine then
    Result := TcxMemoProperties
  else
    Result := TcxTextEditProperties;
end;

procedure TdxPDFViewerTextFieldWidgetViewInfo.InitFont(AFont: TFont);
begin
  inherited InitFont(AFont);
  TdxPDFViewerWidgetTextBasedEditViewInfo.InitFont(Self, AFont);
end;

procedure TdxPDFViewerTextFieldWidgetViewInfo.UpdateEditFontSize(AEdit: TcxCustomEdit);
begin
  TdxPDFViewerWidgetTextBasedEditViewInfo.UpdateFontSize(Self, AEdit);
end;

function TdxPDFViewerTextFieldWidgetViewInfo.IsMultiLine: Boolean;
begin
  Result := TdxPDFTextFieldAccess(Field).MultiLine
end;

function TdxPDFViewerTextFieldWidgetViewInfo.NeedExtraSymbolWidthForEditor: Boolean;
begin
  Result := not IsMultiLine;
end;

procedure TdxPDFViewerTextFieldWidgetViewInfo.InitProperties(AProperties: TcxCustomEditProperties);
const
  EchoModeMap: array[TdxPDFTextFieldInputType] of TcxEditEchoMode = (eemNormal, eemPassword);
var
  AActualProperties: TcxCustomTextEditProperties;
  AMemoProperties: TcxMemoProperties;
begin
  inherited InitProperties(AProperties);
  AActualProperties := AProperties as TcxCustomTextEditProperties;
  AActualProperties.EchoMode := EchoModeMap[Field.InputType];
  AActualProperties.MaxLength := Field.MaxLength;
  if IsMultiLine then
  begin
    AMemoProperties := AProperties as TcxMemoProperties;
    if TdxPDFTextFieldAccess(Field).Scrollable then
      AMemoProperties.ScrollBars := TcxScrollStyle.ssVertical
    else
      AMemoProperties.ScrollBars := TcxScrollStyle.ssNone;
  end;
end;

procedure TdxPDFViewerTextFieldWidgetViewInfo.SetEditValue(const AValue: Variant);
begin
  Field.Text := AValue;
end;

function TdxPDFViewerTextFieldWidgetViewInfo.GetField: TdxPDFTextField;
begin
  Result := inherited Field as TdxPDFTextField;
end;

{ TdxPDFViewerRadioGroupFieldItemWidgetViewInfo }

function TdxPDFViewerRadioGroupFieldItemWidgetViewInfo.AllowActivateByMouseDown: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerRadioGroupFieldItemWidgetViewInfo.GetCursor: TCursor;
begin
  Result := crHandPoint;
end;

function TdxPDFViewerRadioGroupFieldItemWidgetViewInfo.UseWindowRegion(out ARegion: TcxRegion): Boolean;
begin
  Result := False;
end;

procedure TdxPDFViewerRadioGroupFieldItemWidgetViewInfo.Execute(AShift: TShiftState = []);
begin
  Group.ItemIndex := Group.IndexOf(Field);
end;

function TdxPDFViewerRadioGroupFieldItemWidgetViewInfo.GetField: TdxPDFRadioGroupFieldItem;
begin
  Result := inherited Field as TdxPDFRadioGroupFieldItem;
end;

function TdxPDFViewerRadioGroupFieldItemWidgetViewInfo.GetGroupField: TdxPDFRadioGroupField;
begin
  Result := TdxPDFRadioGroupFieldItemAccess(Field).Group;
end;

{ TdxPDFViewerCheckBoxFieldWidgetViewInfo }

function TdxPDFViewerCheckBoxFieldWidgetViewInfo.AllowActivateByMouseDown: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerCheckBoxFieldWidgetViewInfo.GetCursor: TCursor;
begin
  Result := crHandPoint;
end;

function TdxPDFViewerCheckBoxFieldWidgetViewInfo.UseWindowRegion(out ARegion: TcxRegion): Boolean;
begin
  Result := False;
end;

procedure TdxPDFViewerCheckBoxFieldWidgetViewInfo.Execute;
var
  AField: TdxPDFCheckBoxField;
begin
  AField := Field;
  AField.Checked := not AField.Checked;
end;

function TdxPDFViewerCheckBoxFieldWidgetViewInfo.GetField: TdxPDFCheckBoxField;
begin
  Result := inherited Field as TdxPDFCheckBoxField;
end;

{ TdxPDFViewerWidgetTextBasedEditViewInfo }

constructor TdxPDFViewerWidgetTextBasedEditViewInfo.Create(AWidget: TdxPDFViewerWidgetViewInfo);
begin
  inherited Create;
  FWidget := AWidget;
  FFont := TFont.Create;
  FEditViewInfo := TdxPDFViewerWidgetViewInfoAccess(FWidget).GetPropertiesClass.GetViewInfoClass.Create as TcxCustomEditViewInfo;
  FEditViewInfo.Transparent := False;
  FEditViewInfo.Owner := FWidget.Viewer;
end;

destructor TdxPDFViewerWidgetTextBasedEditViewInfo.Destroy;
begin
  FreeAndNil(FFont);
  FreeAndNil(FEditViewInfo);
  inherited Destroy;
end;

procedure TdxPDFViewerWidgetTextBasedEditViewInfo.CalculateEditViewInfo;
var
  AProperties: TcxCustomEditProperties;
  AStyle: TcxCustomEditStyle;
  AViewData: TcxCustomEditViewData;
begin
  if not FWidget.TryGetProperties(AProperties) then
    Exit;

  AStyle := AProperties.GetStyleClass.Create(nil, True);
  try
    AStyle.Font := FFont;
    FWidget.InitStyle(AStyle);
    AViewData := AProperties.CreateViewData(AStyle, True, FWidget.ScaleFactor);
    try
      AViewData.PaintOptions := [];
      if FWidget.IsMultiLine then
      begin
        Include(AViewData.PaintOptions, epoAutoHeight);
        AViewData.MaxLineCount := 0;
      end;
      Include(AViewData.PaintOptions, epoShowEndEllipsis);

      AViewData.SelLength := 0;
      AViewData.EditValueToDrawValue(FWidget.EditValue, FEditViewInfo);

      AViewData.Calculate(FWidget.Canvas, FWidget.EditBounds, FWidget.MousePos, cxmbNone, [], FEditViewInfo, True);
    finally
      AViewData.Free;
    end;
  finally
    AStyle.Free;
  end;
end;

procedure TdxPDFViewerWidgetTextBasedEditViewInfo.Calculate;
begin
  CalculateEditViewInfo;
end;

procedure TdxPDFViewerWidgetTextBasedEditViewInfo.DrawDropDownButton(ACanvas: TcxCanvas);
begin
  FEditViewInfo.DrawButton(ACanvas, 0);
end;


class procedure TdxPDFViewerWidgetTextBasedEditViewInfo.AdjustFontSize(AWidget: TdxPDFViewerWidgetViewInfo; const AText: string; AFont: TFont);
begin
  TdxPDFAdjustFontSizeHelper.Execute(AWidget.EditBounds.Size, AText, AFont, AWidget.IsMultiLine, AWidget.ViewerDocumentScaleFactor);
end;

class procedure TdxPDFViewerWidgetTextBasedEditViewInfo.InitFont(AWidget: TdxPDFViewerWidgetViewInfo; AFont: TFont);
begin
  if IsZero(AWidget.OriginalFontSize) then
    AdjustFontSize(AWidget, AWidget.EditValue, AFont)
  else
    AFont.Height := AWidget.ScaledFontSize;
end;

class procedure TdxPDFViewerWidgetTextBasedEditViewInfo.UpdateFontSize(AWidget: TdxPDFViewerWidgetViewInfo; AEdit: TcxCustomEdit);
begin
  if not IsZero(AWidget.OriginalFontSize) then
    Exit;
  AdjustFontSize(AWidget, AEdit.EditingValue, AEdit.Style.Font);
  AEdit.ShortRefreshContainer(False);
end;

procedure TdxPDFViewerWidgetTextBasedEditViewInfo.Offset(const AOffset: TPoint);
begin
  CalculateEditViewInfo;
end;

procedure TdxPDFViewerWidgetTextBasedEditViewInfo.UpdateState;
begin
  CalculateEditViewInfo;
  FWidget.Viewer.InvalidateRect(FWidget.EditBounds, False);
end;

{ TdxPDFViewerListBoxFieldWidgetViewInfo }

function TdxPDFViewerListBoxFieldWidgetViewInfo.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TdxPDFListBoxProperties;
end;

function TdxPDFViewerListBoxFieldWidgetViewInfo.GetPropertiesItems(AProperties: TcxCustomEditProperties): TStrings;
begin
  Result := (AProperties as TdxPDFListBoxProperties).Items;
end;

procedure TdxPDFViewerListBoxFieldWidgetViewInfo.InitFont(AFont: TFont);
begin
  inherited InitFont(AFont);
  TdxPDFViewerWidgetTextBasedEditViewInfo.InitFont(Self, AFont);
end;

procedure TdxPDFViewerListBoxFieldWidgetViewInfo.InitProperties(AProperties: TcxCustomEditProperties);
var
  AActualProperties: TdxPDFListBoxProperties absolute AProperties;
begin
  inherited InitProperties(AProperties);
  AActualProperties.MultiSelect := Field.MultiSelect;
end;

procedure TdxPDFViewerListBoxFieldWidgetViewInfo.SetEditValue(const AValue: Variant);
var
  I: Integer;
  AIndex: Integer;
  AFirst, ALast: Integer;
begin
  Field.BeginUpdate;
  try
    Field.ItemIndex := -1;
    if not VarIsArray(AValue) then
      Exit;
    AFirst := VarArrayLowBound(AValue, 1);
    ALast := VarArrayHighBound(AValue, 1);
    for I := AFirst to ALast do
    begin
      AIndex := AValue[I];
      if I = AFirst then
        Field.TopIndex := AIndex
      else
        Field.Selected[AIndex] := True;
    end;
  finally
    Field.EndUpdate;
  end;
end;

function TdxPDFViewerListBoxFieldWidgetViewInfo.GetCursor: TCursor;
begin
  Result := crDefault;
end;

function TdxPDFViewerListBoxFieldWidgetViewInfo.GetEditValue: Variant;
var
  AResult: TdxIntegerList;
begin
  AResult := TdxIntegerList.Create;
  try
    AResult.Add(Field.TopIndex);
    AResult.AddRange(TdxPDFChoiceFieldAccess(Field).SelectedIndexes);
    Result := AResult.ToArray;
  finally
    AResult.Free;
  end;
end;

function TdxPDFViewerListBoxFieldWidgetViewInfo.GetField: TdxPDFListBoxField;
begin
  Result := inherited Field as TdxPDFListBoxField
end;

{ TdxPDFViewerSignatureFieldWidgetViewInfo }

function TdxPDFViewerSignatureFieldWidgetViewInfo.CanFocus: Boolean;
begin
  Result := False;
end;

function TdxPDFViewerSignatureFieldWidgetViewInfo.UseWindowRegion(out ARegion: TcxRegion): Boolean;
begin
  Result := False;
end;

{ TdxPDFComboBoxFieldWidgetViewInfo }

function TdxPDFComboBoxFieldWidgetViewInfo.GetCursor: TCursor;
var
  AEditViewInfo: TcxCustomEditViewInfo;
begin
  AEditViewInfo := FEditViewInfo.InnerViewInfo;
  if (Length(AEditViewInfo.ButtonsInfo) > 0) and PtInRect(AEditViewInfo.ButtonsInfo[0].Bounds, MousePos) then
    Result := crDefault
  else
    Result := inherited GetCursor;
  Result := GetRotatedWidgetCursor(Result);
end;

function TdxPDFComboBoxFieldWidgetViewInfo.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxComboBoxProperties;
end;

function TdxPDFComboBoxFieldWidgetViewInfo.GetPropertiesItems(AProperties: TcxCustomEditProperties): TStrings;
begin
  Result := (AProperties as TcxComboBoxProperties).Items;
end;

procedure TdxPDFComboBoxFieldWidgetViewInfo.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FEditViewInfo := TdxPDFViewerWidgetTextBasedEditViewInfo.Create(Self);
end;

procedure TdxPDFComboBoxFieldWidgetViewInfo.DestroySubClasses;
begin
  FreeAndNil(FEditViewInfo);
  inherited DestroySubClasses;
end;

procedure TdxPDFComboBoxFieldWidgetViewInfo.DoCalculate;
begin
  inherited DoCalculate;
  FEditViewInfo.Calculate;
end;

procedure TdxPDFComboBoxFieldWidgetViewInfo.DrawContent(ACanvas: TcxCanvas);
begin
  inherited DrawContent(ACanvas);
  if not IsRotated then
    FEditViewInfo.DrawDropDownButton(ACanvas);
end;

procedure TdxPDFComboBoxFieldWidgetViewInfo.InitFont(AFont: TFont);
begin
  inherited InitFont(AFont);
  FEditViewInfo.InitFont(Self, AFont);
end;

procedure TdxPDFComboBoxFieldWidgetViewInfo.Offset(const AOffset: TPoint);
begin
  inherited Offset(AOffset);
  FEditViewInfo.Offset(AOffset);
end;

procedure TdxPDFComboBoxFieldWidgetViewInfo.UpdateState;
begin
  FEditViewInfo.UpdateState;
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFViewerRegisterDocumentObjectViewInfo(TdxPDFButtonField, TdxPDFViewerButtonFieldWidgetViewInfo);
  dxPDFViewerRegisterDocumentObjectViewInfo(TdxPDFComboBoxField, TdxPDFComboBoxFieldWidgetViewInfo);
  dxPDFViewerRegisterDocumentObjectViewInfo(TdxPDFTextField, TdxPDFViewerTextFieldWidgetViewInfo);
  dxPDFViewerRegisterDocumentObjectViewInfo(TdxPDFRadioGroupFieldItem, TdxPDFViewerRadioGroupFieldItemWidgetViewInfo);
  dxPDFViewerRegisterDocumentObjectViewInfo(TdxPDFCheckBoxField, TdxPDFViewerCheckBoxFieldWidgetViewInfo);
  dxPDFViewerRegisterDocumentObjectViewInfo(TdxPDFListBoxField, TdxPDFViewerListBoxFieldWidgetViewInfo);
  dxPDFViewerRegisterDocumentObjectViewInfo(TdxPDFSignatureField, TdxPDFViewerSignatureFieldWidgetViewInfo);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFViewerUnregisterDocumentObjectViewInfo(TdxPDFListBoxField);
  dxPDFViewerUnregisterDocumentObjectViewInfo(TdxPDFCheckBoxField);
  dxPDFViewerUnregisterDocumentObjectViewInfo(TdxPDFRadioGroupField);
  dxPDFViewerUnregisterDocumentObjectViewInfo(TdxPDFTextField);
  dxPDFViewerUnregisterDocumentObjectViewInfo(TdxPDFComboBoxField);
  dxPDFViewerUnregisterDocumentObjectViewInfo(TdxPDFButtonField);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.


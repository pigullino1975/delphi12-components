{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressEditors                                           }
{                                                                    }
{           Copyright (c) 1998-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSEDITORS AND ALL                }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
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

unit cxCheckComboBox;

interface

{$I cxVer.inc}

uses
  Types, Variants, Windows, Messages, SysUtils, Classes, Controls, Graphics,
  StdCtrls, Forms, Math,
  dxCore, dxCoreClasses, cxClasses, cxControls, cxContainer, cxGraphics, dxGDIPlusClasses,
  cxDataStorage, cxDataUtils, cxVariants, cxEdit, cxEditUtils,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxImageComboBox,
  cxExtEditUtils, cxCheckBox, cxLookAndFeels, cxExtEditConsts,
  cxGroupBox, cxFilterControlUtils, cxLookAndFeelPainters, cxAccessibility;

type
  { TcxCheckComboBoxItem }

  TcxCheckComboBoxItem = class(TcxButtonGroupItem)
  private
    FShortDescription: TCaption;
    function GetDescription: TCaption;
    procedure SetDescription(const Value: TCaption);
    procedure SetShortDescription(const Value: TCaption);
  protected
    function GetDisplayDescription: string; virtual;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Description: TCaption read GetDescription write SetDescription;
    property Enabled;
    property ShortDescription: TCaption read FShortDescription
      write SetShortDescription;
    property Tag;
  end;

  { TcxCheckComboBoxItems }

  TcxCheckComboBoxItems = class(TcxButtonGroupItems)
  private
    function GetItems(Index: Integer): TcxCheckComboBoxItem;
    procedure SetItems(Index: Integer; const Value: TcxCheckComboBoxItem);
  public
    function Add: TcxCheckComboBoxItem;
    function AddCheckItem(const ADescription: TCaption;
      const AShortDescription: TCaption = ''): TcxCheckComboBoxItem;
    property Items[Index: Integer]: TcxCheckComboBoxItem read GetItems write SetItems; default;
  end;

  { TcxCustomCheckComboBoxViewData }

  TcxCustomCheckComboBoxProperties = class;

  TcxCustomCheckComboBoxViewData = class(TcxCustomDropDownEditViewData)
  protected
    function GetProperties: TcxCustomCheckComboBoxProperties;
    function InternalEditValueToDisplayText(AEditValue: TcxEditValue): string; override;
    function IsComboBoxStyle: Boolean; override;
  public
    property Properties: TcxCustomCheckComboBoxProperties read GetProperties;
  end;

  { TdxCheckComboBoxListBoxToggleProvider }

  TcxCustomCheckComboBox = class;

  TdxCheckComboBoxListBoxToggleProvider = class(TdxToggleProvider) // for internal use
  strict private
    FCheckComboBox: TcxCustomCheckComboBox;
  protected
    FItemIndex: Integer;

    procedure DoToggle; override;
    function GetToggleState: Integer; override;
  public
    constructor Create(ACheckComboBox: TcxCustomCheckComboBox);
  end;

  { TdxCheckComboBoxListBoxAccessibilityHelper }

  TcxCustomCheckComboBoxListBox = class;

  TdxCheckComboBoxListBoxAccessibilityHelper = class(TdxCustomComboBoxListBoxAccessibilityHelper) // for internal use
  strict private
    FToggleProvider: TdxCheckComboBoxListBoxToggleProvider;

    function GetCheckComboBoxListBox: TcxCustomCheckComboBox;
  protected
    function GetName(AChildID: TcxAccessibleSimpleChildElementID): string; override;
    function GetState(AChildID: TcxAccessibleSimpleChildElementID): Integer; override;
    function IsSupportedPattern(APatternID: Integer; out AProvider: IInterface;
      AChildID: TcxAccessibleSimpleChildElementID = 0): Boolean; override;

    property CheckComboBox: TcxCustomCheckComboBox read GetCheckComboBoxListBox;
  public
    constructor Create(AOwnerObject: TObject); override;
    destructor Destroy; override;
  end;

  { TcxCheckComboBoxListBox }

  TcxCustomCheckComboBoxListBox = class(TcxCustomComboBoxListBox,
    IUnknown)
  private
    FCapturedCheckIndex: Integer;
    FCheckBorderOffset: Integer;
    FCheckSize: TSize;
    FElementIndent: Integer;
    FHotCheckIndex: Integer;
    FInternalUpdate: Boolean;
    FPressedCheckIndex: Integer;
    function GetCheckComboBoxItem(AIndex: Integer): TcxCheckComboBoxItem;
    function GetEdit: TcxCustomCheckComboBox;
    function GetItemCheckState(AIndex: Integer): TcxCheckBoxState;
    procedure SetItemCheckState(AIndex: Integer; AState: TcxCheckBoxState);
    procedure LBGetTextLen(var Message: TMessage); message LB_GETTEXTLEN;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure CalculatePadding; override;
    procedure CheckHotTrack;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure DrawItemContent(AIndex: Integer; ARect: TRect; AState: TOwnerDrawState); override;
    procedure FullRepaint;
    function GetAccessibilityHelperClass: TdxCustomInnerListBoxAccessibilityHelperClass; override;
    function GetCheckAt(X, Y: Integer): Integer;
    function GetCheckRect(const R: TRect; AReturnFullRect: Boolean): TRect;
    function GetDefaultItemHeight: Integer; override;
    function GetRealStyle: TListBoxStyle; override;
    procedure InternalMouseMove(Shift: TShiftState; X, Y: Integer);
    procedure InvalidateCheck(Index: Integer);
    procedure KeyPress(var Key: Char); override;
    procedure LookAndFeelChanged(Sender: TcxLookAndFeel;
      AChangedValues: TcxLookAndFeelValues); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure RecreateWindow; override;
    procedure SetItemIndex(const Value: Integer); override;
    procedure SynchronizeCheckStates(ANewHotCheckIndex, ANewPressedIndex: Integer);
    procedure UpdateItemState(const AIndex: Integer); virtual;
    property Edit: TcxCustomCheckComboBox read GetEdit;
  public
    constructor Create(AOwner: TComponent); override;
    function GetItemWidth(AIndex: Integer): Integer; override;
  end;

  TcxCheckComboBoxIncrementalFilteringHelper = class(TcxComboBoxIncrementalFilteringHelper)
  protected
    procedure SearchEditKeyPress(Sender: TObject; var Key: Char); override;
  end;

  { TcxCheckComboBoxLookupData }

  TcxCheckComboBoxLookupData = class(TcxComboBoxLookupData)
  protected
    function CreateIncrementalFilteringHelper: TcxComboBoxIncrementalFilteringHelper; override;
    function GetListBoxClass: TcxCustomEditListBoxClass; override;
    function GetItem(Index: Integer): string; override;
    function GetItemCount: Integer; override;
  public
    procedure TextChanged; override;
  end;

  { TcxCheckPaintHelper }

  TcxCheckPaintHelper = class(TcxOwnedPersistent)
  private
    FStyle: TcxCustomEditStyle;
    FGlyph: TdxSmartGlyph;
    FGlyphCount: Integer;
    procedure SetStyle(Value: TcxCustomEditStyle);
  protected
    function GetNextState(Value: TcxCheckBoxState): TcxCheckBoxState; virtual;
    property Style: TcxCustomEditStyle read FStyle write SetStyle;
    property Glyph: TdxSmartGlyph read FGlyph write FGlyph;
    property GlyphCount: Integer read FGlyphCount write FGlyphCount;
    function CalcTextRect(const ARect: TRect; const ACheckState: TcxCheckBoxState): TRect; virtual;
    function CalcCheckPoint(const ARect: TRect; const ACheckState: TcxCheckBoxState): TPoint; virtual;
    function IsClickInCheck(const AItemRect: TRect; const ACheckState: TcxCheckBoxState;
      X, Y: Integer; const AUseRightToLeftAlignment: Boolean = False): Boolean;
    function GetCheckWidth: Integer; virtual;
  public
    constructor Create(AOwner : TPersistent); override;
    destructor Destroy; override;
  end;

  { TcxCustomCheckComboBoxProperties }

  TcxCheckComboClickCheckEvent = procedure(Sender: TObject; ItemIndex: Integer;
    var AllowToggle: Boolean) of object;

  TcxCustomCheckComboBoxProperties = class(TcxCustomComboBoxProperties, IdxMultiPartGlyphSupport)
  private
    FAllowGrayed: Boolean; // deprecated
    FCheckPaintHelper : TcxCheckPaintHelper;
    FDelimiter: string;
    FEditValueFormat: TcxCheckStatesValueFormat;
    FEmptySelectionText: string;
    FGlyph: TdxSmartGlyph;
    FGlyphCount: Integer;
    FItems: TcxCheckComboBoxItems;
    FShowEmptyText: Boolean;
    FOnClickCheck: TcxCheckComboClickCheckEvent;
    FOnEditValueToStates: TcxValueToCheckStatesEvent;
    FOnStatesToEditValue: TcxCheckStatesToValueEvent;

    function GetItems: TcxCheckComboBoxItems;
    function IsDelimiterStored: Boolean;
    function IsEmptySelectionTextStored: Boolean;
    procedure SetGlyph(Value: TdxSmartGlyph);
    procedure SetGlyphCount(Value: Integer);
    procedure SetDelimiter(Value: string);
    procedure SetEditValueFormat(Value: TcxCheckStatesValueFormat);
    procedure SetEmptySelectionText(Value: string);
    procedure SetShowEmptyText(Value: Boolean);
    procedure SetItems(const Value: TcxCheckComboBoxItems);

    procedure CheckEditValueFormat;
    function GetRealEditValueFormat: TcxCheckStatesValueFormatEx;
    procedure ItemsChanged(Sender: TObject; AItem: TCollectionItem);
  protected
    procedure DoAssign(AProperties: TcxCustomEditProperties); override;
    class function GetLookupDataClass: TcxInterfacedPersistentClass; override;
    class function GetPopupWindowClass: TcxCustomEditPopupWindowClass; override;
    class function GetViewDataClass: TcxCustomEditViewDataClass; override;
    function HasDisplayValue: Boolean; override;

    // IdxMultiPartGlyphSupport
    function GetGlyphCount: Integer;
    function GetStateCaption(AIndex: Integer): string;

    // IcxValueByItemIndexProvider
    function GetItemCount: Integer; override;

    procedure CalculateCheckStatesByEditValue(Sender: TObject;
      const AEditValue: TcxEditValue; var ACheckStates: TcxCheckStates); virtual;
    function CalculateDisplayValueByCheckStates(
      const ACheckStates: TcxCheckStates): string; virtual;
    function CalculateEditValueByCheckStates(Sender: TObject;
      const ACheckStates: TcxCheckStates): TcxEditValue; virtual;
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed stored False; // deprecated
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    class function GetContainerClass: TcxContainerClass; override;
    function GetEditValueSource(AEditFocused: Boolean): TcxDataEditValueSource; override;
    function GetSupportedOperations: TcxEditSupportedOperations; override;
    procedure PrepareDisplayValue(const AEditValue: TcxEditValue;
      var DisplayValue: TcxEditValue; AEditFocused: Boolean); override;
    function IsEditValueValid(var EditValue: TcxEditValue; AEditFocused: Boolean): Boolean; override;
    // !!!
    property EditValueFormat: TcxCheckStatesValueFormat read FEditValueFormat write SetEditValueFormat default cvfInteger;
    property Glyph: TdxSmartGlyph read FGlyph write SetGlyph;
    property GlyphCount: Integer read FGlyphCount write SetGlyphCount default 6;
    property Delimiter: string read FDelimiter write SetDelimiter
      stored IsDelimiterStored;
    property EmptySelectionText : string read FEmptySelectionText
      write SetEmptySelectionText stored IsEmptySelectionTextStored;
    property Items: TcxCheckComboBoxItems read GetItems write SetItems;
    property ShowEmptyText: Boolean read FShowEmptyText write SetShowEmptyText default True;
    property OnClickCheck: TcxCheckComboClickCheckEvent read FOnClickCheck write FOnClickCheck;
    property OnEditValueToStates: TcxValueToCheckStatesEvent read FOnEditValueToStates write FOnEditValueToStates;
    property OnStatesToEditValue: TcxCheckStatesToValueEvent read FOnStatesToEditValue write FOnStatesToEditValue;
  end;

  { TcxCheckComboBoxProperties }

  TcxCheckComboBoxProperties = class(TcxCustomCheckComboBoxProperties)
  protected
    // IcxValueByItemIndexProvider
    function FindValueByItemIndex(AItemIndex: Integer; out AValue: Variant): Boolean; override;
    function SupportsItemIndex: Boolean; override;
  published
    property AllowDropDownWhenReadOnly;
    property AllowGrayed; // deprecated
    property AssignedValues;
    property Delimiter;
    property EmptySelectionText;
    property ShowEmptyText;
    property Alignment;
    property BeepOnError;
    property ButtonGlyph;
    property CharCase;
    property ClearKey;
    property DropDownAutoWidth;
    property DropDownRows;
    property DropDownSizeable;
    property DropDownWidth;
    property EditValueFormat;
    property Glyph;
    property GlyphCount;
    property ImeMode;
    property ImeName;
    property ImmediateDropDownWhenActivated;
    property ImmediateDropDownWhenKeyPressed;
    property ImmediatePost;
    property IncrementalFiltering;
    property IncrementalFilteringOptions;
    property Items;
    property PopupAlignment;
    property ReadOnly;
    property ValidateOnEnter;
    property OnChange;
    property OnClickCheck;
    property OnCloseUp;
    property OnEditValueChanged;
    property OnEditValueToStates;
    property OnInitPopup;
    property OnPopup;
    property OnStatesToEditValue;
  end;

  { TcxCheckComboBoxPopupWindow }

  TcxCheckComboBoxPopupWindow = class(TcxComboBoxPopupWindow)
  public
    property ViewInfo;
    property SysPanelStyle;
  end;

  { TdxCheckComboBoxAccessibilityHelper }

  TdxCheckComboBoxAccessibilityHelper = class(TdxCustomDropDownEditAccessibilityHelper) // for internal use
  protected
    function GetValue(AChildID: TcxAccessibleSimpleChildElementID): string; override;
  end;

  { TcxCustomCheckComboBox }

  TcxCustomCheckComboBox = class(TcxCustomComboBox)
  private
    FCheckBorderStyle: TcxEditCheckBoxBorderStyle;
    FNativeStyle: Boolean;
    FStates: TcxCheckStates;
    FStatesItems: Boolean;
    function GetActiveProperties: TcxCustomCheckComboBoxProperties;
    function GetLookupData: TcxCheckComboBoxLookupData;
    function GetProperties: TcxCustomCheckComboBoxProperties;
    procedure SetProperties(Value: TcxCustomCheckComboBoxProperties);
  protected
    procedure CalculateDrawCheckParams;
    function GetAccessibilityHelperClass: TdxEditAccessibilityHelperClass; override;
    function GetClearValue: TcxEditValue; override;
    function GetValue: Variant; virtual; // deprecated
    procedure PopupControlsLookAndFeelChanged(Sender: TcxLookAndFeel;
      AChangedValues: TcxLookAndFeelValues); override;
    procedure PopupWindowShowed(Sender: TObject); override;
    procedure PropertiesChanged(Sender: TObject); override;
    function DoRefreshContainer(const P: TPoint; Button: TcxMouseButton;
      Shift: TShiftState; AIsMouseEvent: Boolean): Boolean; override;
    procedure SetItemIndex(Value: Integer); override;
    procedure SetValue(const AValue: Variant); virtual; // deprecated
    procedure SynchronizeDisplayValue; override;
    procedure SynchronizeEditValue; override;
    procedure UpdateDrawValue; override;
    function ClickCheck(AItemIndex: Integer): Boolean; virtual;
    function DoClickCheck(AItemIndex: Integer): Boolean;
    procedure HandleSelectItem(Sender: TObject); override;
    procedure Initialize; override;
    procedure InitializePopupWindow; override;
    function InternalGetEditingValue: TcxEditValue; override;
    function InternalGetText: string; override;
    function InternalSetText(const Value: string): Boolean; override;
    procedure InternalValidateDisplayValue(const ADisplayValue: TcxEditValue); override;
    function IsEditValueStored: Boolean; override;
    procedure KeyPress(var Key: Char); override;

    property LookupData: TcxCheckComboBoxLookupData read GetLookupData;
    property Value: Variant read GetValue write SetValue stored False; // deprecated
    procedure CloseUp(AReason: TcxEditCloseUpReason); override;
    property StatesItems: Boolean read FStatesItems write FStatesItems stored False;
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    function GetItemState(AIndex: Integer): TcxCheckBoxState; // deprecated
    procedure SetItemState(AIndex: Integer; AState: TcxCheckBoxState); // deprecated
    property ActiveProperties: TcxCustomCheckComboBoxProperties
      read GetActiveProperties;
    property Properties: TcxCustomCheckComboBoxProperties read GetProperties
      write SetProperties;
    property States[AIndex: Integer]: TcxCheckBoxState read GetItemState
      write SetItemState;
  end;

  { TcxCheckComboBox }

  TcxCheckComboBox = class(TcxCustomCheckComboBox)
  private
    function GetActiveProperties: TcxCheckComboBoxProperties;
    function GetProperties: TcxCheckComboBoxProperties;
    procedure SetProperties(Value: TcxCheckComboBoxProperties);
  protected
    // IcxItemIndexHandler
    function SupportsItemIndex: Boolean; override;
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    property ActiveProperties: TcxCheckComboBoxProperties
      read GetActiveProperties;
  published
    property Anchors;
    property AutoSize;
    property BeepOnEnter;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Properties: TcxCheckComboBoxProperties read GetProperties
      write SetProperties;
    property ShowHint;
    property StatesItems;
    property EditValue; // to be after StatesItems (B34627)
    property Style;
    property StyleDisabled;
    property StyleFocused;
    property StyleHot;
    property StyleReadOnly;
    property TabOrder;
    property TabStop;
    property Value; // deprecated
    property Visible;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TcxFilterChecksHelper }

  TcxFilterChecksHelper = class(TcxFilterComboBoxHelper)
  protected
    class function GetEditValueFormat(
      AEditProperties: TcxCustomEditProperties): TcxCheckStatesValueFormat; virtual;
    class function GetItems(
      AEditProperties: TcxCustomEditProperties): IcxCheckItems; virtual;
    class procedure InitializeItems(AProperties,
      AEditProperties: TcxCustomEditProperties); virtual;
  public
    class function GetFilterEditClass: TcxCustomEditClass; override;
    class function GetSupportedFilterOperators(
      AProperties: TcxCustomEditProperties; AValueTypeClass: TcxValueTypeClass;
      AExtendedSet: Boolean = False): TcxFilterControlOperators; override;
    class procedure InitializeProperties(AProperties,
      AEditProperties: TcxCustomEditProperties; AHasButtons: Boolean); override;
  end;

  { TcxFilterCheckComboBoxHelper }

  TcxFilterCheckComboBoxHelper = class(TcxFilterChecksHelper)
  protected
    class function GetEditValueFormat(
      AEditProperties: TcxCustomEditProperties): TcxCheckStatesValueFormat; override;
    class function GetItems(
      AEditProperties: TcxCustomEditProperties): IcxCheckItems; override;
  end;

const
  cxCheckComboValuesDelimiter = ';';

implementation

uses
  dxThemeManager, cxGeometry, dxCoreGraphics, dxTypeHelpers;

const
  dxThisUnitName = 'cxCheckComboBox';

{ TcxCheckComboBoxItem }

procedure TcxCheckComboBoxItem.Assign(Source: TPersistent);
begin
  if Source is TcxCheckComboBoxItem then
    ShortDescription := TcxCheckComboBoxItem(Source).ShortDescription;
  inherited Assign(Source);
end;

function TcxCheckComboBoxItem.GetDisplayDescription: string;
begin
  if ShortDescription <> '' then
    Result := ShortDescription
  else
    Result := Description;
end;

function TcxCheckComboBoxItem.GetDescription: TCaption;
begin
  Result := Caption;
end;

procedure TcxCheckComboBoxItem.SetDescription(const Value: TCaption);
begin
  Caption := Value;
end;

procedure TcxCheckComboBoxItem.SetShortDescription(const Value: TCaption);
begin
  if Value <> FShortDescription then
  begin
    FShortDescription := Value;
    DoChanged(Collection, copChanged);
  end;
end;

{ TcxCheckComboBoxItems }

function TcxCheckComboBoxItems.GetItems(Index: Integer): TcxCheckComboBoxItem;
begin
  Result := TcxCheckComboBoxItem(inherited Items[Index]);
end;

procedure TcxCheckComboBoxItems.SetItems(Index: Integer;const Value: TcxCheckComboBoxItem);
begin
  inherited Items[Index] := Value;
end;

function TcxCheckComboBoxItems.Add: TcxCheckComboBoxItem;
begin
  Result := TcxCheckComboBoxItem(inherited Add);
end;

function TcxCheckComboBoxItems.AddCheckItem(const ADescription: TCaption;
  const AShortDescription: TCaption = ''): TcxCheckComboBoxItem;
begin
  Result := Add;
  Result.Description := ADescription;
  Result.ShortDescription := AShortDescription;
end;

{ TcxCustomCheckComboBoxViewData }

function TcxCustomCheckComboBoxViewData.GetProperties: TcxCustomCheckComboBoxProperties;
begin
  Result := TcxCustomCheckComboBoxProperties(FProperties);
end;

function TcxCustomCheckComboBoxViewData.InternalEditValueToDisplayText(
  AEditValue: TcxEditValue): string;
var
  ASender: TObject;
  ACheckStates: TcxCheckStates;
begin
  if IsInplace then
    ASender := nil
  else
    ASender := Edit;
  Properties.CalculateCheckStatesByEditValue(ASender, AEditValue, ACheckStates);
  Result := Properties.CalculateDisplayValueByCheckStates(ACheckStates);
  Properties.DisplayValueToDisplayText(Result);
end;

function TcxCustomCheckComboBoxViewData.IsComboBoxStyle: Boolean;
begin
  Result := True;
end;

{ TdxCheckComboBoxListBoxToggleProvider }

constructor TdxCheckComboBoxListBoxToggleProvider.Create(ACheckComboBox: TcxCustomCheckComboBox);
begin
  FCheckComboBox := ACheckComboBox;
end;

procedure TdxCheckComboBoxListBoxToggleProvider.DoToggle;
begin
  if FCheckComboBox.States[FItemIndex] = cbsChecked then
    FCheckComboBox.States[FItemIndex] := cbsUnchecked
  else
    FCheckComboBox.States[FItemIndex] := cbsChecked;
end;

function TdxCheckComboBoxListBoxToggleProvider.GetToggleState: Integer;
begin
  Result := Integer(FCheckComboBox.States[FItemIndex]);
end;

{ TdxCheckComboBoxListBoxAccessibilityHelper }

constructor TdxCheckComboBoxListBoxAccessibilityHelper.Create(AOwnerObject: TObject);
begin
  inherited;
  FToggleProvider := TdxCheckComboBoxListBoxToggleProvider.Create(CheckComboBox);
end;

destructor TdxCheckComboBoxListBoxAccessibilityHelper.Destroy;
begin
  FreeAndNil(FToggleProvider);
  inherited;
end;

function TdxCheckComboBoxListBoxAccessibilityHelper.GetName(AChildID: TcxAccessibleSimpleChildElementID): string;
begin
  if AChildID > 0 then
    Result := CheckComboBox.Properties.Items[AChildID - 1].Caption
  else
    Result := inherited;
end;

function TdxCheckComboBoxListBoxAccessibilityHelper.GetState(AChildID: TcxAccessibleSimpleChildElementID): Integer;
begin
  Result := inherited;
  if AChildID > 0 then
  begin
    if not CheckComboBox.ActiveProperties.Items[AChildID - 1].Enabled then
      Result := Result or cxSTATE_SYSTEM_UNAVAILABLE;
    if CheckComboBox.States[AChildID - 1] = cbsChecked then
      Result := Result or cxSTATE_SYSTEM_CHECKED;
  end;
end;

function TdxCheckComboBoxListBoxAccessibilityHelper.IsSupportedPattern(APatternID: Integer; out AProvider: IInterface;
  AChildID: TcxAccessibleSimpleChildElementID = 0): Boolean;
begin
  Result := (APatternID = dxUIA_TogglePatternId) and (AChildID > 0);
  if Result then
  begin
    FToggleProvider.FItemIndex := AChildID - 1;
    AProvider := FToggleProvider;
  end;
end;

function TdxCheckComboBoxListBoxAccessibilityHelper.GetCheckComboBoxListBox: TcxCustomCheckComboBox;
begin
  Result := TcxCustomCheckComboBoxListBox(ListBox).Edit;
end;

{ TcxCustomCheckComboBoxListBox }

constructor TcxCustomCheckComboBoxListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCapturedCheckIndex := -1;
  FHotCheckIndex := -1;
  FInternalUpdate := False;
  FPressedCheckIndex := -1;
end;

function TcxCustomCheckComboBoxListBox.GetItemWidth(AIndex: Integer): Integer;
begin
  Result := inherited GetItemWidth(AIndex) + FCheckSize.cx + FElementIndent;
end;

function TcxCustomCheckComboBoxListBox.GetDefaultItemHeight: Integer;
var
  AMinItemHeight: Integer;
begin
  if Edit.ActiveProperties.ItemHeight > 0 then
    Result := Edit.ActiveProperties.ItemHeight
  else
  begin
    Result := TdxTextMeasurer.TextLineHeight(Font);
    AMinItemHeight := FCheckSize.cy;
    if not UseCustomPadding then
      Inc(AMinItemHeight, ScaleFactor.Apply(2));
    if Result < AMinItemHeight then
      Result := AMinItemHeight;
    Inc(Result, FItemPadding.Height);
  end;
  dxAdjustToTouchableSize(Result, ScaleFactor);
end;

function TcxCustomCheckComboBoxListBox.GetRealStyle: TListBoxStyle;
begin
  if Edit.IsOnMeasureItemEventAssigned then
    Result := lbOwnerDrawVariable
  else
    Result := lbOwnerDrawFixed;
end;

procedure TcxCustomCheckComboBoxListBox.CalculatePadding;
begin
  inherited CalculatePadding;
  FElementIndent := Painter.GetEditorGlyphIndent(False, False, ScaleFactor, TdxPaintPartID.CheckComboBox);
  if SupportsListBoxSkinPadding then
    FItemPadding.Left := Painter.GetEditorGlyphIndent(True, False, ScaleFactor, TdxPaintPartID.CheckComboBox)
  else
    if UseCustomPadding then
      Inc(FItemPadding.Left, Painter.GetEditorGlyphIndent(True, False, ScaleFactor, TdxPaintPartID.CheckComboBox))
    else
      FItemPadding := TRect.Create(Painter.GetEditorGlyphIndent(True, False, ScaleFactor, TdxPaintPartID.CheckComboBox), 0, 0, 0);
end;

procedure TcxCustomCheckComboBoxListBox.CheckHotTrack;
var
  P: TPoint;
begin
  P := ScreenToClient(GetMouseCursorPos);
  InternalMouseMove(KeyboardStateToShiftState, P.X, P.Y);
end;

function TcxCustomCheckComboBoxListBox.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  CheckHotTrack;
end;

procedure TcxCustomCheckComboBoxListBox.DrawItemContent(AIndex: Integer; ARect: TRect;
  AState: TOwnerDrawState);

  function GetCheckState(AIsItemEnabled: Boolean): TcxEditCheckState;
  begin
    if not AIsItemEnabled then
      Result := ecsDisabled
    else
      if FHotCheckIndex = AIndex then
        Result := ecsHot
      else
        if FPressedCheckIndex = AIndex then
          Result := ecsPressed
        else
          Result := ecsNormal;
  end;

  function GetCheckBorderStyle(ACheckState: TcxEditCheckState): TcxEditCheckBoxBorderStyle;
  begin
    if not Edit.FNativeStyle and (Edit.FCheckBorderStyle = ebsFlat) and
        (ACheckState in [ecsHot, ecsPressed]) then
      Result := ebs3D
    else
      Result := Edit.FCheckBorderStyle;
  end;

var
  ACheckState: TcxEditCheckState;
  ACheckBoxState: TcxCheckBoxState;
  AText: string;
  ATextRect : TRect;
  ACheckPaintHelper: TcxCheckPaintHelper;
  AGlyph: TdxSmartGlyph;
  AGlyphCount: Integer;
begin
  AGlyph := Edit.ActiveProperties.Glyph;
  AGlyphCount := Edit.ActiveProperties.GlyphCount;
  ACheckPaintHelper := Edit.ActiveProperties.FCheckPaintHelper;
  ACheckPaintHelper.Glyph := AGlyph;
  ACheckPaintHelper.GlyphCount := AGlyphCount;
  ACheckBoxState := GetItemCheckState(AIndex);
  ATextRect := ARect;
  Inc(ATextRect.Left, FCheckSize.cx + FElementIndent);
  if UseRightToLeftAlignment then
    ATextRect := TdxRightToLeftLayoutConverter.ConvertRect(ATextRect, ARect);
  AText := GetItem(AIndex);
  if not GetCheckComboBoxItem(AIndex).Enabled then
    Canvas.Font.Color := Edit.StyleDisabled.TextColor;
  if IsHighlightSearchText then
    DrawItemText(AText, ATextRect, AState)
  else
    cxDrawText(Canvas.Handle, AText, ATextRect, GetDrawTextFlags);
  if ARect.Top >= 0 then
  begin
    ACheckState := GetCheckState(GetCheckComboBoxItem(AIndex).Enabled);
    DrawScaledEditCheck(Canvas, GetCheckRect(ARect, True), ACheckBoxState,
      ACheckState, AGlyph, AGlyphCount, GetCheckBorderStyle(ACheckState),
      Edit.FNativeStyle, clBtnText, Color, False, False, False, False,
      Edit.Style.LookAndFeel.SkinPainter, Edit.ScaleFactor);
  end;
end;

procedure TcxCustomCheckComboBoxListBox.FullRepaint;
var
  R: TRect;
begin
  if HandleAllocated then
  begin
    R := GetControlRect(Self);
    InvalidateRect(Handle, @R, True);
  end;
end;

function TcxCustomCheckComboBoxListBox.GetAccessibilityHelperClass: TdxCustomInnerListBoxAccessibilityHelperClass;
begin
  Result := TdxCheckComboBoxListBoxAccessibilityHelper;
end;

function TcxCustomCheckComboBoxListBox.GetCheckAt(X, Y: Integer): Integer;
begin
  Result := ItemAtPos(Point(X, Y), True);
end;

function TcxCustomCheckComboBoxListBox.GetCheckRect(const R: TRect; AReturnFullRect: Boolean): TRect;
begin
  Result.Top := (R.Bottom - R.Top - FCheckSize.cy) div 2;
  Result.Left := R.Left;
  Inc(Result.Top, R.Top);
  Result.Bottom := Result.Top + FCheckSize.cy;
  if Result.Left < 1 then
    Result.Left := 1;
  Result.Right := Result.Left + FCheckSize.cx;
  if UseRightToLeftAlignment then
    Result := TdxRightToLeftLayoutConverter.ConvertRect(Result, R);
  if AReturnFullRect then
    InflateRect(Result, FCheckBorderOffset, FCheckBorderOffset);
end;

procedure TcxCustomCheckComboBoxListBox.InternalMouseMove(Shift: TShiftState; X, Y: Integer);
var
  ANewHotCheckIndex, ANewPressedCheckIndex: Integer;
begin
  ANewHotCheckIndex := FHotCheckIndex;
  ANewPressedCheckIndex := FPressedCheckIndex;
  if FCapturedCheckIndex <> -1 then
  begin
    ANewHotCheckIndex := -1;
    if GetCheckAt(X, Y) = FCapturedCheckIndex then
      ANewPressedCheckIndex := FCapturedCheckIndex
    else
      ANewPressedCheckIndex := -1;
  end;
  if (GetCaptureControl <> Self) and cxShiftStateMoveOnly(Shift) then
    ANewHotCheckIndex := GetCheckAt(X, Y);
  SynchronizeCheckStates(ANewHotCheckIndex, ANewPressedCheckIndex);
end;

procedure TcxCustomCheckComboBoxListBox.InvalidateCheck(Index: Integer);
var
  R: TRect;
begin
  R := GetItemContentBounds(ItemRect(Index));
  R := GetCheckRect(R, False);
  InvalidateRect(Handle, @R, False);
end;

procedure TcxCustomCheckComboBoxListBox.KeyPress(var Key: Char);
begin
  if (ItemIndex <> -1) and Assigned(Edit) then
  begin
    if Key = dxSpace then
    begin
      if not (GetCheckComboBoxItem(ItemIndex).Enabled) then Exit;
      FInternalUpdate := True;
      UpdateItemState(ItemIndex);
      FInternalUpdate := False;
      Key := #0;
    end;
  end
  else
    inherited KeyPress(Key);
end;

procedure TcxCustomCheckComboBoxListBox.LookAndFeelChanged(Sender: TcxLookAndFeel;
  AChangedValues: TcxLookAndFeelValues);
begin
  inherited LookAndFeelChanged(Sender, AChangedValues);
  RecreateWindow;
end;

procedure TcxCustomCheckComboBoxListBox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ANewPressedCheckIndex: Integer;
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
  begin
    ANewPressedCheckIndex := GetCheckAt(X, Y);
    FCapturedCheckIndex := ANewPressedCheckIndex;
  end
  else
    ANewPressedCheckIndex := -1;
  SynchronizeCheckStates(-1, ANewPressedCheckIndex);
end;

procedure TcxCustomCheckComboBoxListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  APopupMouseMoveLocked: Boolean;
begin
  APopupMouseMoveLocked := Edit.PopupMouseMoveLocked;
  inherited MouseMove(Shift, X, Y);
  if not APopupMouseMoveLocked then
    InternalMouseMove(Shift, X, Y);
end;

procedure TcxCustomCheckComboBoxListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AItemIndex: Integer;
  ANewHotCheckIndex, ANewPressedCheckIndex: Integer;
begin
  inherited MouseUp(Button, Shift, X, Y);
  ANewPressedCheckIndex := FPressedCheckIndex;
  if Button = mbLeft then
  begin
    SetCaptureControl(nil);
    AItemIndex := ItemAtPos(Point(X, Y), True);
    if (AItemIndex <> -1) and GetCheckComboBoxItem(AItemIndex).Enabled then
    begin
      Edit.LookupData.InternalSetCurrentKey(
        Edit.LookupData.GetLookupItemIndexFromFilteredItemIndex(AItemIndex));
      if AItemIndex = FPressedCheckIndex then
        UpdateItemState(AItemIndex);
    end;
    ANewPressedCheckIndex := -1;
  end;
  if cxShiftStateMoveOnly(Shift) then
    ANewHotCheckIndex := GetCheckAt(X, Y)
  else
    ANewHotCheckIndex := -1;
  SynchronizeCheckStates(ANewHotCheckIndex, ANewPressedCheckIndex);
end;

procedure TcxCustomCheckComboBoxListBox.RecreateWindow;
begin
  FCheckSize := GetScaledEditCheckSize(Self.Canvas, Edit.PopupControlsLookAndFeel.NativeStyle,
    Edit.ActiveProperties.Glyph, Edit.ActiveProperties.GlyphCount, Edit.PopupControlsLookAndFeel.SkinPainter, Edit.ScaleFactor);
  FCheckBorderOffset := GetEditCheckBorderOffset(TcxContainerBorderStyle(Edit.FCheckBorderStyle),
    Edit.FNativeStyle, IsGlyphAssigned(Edit.ActiveProperties.Glyph) and (Edit.ActiveProperties.GlyphCount > 0),
    LookAndFeel.SkinPainter);
  FCheckSize.cx := FCheckSize.cx - FCheckBorderOffset * 2;
  FCheckSize.cy := FCheckSize.cy - FCheckBorderOffset * 2;

  ItemHeight := GetDefaultItemHeight;
end;

procedure TcxCustomCheckComboBoxListBox.SetItemIndex(const Value: Integer);
begin
  if not FInternalUpdate then
    inherited SetItemIndex(Value);
end;

procedure TcxCustomCheckComboBoxListBox.SynchronizeCheckStates(ANewHotCheckIndex,
  ANewPressedIndex: Integer);
begin
  if ANewHotCheckIndex <> FHotCheckIndex then
  begin
    InvalidateCheck(FHotCheckIndex);
    FHotCheckIndex := ANewHotCheckIndex;
    InvalidateCheck(FHotCheckIndex);
  end;
  if ANewPressedIndex <> FPressedCheckIndex then
  begin
    InvalidateCheck(FPressedCheckIndex);
    FPressedCheckIndex := ANewPressedIndex;
    InvalidateCheck(FPressedCheckIndex);
  end;
end;

procedure TcxCustomCheckComboBoxListBox.UpdateItemState(const AIndex: Integer);
var
  ACurrentState: TcxCheckBoxState;
  ANonFilteredItemIndex: Integer;
begin
  ANonFilteredItemIndex := Edit.LookupData.GetLookupItemIndexFromFilteredItemIndex(AIndex);
  if Edit.ClickCheck(ANonFilteredItemIndex) then
  begin
    with Edit.ActiveProperties do
    begin
      ACurrentState := GetItemCheckState(AIndex);
      SetItemCheckState(AIndex, FCheckPaintHelper.GetNextState(ACurrentState));
      if HandleAllocated then
        NotifyWinEvent(dxUIA_ToggleToggleStatePropertyId, Handle, OBJID_CLIENT, AIndex + 1);
      Edit.SynchronizeEditValue;
      Edit.ModifiedAfterEnter := True;
    end;
    if Edit.ActiveProperties.ImmediatePost and Edit.CanPostEditValue then
      Edit.InternalPostEditValue;
    InvalidateCheck(AIndex);
  end;
end;

function TcxCustomCheckComboBoxListBox.GetCheckComboBoxItem(AIndex: Integer): TcxCheckComboBoxItem;
begin
  Result := Edit.ActiveProperties.Items[Edit.LookupData.GetLookupItemIndexFromFilteredItemIndex(AIndex)];
end;

function TcxCustomCheckComboBoxListBox.GetEdit: TcxCustomCheckComboBox;
begin
  Result := TcxCustomCheckComboBox(inherited Edit);
end;

function TcxCustomCheckComboBoxListBox.GetItemCheckState(
  AIndex: Integer): TcxCheckBoxState;
begin
  Result := Edit.FStates[Edit.LookupData.GetLookupItemIndexFromFilteredItemIndex(AIndex)];
end;

procedure TcxCustomCheckComboBoxListBox.SetItemCheckState(AIndex: Integer;
  AState: TcxCheckBoxState);
begin
  Edit.FStates[Edit.LookupData.GetLookupItemIndexFromFilteredItemIndex(AIndex)] := AState;
end;

procedure TcxCustomCheckComboBoxListBox.LBGetTextLen(var Message: TMessage);
begin
  Message.Result := 0;
end;

procedure TcxCustomCheckComboBoxListBox.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  InternalMouseMove([], -1, -1);
end;

{ TcxCheckComboBoxIncrementalFilteringHelper }

procedure TcxCheckComboBoxIncrementalFilteringHelper.SearchEditKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = dxSpace) and (TcxCheckComboBoxLookupData(LookupData).ItemIndex <> -1) then
    TcxCheckComboBox(TcxCheckComboBoxLookupData(LookupData).Edit).KeyPress(Key);
end;

{ TcxCheckComboBoxLookupData }

procedure TcxCheckComboBoxLookupData.TextChanged;
begin
end;

function TcxCheckComboBoxLookupData.CreateIncrementalFilteringHelper: TcxComboBoxIncrementalFilteringHelper;
begin
  Result := TcxCheckComboBoxIncrementalFilteringHelper.Create(Self);
end;

function TcxCheckComboBoxLookupData.GetListBoxClass: TcxCustomEditListBoxClass;
begin
  Result := TcxCustomCheckComboBoxListBox;
end;

function TcxCheckComboBoxLookupData.GetItem(Index: Integer): string;
begin
  with TcxCustomCheckComboBox(Edit).ActiveProperties do
    if (Index > -1) and (Index < Items.Count) then
      Result := Items[Index].Description
    else
      Result := ''
end;

function TcxCheckComboBoxLookupData.GetItemCount: Integer;
begin
  Result := TcxCustomCheckComboBox(Edit).ActiveProperties.Items.Count;
end;

{ TcxCheckComboBox }

class function TcxCheckComboBox.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxCheckComboBoxProperties;
end;

function TcxCheckComboBox.GetActiveProperties: TcxCheckComboBoxProperties;
begin
  Result := TcxCheckComboBoxProperties(InternalGetActiveProperties);
end;

function TcxCheckComboBox.GetProperties: TcxCheckComboBoxProperties;
begin
  Result := TcxCheckComboBoxProperties(inherited Properties);
end;

procedure TcxCheckComboBox.SetProperties(Value: TcxCheckComboBoxProperties);
begin
  Properties.Assign(Value);
end;

function TcxCheckComboBox.SupportsItemIndex: Boolean;
begin
  Result := True;
end;

{ TcxCheckPaintHelper }

constructor TcxCheckPaintHelper.Create(AOwner : TPersistent);
begin
  inherited;
  FStyle := TcxCustomEditStyle.Create(Self, False);
end;

destructor TcxCheckPaintHelper.Destroy;
begin
  FreeAndNil(FStyle);
  inherited Destroy;
end;

procedure TcxCheckPaintHelper.SetStyle(Value: TcxCustomEditStyle);
begin
  FStyle.Assign(Value);
end;

function TcxCheckPaintHelper.GetNextState(Value: TcxCheckBoxState): TcxCheckBoxState;
begin
  case Value of
    cbsChecked:
      Result := cbsUnchecked;
    cbsGrayed:
      Result := cbsUnchecked;
    else
      Result := cbsChecked;
  end;
end;

function TcxCheckPaintHelper.GetCheckWidth: Integer;
begin
  Result := 13;
end;

function TcxCheckPaintHelper.CalcTextRect(const ARect: TRect;
  const ACheckState: TcxCheckBoxState): TRect;
begin
  Result := ARect;
  Inc(Result.Left, cxRectHeight(ARect) + 2);
end;

function TcxCheckPaintHelper.CalcCheckPoint(const ARect: TRect;
  const ACheckState: TcxCheckBoxState): TPoint;
var
  FCenterPos : Integer;
begin
  FCenterPos := CalcCenterPosHeight(ARect, GetCheckWidth);
  Result.X := ARect.Left + FCenterPos;
  Result.Y := ARect.Top + FCenterPos;
end;

function TcxCheckPaintHelper.IsClickInCheck(const AItemRect: TRect;
  const ACheckState: TcxCheckBoxState; X, Y: Integer;
  const AUseRightToLeftAlignment: Boolean = False): Boolean;
var
  FCheckRect : TRect;
  FCenterPos : Integer;
begin
  FCenterPos := CalcCenterPosHeight(AItemRect, GetCheckWidth);
  if not AUseRightToLeftAlignment then
    FCheckRect := Bounds(AItemRect.Left + FCenterPos, AItemRect.Top + FCenterPos,
      GetCheckWidth, GetCheckWidth)
  else
    FCheckRect := Bounds(AItemRect.Right - (FCenterPos * 3), AItemRect.Top + FCenterPos,
      GetCheckWidth, GetCheckWidth);
  Result := (X >= FCheckRect.Left) and (X <= FCheckRect.Right) and
            (Y >= FCheckRect.Top) and (Y <= FCheckRect.Bottom);
end;

{ TcxCustomCheckComboBoxProperties }

constructor TcxCustomCheckComboBoxProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  DropDownListStyle := lsFixedList;
  FDelimiter := cxCheckComboValuesDelimiter;
  FEditValueFormat := cvfInteger;
  FShowEmptyText := True;
  FEmptySelectionText := cxGetResourceString(@cxSCheckComboBoxEmptySelectionText);
  FCheckPaintHelper := TcxCheckPaintHelper.Create(nil);
  FItems := TcxCheckComboBoxItems.Create(Self, TcxCheckComboBoxItem);
  FItems.OnChange := ItemsChanged;
  FGlyph := TdxSmartGlyph.Create;
  FGlyph.OnChange := ChangeHandler;
  FGlyphCount := 6;
end;

destructor TcxCustomCheckComboBoxProperties.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FCheckPaintHelper);
  FreeAndNil(FGlyph);
  inherited;
end;

function TcxCustomCheckComboBoxProperties.GetItemCount: Integer;
begin
  Result := Items.Count;
end;

function TcxCustomCheckComboBoxProperties.GetItems: TcxCheckComboBoxItems;
begin
  Result := FItems;
end;

function TcxCustomCheckComboBoxProperties.IsDelimiterStored: Boolean;
begin
  Result := FDelimiter <> cxCheckComboValuesDelimiter;
end;

function TcxCustomCheckComboBoxProperties.IsEmptySelectionTextStored: Boolean;
begin
  Result := FEmptySelectionText <>
     cxGetResourceString(@cxSCheckComboBoxEmptySelectionText);
end;

procedure TcxCustomCheckComboBoxProperties.SetGlyph(Value: TdxSmartGlyph);
begin
  Glyph.Assign(Value);
end;

procedure TcxCustomCheckComboBoxProperties.SetGlyphCount(Value: Integer);
begin
  if FGlyphCount <> Value then
  begin
    FGlyphCount := Value;
    if FGlyph <> nil then
      Changed;
  end;
end;

class function TcxCustomCheckComboBoxProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TcxCheckComboBox;
end;

function TcxCustomCheckComboBoxProperties.GetEditValueSource(AEditFocused: Boolean): TcxDataEditValueSource;
begin
  Result := evsValue;
end;

function TcxCustomCheckComboBoxProperties.GetSupportedOperations: TcxEditSupportedOperations;
begin
  Result := inherited GetSupportedOperations;
  Include(Result, esoSortingByDisplayText);
end;

procedure TcxCustomCheckComboBoxProperties.DoAssign(AProperties: TcxCustomEditProperties);
begin
  inherited;
  if AProperties is TcxCustomCheckComboBoxProperties then
      with TcxCustomCheckComboBoxProperties(AProperties) do
      begin
        Self.Delimiter := Delimiter;
        Self.EditValueFormat := EditValueFormat;
        Self.Glyph := Glyph;
        Self.GlyphCount := GlyphCount;
        Self.ShowEmptyText := ShowEmptyText;
        Self.EmptySelectionText := EmptySelectionText;
        Self.Items.Assign(Items);
        Self.OnClickCheck := OnClickCheck;
        Self.OnEditValueToStates := OnEditValueToStates;
        Self.OnStatesToEditValue := OnStatesToEditValue;
      end;
end;

class function TcxCustomCheckComboBoxProperties.GetLookupDataClass: TcxInterfacedPersistentClass;
begin
  Result := TcxCheckComboBoxLookupData;
end;

class function TcxCustomCheckComboBoxProperties.GetPopupWindowClass: TcxCustomEditPopupWindowClass;
begin
  Result := TcxCheckComboBoxPopupWindow;
end;

class function TcxCustomCheckComboBoxProperties.GetViewDataClass: TcxCustomEditViewDataClass;
begin
  Result := TcxCustomCheckComboBoxViewData;
end;

function TcxCustomCheckComboBoxProperties.HasDisplayValue: Boolean;
begin
  Result := False;
end;

function TcxCustomCheckComboBoxProperties.GetGlyphCount: Integer;
begin
  Result := FGlyphCount;
end;

function TcxCustomCheckComboBoxProperties.GetStateCaption(AIndex: Integer): string;
begin
  Result := GetCheckBoxStateCaptionByGlyphIndex(AIndex);
end;

procedure TcxCustomCheckComboBoxProperties.SetDelimiter(Value: string);
begin
  if FDelimiter <> Value then
  begin
    FDelimiter := Value;
    Changed;
  end;
end;

procedure TcxCustomCheckComboBoxProperties.SetEditValueFormat(Value: TcxCheckStatesValueFormat);
begin
  if Value <> FEditValueFormat then
  begin
    FEditValueFormat := Value;
    Items.InternalNotify(nil, -1, copChanged);
    CheckEditValueFormat;
  end;
end;

procedure TcxCustomCheckComboBoxProperties.SetEmptySelectionText(Value: string);
begin
  if FEmptySelectionText <> Value then
  begin
    FEmptySelectionText := Value;
    Changed;
  end;
end;

procedure TcxCustomCheckComboBoxProperties.SetShowEmptyText(Value: Boolean);
begin
  if FShowEmptyText <> Value then
  begin
    FShowEmptyText := Value;
    Changed;
  end;
end;

procedure TcxCustomCheckComboBoxProperties.SetItems(const Value: TcxCheckComboBoxItems);
begin
  FItems.Assign(Value);
  Changed;
end;

procedure TcxCustomCheckComboBoxProperties.CheckEditValueFormat;
begin
  if (GetRealEditValueFormat = cvfInteger) and (Items.Count > 64) then
    raise EdxException.Create(cxGetResourceString(@cxSCheckControlIncorrectItemCount));
end;

function TcxCustomCheckComboBoxProperties.GetRealEditValueFormat: TcxCheckStatesValueFormatEx;
begin
  if Assigned(OnEditValueToStates) and Assigned(OnStatesToEditValue) then
    Result := cvfCustom
  else
    Result := EditValueFormat;
end;

procedure TcxCustomCheckComboBoxProperties.ItemsChanged(Sender: TObject; AItem: TCollectionItem);
begin
  CheckEditValueFormat;
end;

procedure TcxCustomCheckComboBoxProperties.CalculateCheckStatesByEditValue(
  Sender: TObject; const AEditValue: TcxEditValue; var ACheckStates: TcxCheckStates);
begin
  if Assigned(OnEditValueToStates) then
  begin
    SetLength(ACheckStates, Items.Count);
    OnEditValueToStates(Sender, AEditValue, ACheckStates)
  end
  else
    cxCheckBox.CalculateCheckStates(AEditValue, Items, EditValueFormat, ACheckStates);
end;

function TcxCustomCheckComboBoxProperties.CalculateDisplayValueByCheckStates(
  const ACheckStates: TcxCheckStates): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Items.Count - 1 do
  begin
    if ACheckStates[I] <> cbsChecked then
      Continue;
    if Result <> '' then
        Result := Result + FDelimiter;
    Result := Result + Items[I].GetDisplayDescription;
  end;
  if (Result = '') and ShowEmptyText then
    Result := EmptySelectionText;
end;

function TcxCustomCheckComboBoxProperties.CalculateEditValueByCheckStates(
  Sender: TObject; const ACheckStates: TcxCheckStates): TcxEditValue;
begin
  if Assigned(OnStatesToEditValue) then
    OnStatesToEditValue(Sender, ACheckStates, Result)
  else
    Result := cxCheckBox.CalculateCheckStatesValue(ACheckStates, Items, EditValueFormat);
end;

function TcxCustomCheckComboBoxProperties.IsEditValueValid(var EditValue: TcxEditValue;
  AEditFocused: Boolean): Boolean;
begin
  Result := True;
end;

procedure TcxCustomCheckComboBoxProperties.PrepareDisplayValue(
  const AEditValue: TcxEditValue; var DisplayValue: TcxEditValue; AEditFocused: Boolean);
var
  ACheckStates: TcxCheckStates;
begin
  CalculateCheckStatesByEditValue(nil, AEditValue, ACheckStates);
  DisplayValue := CalculateDisplayValueByCheckStates(ACheckStates);
end;

{ TdxCheckComboBoxAccessibilityHelper }
function TdxCheckComboBoxAccessibilityHelper.GetValue(AChildID: TcxAccessibleSimpleChildElementID): string;
begin
  Result := TcxCustomCheckComboBox(Edit).Text;
end;

{ TcxCustomCheckComboBox }

class function TcxCustomCheckComboBox.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxCustomCheckComboBoxProperties;
end;

function TcxCustomCheckComboBox.GetItemState(AIndex: Integer): TcxCheckBoxState;
begin
  Result := FStates[AIndex];
end;

procedure TcxCustomCheckComboBox.SetItemState(AIndex: Integer; AState: TcxCheckBoxState);
begin
  if AState = cbsGrayed then Exit;
  if FStates[AIndex] <> AState then
  begin
    FStates[AIndex] := AState;
    SynchronizeEditValue;
  end;
end;

function TcxCustomCheckComboBox.ClickCheck(AItemIndex: Integer): Boolean;
begin
  Result := CanModify and DoClickCheck(AItemIndex) and DoEditing;
end;

function TcxCustomCheckComboBox.DoClickCheck(AItemIndex: Integer): Boolean;

  function InternalDoClickCheck(AProperties: TcxCustomCheckComboBoxProperties;
    AItemIndex: Integer): Boolean;
  begin
    Result := True;
    if Assigned(AProperties.OnClickCheck) then
      AProperties.OnClickCheck(Self, AItemIndex, Result);
  end;

var
  AAllowToggle1, AAllowToggle2: Boolean;
begin
  AAllowToggle1 := InternalDoClickCheck(Properties, AItemIndex);
  if RepositoryItem <> nil then
    AAllowToggle2 := InternalDoClickCheck(
      TcxCustomCheckComboBoxProperties(RepositoryItem.Properties), AItemIndex)
  else
    AAllowToggle2 := True;
  Result := AAllowToggle1 and AAllowToggle2;
end;

procedure TcxCustomCheckComboBox.HandleSelectItem(Sender: TObject);
begin
end;

procedure TcxCustomCheckComboBox.Initialize;
begin
  inherited Initialize;
  FEditValue := 0;
  ControlStyle := ControlStyle - [csClickEvents];
  CalculateDrawCheckParams;
end;

procedure TcxCustomCheckComboBox.InitializePopupWindow;
begin
  inherited InitializePopupWindow;
  (PopupWindow as TcxCheckComboBoxPopupWindow).SysPanelStyle := ActiveProperties.PopupSizeable;
end;

function TcxCustomCheckComboBox.InternalGetEditingValue: TcxEditValue;
begin
  Result := EditValue;
end;

function TcxCustomCheckComboBox.InternalGetText: string;
begin
  if IsDestroying then
    Result := ''
  else
    Result := ViewInfo.Text;
end;

function TcxCustomCheckComboBox.InternalSetText(const Value: string): Boolean;
begin
  Result := False;
end;

procedure TcxCustomCheckComboBox.InternalValidateDisplayValue(const ADisplayValue: TcxEditValue);
begin
end;

function TcxCustomCheckComboBox.IsEditValueStored: Boolean;
begin
  Result := (ActiveProperties.EditValueFormat = cvfInteger) and (EditValue <> 0) or
    (ActiveProperties.EditValueFormat <> cvfInteger) and (VarToStr(EditValue) <> '');
end;

procedure TcxCustomCheckComboBox.KeyPress(var Key: Char);
begin
  if (Key = dxSpace) and HasPopupWindow then
  begin
    if Assigned(OnKeyPress) then
      OnKeyPress(Self, Key);
    (LookupData.List as TcxCustomCheckComboBoxListBox).KeyPress(Key)
  end
  else
    inherited KeyPress(Key);
end;

procedure TcxCustomCheckComboBox.CloseUp(AReason: TcxEditCloseUpReason);
begin
  if HasPopupWindow then
  begin
    FCloseUpReason := AReason;
    PopupWindow.CloseUp;
    if not ActiveProperties.AlwaysPostEditValue and ActiveProperties.ImmediatePost and
        CanPostEditValue and InternalValidateEdit then
      InternalPostEditValue;
  end;
end;

function TcxCustomCheckComboBox.GetProperties: TcxCustomCheckComboBoxProperties;
begin
  Result := TcxCustomCheckComboBoxProperties(inherited Properties);
end;

function TcxCustomCheckComboBox.GetActiveProperties: TcxCustomCheckComboBoxProperties;
begin
  Result := TcxCustomCheckComboBoxProperties(InternalGetActiveProperties);
end;

function TcxCustomCheckComboBox.GetClearValue: TcxEditValue;
var
  ACheckStates: TcxCheckStates;
  I: Integer;
begin
  SetLength(ACheckStates, ActiveProperties.Items.Count);
  for I := 0 to ActiveProperties.Items.Count - 1 do
    ACheckStates[I] := cbsUnchecked;
  Result := ActiveProperties.CalculateEditValueByCheckStates(Self, ACheckStates);
end;

function TcxCustomCheckComboBox.GetLookupData: TcxCheckComboBoxLookupData;
begin
  Result := TcxCheckComboBoxLookupData(FLookupData);
end;

procedure TcxCustomCheckComboBox.SetProperties(Value: TcxCustomCheckComboBoxProperties);
begin
  Properties.Assign(Value);
end;

procedure TcxCustomCheckComboBox.CalculateDrawCheckParams;
const
  ABorderStyleMap: array[TcxLookAndFeelKind] of TcxEditCheckBoxBorderStyle =
    (ebsFlat, ebs3D, ebsUltraFlat, ebsOffice11);
begin
  with PopupControlsLookAndFeel do
  begin
    FNativeStyle := NativeStyle and AreVisualStylesAvailable([totButton, totComboBox]);
    if not FNativeStyle then
      FCheckBorderStyle := ABorderStyleMap[Kind];
  end;
end;

function TcxCustomCheckComboBox.GetAccessibilityHelperClass: TdxEditAccessibilityHelperClass;
begin
  Result := TdxCheckComboBoxAccessibilityHelper;
end;

function TcxCustomCheckComboBox.GetValue: Variant;
begin
  Result := EditValue;
end;

procedure TcxCustomCheckComboBox.PopupControlsLookAndFeelChanged(
  Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
  inherited PopupControlsLookAndFeelChanged(Sender, AChangedValues);
  if not IsDestroying then
    CalculateDrawCheckParams;
end;

procedure TcxCustomCheckComboBox.PopupWindowShowed(Sender: TObject);
begin
  inherited PopupWindowShowed(Sender);
  (LookupData.List as TcxCustomCheckComboBoxListBox).CheckHotTrack;
end;

procedure TcxCustomCheckComboBox.PropertiesChanged(Sender: TObject);
begin
  with ActiveProperties.Items do
    if ItemChanged and (ChangedItemOperation = copDelete) and (ChangedItemIndex < Length(FStates) - 1) then
      Move(FStates[ChangedItemIndex + 1], FStates[ChangedItemIndex],
        (ActiveProperties.Items.Count - 1 - ChangedItemIndex) * SizeOf(TcxCheckBoxState));
  SetLength(FStates, ActiveProperties.Items.Count);

  inherited PropertiesChanged(Sender);

  if not IsInplaceInitializing then
    if ModifiedAfterEnter then
      UpdateDrawValue
    else
      if IsDBEdit then
        SynchronizeDisplayValue
      else
        FEditValue := ActiveProperties.CalculateEditValueByCheckStates(GetStandaloneEventSender(Self), FStates);
end;

function TcxCustomCheckComboBox.DoRefreshContainer(const P: TPoint;
  Button: TcxMouseButton; Shift: TShiftState; AIsMouseEvent: Boolean): Boolean;
begin
  Result := inherited DoRefreshContainer(P, Button, Shift, AIsMouseEvent);
  ActiveProperties.FCheckPaintHelper.Style.Assign(ActiveStyle);
end;

procedure TcxCustomCheckComboBox.SetItemIndex(Value: Integer);
begin
  LookupData.InternalSetCurrentKey(Value);
end;

procedure TcxCustomCheckComboBox.SetValue(const AValue: Variant);
begin
  InternalEditValue := AValue;
end;

procedure TcxCustomCheckComboBox.SynchronizeDisplayValue;
begin
  ActiveProperties.CalculateCheckStatesByEditValue(GetStandaloneEventSender(Self), EditValue, FStates);
  UpdateDrawValue;
  if LookupData.List <> nil then
    TcxCustomCheckComboBoxListBox(LookupData.List).FullRepaint;
end;

procedure TcxCustomCheckComboBox.SynchronizeEditValue;
begin
  InternalEditValue := ActiveProperties.CalculateEditValueByCheckStates(GetStandaloneEventSender(Self), FStates);
end;

procedure TcxCustomCheckComboBox.UpdateDrawValue;
begin
  TcxCustomTextEditViewInfo(ViewInfo).SelLength := 0;
  TcxCustomTextEditViewInfo(ViewInfo).Text := ActiveProperties.CalculateDisplayValueByCheckStates(FStates);
  Self.ActiveProperties.DisplayValueToDisplayText(TcxCustomTextEditViewInfo(ViewInfo).Text);
  TcxCustomTextEditViewInfo(ViewInfo).TextOutData.Initialized := False;
  InvalidateRect(TcxCustomTextEditViewInfo(ViewInfo).ClientRect, False);
end;

{ TcxFilterChecksHelper }

class function TcxFilterChecksHelper.GetFilterEditClass: TcxCustomEditClass;
begin
  Result := TcxCheckComboBox;
end;

class function TcxFilterChecksHelper.GetSupportedFilterOperators(
  AProperties: TcxCustomEditProperties; AValueTypeClass: TcxValueTypeClass;
  AExtendedSet: Boolean = False): TcxFilterControlOperators;
begin
  Result := [fcoEqual, fcoNotEqual, fcoBlanks, fcoNonBlanks];
  if AExtendedSet then
    Result := Result + [fcoInList, fcoNotInList];
end;

class procedure TcxFilterChecksHelper.InitializeProperties(AProperties,
  AEditProperties: TcxCustomEditProperties; AHasButtons: Boolean);
begin
  inherited InitializeProperties(AProperties, AEditProperties, AHasButtons);
  TcxCustomCheckComboBoxProperties(AProperties).EditValueFormat := GetEditValueFormat(AEditProperties);
  with TcxCustomCheckComboBoxProperties(AProperties) do
  begin
    BeginUpdate;
    try
      Items.Clear;
      Buttons.Clear;
      Buttons.Add;
      Buttons[0].Kind := bkDown;
      DropDownListStyle := lsFixedList;
      InitializeItems(AProperties, AEditProperties);
    finally
      EndUpdate;
    end;
  end;
end;

class function TcxFilterChecksHelper.GetEditValueFormat(
  AEditProperties: TcxCustomEditProperties): TcxCheckStatesValueFormat;
begin
  Result := cvfCaptions;
end;

class function TcxFilterChecksHelper.GetItems(
  AEditProperties: TcxCustomEditProperties): IcxCheckItems;
begin
  Result := nil;
end;

class procedure TcxFilterChecksHelper.InitializeItems(AProperties,
  AEditProperties: TcxCustomEditProperties);
var
  AItems: IcxCheckItems;
  I: Integer;
begin
  AItems := GetItems(AEditProperties);
  if AItems = nil then
    Exit;
  for I := 0 to AItems.Count - 1 do
    TcxCustomCheckComboBoxProperties(AProperties).Items.Add.Description :=
      AItems.Captions[I];
end;

{ TcxFilterCheckComboBoxHelper }

class function TcxFilterCheckComboBoxHelper.GetEditValueFormat(
  AEditProperties: TcxCustomEditProperties): TcxCheckStatesValueFormat;
begin
  Result := TcxCustomCheckComboBoxProperties(AEditProperties).EditValueFormat
end;

class function TcxFilterCheckComboBoxHelper.GetItems(
  AEditProperties: TcxCustomEditProperties): IcxCheckItems;
begin
  Result := TcxCustomCheckComboBoxProperties(AEditProperties).Items;
end;

{ TcxCheckComboBoxProperties }

function TcxCheckComboBoxProperties.FindValueByItemIndex(AItemIndex: Integer;
  out AValue: Variant): Boolean;
begin
  Result := InRange(AItemIndex, 0, Items.Count - 1);
  if Result then
    AValue := Items[AItemIndex].Caption;
end;

function TcxCheckComboBoxProperties.SupportsItemIndex: Boolean;
begin
  Result := True;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  GetRegisteredEditProperties.Register(TcxCheckComboBoxProperties, scxSEditRepositoryCheckComboBox);
  FilterEditsController.Register(TcxCheckComboBoxProperties, TcxFilterCheckComboBoxHelper);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FilterEditsController.Unregister(TcxCheckComboBoxProperties, TcxFilterCheckComboBoxHelper);
  GetRegisteredEditProperties.Unregister(TcxCheckComboBoxProperties);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.

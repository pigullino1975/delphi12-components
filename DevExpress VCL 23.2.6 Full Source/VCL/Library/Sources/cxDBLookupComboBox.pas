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

unit cxDBLookupComboBox;

{$I cxVer.inc}

interface

uses
  Variants, Windows, Messages, SysUtils, Classes, Controls, Graphics, DB, DBCtrls,
  cxClasses, cxContainer, cxCustomData, cxDataStorage, cxDB, cxDBData, cxLookAndFeels,
  cxEdit, cxDBEdit, cxEditConsts, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxLookupGrid, cxLookupDBGrid, cxFilterControlUtils, cxTextEdit;

type
  { TcxLookupComboBoxProperties }

  TcxLookupComboBoxProperties = class(TcxCustomDBLookupEditProperties)
  private
    FGrid: TcxCustomLookupDBGrid;
    function GetGrid: TcxCustomLookupDBGrid;
    function GetGridMode: Boolean;
    function GetListColumns: TcxLookupDBGridColumns;
    function GetListOptions: TcxLookupDBGridOptions;
    function GetListSource: TDataSource;
    function GetOnSortingChanged: TNotifyEvent;
    procedure SetGridMode(Value: Boolean);
    procedure SetListColumns(Value: TcxLookupDBGridColumns);
    procedure SetListOptions(Value: TcxLookupDBGridOptions);
    procedure SetListSource(Value: TDataSource);
    procedure SetOnSortingChanged(Value: TNotifyEvent);
  protected
    // IcxValueByItemIndexProvider
    function FindValueByItemIndex(AItemIndex: Integer; out AValue: Variant): Boolean; override;
    function SupportsItemIndex: Boolean; override;

    function GetLookupGridClass: TcxCustomLookupDBGridClass; virtual;
    procedure ListOptionsChanged(Sender: TObject); virtual;
    procedure SetIncrementalFilteringOptions(Value: TcxTextEditIncrementalFilteringOptions); override;
    // LookupGrid methods
    function GetLookupGridColumnCount: Integer; override;
    function GetLookupGridColumnProperties(AIndex: Integer): TcxCustomEditProperties; override;
    function GetLookupGridControl: TWinControl; override;
    function GetLookupGridDataController: TcxCustomDataController; override;
    function GetLookupGridVisualAreaPreferredWidth: Integer; override;
    function GetLookupGridNearestPopupHeight(AHeight: Integer): Integer; override;
    function GetLookupGridPopupHeight(ADropDownRowCount: Integer): Integer; override;
    function IsLookupGridMouseOverList(const P: TPoint): Boolean; override;
    procedure LookupGridInitEvents(AOnClick, AOnFocusedRowChanged: TNotifyEvent;
      AOnCloseUp: cxLookupEdit.TcxLookupGridCloseUpEvent); override;
    procedure LookupGridInitLookAndFeel(ALookAndFeel: TcxLookAndFeel; AColor: TColor; AFont: TFont); override;
    procedure LookupGridLockMouseMove; override;
    procedure LookupGridMakeFocusedRowVisible; override;
    procedure LookupGridUnlockMouseMove; override;
    // DBLookupGrid methods
    procedure DBLookupGridBeginUpdate; override;
    procedure DBLookupGridCheckColumnByFieldName(const AFieldName: string); override;
    procedure DBLookupGridCreateColumnsByFieldNames(const AFieldNames: string); override;
    procedure DBLookupGridEndUpdate; override;
    function GetDBLookupGridColumnField(AIndex: Integer): TField; override;
    function GetDBLookupGridColumnFieldName(AIndex: Integer): string; override;
    function GetDBLookupGridColumnIndexByFieldName(const AFieldName: string): Integer; override;
    function GetDBLookupGridDataController: TcxDBDataController; override;
  public
    constructor Create(AOwner: TPersistent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    class function GetContainerClass: TcxContainerClass; override;
    property Grid: TcxCustomLookupDBGrid read GetGrid; // for internal use
  published
    property Alignment;
    property AllowDropDownWhenReadOnly;
    property AutoSelect;
    property AssignedValues;
    property ButtonGlyph;
    property CaseSensitiveSearch;
    property CharCase;
    property ClearKey;
    property DropDownAutoSize;
    property DropDownHeight;
    property DropDownListStyle;
    property DropDownRows;
    property DropDownSizeable;
    property DropDownWidth;
    property GridMode: Boolean read GetGridMode write SetGridMode default False;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property ImmediateDropDownWhenActivated;
    property ImmediateDropDownWhenKeyPressed;
    property ImmediatePost;
    property IncrementalFiltering;
    property IncrementalFilteringOptions default [];
    property KeyFieldNames;
    property ListColumns: TcxLookupDBGridColumns read GetListColumns write SetListColumns;
    property ListFieldNames;
    property ListFieldIndex;
    property ListOptions: TcxLookupDBGridOptions read GetListOptions write SetListOptions;
    property ListSource: TDataSource read GetListSource write SetListSource;
    property MaxLength;
    property OEMConvert;
    property PopupAlignment;
    property PostPopupValueOnTab;
    property ReadOnly;
    property Revertable;
    property UseLeftAlignmentOnEditing;
    property ValidateOnEnter;
    property ValidationErrorIconAlignment;
    property ValidationOptions;
    property OnChange;
    property OnCloseUp;
    property OnEditValueChanged;
    property OnInitPopup;
    property OnNewLookupDisplayText;
    property OnPopup;
    property OnSortingChanged: TNotifyEvent read GetOnSortingChanged write SetOnSortingChanged;
    property OnValidate;
  end;

  { TcxCustomLookupComboBox }

  TcxCustomLookupComboBox = class(TcxCustomDBLookupEdit)
  private
    function GetProperties: TcxLookupComboBoxProperties;
    function GetActiveProperties: TcxLookupComboBoxProperties;
    procedure SetProperties(Value: TcxLookupComboBoxProperties);
  protected
    procedure InitializeNonShareableProperties; override;
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    property ActiveProperties: TcxLookupComboBoxProperties read GetActiveProperties;
    property EditValue; 
    property Properties: TcxLookupComboBoxProperties read GetProperties write SetProperties;
    property Text;
  end;

  { TcxLookupComboBox }

  TcxLookupComboBox = class(TcxCustomLookupComboBox)
  protected
    // IcxItemIndexHandler
    function SupportsItemIndex: Boolean; override;
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
    property Properties;
    property EditValue;
    property ShowHint;
    property Style;
    property StyleDisabled;
    property StyleFocused;
    property StyleHot;
    property StyleReadOnly;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnEditing;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  { TcxDBLookupComboBox }

  TcxDBLookupComboBox = class(TcxCustomLookupComboBox)
  private
    function GetDataBinding: TcxDBTextEditDataBinding;
    procedure SetDataBinding(Value: TcxDBTextEditDataBinding);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    class function GetDataBindingClass: TcxEditDataBindingClass; override;
  published
    property Anchors;
    property AutoSize;
    property BeepOnEnter;
    property BiDiMode;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DataBinding: TcxDBTextEditDataBinding read GetDataBinding write SetDataBinding;
    property DragMode;
    property Enabled;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Properties;
    property ShowHint;
    property Style;
    property StyleDisabled;
    property StyleFocused;
    property StyleHot;
    property StyleReadOnly;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnEditing;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  { TcxFilterLookupComboBoxHelper }

  TcxFilterLookupComboBoxHelper = class(TcxFilterComboBoxHelper)
  protected
    class function IsIDefaultValuesProviderNeeded(
      AEditProperties: TcxCustomEditProperties): Boolean; override;
  public
    class function GetFilterDataType(AValueTypeClass: TcxValueTypeClass): TcxFilterDataType; override;
    class function GetFilterEditClass: TcxCustomEditClass; override;
    class procedure GetFilterValue(AEdit: TcxCustomEdit; AEditProperties: TcxCustomEditProperties;
      var V: Variant; var S: TCaption); override;
    class function GetSupportedFilterOperators(
      AProperties: TcxCustomEditProperties;
      AValueTypeClass: TcxValueTypeClass;
      AExtendedSet: Boolean = False): TcxFilterControlOperators; override;
    class procedure InitializeProperties(AProperties,
      AEditProperties: TcxCustomEditProperties; AHasButtons: Boolean); override;
    class function IsValueValid(AValueTypeClass: TcxValueTypeClass;
      var Value: Variant): Boolean; override;
  end;

implementation

uses
  VDBConsts, DBConsts, cxControls, cxScrollBar, dxCore, Math;

const
  dxThisUnitName = 'cxDBLookupComboBox';

type
  TControlAccess = class(TControl);
  TcxControlAccess = class(TcxControl);

{ TcxLookupComboBoxProperties }

constructor TcxLookupComboBoxProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FGrid := GetLookupGridClass.Create(nil);
  FGrid.IsPopupControl := True;
  FGrid.Options.OnChanged := ListOptionsChanged;
  InitializeDataController;
end;

destructor TcxLookupComboBoxProperties.Destroy;
begin
  DeinitializeDataController;
  FGrid.Free;
  FGrid := nil;
  inherited Destroy;
end;

function TcxLookupComboBoxProperties.FindValueByItemIndex(AItemIndex: Integer;
  out AValue: Variant): Boolean;
begin
  Result := InRange(AItemIndex, 0, Items.Count - 1);
  if Result then
    AValue := Items[AItemIndex];
end;

function TcxLookupComboBoxProperties.SupportsItemIndex: Boolean;
begin
  Result := True;
end;

procedure TcxLookupComboBoxProperties.Assign(Source: TPersistent);
var
  AIsDefinedByLookup, AIsSourceDefinedByLookup: Boolean;
begin
  if Source is TcxLookupComboBoxProperties then
  begin
    BeginUpdate;
    try
//      Grid.BeginUpdate;
//      try
        GridMode := TcxLookupComboBoxProperties(Source).GridMode;
        ListOptions := TcxLookupComboBoxProperties(Source).ListOptions;
        AIsDefinedByLookup := IsDefinedByLookup;
        AIsSourceDefinedByLookup := TcxLookupComboBoxProperties(Source).IsDefinedByLookup;
        if not (AIsDefinedByLookup or AIsSourceDefinedByLookup) then
        begin
          ListSource := TcxLookupComboBoxProperties(Source).ListSource;
          ListColumns := TcxLookupComboBoxProperties(Source).ListColumns;
        end;
        OnSortingChanged := TcxLookupComboBoxProperties(Source).OnSortingChanged;
        inherited Assign(Source);
        if AIsDefinedByLookup or AIsSourceDefinedByLookup then
        begin
          if not AIsSourceDefinedByLookup then
            ListSource := TcxLookupComboBoxProperties(Source).ListSource;
          ListColumns := TcxLookupComboBoxProperties(Source).ListColumns;
        end;
//      finally
//        Grid.EndUpdate;
//      end;
    finally
      EndUpdate;
    end
  end
  else
    inherited Assign(Source);
end;

class function TcxLookupComboBoxProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TcxLookupComboBox;
end;

function TcxLookupComboBoxProperties.GetLookupGridClass: TcxCustomLookupDBGridClass;
begin
  Result := TcxCustomLookupDBGrid;
end;

procedure TcxLookupComboBoxProperties.ListOptionsChanged(Sender: TObject);
begin
  Changed;
end;

// LookupGrid

function TcxLookupComboBoxProperties.GetLookupGridColumnCount: Integer;
begin
  Result := ListColumns.Count;
end;

function TcxLookupComboBoxProperties.GetLookupGridColumnProperties(AIndex: Integer): TcxCustomEditProperties;
begin
  Result := ListColumns[AIndex].Properties;
end;

function TcxLookupComboBoxProperties.GetLookupGridControl: TWinControl;
begin
  Result := Grid;
end;

function TcxLookupComboBoxProperties.GetLookupGridDataController: TcxCustomDataController;
begin
  Result := Grid.DataController;
end;

function TcxLookupComboBoxProperties.GetLookupGridVisualAreaPreferredWidth: Integer;
var
  I: Integer;
begin
  Result := Grid.ViewInfo.GridLineWidth * ListColumns.Count;
  for I := 0 to ListColumns.Count - 1 do
    Inc(Result, ListColumns[I].Width);
  if (DataController <> nil) and (DataController.GetRowCount > DropDownRows) then
    Result := Result + TcxControlAccess(Grid).GetVScrollBarDefaultAreaWidth;
end;

function TcxLookupComboBoxProperties.GetLookupGridNearestPopupHeight(AHeight: Integer): Integer;
begin
  Result := Grid.GetNearestPopupHeight(AHeight);
end;

function TcxLookupComboBoxProperties.GetLookupGridPopupHeight(ADropDownRowCount: Integer): Integer;
begin
  Result := Grid.GetPopupHeight(ADropDownRowCount);
end;

function TcxLookupComboBoxProperties.IsLookupGridMouseOverList(const P: TPoint): Boolean;
begin
  Result := Grid.IsMouseOverList(P);
end;

procedure TcxLookupComboBoxProperties.LookupGridInitEvents(AOnClick, AOnFocusedRowChanged: TNotifyEvent;
  AOnCloseUp: cxLookupEdit.TcxLookupGridCloseUpEvent);
begin
  Grid.OnClick := AOnClick;
  Grid.OnFocusedRowChanged := AOnFocusedRowChanged;
  Grid.OnCloseUp := AOnCloseUp;
end;

procedure TcxLookupComboBoxProperties.LookupGridInitLookAndFeel(ALookAndFeel: TcxLookAndFeel;
  AColor: TColor; AFont: TFont);
begin
  Grid.LookAndFeel.MasterLookAndFeel := ALookAndFeel;
  Grid.Color := AColor;
  Grid.Font := AFont;
end;

procedure TcxLookupComboBoxProperties.LookupGridLockMouseMove;
begin
  Grid.LockPopupMouseMove;
end;

procedure TcxLookupComboBoxProperties.LookupGridMakeFocusedRowVisible;
begin
  Grid.MakeFocusedRowVisible;
end;

procedure TcxLookupComboBoxProperties.LookupGridUnlockMouseMove;
begin
  TControlAccess(Grid).MouseCapture := False;
end;

// DBLookupGrid

procedure TcxLookupComboBoxProperties.DBLookupGridBeginUpdate;
begin
  Grid.BeginUpdate;
end;

procedure TcxLookupComboBoxProperties.DBLookupGridCheckColumnByFieldName(const AFieldName: string);
begin
  if (AFieldName <> '') and (ListColumns.ColumnByFieldName(AFieldName) = nil) then
    with ListColumns.Add do
    begin
      FieldName := AFieldName;
      Index := 0;
    end;
end;

procedure TcxLookupComboBoxProperties.DBLookupGridCreateColumnsByFieldNames(const AFieldNames: string);
begin
  Grid.CreateColumnsByFieldNames(AFieldNames);
end;

procedure TcxLookupComboBoxProperties.DBLookupGridEndUpdate;
begin
  Grid.EndUpdate;
end;

function TcxLookupComboBoxProperties.GetDBLookupGridColumnField(AIndex: Integer): TField;
begin
  Result := ListColumns[AIndex].Field;
end;

function TcxLookupComboBoxProperties.GetDBLookupGridColumnFieldName(AIndex: Integer): string;
begin
  Result := ListColumns[AIndex].FieldName;
end;

function TcxLookupComboBoxProperties.GetDBLookupGridColumnIndexByFieldName(const AFieldName: string): Integer;
var
  AColumn: TcxLookupDBGridColumn;
begin
  AColumn := ListColumns.ColumnByFieldName(AFieldName);
  if AColumn <> nil then
    Result := AColumn.Index
  else
    Result := -1;
end;

function TcxLookupComboBoxProperties.GetDBLookupGridDataController: TcxDBDataController;
begin
  if Grid <> nil then
    Result := Grid.DataController
  else
    Result := nil;
end;

function TcxLookupComboBoxProperties.GetGrid: TcxCustomLookupDBGrid;
begin
  Result := FGrid;
end;

function TcxLookupComboBoxProperties.GetGridMode: Boolean;
begin
  Result := inherited IsUseLookupList;
end;

function TcxLookupComboBoxProperties.GetListColumns: TcxLookupDBGridColumns;
begin
  Result := Grid.Columns;
end;

function TcxLookupComboBoxProperties.GetListOptions: TcxLookupDBGridOptions;
begin
  Result := Grid.Options;
end;

function TcxLookupComboBoxProperties.GetListSource: TDataSource;
begin
  if IsDefinedByLookup then
    Result := nil
  else
    Result := Grid.DataSource;
end;

function TcxLookupComboBoxProperties.GetOnSortingChanged: TNotifyEvent;
begin
  Result := Grid.DataController.OnSortingChanged;
end;

procedure TcxLookupComboBoxProperties.SetGridMode(Value: Boolean);
begin
  inherited IsUseLookupList := Value;
  CheckLookupList;
end;

procedure TcxLookupComboBoxProperties.SetIncrementalFilteringOptions(Value: TcxTextEditIncrementalFilteringOptions);
begin
  inherited SetIncrementalFilteringOptions(Value);
  Grid.Options.HighlightIncrementalFilteringText := ifoHighlightSearchText in Value;
end;

procedure TcxLookupComboBoxProperties.SetListColumns(Value: TcxLookupDBGridColumns);
begin
  if not Grid.Columns.Equals(Value) then
  begin
    Grid.Columns := Value; // TODO: recreate?
    CheckLookupColumn;
    CheckDisplayColumnIndex;
  end;
end;

procedure TcxLookupComboBoxProperties.SetListOptions(Value: TcxLookupDBGridOptions);
begin
  Grid.Options := Value;
end;

procedure TcxLookupComboBoxProperties.SetListSource(Value: TDataSource);

  procedure CheckListSource(ADataSource: TDataSource);
  var
    AField: TField;
  begin
    AField := GetDataField;
    if Assigned(AField) and Assigned(ADataSource) and IsLinkedToDataSet(ADataSource, AField.DataSet) then
      DatabaseError(SCircularDataLink);
  end;

begin
  if IsDefinedByLookup and not InSyncLookup then
    DefineByLookupError;
  if Value <> nil then
    CheckListSource(Value);
  if ListSource <> Value then
  begin
    Grid.DataSource := Value;
    Changed;
  end;
end;

procedure TcxLookupComboBoxProperties.SetOnSortingChanged(Value: TNotifyEvent);
begin
  Grid.DataController.OnSortingChanged := Value;
end;

{ TcxCustomLookupComboBox }

class function TcxCustomLookupComboBox.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxLookupComboBoxProperties;
end;

procedure TcxCustomLookupComboBox.InitializeNonShareableProperties;
begin
  inherited InitializeNonShareableProperties;
  if Properties.ListOptions.SyncMode then
    ILookupData.SelectedItem := Properties.DataController.RecNo - 1;
end;

function TcxCustomLookupComboBox.GetProperties: TcxLookupComboBoxProperties;
begin
  Result := TcxLookupComboBoxProperties(inherited Properties);
end;

function TcxCustomLookupComboBox.GetActiveProperties: TcxLookupComboBoxProperties;
begin
  Result := TcxLookupComboBoxProperties(InternalGetActiveProperties);
end;

procedure TcxCustomLookupComboBox.SetProperties(Value: TcxLookupComboBoxProperties);
begin
  Properties.Assign(Value);
end;

{ TcxDBLookupComboBox }

class function TcxDBLookupComboBox.GetDataBindingClass: TcxEditDataBindingClass;
begin
  Result := TcxDBLookupEditDataBinding;
end;

function TcxDBLookupComboBox.GetDataBinding: TcxDBTextEditDataBinding;
begin
  Result := TcxDBTextEditDataBinding(FDataBinding);
end;

procedure TcxDBLookupComboBox.SetDataBinding(Value: TcxDBTextEditDataBinding);
begin
  FDataBinding.Assign(Value);
end;

procedure TcxDBLookupComboBox.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := LRESULT(GetcxDBEditDataLink(Self));
end;

{ TcxFilterLookupComboBoxHelper }

class function TcxFilterLookupComboBoxHelper.GetFilterDataType(AValueTypeClass: TcxValueTypeClass): TcxFilterDataType;
begin
  Result := fdtLookup;
end;

class function TcxFilterLookupComboBoxHelper.GetFilterEditClass: TcxCustomEditClass;
begin
  Result := TcxLookupComboBox;
end;

class procedure TcxFilterLookupComboBoxHelper.GetFilterValue(AEdit: TcxCustomEdit;
  AEditProperties: TcxCustomEditProperties; var V: Variant; var S: TCaption);
begin
  V := AEdit.EditValue;
  S := TcxCustomTextEdit(AEdit).ILookupData.GetDisplayText(V);
end;

class function TcxFilterLookupComboBoxHelper.GetSupportedFilterOperators(
  AProperties: TcxCustomEditProperties;
  AValueTypeClass: TcxValueTypeClass;
  AExtendedSet: Boolean = False): TcxFilterControlOperators;
begin
  Result := [fcoEqual, fcoNotEqual, fcoBlanks, fcoNonBlanks];
end;

class procedure TcxFilterLookupComboBoxHelper.InitializeProperties(AProperties,
  AEditProperties: TcxCustomEditProperties; AHasButtons: Boolean);
begin
  inherited InitializeProperties(AProperties, AEditProperties, AHasButtons);
  with TcxCustomLookupEditProperties(AProperties) do
  begin
    DropDownAutoSize := True;
    DropDownListStyle := lsFixedList;
    DropDownSizeable := True;
    IncrementalFiltering := True;
  end;
end;

class function TcxFilterLookupComboBoxHelper.IsValueValid(AValueTypeClass: TcxValueTypeClass;
  var Value: Variant): Boolean;
begin
  Result := True;
end;

class function TcxFilterLookupComboBoxHelper.IsIDefaultValuesProviderNeeded(
  AEditProperties: TcxCustomEditProperties): Boolean;
begin
  Result := TcxCustomDBLookupEditProperties(AEditProperties).IsDefinedByLookup;
end;


{ TcxLookupComboBox }

function TcxLookupComboBox.SupportsItemIndex: Boolean;
begin
  Result := True;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  GetRegisteredEditProperties.Register(TcxLookupComboBoxProperties, scxSEditRepositoryLookupComboBoxItem);
  FilterEditsController.Register(TcxLookupComboBoxProperties, TcxFilterLookupComboBoxHelper);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  FilterEditsController.Unregister(TcxLookupComboBoxProperties, TcxFilterLookupComboBoxHelper);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.

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

unit dxPDFInteractiveFormField;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, SysUtils, Classes, Generics.Defaults, Generics.Collections, dxGenerics, dxPDFCore, dxPDFBase, dxPDFTypes,
  dxPDFAnnotation;

type
  TdxPDFInteractiveFormFieldPermission = (ifpAdd, ifpDelete, ifpFillIn, ifpImport, ifpExport, ifpSubmitStandalone,
    ifpSpawnTemplate, ifpBarcodePlainText, ifpOnline); // for internal use
  TdxPDFInteractiveFormFieldPermissions = set of TdxPDFInteractiveFormFieldPermission; // for internal use
  TdxPDFSignatureFieldLockRange = (lrAll, lrInclude, lrExclude); // for internal use
  TdxPDFTextFieldInputType = (itPlainText, itPassword);

  { TdxPDFInteractiveFormTextFieldEditValue }

  TdxPDFInteractiveFormTextFieldEditValue = class(TdxPDFInteractiveFormCustomFieldEditValue) // for internal use
  strict private
    FMaxLen: Integer;
    //
    procedure SetMaxLen(const AValue: Integer);
  strict protected
    function GetDefaultValueKey: string; override;
    function GetValueKey: string; override;
    function ValidateValue(const AValue: string): string; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    property MaxLen: Integer read FMaxLen write SetMaxLen;
  end;

  { TdxPDFInteractiveFormTextField }

  TdxPDFInteractiveFormTextField = class(TdxPDFInteractiveFormField) // for internal use
  strict private
    function GetAppearanceText: string;
    function GetDefaultText: string;
    function GetInputType: TdxPDFTextFieldInputType;
    function GetMaxLen: Integer;
    function GetMultiLine: Boolean;
    function GetScrollable: Boolean;
    function GetSpellCheck: Boolean;
    function GetText: string;
    function GetWidget: TdxPDFWidgetAnnotation;
    function GetEditValue: TdxPDFInteractiveFormTextFieldEditValue;
    function GetEditValueProvider: TdxPDFInteractiveFormTextField;
    procedure SetDefaultText(const AValue: string);
    procedure SetInputType(const AValue: TdxPDFTextFieldInputType);
    procedure SetMaxLen(const AValue: Integer);
    procedure SetMultiLine(const AValue: Boolean);
    procedure SetScrollable(const AValue: Boolean);
    procedure SetSpellCheck(const AValue: Boolean);
    procedure SetText(const AValue: string);
    //
    function IsPassword: Boolean;
  protected
    function CreateAppearanceBuilder: TObject; override;
    function CreateEditValue: TdxPDFInteractiveFormCustomFieldEditValue; override;
    function GetFieldType: TdxPDFInteractiveFormFieldType; override;
    //
    property EditValueProvider: TdxPDFInteractiveFormTextField read GetEditValueProvider;
  public
    class function GetTypeName: string; override;
    //
    property AppearanceText: string read GetAppearanceText;
    property DefaultText: string read GetDefaultText write SetDefaultText;
    property InputType: TdxPDFTextFieldInputType read GetInputType write SetInputType;
    property MaxLen: Integer read GetMaxLen write SetMaxLen;
    property MultiLine: Boolean read GetMultiLine write SetMultiLine;
    property Scrollable: Boolean read GetScrollable write SetScrollable;
    property SpellCheck: Boolean read GetSpellCheck write SetSpellCheck;
    property Text: string read GetText write SetText;
    property Widget: TdxPDFWidgetAnnotation read GetWidget;
  end;

   { TdxPDFChoiceFieldValue }

  TdxPDFChoiceFieldValue = record
  strict private
    FExportValue: string;
    FValue: string;
  public
    class function Create(const AValue: string): TdxPDFChoiceFieldValue; overload; static;
    class function Create(const AValue, AExportValue: string): TdxPDFChoiceFieldValue; overload; static;
    function IsEqual(const AValue: TdxPDFChoiceFieldValue): Boolean;
    //
    property ExportValue: string read FExportValue;
    property Value: string read FValue;
  end;
  TdxPDFChoiceFieldValueList = class(TList<TdxPDFChoiceFieldValue>); // for internal use

  { TdxPDFInteractiveFormChoiceFieldEditValue }

  TdxPDFInteractiveFormChoiceFieldEditValue = class(TdxPDFInteractiveFormCustomFieldEditValue) // for internal use
  strict private type
    TSearchKind = (skAll, skValue, skExportValue);
  strict private
    FOptions: TdxPDFChoiceFieldValueList;
    FSelectedIndexes: TdxIntegerList;
    //
    function DoIndexOf(const AValue: TdxPDFChoiceFieldValue; ASearchKind: TSearchKind): Integer;
    procedure AddSelectedIndex(const AValue: string);
    procedure SyncSelectedIndexes;
    //
    procedure ReadList(ADictionary: TdxPDFReaderDictionary; const AKey: string; AList: TStringList);
    procedure ReadOptions(ADictionary: TdxPDFReaderDictionary);
    procedure WriteOptions(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
    procedure WriteSelectedIndexes(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
    procedure Validate;
  strict protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoAdd(const AValue: string); override;
    procedure DoDelete(AIndex: Integer); override;
    procedure DoClear; override;
    procedure DoSort; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    function AddItem(const AValue: TdxPDFChoiceFieldValue): Integer;
    function IndexOf(const AValue: string): Integer; overload;
    function IndexOf(const AValue: TdxPDFChoiceFieldValue): Integer; overload;
    function IndexOfExportValue(const AValue: string): Integer;
    procedure ClearItems;
    procedure DeleteItem(AIndex: Integer);
    procedure InsertItem(AIndex: Integer; const AValue: TdxPDFChoiceFieldValue);
    procedure MoveItem(ACurrentIndex, ANewIndex: Integer);
    //
    property Options: TdxPDFChoiceFieldValueList read FOptions;
    property SelectedIndexes: TdxIntegerList read FSelectedIndexes;
  end;

  { TdxPDFInteractiveFormChoiceField }

  TdxPDFInteractiveFormChoiceField = class(TdxPDFInteractiveFormField) // for internal use
  strict private
    FTopIndex: Integer;
    //
    function GetCommitOnSelectionChange: Boolean;
    function GetEditable: Boolean;
    function GetEditValue: TdxPDFInteractiveFormChoiceFieldEditValue;
    function GetItems: TdxPDFChoiceFieldValueList;
    function GetSelectedIndexes: TdxIntegerList;
    function GetSelectedValues: TStringList;
    function GetSpellCheck: Boolean;
    function GetTopIndex: Integer;
    function GetWidget: TdxPDFWidgetAnnotation;
    function GetEditValueProvider: TdxPDFInteractiveFormChoiceField;
    procedure SetCommitOnSelectionChange(const AValue: Boolean);
    procedure SetEditable(const AValue: Boolean);
    procedure SetSpellCheck(const AValue: Boolean);
    procedure SetTopIndex(const AValue: Integer);
    //
    property EditValue: TdxPDFInteractiveFormChoiceFieldEditValue read GetEditValue;
    property EditValueProvider: TdxPDFInteractiveFormChoiceField read GetEditValueProvider;
  protected
    function CreateAppearanceBuilder: TObject; override;
    function CreateEditValue: TdxPDFInteractiveFormCustomFieldEditValue; override;
    function ForceAppearanceChangeOnEditValueChanged: Boolean; override;
    function GetFieldType: TdxPDFInteractiveFormFieldType; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure DoWrite(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function GetTypeName: string; override;
    //
    function AddItem(const AValue: TdxPDFChoiceFieldValue): Integer;
    function IndexOf(const AValue: string): Integer; overload;
    function IndexOf(const AValue: TdxPDFChoiceFieldValue): Integer; overload;
    function IndexOfExportValue(const AValue: string): Integer;
    procedure ClearItems;
    procedure DeleteItem(AIndex: Integer);
    procedure InsertItem(AIndex: Integer; const AValue: TdxPDFChoiceFieldValue);
    procedure MoveItem(ACurrentIndex, ANewIndex: Integer);
    //
    property CommitOnSelectionChange: Boolean read GetCommitOnSelectionChange write SetCommitOnSelectionChange;
    property Editable: Boolean read GetEditable write SetEditable;
    property Items: TdxPDFChoiceFieldValueList read GetItems;
    property SelectedIndexes: TdxIntegerList read GetSelectedIndexes;
    property SelectedValues: TStringList read GetSelectedValues;
    property SpellCheck: Boolean read GetSpellCheck write SetSpellCheck;
    property TopIndex: Integer read GetTopIndex write SetTopIndex;
    property Widget: TdxPDFWidgetAnnotation read GetWidget;
    //
    property MultiSelect;
  end;

  { TdxPDFInteractiveFormButtonFieldEditValue }

  TdxPDFInteractiveFormButtonFieldEditValue = class(TdxPDFInteractiveFormCustomFieldEditValue) // for internal use
  protected
    procedure Initialize; override;
  end;

  { TdxPDFInteractiveFormButtonField }

  TdxPDFInteractiveFormButtonField = class(TdxPDFInteractiveFormField) // for internal use
  strict private
    FKidStateList: TStringList;
    //
    function GetDefaultState: string;
    function GetOnStateName: string;
    function GetOffStateName: string;
    function GetRadiosInUnison: Boolean;
    function GetState: string;
    function GetToggleToOff: Boolean;
    function GetValue: string;
    function GetEditValueProvider: TdxPDFInteractiveFormButtonField;
    function GetWidget: TdxPDFWidgetAnnotation;
    procedure SetRadiosInUnison(const AValue: Boolean);
    procedure SetToggleToOff(const AValue: Boolean);
    procedure SetState(const AValue: string);
    //
    function FindOption(const AName: string): string;
    procedure ReadOptions(ADictionary: TdxPDFReaderDictionary);
    //
    function ConvertToKidState(AOption: TdxPDFBase): string;
    function TryFindAppearanceName(const AValue: string): Boolean;
    procedure RebuildCheckBoxAppearance(AForce: Boolean);
    procedure RebuildPushButtonAppearance(AForce: Boolean);
    procedure RebuildRadioGroupAppearance(AForce: Boolean);
    procedure SetAppearanceName(const AValue: string);
  protected
    function CreateEditValue: TdxPDFInteractiveFormCustomFieldEditValue; override;
    function GetFieldType: TdxPDFInteractiveFormFieldType; override;
    procedure BeginUpdate; override;
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure EndUpdate; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure DoRebuildAppearance(AForce: Boolean); override;
    procedure DoWrite(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property EditValueProvider: TdxPDFInteractiveFormButtonField read GetEditValueProvider;
    property KidStateList: TStringList read FKidStateList;
  public
    class function GetTypeName: string; override;
    //
    function UseDefaultAppearance: Boolean; override;
    procedure ResetEditValue; override;
    procedure SetEditValue(const AValue: string); override;
    procedure SetExportEditValue(const AValue: string); override;
    //
    property DefaultState: string read GetDefaultState;
    property OnStateName: string read GetOnStateName;
    property OffStateName: string read GetOffStateName;
    property RadiosInUnison: Boolean read GetRadiosInUnison write SetRadiosInUnison;
    property State: string read GetState write SetState;
    property ToggleToOff: Boolean read GetToggleToOff write SetToggleToOff;
    property Value: string read GetValue;
    property Widget: TdxPDFWidgetAnnotation read GetWidget;
  end;

  { TdxPDFSignatureFieldLock }

  TdxPDFSignatureFieldLock = class(TdxPDFObject) // for internal use
  strict private const
    LockRangeMap: array[TdxPDFSignatureFieldLockRange] of string = ('All', 'Include', 'Exclude');
  strict private
    FFieldNames: TStringList;
    FRange: TdxPDFSignatureFieldLockRange;
    //
    function ReadLockRange(AObject: TdxPDFBase): TdxPDFSignatureFieldLockRange;
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    procedure DoRead(ADictionary: TdxPDFReaderDictionary); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
  public
    class function Parse(ADictionary: TdxPDFReaderDictionary): TdxPDFSignatureFieldLock; static;
    //
    property FieldNames: TStringList read FFieldNames;
    property Range: TdxPDFSignatureFieldLockRange read FRange;
  end;

  { TdxPDFInteractiveFormSignatureField }

  TdxPDFInteractiveFormSignatureField = class(TdxPDFInteractiveFormField) // for internal use
  strict private
    FCanWriteSignature: Boolean;
    FLock: TdxPDFSignatureFieldLock;
    FSignature: TObject; {TdxPDFSignature}
  protected
    function GetFieldType: TdxPDFInteractiveFormFieldType; override;
    procedure DestroySubClasses; override;
    procedure Read(ADictionary: TdxPDFReaderDictionary; ANumber: Integer); override;
    procedure Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary); override;
    //
    property CanWriteSignature: Boolean read FCanWriteSignature;
  public
    constructor Create(AForm: TdxPDFInteractiveForm; AWidget: TdxPDFWidgetAnnotation; ASignature: TObject); reintroduce;
    class function GetTypeName: string; override;
    //
    property Lock: TdxPDFSignatureFieldLock read FLock;
    property Signature: TObject read FSignature;
  end;

implementation

uses
  Math, Variants, dxCore, dxStringHelper, dxPDFCommandConstructor, dxPDFInteractivity, dxPDFSignature, dxPDFUtils,
  dxPDFInteractiveFormFieldAppearanceBuilder;

const
  dxThisUnitName = 'dxPDFInteractiveFormField';

type
  TdxPDFWidgetAnnotationAccess = class(TdxPDFWidgetAnnotation);

  TdxPDFInteractiveFormFieldValueComparer = class(TInterfacedObject, IComparer<TdxPDFChoiceFieldValue>)
  strict private
    function Compare(const Left, Right: TdxPDFChoiceFieldValue): Integer;
  end;

{ TdxPDFInteractiveFormFieldValueComparer }

function TdxPDFInteractiveFormFieldValueComparer.Compare(const Left, Right: TdxPDFChoiceFieldValue): Integer;
begin
  Result := AnsiCompareText(Left.Value, Right.Value);
  if Result = 0 then
    Result := AnsiCompareText(Left.ExportValue, Right.ExportValue);
end;

{ TdxPDFInteractiveFormTextFieldEditValue }

function TdxPDFInteractiveFormTextFieldEditValue.GetDefaultValueKey: string;
begin
  Result := TdxPDFKeywords.TextDefaultValue;
end;

function TdxPDFInteractiveFormTextFieldEditValue.GetValueKey: string;
begin
  Result := TdxPDFKeywords.TextValue;
end;

function TdxPDFInteractiveFormTextFieldEditValue.ValidateValue(const AValue: string): string;
begin
  Result := AValue;
  if (MaxLen > 0) and (Length(Result) > MaxLen) then
    Result := TdxStringHelper.Substring(Result, 0, MaxLen)
end;

procedure TdxPDFInteractiveFormTextFieldEditValue.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  MaxLen := ADictionary.GetInteger(TdxPDFKeywords.MaxLength, 0);
end;

procedure TdxPDFInteractiveFormTextFieldEditValue.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.MaxLength, MaxLen, 0);
end;

procedure TdxPDFInteractiveFormTextFieldEditValue.SetMaxLen(const AValue: Integer);
begin
  if FMaxLen <> AValue then
  begin
    FMaxLen := AValue;
    SetExportValue(Text);
  end;
end;

{ TdxPDFInteractiveFormTextField }

class function TdxPDFInteractiveFormTextField.GetTypeName: string;
begin
  Result := 'Tx';
end;

function TdxPDFInteractiveFormTextField.IsPassword: Boolean;
begin
  Result := HasFlag(ffPassword);
end;

function TdxPDFInteractiveFormTextField.CreateAppearanceBuilder: TObject;
begin
  Result := TdxPDFTextFieldAppearanceBuilder.Create(Widget, Self, TdxPDFARGBColor.Null, FontProvider);
end;

function TdxPDFInteractiveFormTextField.CreateEditValue: TdxPDFInteractiveFormCustomFieldEditValue;
begin
  Result := TdxPDFInteractiveFormTextFieldEditValue.Create(Self);
end;

function TdxPDFInteractiveFormTextField.GetFieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftText;
end;

function TdxPDFInteractiveFormTextField.GetAppearanceText: string;
var
  I: Integer;
begin
  if IsPassword then
    for I := 0 to Length(Text) - 1 do
      Result := Result + '*'
  else
    Result := Text;
end;

function TdxPDFInteractiveFormTextField.GetDefaultText: string;
begin
  Result := EditValue.DefaultText;
end;

function TdxPDFInteractiveFormTextField.GetInputType: TdxPDFTextFieldInputType;
begin
  if IsPassword then
    Result := itPassword
  else
    Result := itPlainText;
end;

function TdxPDFInteractiveFormTextField.GetMaxLen: Integer;
begin
  Result := GetEditValue.MaxLen;
end;

function TdxPDFInteractiveFormTextField.GetMultiLine: Boolean;
begin
  Result := HasFlag(ffMultiLine);
end;

function TdxPDFInteractiveFormTextField.GetScrollable: Boolean;
begin
  Result := not HasFlag(ffDoNotScroll);
end;

function TdxPDFInteractiveFormTextField.GetSpellCheck: Boolean;
begin
  Result := not HasFlag(ffDoNotSpellCheck);
end;

function TdxPDFInteractiveFormTextField.GetText: string;
begin
  Result := EditValue.Text;
end;

function TdxPDFInteractiveFormTextField.GetWidget: TdxPDFWidgetAnnotation;
begin
  Result := inherited Widget as TdxPDFWidgetAnnotation;
end;

function TdxPDFInteractiveFormTextField.GetEditValue: TdxPDFInteractiveFormTextFieldEditValue;
begin
  Result := inherited EditValue as TdxPDFInteractiveFormTextFieldEditValue;
end;

function TdxPDFInteractiveFormTextField.GetEditValueProvider: TdxPDFInteractiveFormTextField;
begin
  Result := inherited EditValueProvider as TdxPDFInteractiveFormTextField;
end;

procedure TdxPDFInteractiveFormTextField.SetDefaultText(const AValue: string);
begin
  EditValue.DefaultText := AValue;
end;

procedure TdxPDFInteractiveFormTextField.SetInputType(const AValue: TdxPDFTextFieldInputType);
begin
  if InputType = AValue then
    Exit;
  case AValue of
    itPassword:
      begin
        SetFlag(ffPassword, True);
        Flags := TdxPDFInteractiveFormFieldFlags(Ord(Flags) and not (Ord(ffComb) or Ord(ffFileSelect) or
          Ord(ffRichText) or Ord(ffMultiLine)));
      end;
  else
      begin
        Flags := TdxPDFInteractiveFormFieldFlags(Ord(Flags) and not (Ord(ffComb) or Ord(ffPassword) or Ord(ffFileSelect) or
          Ord(ffRichText)));
      end;
  end;
  LayoutChanged;
end;

procedure TdxPDFInteractiveFormTextField.SetMaxLen(const AValue: Integer);
begin
  GetEditValue.MaxLen := AValue;
  CheckChanges;
end;

procedure TdxPDFInteractiveFormTextField.SetMultiLine(const AValue: Boolean);
begin
  if MultiLine <> AValue then
  begin
    SetFlag(ffMultiLine, AValue);
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormTextField.SetScrollable(const AValue: Boolean);
begin
  if Scrollable <> AValue then
  begin
    SetFlag(ffDoNotScroll, not AValue);
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormTextField.SetSpellCheck(const AValue: Boolean);
begin
  if SpellCheck <> AValue then
  begin
    SetFlag(ffDoNotSpellCheck, not AValue);
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormTextField.SetText(const AValue: string);
begin
  SetEditValue(AValue);
end;

{ TdxPDFInteractiveFormChoiceField }

class function TdxPDFInteractiveFormChoiceField.GetTypeName: string;
begin
  Result := 'Ch';
end;

function TdxPDFInteractiveFormChoiceField.AddItem(const AValue: TdxPDFChoiceFieldValue): Integer;
begin
  Result := EditValue.AddItem(AValue);
  CheckChanges;
end;

function TdxPDFInteractiveFormChoiceField.IndexOf(const AValue: string): Integer;
begin
  Result := EditValue.IndexOf(AValue);
end;

function TdxPDFInteractiveFormChoiceField.IndexOf(const AValue: TdxPDFChoiceFieldValue): Integer;
begin
  Result := EditValue.IndexOf(AValue);
end;

function TdxPDFInteractiveFormChoiceField.IndexOfExportValue(const AValue: string): Integer;
begin
  Result := EditValue.IndexOfExportValue(AValue);
end;

procedure TdxPDFInteractiveFormChoiceField.InsertItem(AIndex: Integer; const AValue: TdxPDFChoiceFieldValue);
begin
  EditValue.InsertItem(AIndex, AValue);
  CheckChanges;
end;

procedure TdxPDFInteractiveFormChoiceField.MoveItem(ACurrentIndex, ANewIndex: Integer);
begin
  EditValue.MoveItem(ACurrentIndex, ANewIndex);
  CheckChanges;
end;

procedure TdxPDFInteractiveFormChoiceField.ClearItems;
begin
  EditValue.ClearItems;
  CheckChanges;
end;

procedure TdxPDFInteractiveFormChoiceField.DeleteItem(AIndex: Integer);
begin
  EditValue.DeleteItem(AIndex);
  CheckChanges;
end;

function TdxPDFInteractiveFormChoiceField.GetCommitOnSelectionChange: Boolean;
begin
  Result := HasFlag(ffCommitOnSelChange);
end;

function TdxPDFInteractiveFormChoiceField.GetEditable: Boolean;
begin
  Result := HasFlag(ffEdit);
end;

function TdxPDFInteractiveFormChoiceField.GetEditValue: TdxPDFInteractiveFormChoiceFieldEditValue;
begin
  Result := inherited EditValue as TdxPDFInteractiveFormChoiceFieldEditValue;
end;

function TdxPDFInteractiveFormChoiceField.GetItems: TdxPDFChoiceFieldValueList;
begin
  Result := EditValue.Options;
end;

function TdxPDFInteractiveFormChoiceField.CreateAppearanceBuilder: TObject;
begin
  Result := TdxPDFChoiceFieldAppearanceBuilder.Create(Widget, Self, GetBackgroundARGBColor, FontProvider);
end;

function TdxPDFInteractiveFormChoiceField.CreateEditValue: TdxPDFInteractiveFormCustomFieldEditValue;
begin
  Result := TdxPDFInteractiveFormChoiceFieldEditValue.Create(Self);
end;

function TdxPDFInteractiveFormChoiceField.ForceAppearanceChangeOnEditValueChanged: Boolean;
begin
  Result := True;
end;

function TdxPDFInteractiveFormChoiceField.GetFieldType: TdxPDFInteractiveFormFieldType;
begin
  if HasFlag(ffCombo) then
    Result := ftComboBox
  else
    Result := ftListBox;
end;

procedure TdxPDFInteractiveFormChoiceField.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  FTopIndex := ADictionary.GetInteger(TdxPDFKeywords.ChoiceTopIndex, 0);
  inherited DoRead(ADictionary);
end;

procedure TdxPDFInteractiveFormChoiceField.DoWrite(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited DoWrite(AHelper, ADictionary);
  ADictionary.Add(TdxPDFKeywords.ChoiceTopIndex, FTopIndex, 0);
end;

function TdxPDFInteractiveFormChoiceField.GetSelectedIndexes: TdxIntegerList;
begin
  Result := TdxPDFInteractiveFormChoiceFieldEditValue(EditValueProvider.EditValue).SelectedIndexes;
end;

function TdxPDFInteractiveFormChoiceField.GetSelectedValues: TStringList;
begin
  Result := EditValue.ValueList;
end;

function TdxPDFInteractiveFormChoiceField.GetSpellCheck: Boolean;
begin
  Result := not HasFlag(ffDoNotSpellCheck);
end;

function TdxPDFInteractiveFormChoiceField.GetTopIndex: Integer;
begin
  Result := EditValueProvider.FTopIndex;
end;

function TdxPDFInteractiveFormChoiceField.GetWidget: TdxPDFWidgetAnnotation;
begin
  Result := inherited Widget as TdxPDFWidgetAnnotation;
end;

function TdxPDFInteractiveFormChoiceField.GetEditValueProvider: TdxPDFInteractiveFormChoiceField;
begin
  Result := inherited EditValueProvider as TdxPDFInteractiveFormChoiceField;
end;

procedure TdxPDFInteractiveFormChoiceField.SetCommitOnSelectionChange(const AValue: Boolean);
begin
  SetFlag(ffCommitOnSelChange, AValue);
end;

procedure TdxPDFInteractiveFormChoiceField.SetEditable(const AValue: Boolean);
begin
  SetFlag(ffEdit, AValue);
end;

procedure TdxPDFInteractiveFormChoiceField.SetSpellCheck(const AValue: Boolean);
begin
  SetFlag(ffDoNotSpellCheck, not AValue);
end;

procedure TdxPDFInteractiveFormChoiceField.SetTopIndex(const AValue: Integer);
begin
  if FTopIndex <> AValue then
  begin
    FTopIndex := AValue;
    Changed([dcModified, dcInteractiveLayer]);
  end;
end;

{ TdxPDFChoiceFieldValue }

class function TdxPDFChoiceFieldValue.Create(const AValue: string): TdxPDFChoiceFieldValue;
begin
  Result := Create(AValue, AValue);
end;

class function TdxPDFChoiceFieldValue.Create(const AValue, AExportValue: string): TdxPDFChoiceFieldValue;
begin
  Result.FValue := AValue;
  Result.FExportValue := AExportValue;
end;

function TdxPDFChoiceFieldValue.IsEqual(const AValue: TdxPDFChoiceFieldValue): Boolean;
begin
  Result := (CompareText(Value, AValue.Value) = 0) and (CompareText(ExportValue, AValue.ExportValue) = 0);
end;

{ TdxPDFInteractiveFormChoiceFieldEditValue }

function TdxPDFInteractiveFormChoiceFieldEditValue.AddItem(const AValue: TdxPDFChoiceFieldValue): Integer;
begin
  if not CanChange then
    Exit(-1);
  Result := FOptions.Add(AValue);
  Sort;
  if Sorted then
    Result := IndexOf(AValue.Value);
  DoChanged;
end;

function TdxPDFInteractiveFormChoiceFieldEditValue.IndexOf(const AValue: string): Integer;
begin
  Result := DoIndexOf(TdxPDFChoiceFieldValue.Create(AValue), skValue);
end;

function TdxPDFInteractiveFormChoiceFieldEditValue.IndexOf(const AValue: TdxPDFChoiceFieldValue): Integer;
begin
  Result := DoIndexOf(AValue, skAll);
end;

function TdxPDFInteractiveFormChoiceFieldEditValue.IndexOfExportValue(const AValue: string): Integer;
begin
  Result := DoIndexOf(TdxPDFChoiceFieldValue.Create(AValue), skExportValue);
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.ClearItems;
begin
  if not CanChange then
    Exit;
  DoClear;
  FOptions.Clear;
  DoChanged;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.DeleteItem(AIndex: Integer);
begin
  if not CanChange then
    Exit;
  FOptions.Delete(AIndex);
  DoDelete(AIndex);
  DoChanged;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.InsertItem(AIndex: Integer; const AValue: TdxPDFChoiceFieldValue);
begin
  if not CanChange then
    Exit;
  FOptions.Insert(AIndex, AValue);
  Sort;
  SyncSelectedIndexes;
  DoChanged;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.MoveItem(ACurrentIndex, ANewIndex: Integer);
begin
  if not CanChange then
    Exit;
  FOptions.Move(ACurrentIndex, ANewIndex);
  Sort;
  SyncSelectedIndexes;
  DoChanged;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.CreateSubClasses;
begin
  inherited CreateSubClasses;;
  FSelectedIndexes := TdxIntegerList.Create;
  FOptions := TdxPDFChoiceFieldValueList.Create;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.DestroySubClasses;
begin
  FreeAndNil(FOptions);
  FreeAndNil(FSelectedIndexes);
  inherited DestroySubClasses;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.DoAdd(const AValue: string);
begin
  inherited DoAdd(AValue);
  AddSelectedIndex(AValue);
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.DoDelete(AIndex: Integer);
begin
  inherited DoDelete(AIndex);
  if InRange(AIndex, 0, FSelectedIndexes.Count - 1) then
    FSelectedIndexes.Delete(AIndex);
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.DoClear;
begin
  inherited DoClear;
  FSelectedIndexes.Clear;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.DoSort;
var
  AComparer: TdxPDFInteractiveFormFieldValueComparer;
begin
  inherited DoSort;
  AComparer := TdxPDFInteractiveFormFieldValueComparer.Create;
  try
    FOptions.Sort(AComparer);
  finally
    AComparer.Free;
  end;
  SyncSelectedIndexes;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  ReadOptions(ADictionary);
  ReadList(ADictionary, GetDefaultValueKey, DefaultValueList);
  ReadList(ADictionary, GetValueKey, ValueList);
  Validate;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.Write(AHelper: TdxPDFWriterHelper;
  ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  WriteOptions(AHelper, ADictionary);
  WriteSelectedIndexes(AHelper, ADictionary);
end;

function TdxPDFInteractiveFormChoiceFieldEditValue.DoIndexOf(const AValue: TdxPDFChoiceFieldValue;
  ASearchKind: TSearchKind): Integer;

  function IsEqualValue(const V1, V2: string): Boolean;
  begin
    Result := CompareText(V1, V2) = 0;
  end;

var
  AFound: Boolean;
  I: Integer;
begin
  Result := -1;
  for I := 0 to FOptions.Count - 1 do
  begin
    case ASearchKind of
      skValue:
        AFound := IsEqualValue(AValue.Value, FOptions[I].Value);
      skExportValue:
        AFound := IsEqualValue(AValue.ExportValue, FOptions[I].ExportValue);
    else
      AFound := AValue.IsEqual(FOptions[I]);
    end;
    if AFound then
    begin
      Result := I;
      Break;
    end;
  end;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.AddSelectedIndex(const AValue: string);
begin
  FSelectedIndexes.Add(IndexOfExportValue(AValue));
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.ReadList(ADictionary: TdxPDFReaderDictionary; const AKey: string;
  AList: TStringList);
begin
  AList.Clear;
  ADictionary.PopulateList(AKey,
    procedure(AValue: string)
    begin
      AList.Add(AValue);
    end);
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.ReadOptions(ADictionary: TdxPDFReaderDictionary);

  function ReadOption(AObject: TdxPDFBase): TdxPDFChoiceFieldValue;
  var
    AArray: TdxPDFArray;
  begin
    if AObject = nil then
      Exit;
    if AObject.ObjectType = otString then
      Result := TdxPDFChoiceFieldValue.Create(TdxPDFString(AObject).Text)
    else
      if AObject.ObjectType = otArray then
      begin
        AArray := TdxPDFArray(AObject);
        if AArray.Count <> 2 then
          TdxPDFUtils.RaiseTestException;
        Result := TdxPDFChoiceFieldValue.Create((AArray[1] as TdxPDFString).Text, (AArray[0] as TdxPDFString).Text);
      end;
  end;

var
  AArray: TdxPDFArray;
  I: Integer;
begin
  FOptions.Clear;
  if not ADictionary.TryGetArray(TdxPDFKeywords.FieldOptions, AArray) then
    Exit;
  for I := 0 to AArray.ElementList.Count - 1 do
    FOptions.Add(ReadOption(Repository.ResolveReference(AArray.Elements[I])));
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.SyncSelectedIndexes;
var
  I: Integer;
begin
  FSelectedIndexes.Clear;
  for I := 0 to ValueList.Count - 1 do
    AddSelectedIndex(ValueList[I]);
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.WriteOptions(AHelper: TdxPDFWriterHelper;
  ADictionary: TdxPDFWriterDictionary);

  procedure Write(const AOption: TdxPDFChoiceFieldValue; AArray: TdxPDFArray);
  var
    APair: TdxPDFArray;
  begin
    if AOption.ExportValue = AOption.Value then
      AArray.Add(AOption.ExportValue)
    else
    begin
      APair := AHelper.CreateArray;
      APair.Add(AOption.ExportValue);
      APair.Add(AOption.Value);
      AArray.Add(APair);
    end;
  end;

var
  AArray: TdxPDFArray;
  AOption: TdxPDFChoiceFieldValue;
begin
  if FOptions.Count > 0 then
  begin
    AArray := AHelper.CreateArray;
    for AOption in FOptions do
      Write(AOption, AArray);
    ADictionary.Add(TdxPDFKeywords.FieldOptions, AArray);
  end;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.WriteSelectedIndexes(AHelper: TdxPDFWriterHelper;
  ADictionary: TdxPDFWriterDictionary);
var
  AArray: TdxPDFArray;
  I: Integer;
begin
  if FSelectedIndexes.Count > 0 then
  begin
    AArray := AHelper.CreateArray;
    for I := 0 to FSelectedIndexes.Count - 1 do
      AArray.Add(FSelectedIndexes[I]);
    ADictionary.Add(TdxPDFKeywords.ChoiceSelectedIndexes, AArray);
  end;
end;

procedure TdxPDFInteractiveFormChoiceFieldEditValue.Validate;
var
  I: Integer;
begin
  if not MultiSelect and (ValueList.Count > 1) then
    DoClear;

  for I := ValueList.Count - 1 downto 0 do
    if IndexOfExportValue(ValueList[I]) = -1 then
      ValueList.Delete(I);
  SyncSelectedIndexes;
end;

{ TdxPDFInteractiveFormButtonFieldEditValue }

procedure TdxPDFInteractiveFormButtonFieldEditValue.Initialize;
begin
  inherited Initialize;
  DefaultText := TdxPDFKeywords.OffStateName;
end;

{ TdxPDFInteractiveFormButtonField }

class function TdxPDFInteractiveFormButtonField.GetTypeName: string;
begin
  Result := 'Btn';
end;

function TdxPDFInteractiveFormButtonField.CreateEditValue: TdxPDFInteractiveFormCustomFieldEditValue;
begin
  Result := TdxPDFInteractiveFormButtonFieldEditValue.Create(nil);
end;

function TdxPDFInteractiveFormButtonField.GetFieldType: TdxPDFInteractiveFormFieldType;
begin
  if IsPushButton then
    Result := ftPushButton
  else
    if IsRadioButton then
      Result := ftRadioGroup
    else
      Result := ftCheckBox;
end;

procedure TdxPDFInteractiveFormButtonField.BeginUpdate;
var
  AKid: TdxPDFInteractiveFormButtonField;
  I: Integer;
begin
  inherited BeginUpdate;
  if IsRadioButton and (Kids <> nil) then
    for I := 0 to Kids.Count - 1 do
    begin
      AKid := Kids[I] as TdxPDFInteractiveFormButtonField;
      if (AKid.Widget <> nil) and (AKid.FieldType = ftRadioGroup) then
        AKid.BeginUpdate;
    end;
end;

procedure TdxPDFInteractiveFormButtonField.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FKidStateList := TStringList.Create;
end;

procedure TdxPDFInteractiveFormButtonField.DestroySubClasses;
begin
  FreeAndNil(FKidStateList);
  inherited DestroySubClasses;
end;

procedure TdxPDFInteractiveFormButtonField.EndUpdate;
var
  AKid: TdxPDFInteractiveFormButtonField;
  I: Integer;
begin
  if IsRadioButton and (Kids <> nil) then
    for I := 0 to Kids.Count - 1 do
    begin
      AKid := Kids[I] as TdxPDFInteractiveFormButtonField;
      if (AKid.Widget <> nil) and (AKid.FieldType = ftRadioGroup) then
        AKid.CancelUpdate;
    end;
  inherited EndUpdate;
end;

procedure TdxPDFInteractiveFormButtonField.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  ReadOptions(ADictionary);
end;

procedure TdxPDFInteractiveFormButtonField.DoRebuildAppearance(AForce: Boolean);
begin
  case FieldType of
    ftCheckBox:
      RebuildCheckBoxAppearance(AForce);
    ftPushButton:
      RebuildPushButtonAppearance(AForce);
    ftRadioGroup:
      RebuildRadioGroupAppearance(AForce);
  end;
end;

procedure TdxPDFInteractiveFormButtonField.DoWrite(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited DoWrite(AHelper, ADictionary);
  if (FKidStateList.Count > 0) and AHelper.Context.AllowPageParentReference then
    ADictionary.Add(TdxPDFKeywords.FieldOptions, FKidStateList);
end;

function TdxPDFInteractiveFormButtonField.UseDefaultAppearance: Boolean;
begin
  Result := IsPushButton;
end;

procedure TdxPDFInteractiveFormButtonField.ResetEditValue;
begin
  if not IsPushButton then
    inherited ResetEditValue;
end;

procedure TdxPDFInteractiveFormButtonField.SetEditValue(const AValue: string);
var
  AState, ANewState: string;
begin
  if AValue <> '' then
    AState := AValue
  else
    AState := OffStateName;
  if SameText(State, AState) then
    Exit;
  ANewState := AState;
  if Widget <> nil then
    Widget.AppearanceName := ANewState;
  if not TryFindAppearanceName(ANewState) then
    ANewState := OffStateName;

  SetAppearanceName(ANewState);
  inherited SetEditValue(ANewState);
end;

procedure TdxPDFInteractiveFormButtonField.SetExportEditValue(const AValue: string);
begin
  SetEditValue(AValue);
end;

function TdxPDFInteractiveFormButtonField.ConvertToKidState(AOption: TdxPDFBase): string;
begin
  case AOption.ObjectType of
    otString:
      Result := TdxPDFString(AOption).Value;
    otIndirectReference:
      Result := Repository.GetString(AOption.Number);
  else
    Result := '';
  end;
end;

function TdxPDFInteractiveFormButtonField.TryFindAppearanceName(const AValue: string): Boolean;
var
  I: Integer;
begin
  Result := True;
  if Kids = nil then
    Exit;
  if (AValue <> '') and (AValue <> OffStateName) then
  begin
    Result := False;
    for I := 0 to Kids.Count - 1 do
    begin
      Result := (Kids[I] as TdxPDFInteractiveFormButtonField).HasAppearance(AValue);
      if Result then
        Break;
    end;
  end;
end;

procedure TdxPDFInteractiveFormButtonField.RebuildCheckBoxAppearance(AForce: Boolean);
var
  ABackgroundColor: TdxPDFARGBColor;
  AButtonStyle: TdxPDFButtonStyle;
  AFontColor: TdxPDFColor;

  procedure DoBuild(AChecked: Boolean; AState: TdxPDFAnnotationAppearanceState; AAppearanceName: string);
  var
    ABuilder: TdxPDFButtonFieldAppearanceBuilder;
  begin
    ABuilder := TdxPDFButtonFieldAppearanceBuilder.Create(Widget, Self, AButtonStyle,  AFontColor,
      AChecked, IsRadioButton, ABackgroundColor);
    try
      DoBuildAppearance(ABuilder, AState, AAppearanceName);
    finally
      ABuilder.Free;
    end;
  end;

begin
  if not IsPushButton and not IsRadioButton then
    Exit;
  AButtonStyle := Widget.ButtonStyle;
  ABackgroundColor := BackgroundARGBColor;
  AFontColor := TdxPDFColor.Create(TextState.FontColor);

  DoBuild(True, asNormal, Widget.GetOnAppearanceName);
  DoBuild(False, asNormal, OffStateName);
  DoBuild(True, asDown, Widget.GetOnAppearanceName);
  DoBuild(True, asDown, OffStateName);
end;

procedure TdxPDFInteractiveFormButtonField.RebuildPushButtonAppearance(AForce: Boolean);
var
  ABuilder: TdxPDFPushButtonFieldAppearanceBuilder;
begin
  ABuilder := TdxPDFPushButtonFieldAppearanceBuilder.Create(Widget, Self, FontProvider);
  try
    DoBuildAppearance(ABuilder, asNormal, '');
  finally
    ABuilder.Free;
  end;
end;

procedure TdxPDFInteractiveFormButtonField.RebuildRadioGroupAppearance(AForce: Boolean);
var
  AKid: TdxPDFInteractiveFormButtonField;
  I: Integer;
begin
  if EditValueProvider.Kids = nil then
    Exit;
  for I := 0 to EditValueProvider.Kids.Count - 1 do
  begin
    AKid := EditValueProvider.Kids[I] as  TdxPDFInteractiveFormButtonField;
    if (AKid.Widget <> nil) and ((AKid.FieldType = ftRadioGroup) and (AKid.IsPushButton or AForce)) then
      AKid.RebuildCheckBoxAppearance(AForce);
  end;
end;

function TdxPDFInteractiveFormButtonField.GetDefaultState: string;
begin
  Result := EditValue.DefaultText;
end;

function TdxPDFInteractiveFormButtonField.GetOnStateName: string;
begin
  if Widget <> nil then
    Result := GetWidget.GetOnAppearanceName
  else
    Result := OffStateName;
end;

function TdxPDFInteractiveFormButtonField.GetOffStateName: string;
begin
  Result := TdxPDFKeywords.OffStateName;
end;

function TdxPDFInteractiveFormButtonField.GetRadiosInUnison: Boolean;
begin
  Result := HasFlag(ffRadiosInUnison);
end;

function TdxPDFInteractiveFormButtonField.GetState: string;
begin
  Result := EditValue.Text;
end;

function TdxPDFInteractiveFormButtonField.GetToggleToOff: Boolean;
begin
  Result := not HasFlag(ffNoToggleToOff);
end;

function TdxPDFInteractiveFormButtonField.GetValue: string;
var
  AOptionValue: string;
begin
  AOptionValue := FindOption(State);
  if AOptionValue = '' then
  begin
    if EditValueProvider.State = '' then
      Result := OffStateName
    else
      Result := EditValueProvider.State;
  end
  else
    Result := AOptionValue;
end;

function TdxPDFInteractiveFormButtonField.GetEditValueProvider: TdxPDFInteractiveFormButtonField;
begin
  Result := inherited EditValueProvider as TdxPDFInteractiveFormButtonField;
end;

function TdxPDFInteractiveFormButtonField.GetWidget: TdxPDFWidgetAnnotation;
begin
  Result := inherited Widget as TdxPDFWidgetAnnotation;
end;

procedure TdxPDFInteractiveFormButtonField.SetRadiosInUnison(const AValue: Boolean);
begin
  if RadiosInUnison <> AValue then
  begin
    SetFlag(ffRadiosInUnison, AValue);
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormButtonField.SetToggleToOff(const AValue: Boolean);
begin
  if ToggleToOff <> AValue then
  begin
    SetFlag(ffNoToggleToOff, not AValue);
    LayoutChanged;
  end;
end;

procedure TdxPDFInteractiveFormButtonField.SetState(const AValue: string);
begin
  SetEditValue(AValue);
end;

function TdxPDFInteractiveFormButtonField.FindOption(const AName: string): string;
var
  AWidget: TdxPDFWidgetAnnotation;
  I: Integer;
begin
  if (EditValueProvider.Kids <> nil) and (EditValueProvider.KidStateList <> nil) and (EditValueProvider.KidStateList.Count = EditValueProvider.Kids.Count) then
    for I := 0 to EditValueProvider.Kids.Count - 1 do
    begin
      AWidget := EditValueProvider.Kids[I].Widget as TdxPDFWidgetAnnotation;
      if (AWidget <> nil) and (AName = TdxPDFWidgetAnnotationAccess(AWidget).GetActualAppearanceName) then
        Exit(EditValueProvider.KidStateList[I]);
    end;
end;

procedure TdxPDFInteractiveFormButtonField.ReadOptions(ADictionary: TdxPDFReaderDictionary);
var
  AFound: Boolean;
  AName: string;
  AOptions: TdxPDFArray;
  AWidget: TdxPDFCustomAnnotation;
  I: Integer;
begin
  if not ADictionary.TryGetArray(TdxPDFKeywords.FieldOptions, AOptions) or IsPushButton then
    Exit;

  if Kids = nil then
    for I := 0 to AOptions.Count - 1 do
      FKidStateList.Add(ConvertToKidState(AOptions.ElementList[I]))
  else
  begin
    AFound := False;
    if AOptions.Count < Kids.Count then
      TdxPDFUtils.RaiseException;
    for I := 0 to Kids.Count - 1 do
    begin
      AWidget := Kids[I].Widget;
      FKidStateList.Add(ConvertToKidState(AOptions.ElementList[I]));
      if ((State = '') or (State = AWidget.AppearanceName)) and
        ((DefaultState = '') or (AWidget.Appearance.Names.IndexOf(DefaultState) <> -1)) then
          AFound := True;
    end;
    if not AFound then
      for I := 0 to Kids.Count - 1 do
      begin
        AName := Kids[I].Widget.AppearanceName;
        if (AName <> '') and (AName <> OffStateName) then
        begin
          EditValue.SetValue(AName);
          Break;
        end;
      end;
  end;
end;

procedure TdxPDFInteractiveFormButtonField.SetAppearanceName(const AValue: string);
var
  AField: TdxPDFInteractiveFormButtonField;
  AName: string;
  I: Integer;
begin
  if EditValueProvider.Kids = nil then
    Exit;
  for I := 0 to EditValueProvider.Kids.Count - 1 do
  begin
    AField := EditValueProvider.Kids[I] as TdxPDFInteractiveFormButtonField;
    if AField.Widget <> nil then
    begin
      if AField.HasAppearance(AValue) then
        AName := AValue
      else
        AName := OffStateName;
      AField.Widget.AppearanceName := AName;
    end;
    AField.EditValue.SetValue(AValue);
  end;
end;

{ TdxPDFSignatureFieldLock }

class function TdxPDFSignatureFieldLock.Parse(ADictionary: TdxPDFReaderDictionary): TdxPDFSignatureFieldLock;
begin
  if ADictionary <> nil then
    Result := ADictionary.Repository.CreateAndRead(TdxPDFSignatureFieldLock, ADictionary) as TdxPDFSignatureFieldLock
  else
    Result := nil;
end;

procedure TdxPDFSignatureFieldLock.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FFieldNames := TStringList.Create;
end;

procedure TdxPDFSignatureFieldLock.DestroySubClasses;
begin
  FreeAndNil(FFieldNames);
  inherited DestroySubClasses;
end;

procedure TdxPDFSignatureFieldLock.DoRead(ADictionary: TdxPDFReaderDictionary);
begin
  inherited DoRead(ADictionary);
  FRange := ReadLockRange(ADictionary.GetObject(TdxPDFKeywords.Action));
  if FRange <> lrAll then
  begin
    FFieldNames.Clear;
    ADictionary.PopulateList(TdxPDFKeywords.Fields,
      procedure(AValue: string)
      begin
        FFieldNames.Add(AValue);
      end);
  end;
end;

function TdxPDFSignatureFieldLock.ReadLockRange(AObject: TdxPDFBase): TdxPDFSignatureFieldLockRange;
var
  AIndex: TdxPDFSignatureFieldLockRange;
  AValue: string;
begin
  if AObject is TdxPDFString then
  begin
    AValue := TdxPDFString(AObject).Value;
    for AIndex := Low(TdxPDFSignatureFieldLockRange) to High(TdxPDFSignatureFieldLockRange) do
    begin
      if LockRangeMap[AIndex] = AValue then
        Exit(AIndex);
    end;
    Result := lrAll;
  end
  else
    if AObject is TdxPDFInteger then
      Result := TdxPDFSignatureFieldLockRange(TdxPDFInteger(AObject).Value)
    else
      Result := lrAll;
end;

procedure TdxPDFSignatureFieldLock.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  inherited Write(AHelper, ADictionary);
  ADictionary.AddName(TdxPDFKeywords.Action, LockRangeMap[Range]);
  ADictionary.Add(TdxPDFKeywords.Fields, FFieldNames);
end;

{ TdxPDFInteractiveFormSignatureField }

constructor TdxPDFInteractiveFormSignatureField.Create(AForm: TdxPDFInteractiveForm; AWidget: TdxPDFWidgetAnnotation;
  ASignature: TObject);
begin
  inherited Create(AForm, AWidget, TdxPDFUtils.GenerateGUID);
  FSignature := ASignature as TdxPDFSignature;
  FCanWriteSignature := True;
  Form.SignatureFlags := [sfAppendOnly, sfSignaturesExist];
  if TdxPDFSignature(Signature).Appearance <> nil then
    TdxPDFSignature(Signature).Appearance.Apply(AWidget);
end;

class function TdxPDFInteractiveFormSignatureField.GetTypeName: string;
begin
  Result := 'Sig';
end;

function TdxPDFInteractiveFormSignatureField.GetFieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftSignature;
end;

procedure TdxPDFInteractiveFormSignatureField.DestroySubClasses;
begin
  FreeAndNil(FSignature);
  FreeAndNil(FLock);
  inherited DestroySubClasses;
end;

procedure TdxPDFInteractiveFormSignatureField.Read(ADictionary: TdxPDFReaderDictionary; ANumber: Integer);
begin
  inherited Read(ADictionary, ANumber);
  FSignature := TdxPDFSignature.Parse(Repository, ADictionary.GetDictionary(TdxPDFKeywords.ShortValue,
    TdxPDFKeywords.Contents));
  FLock := TdxPDFSignatureFieldLock.Parse(ADictionary.GetDictionary(TdxPDFKeywords.Lock));
end;

procedure TdxPDFInteractiveFormSignatureField.Write(AHelper: TdxPDFWriterHelper; ADictionary: TdxPDFWriterDictionary);
begin
  if FCanWriteSignature and (Widget <> nil) then
  begin
    TdxPDFSignature(FSignature).UpdateSignTime;
    Widget.Modified := TdxPDFSignature(FSignature).SignTime;
  end;
  inherited Write(AHelper, ADictionary);
  ADictionary.AddReference(TdxPDFKeywords.Lock, FLock);
  if FCanWriteSignature then
    ADictionary.AddReference(TdxPDFKeywords.ShortValue, TdxPDFSignature(FSignature));
end;


initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFRegisterDocumentObjectClass(TdxPDFInteractiveFormTextField);
  dxPDFRegisterDocumentObjectClass(TdxPDFInteractiveFormChoiceField);
  dxPDFRegisterDocumentObjectClass(TdxPDFInteractiveFormButtonField);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  dxPDFUnregisterDocumentObjectClass(TdxPDFInteractiveFormButtonField);
  dxPDFUnregisterDocumentObjectClass(TdxPDFInteractiveFormChoiceField);
  dxPDFUnregisterDocumentObjectClass(TdxPDFInteractiveFormTextField);
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.


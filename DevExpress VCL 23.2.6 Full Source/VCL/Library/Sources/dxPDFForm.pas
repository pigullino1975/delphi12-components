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

unit dxPDFForm;

{$I cxVer.inc}

interface

uses
  Types, SysUtils, Classes, Graphics, Generics.Defaults, Generics.Collections, dxCoreClasses, dxGenerics,
  dxPDFBase, dxPDFTypes, dxPDFCore, dxPDFAnnotation, dxPDFInteractiveFormField, dxPDFFormData, dxPDFDocumentState;

type
  TdxPDFCheckBoxField = class;
  TdxPDFCustomField = class;
  TdxPDFForm = class;
  TdxPDFRadioGroupField = class;

  TdxPDFFormFieldEditValueChangingEvent = procedure(ASender: TdxPDFCustomField; const AOldValue, ANewValue: Variant;
    var AAccept: Boolean) of object; // for internal use
  TdxPDFFormForEachFieldProc = reference to procedure (AField: TdxPDFCustomField);

  { TdxPDFCustomWidget }

  TdxPDFCustomWidgetClass = class of TdxPDFCustomWidget; // for internal use
  TdxPDFCustomWidget = class(TPersistent) // for internal use
  strict private
    FAnnotation: TdxPDFWidgetAnnotation;
    FField: TdxPDFCustomField;
    //
    function GetBackgroundColor: TColor;
    function GetBorderColor: TColor;
    function GetBorderStyle: TdxPDFBorderStyle;
    function GetBorderWidth: Single;
    function GetBounds: TdxPDFPageRect;
    function GetCharacterSpacing: Single;
    function GetFontBold: Boolean;
    function GetFontColor: TColor;
    function GetFontItalic: Boolean;
    function GetFontName: string;
    function GetFontSize: Single;
    function GetHint: string;
    function GetHorizontalScaling: Single;
    function GetRotationAngle: Integer;
    function GetTextJustify: TdxPDFTextJustify;
    function GetWordSpacing: Single;
    procedure SetBackgroundColor(const AValue: TColor);
    procedure SetBorderColor(const AValue: TColor);
    procedure SetBorderStyle(const AValue: TdxPDFBorderStyle);
    procedure SetBorderWidth(const AValue: Single);
    procedure SetCharacterSpacing(const AValue: Single);
    procedure SetFontBold(const AValue: Boolean);
    procedure SetFontColor(const AValue: TColor);
    procedure SetFontItalic(const AValue: Boolean);
    procedure SetFontName(const AValue: string);
    procedure SetFontSize(const AValue: Single);
    procedure SetHorizontalScaling(const AValue: Single);
    procedure SetRotationAngle(const AValue: Integer);
    procedure SetTextJustify(const AValue: TdxPDFTextJustify);
    procedure SetWordSpacing(const AValue: Single);
  strict protected
    procedure CreateSubClasses; virtual;
    procedure DestroySubClasses; virtual;
  protected
    constructor Create(AAnnotation: TdxPDFWidgetAnnotation; AField: TdxPDFCustomField); // for internal use
    //
    function Visible: Boolean;
    //
    property Annotation: TdxPDFWidgetAnnotation read FAnnotation;
    property Field: TdxPDFCustomField read FField;
    //
    property BackgroundColor: TColor read GetBackgroundColor write SetBackgroundColor;
    property BorderColor: TColor read GetBorderColor write SetBorderColor;
    property BorderStyle: TdxPDFBorderStyle read GetBorderStyle write SetBorderStyle;
    property BorderWidth: Single read GetBorderWidth write SetBorderWidth;
    property CharacterSpacing: Single read GetCharacterSpacing write SetCharacterSpacing;
    property FontBold: Boolean read GetFontBold write SetFontBold;
    property FontColor: TColor read GetFontColor write SetFontColor;
    property FontItalic: Boolean read GetFontItalic write SetFontItalic;
    property FontName: string read GetFontName write SetFontName;
    property FontSize: Single read GetFontSize write SetFontSize;
    property Hint: string read GetHint;
    property HorizontalScaling: Single read GetHorizontalScaling write SetHorizontalScaling;
    property RotationAngle: Integer read GetRotationAngle write SetRotationAngle;
    property TextJustify: TdxPDFTextJustify read GetTextJustify write SetTextJustify;
    property WordSpacing: Single read GetWordSpacing write SetWordSpacing;
  public
    destructor Destroy; override;
    //
    property Bounds: TdxPDFPageRect read GetBounds;
  end;

  { TdxPDFCustomField }

  TdxPDFCustomFieldClass = class of TdxPDFCustomField; // for internal use
  TdxPDFCustomField = class(TcxLockablePersistent)
  strict private
    FItemList: TdxFastObjectList;
    FValueChanged: Boolean;
    FWidgetList: TdxFastObjectList;
    //
    function GetExportable: Boolean;
    function GetEditValue: string;
    function GetFullName: string;
    function GetReadOnly: Boolean;
    function GetRequired: Boolean;
    function GetWidgetCount: Integer;
    procedure SetEditValue(const AValue: string);
    procedure SetReadOnly(const AValue: Boolean);
    procedure SetRequired(const AValue: Boolean);
    procedure OnEditValueChangedHandler(ASender: TObject);
    procedure OnEditValueChangingHandler(const AOldValue, ANewValue: string; var AAccept: Boolean);
  strict protected
    FField: TdxPDFInteractiveFormField;
    //
    class function WidgetClass: TdxPDFCustomWidgetClass; virtual;
    function CreateSubItem(AField: TdxPDFInteractiveFormField): TdxPDFCustomField; virtual;
    procedure CreateSubClasses; virtual;
    procedure DestroySubClasses; virtual;
    procedure DoClear; virtual;
    procedure Initialize; virtual;
    procedure SetExportable(const AValue: Boolean); virtual;
  protected
    OnEditValueChanged: TNotifyEvent;
    OnEditValueChanging: TdxPDFFormFieldEditValueChangingEvent;
    //
    constructor Create(AField: TdxPDFInteractiveFormField); reintroduce;
    function DoGetWidget<T: TdxPDFCustomWidget>(AIndex: Integer): T;
    procedure DoChanged; override;
    //
    property EditValue: string read GetEditValue write SetEditValue;
    property Field: TdxPDFInteractiveFormField read FField;
    property ItemList: TdxFastObjectList read FItemList;
    property WidgetCount: Integer read GetWidgetCount;
    property WidgetList: TdxFastObjectList read FWidgetList;
    //
    property Required: Boolean read GetRequired write SetRequired;
  public
    class function FieldType: TdxPDFInteractiveFormFieldType; virtual;
    destructor Destroy; override;
    //
    procedure BeginUpdate; override;
    procedure EndUpdate; override;
    procedure Clear;
    procedure Reset;
    //
    property Exportable: Boolean read GetExportable write SetExportable;
    property FullName: string read GetFullName;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  end;

  { TdxPDFCustomNonExportableField }

  TdxPDFCustomNonExportableField = class(TdxPDFCustomField) // for internal use
  strict protected
    procedure Initialize; override;
    procedure SetExportable(const AValue: Boolean); override;
  end;

  { TdxPDFChoiceFieldWidget }

  TdxPDFChoiceFieldWidget = class(TdxPDFCustomWidget);

  { TdxPDFChoiceField }

  TdxPDFChoiceField = class(TdxPDFCustomField)
  strict private
    function GetImmediatePost: Boolean;
    function GetItem(AIndex: Integer): TdxPDFChoiceFieldValue;
    function GetItemCount: Integer;
    function GetItemIndex: Integer;
    function GetItemList: TdxPDFChoiceFieldValueList;
    function GetMultiSelect: Boolean;
    function GetSelectedCount: Integer;
    function GetSelected(AIndex: Integer): Boolean;
    function GetSelectedIndexes: TdxIntegerList;
    function GetSorted: Boolean;
    function GetTopIndex: Integer;
    function GetWidget(AIndex: Integer): TdxPDFChoiceFieldWidget;
    procedure SetImmediatePost(const AValue: Boolean);
    procedure SetItemIndex(const AIndex: Integer);
    procedure SetMultiSelect(const AValue: Boolean);
    procedure SetSorted(const AValue: Boolean);
    procedure SetTopIndex(const AValue: Integer);
  strict protected
    class function WidgetClass: TdxPDFCustomWidgetClass; override;
    procedure DoClear; override;
    //
    function GetField: TdxPDFInteractiveFormChoiceField;
    function IsValidIndex(AIndex: Integer): Boolean;
    procedure DoClearSelection;
    procedure DoSelectAll;
    procedure SetSelected(AIndex: Integer; ASelected: Boolean);
  protected
    property ItemList: TdxPDFChoiceFieldValueList read GetItemList;
    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect;
    property SelectedIndexes: TdxIntegerList read GetSelectedIndexes;
    property TopIndex: Integer read GetTopIndex write SetTopIndex;
    property Widgets[Index: Integer]: TdxPDFChoiceFieldWidget read GetWidget;
  public
    function AddItem(const AValue: string): Integer; overload;
    function AddItem(const AValue: TdxPDFChoiceFieldValue): Integer; overload;
    function AddItem(const AValue, AExportValue: string): Integer; overload;
    function IndexOf(const AValue: string): Integer;
    function IndexOfExportValue(const AValue: string): Integer;
    procedure ClearItems;
    procedure DeleteItem(AIndex: Integer);
    procedure InsertItem(AIndex: Integer; const AValue: string); overload;
    procedure InsertItem(AIndex: Integer; const AValue, AExportValue: string); overload;
    procedure InsertItem(AIndex: Integer; const AValue: TdxPDFChoiceFieldValue); overload;
    procedure MoveItem(ACurrentIndex, ANewIndex: Integer);
    //
    property ImmediatePost: Boolean read GetImmediatePost write SetImmediatePost;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property ItemCount: Integer read GetItemCount;
    property Items[Index: Integer]: TdxPDFChoiceFieldValue read GetItem; default;
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
    property SelectedCount: Integer read GetSelectedCount;
    property Sorted: Boolean read GetSorted write SetSorted;
  end;

  { TdxPDFListBoxField }

  TdxPDFListBoxField = class(TdxPDFChoiceField)
  protected
    property WidgetCount;
    property Widgets;
  public
    class function FieldType: TdxPDFInteractiveFormFieldType; override;
    //
    procedure ClearSelection;
    procedure SelectAll;
    //
    property MultiSelect;
    property TopIndex;
  end;

  { TdxPDFComboBoxField }

  TdxPDFComboBoxField = class(TdxPDFChoiceField)
  strict private
    function GetEditable: Boolean;
    function GetExportText: string;
    function GetSpellCheck: Boolean;
    function GetText: string;
    procedure SetEditable(const AValue: Boolean);
    procedure SetSpellCheck(const AValue: Boolean);
  protected
    property Editable: Boolean read GetEditable write SetEditable;
    property SpellCheck: Boolean read GetSpellCheck write SetSpellCheck;
    property WidgetCount;
    property Widgets;
  public
    class function FieldType: TdxPDFInteractiveFormFieldType; override;
    //
    property ExportText: string read GetExportText;
    property Text: string read GetText;
  end;

  { TdxPDFCheckBoxFieldWidget }

  TdxPDFCheckBoxFieldWidget = class(TdxPDFCustomWidget)
  strict private
    function GetButtonStyle: TdxPDFButtonStyle;
    function GetField: TdxPDFCheckBoxField;
    procedure SetButtonStyle(const AValue: TdxPDFButtonStyle);
  protected
    property Field: TdxPDFCheckBoxField read GetField;
  public
    property ButtonStyle: TdxPDFButtonStyle read GetButtonStyle write SetButtonStyle;
  end;

  { TdxPDFCheckBoxField }

  TdxPDFCheckBoxField = class(TdxPDFCustomField)
  strict private
    function GetChecked: Boolean;
    function GetField: TdxPDFInteractiveFormButtonField;
    function GetToggleToOff: Boolean;
    function GetWidget(AIndex: Integer): TdxPDFCheckBoxFieldWidget;
    procedure SetChecked(const AValue: Boolean);
    procedure SetToggleToOff(const AValue: Boolean);
  strict protected
    class function WidgetClass: TdxPDFCustomWidgetClass; override;
    procedure DoClear; override;
  protected
    property ToggleToOff: Boolean read GetToggleToOff write SetToggleToOff;
    property WidgetCount;
    property Widgets[Index: Integer]: TdxPDFCheckBoxFieldWidget read GetWidget;
  public
    class function FieldType: TdxPDFInteractiveFormFieldType; override;
    //
    property Checked: Boolean read GetChecked write SetChecked;
  end;

  { TdxPDFButtonFieldAppearanceIconOptions }

  TdxPDFButtonFieldWidget = class;  // for internal use
  TdxPDFButtonFieldAppearanceIconOptions = class  // for internal use
  strict private
    FWidget: TdxPDFButtonFieldWidget;
    //
    function GetAppearanceCharacteristics: TdxPDFWidgetAppearanceCharacteristics;
    function GetFitToAnnotationBounds: Boolean;
    function GetHorizontalPosition: Double;
    function GetIconFit: TdxPDFIconFit;
    function GetScaleCondition: TdxPDFIconScalingCircumstances;
    function GetScaleType: TdxPDFIconScalingType;
    function GetVerticalPosition: Double;
    procedure SetFitToAnnotationBounds(const AValue: Boolean);
    procedure SetHorizontalPosition(const AValue: Double);
    procedure SetScaleCondition(const AValue: TdxPDFIconScalingCircumstances);
    procedure SetScaleType(const AValue: TdxPDFIconScalingType);
    procedure SetVerticalPosition(const AValue: Double);
    //
    property AppearanceCharacteristics: TdxPDFWidgetAppearanceCharacteristics read GetAppearanceCharacteristics;
  protected
    constructor Create(AWidget: TdxPDFButtonFieldWidget);
    //
    property IconFit: TdxPDFIconFit read GetIconFit;
  public
    property FitToAnnotationBounds: Boolean read GetFitToAnnotationBounds write SetFitToAnnotationBounds;
    property HorizontalPosition: Double read GetHorizontalPosition write SetHorizontalPosition;
    property ScaleCondition: TdxPDFIconScalingCircumstances read GetScaleCondition write SetScaleCondition;
    property ScaleType: TdxPDFIconScalingType read GetScaleType write SetScaleType;
    property VerticalPosition: Double read GetVerticalPosition write SetVerticalPosition;
  end;

  { TdxPDFButtonFieldWidget }

  TdxPDFButtonFieldWidget = class(TdxPDFCustomWidget)  // for internal use
  strict private
    FIconOptions: TdxPDFButtonFieldAppearanceIconOptions;
    //
    function GetAlternateCaption: string;
    function GetCaption: string;
    function GetHint: string;
    function GetRolloverCaption: string;
    function GetTextPosition: TdxPDFWidgetAnnotationTextPosition;
    procedure SetAlternateCaption(const AValue: string);
    procedure SetCaption(const AValue: string);
    procedure SetHint(const AValue: string);
    procedure SetRolloverCaption(const AValue: string);
    procedure SetTextPosition(const AValue: TdxPDFWidgetAnnotationTextPosition);
  protected
    procedure CreateSubClasses; override;
    procedure DestroySubClasses; override;
    //
    property AlternateCaption: string read GetAlternateCaption write SetAlternateCaption;
    property Caption: string read GetCaption write SetCaption;
    property IconOptions: TdxPDFButtonFieldAppearanceIconOptions read FIconOptions;
    property RolloverCaption: string read GetRolloverCaption write SetRolloverCaption;
    property TextPosition: TdxPDFWidgetAnnotationTextPosition read GetTextPosition write SetTextPosition;
  public
    property Hint: string read GetHint write SetHint;
  end;

  { TdxPDFButtonField }

  TdxPDFButtonField = class(TdxPDFCustomNonExportableField)
  strict private
    function GetWidget(AIndex: Integer): TdxPDFButtonFieldWidget;
  strict protected
    class function WidgetClass: TdxPDFCustomWidgetClass; override;
    procedure SetExportable(const AValue: Boolean); override;
  protected
    property WidgetCount;
    property Widgets[Index: Integer]: TdxPDFButtonFieldWidget read GetWidget;
  public
    class function FieldType: TdxPDFInteractiveFormFieldType; override;
  end;

  { TdxPDFRadioButtonFieldWidget }

  TdxPDFRadioButtonFieldWidget = class(TdxPDFCheckBoxFieldWidget); // for internal use

  { TdxPDFRadioGroupFieldItem }

  TdxPDFRadioGroupFieldItem = class(TdxPDFCustomField)
  strict private
    FGroup: TdxPDFRadioGroupField;
    //
    function GetAnnotation: TdxPDFWidgetAnnotation;
    function GetCheckedStateName: string;
    function GetField: TdxPDFInteractiveFormButtonField;
    function GetRadiosInUnison: Boolean;
    function GetToggleToOff: Boolean;
    function GetWidget: TdxPDFRadioButtonFieldWidget;
    procedure SetRadiosInUnison(const AValue: Boolean);
    procedure SetToggleToOff(const AValue: Boolean);
  strict protected
    class function WidgetClass: TdxPDFCustomWidgetClass; override;
  protected
    constructor Create(AField: TdxPDFInteractiveFormField; AGroup: TdxPDFRadioGroupField); reintroduce;
    procedure DoChanged; override;
    //
    property Group: TdxPDFRadioGroupField read FGroup;
    property RadiosInUnison: Boolean read GetRadiosInUnison write SetRadiosInUnison;
    property ToggleToOff: Boolean read GetToggleToOff write SetToggleToOff;
    property Widget: TdxPDFRadioButtonFieldWidget read GetWidget;
  public
    class function FieldType: TdxPDFInteractiveFormFieldType; override;
    //
    property CheckedStateName: string read GetCheckedStateName;
  end;

  { TdxPDFRadioGroupField }

  TdxPDFRadioGroupField = class(TdxPDFCustomField)
  strict private
    function GetField: TdxPDFInteractiveFormButtonField;
    function GetItem(AIndex: Integer): TdxPDFRadioGroupFieldItem;
    function GetItemCount: Integer;
    function GetItemIndex: Integer;
    function GetState: string;
    function GetWidget(AIndex: Integer): TdxPDFRadioButtonFieldWidget;
    procedure SetItemIndex(const AValue: Integer);
  strict protected
    class function WidgetClass: TdxPDFCustomWidgetClass; override;
    function CreateSubItem(AField: TdxPDFInteractiveFormField): TdxPDFCustomField; override;
    procedure DoClear; override;
  protected
    property WidgetCount;
    property Widgets[Index: Integer]: TdxPDFRadioButtonFieldWidget read GetWidget;
  public
    class function FieldType: TdxPDFInteractiveFormFieldType; override;
    //
    function IndexOf(AItem: TdxPDFRadioGroupFieldItem): Integer; // for internal use
    //
    property ItemCount: Integer read GetItemCount;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property Items[Index: Integer]: TdxPDFRadioGroupFieldItem read GetItem;
    property State: string read GetState;
  end;

  { TdxPDFTextFieldWidget }

  TdxPDFTextFieldWidget = class(TdxPDFCustomWidget);

  { TdxPDFTextField }

  TdxPDFTextField = class(TdxPDFCustomField)
  strict private
    function GetDefaultText: string;
    function GetField: TdxPDFInteractiveFormTextField;
    function GetHint: string;
    function GetInputType: TdxPDFTextFieldInputType;
    function GetMaxLength: Integer;
    function GetMultiLine: Boolean;
    function GetScrollable: Boolean;
    function GetSpellCheck: Boolean;
    function GetText: string;
    function GetWidget(AIndex: Integer): TdxPDFTextFieldWidget;
    procedure SetInputType(const AValue: TdxPDFTextFieldInputType);
    procedure SetMaxLength(const AValue: Integer);
    procedure SetMultiLine(const AValue: Boolean);
    procedure SetScrollable(const AValue: Boolean);
    procedure SetSpellCheck(const AValue: Boolean);
    procedure SetText(const AValue: string);
  strict protected
    class function WidgetClass: TdxPDFCustomWidgetClass; override;
    procedure DoClear; override;
  protected
    function IsComposite: Boolean;
    //
    property MultiLine: Boolean read GetMultiLine write SetMultiLine;
    property Scrollable: Boolean read GetScrollable write SetScrollable;
    property SpellCheck: Boolean read GetSpellCheck write SetSpellCheck;
    property Hint: string read GetHint;
    property WidgetCount;
    property Widgets[Index: Integer]: TdxPDFTextFieldWidget read GetWidget;
  public
    class function FieldType: TdxPDFInteractiveFormFieldType; override;
    //
    property DefaultText: string read GetDefaultText;
    property InputType: TdxPDFTextFieldInputType read GetInputType write SetInputType;
    property MaxLength: Integer read GetMaxLength write SetMaxLength;
    property Text: string read GetText write SetText;
  end;

  { TdxPDFSignatureField }

  TdxPDFSignatureField = class(TdxPDFCustomNonExportableField)
  public
    class function FieldType: TdxPDFInteractiveFormFieldType; override;
  end;

  { TdxPDFForm }

  TdxPDFForm = class(TEnumerable<TdxPDFCustomField>)
  strict private
    FAnnotationWidgetMap: TDictionary<TObject, TdxPDFCustomWidget>;
    FDocument: TObject;
    FFieldNameList: TStringList;
    FFields: TdxPDFStringObjectDictionary<TdxPDFCustomField>;
    FNeedRefresh: Boolean;
    //
    function GetAcroForm: TdxPDFInteractiveForm;
    function GetState: TdxPDFDocumentState;
    function GetFieldCount: Integer;
    function GetFieldNames: TStringList;
    //
    function CreateFormData(AField: TdxPDFInteractiveFormField): TdxPDFFormData; overload;
    function DoTryGetField(const AFullName: string; AFieldClass: TdxPDFCustomFieldClass; out AField): Boolean;
    function IsLocked: Boolean;
    procedure CreateFormDataAndExecute(const AAction: TProc<TdxPDFFormData>);
    procedure PopulateFields;
  private
    class function GetUniqueName<T>(ADictionary: TdxPDFStringObjectDictionary<T>; const AName: String): String;
  protected
    function DoGetEnumerator: TEnumerator<TdxPDFCustomField>; override;
    //
    function CreateData: TdxPDFFormData;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure LoadData(AData: TdxPDFFormData);
    procedure Update;
    //
    procedure OnFieldEditValueChangedHandler(ASender: TObject);
    procedure OnFieldEditValueChangingHandler(ASender: TdxPDFCustomField; const AOldValue, ANewValue: Variant;
      var AAccept: Boolean);
    //
    property AnnotationWidgetMap: TDictionary<TObject, TdxPDFCustomWidget> read FAnnotationWidgetMap;
    property State: TdxPDFDocumentState read GetState;
  public
    constructor Create(ADocument: TObject); // for internal use
    destructor Destroy; override;
    //
    procedure LoadDataFromFile(const AFileName: string);
    procedure LoadDataFromStream(AStream: TStream);
    procedure SaveDataToFile(const AFileName: string);
    procedure SaveDataToStream(AStream: TStream; AFormat: TdxPDFFormDataFormat);
    //
    procedure ClearValues;
    procedure Flatten(AField: TdxPDFCustomField); overload;
    procedure Flatten; overload;
    procedure ForEach(AProc: TdxPDFFormForEachFieldProc);
    procedure Reset;
    //
    function GetButtonField(const AFullName: string): TdxPDFButtonField;
    function GetCheckBoxField(const AFullName: string): TdxPDFCheckBoxField;
    function GetComboBoxField(const AFullName: string): TdxPDFComboBoxField;
    function GetField(const AFullName: string): TdxPDFCustomField;
    function GetListBoxField(const AFullName: string): TdxPDFListBoxField;
    function GetRadioGroupField(const AFullName: string): TdxPDFRadioGroupField;
    function GetTextField(const AFullName: string): TdxPDFTextField;
    function TryGetButtonField(const AFullName: string; out AField: TdxPDFButtonField): Boolean;
    function TryGetCheckBoxField(const AFullName: string; out AField: TdxPDFCheckBoxField): Boolean;
    function TryGetComboBoxField(const AFullName: string; out AField: TdxPDFComboBoxField): Boolean;
    function TryGetField(const AFullName: string; out AField: TdxPDFCustomField): Boolean;
    function TryGetListBoxField(const AFullName: string; out AField: TdxPDFListBoxField): Boolean;
    function TryGetRadioGroupField(const AFullName: string; out AField: TdxPDFRadioGroupField): Boolean;
    function TryGetTextField(const AFullName: string; out AField: TdxPDFTextField): Boolean;
    //
    property FieldCount: Integer read GetFieldCount;
    property FieldNames: TStringList read GetFieldNames;
  end;

implementation

uses
  System.UITypes,
  RTLConsts, Windows, Math, dxCore, dxCoreGraphics, dxPDFDocument, dxPDFUtils;

const
  dxThisUnitName = 'dxPDFForm';

type
  TdxPDFCommandListAccess = class(TdxPDFCommandList);
  TdxPDFObjectAccess = class(TdxPDFObject);
  TdxPDFDocumentAccess = class(TdxPDFDocument);
  TdxPDFDocumentStateAccess = class(TdxPDFDocumentState);
  TdxPDFInteractiveFormFieldAccess = class(TdxPDFInteractiveFormField);

  { TdxPDFFormFieldTreeNode }

  TdxPDFFormFieldTreeNode = class
  strict private
    FAcroForm: TdxPDFForm;
    FInternalField: TdxPDFInteractiveFormField;
    FField: TdxPDFCustomField;
    FKids: TdxPDFStringObjectDictionary<TdxPDFFormFieldTreeNode>;
    //
    function CreateNode(AField: TdxPDFInteractiveFormField): TdxPDFFormFieldTreeNode;
    function GetField: TdxPDFCustomField;
  protected
    constructor Create(AAcroForm: TdxPDFForm; AField: TdxPDFInteractiveFormField); overload;
    constructor Create(AAcroForm: TdxPDFForm; AField: TdxPDFInteractiveFormField;
      AKids: TdxPDFInteractiveFormFieldCollection); overload;
    //
    property InternalField: TdxPDFInteractiveFormField read FInternalField;
    property Field: TdxPDFCustomField read GetField;
    property Kids: TdxPDFStringObjectDictionary<TdxPDFFormFieldTreeNode> read FKids;
  public
    class function CreateField(AField: TdxPDFInteractiveFormField): TdxPDFCustomField; static;
    destructor Destroy; override;
  end;

{ TdxPDFFormFieldTreeNode }

class function TdxPDFFormFieldTreeNode.CreateField(AField: TdxPDFInteractiveFormField): TdxPDFCustomField;
var
  AFieldClass: TdxPDFCustomFieldClass;
begin
  if AField = nil then
    Exit(nil);
  case AField.FieldType of
    ftCheckBox:
      AFieldClass := TdxPDFCheckBoxField;
    ftComboBox:
      AFieldClass := TdxPDFComboBoxField;
    ftListBox:
      AFieldClass := TdxPDFListBoxField;
    ftPushButton:
      AFieldClass := TdxPDFButtonField;
    ftRadioGroup:
      AFieldClass := TdxPDFRadioGroupField;
    ftText:
      AFieldClass := TdxPDFTextField;
    ftSignature:
      AFieldClass := TdxPDFSignatureField;
  else
    AFieldClass := nil;
  end;
  if AFieldClass <> nil then
    Result := AFieldClass.Create(AField)
  else
    Result := nil;
end;

constructor TdxPDFFormFieldTreeNode.Create(AAcroForm: TdxPDFForm; AField: TdxPDFInteractiveFormField);
begin
  inherited Create;
  FAcroForm := AAcroForm;
  FInternalField := AField;
  FKids := TdxPDFStringObjectDictionary<TdxPDFFormFieldTreeNode>.Create([doOwnsValues]);
end;

constructor TdxPDFFormFieldTreeNode.Create(AAcroForm: TdxPDFForm; AField: TdxPDFInteractiveFormField;
  AKids: TdxPDFInteractiveFormFieldCollection);
var
  AChild: TdxPDFInteractiveFormField;
  ANode: TdxPDFFormFieldTreeNode;
  I: Integer;
begin
  Create(AAcroForm, AField);
  if AKids <> nil then
    for I := 0 to AKids.Count - 1 do
    begin
      AChild := AKids[I];
      ANode := CreateNode(AChild);
      if ANode <> nil then
        Kids.Add(TdxPDFForm.GetUniqueName<TdxPDFFormFieldTreeNode>(Kids, AChild.Name), ANode);
    end;
end;

function TdxPDFFormFieldTreeNode.CreateNode(AField: TdxPDFInteractiveFormField): TdxPDFFormFieldTreeNode;
begin
  if AField.Name = '' then
    Result := nil
  else
    if (AField.FieldType = ftNode) and (AField.Kids <> nil) then
      Result := TdxPDFFormFieldTreeNode.Create(FAcroForm, AField, AField.Kids)
    else
      Result := TdxPDFFormFieldTreeNode.Create(FAcroForm, AField);
end;

destructor TdxPDFFormFieldTreeNode.Destroy;
begin
  FreeAndNil(FKids);
  inherited Destroy;
end;

function TdxPDFFormFieldTreeNode.GetField: TdxPDFCustomField;
begin
  if FField = nil then
  begin
    FField := CreateField(FInternalField);
    if FField <> nil then
    begin
      FField.OnEditValueChanged := FAcroForm.OnFieldEditValueChangedHandler;
      FField.OnEditValueChanging := FAcroForm.OnFieldEditValueChangingHandler;
    end;
  end;
  Result := FField;
end;

{ TdxPDFCustomWidget }

constructor TdxPDFCustomWidget.Create(AAnnotation: TdxPDFWidgetAnnotation; AField: TdxPDFCustomField);
begin
  inherited Create;
  FAnnotation := AAnnotation;
  FField := AField;
  CreateSubClasses;
end;

function TdxPDFCustomWidget.Visible: Boolean;
begin
  Result := ((Ord(afHidden) or Ord(afNoView)) and Ord(FAnnotation.Flags)) = 0;
end;

destructor TdxPDFCustomWidget.Destroy;
begin
  DestroySubClasses;
  inherited Destroy;
end;

procedure TdxPDFCustomWidget.CreateSubClasses;
begin
  // do nothing
end;

procedure TdxPDFCustomWidget.DestroySubClasses;
begin
  // do nothing
end;

function TdxPDFCustomWidget.GetBackgroundColor: TColor;
begin
  Result := Annotation.AppearanceCharacteristics.BackgroundColor.ToColor;
end;

function TdxPDFCustomWidget.GetBorderColor: TColor;
begin
  Result := Annotation.AppearanceCharacteristics.BorderColor.ToColor;
end;

function TdxPDFCustomWidget.GetBorderStyle: TdxPDFBorderStyle;
begin
  Result := Annotation.BorderStyle.Style;
end;

function TdxPDFCustomWidget.GetBorderWidth: Single;
begin
  Result := Annotation.BorderStyle.Width;
end;

function TdxPDFCustomWidget.GetBounds: TdxPDFPageRect;
begin
  Result := Annotation.PageRect;
end;

function TdxPDFCustomWidget.GetCharacterSpacing: Single;
begin
  Result := Annotation.Field.TextState.CharacterSpacing;
end;

function TdxPDFCustomWidget.GetFontBold: Boolean;
begin
  Result := Annotation.Field.TextState.FontBold;
end;

function TdxPDFCustomWidget.GetFontColor: TColor;
begin
  Result := Annotation.Field.TextState.FontColor;
end;

function TdxPDFCustomWidget.GetFontItalic: Boolean;
begin
  Result := Annotation.Field.TextState.FontItalic;
end;

function TdxPDFCustomWidget.GetFontName: string;
begin
  Result := Annotation.Field.TextState.FontName;
end;

function TdxPDFCustomWidget.GetFontSize: Single;
begin
  Result := Annotation.Field.TextState.FontSize;
end;

function TdxPDFCustomWidget.GetHint: string;
begin
  Result := Annotation.Field.AlternateName;
end;

function TdxPDFCustomWidget.GetHorizontalScaling: Single;
begin
  Result := Annotation.Field.TextState.HorizontalScaling;
end;

function TdxPDFCustomWidget.GetRotationAngle: Integer;
begin
  Result := Annotation.AppearanceCharacteristics.RotationAngle;
end;

function TdxPDFCustomWidget.GetTextJustify: TdxPDFTextJustify;
begin
  Result := Annotation.Field.TextJustify;
end;

function TdxPDFCustomWidget.GetWordSpacing: Single;
begin
  Result := Annotation.Field.TextState.WordSpacing;
end;

procedure TdxPDFCustomWidget.SetBackgroundColor(const AValue: TColor);
begin
  Annotation.AppearanceCharacteristics.BackgroundColor := TdxPDFUtils.ConvertToColor(AValue);
end;

procedure TdxPDFCustomWidget.SetBorderColor(const AValue: TColor);
begin
  Annotation.AppearanceCharacteristics.BorderColor := TdxPDFUtils.ConvertToColor(AValue);
end;

procedure TdxPDFCustomWidget.SetBorderStyle(const AValue: TdxPDFBorderStyle);
begin
  Annotation.BorderStyle.Style := AValue;
end;

procedure TdxPDFCustomWidget.SetBorderWidth(const AValue: Single);
begin
  Annotation.BorderStyle.Width := AValue;
end;

procedure TdxPDFCustomWidget.SetCharacterSpacing(const AValue: Single);
begin
  Annotation.Field.TextState.CharacterSpacing := AValue;
end;

procedure TdxPDFCustomWidget.SetFontBold(const AValue: Boolean);
begin
  Annotation.Field.TextState.FontBold := AValue;
end;

procedure TdxPDFCustomWidget.SetFontColor(const AValue: TColor);
begin
  Annotation.Field.TextState.FontColor := AValue;
end;

procedure TdxPDFCustomWidget.SetFontItalic(const AValue: Boolean);
begin
  Annotation.Field.TextState.FontItalic := AValue;
end;

procedure TdxPDFCustomWidget.SetFontName(const AValue: string);
begin
  Annotation.Field.TextState.FontName := AValue;
end;

procedure TdxPDFCustomWidget.SetFontSize(const AValue: Single);
begin
  Annotation.Field.TextState.FontSize := AValue;
end;

procedure TdxPDFCustomWidget.SetHorizontalScaling(const AValue: Single);
begin
  Annotation.Field.TextState.HorizontalScaling := AValue;
end;

procedure TdxPDFCustomWidget.SetRotationAngle(const AValue: Integer);
begin
  Annotation.AppearanceCharacteristics.RotationAngle := AValue;
end;

procedure TdxPDFCustomWidget.SetTextJustify(const AValue: TdxPDFTextJustify);
begin
  Annotation.Field.TextJustify := AValue;
end;

procedure TdxPDFCustomWidget.SetWordSpacing(const AValue: Single);
begin
  Annotation.Field.TextState.WordSpacing := AValue;
end;

{ TdxPDFCustomField }

constructor TdxPDFCustomField.Create(AField: TdxPDFInteractiveFormField);
begin
  inherited Create(nil);
  FField := AField;
  CreateSubClasses;
  Initialize;
  TdxPDFInteractiveFormFieldAccess(FField).OnEditValueChanged := OnEditValueChangedHandler;
  TdxPDFInteractiveFormFieldAccess(FField).OnEditValueChanging := OnEditValueChangingHandler;
end;

function TdxPDFCustomField.DoGetWidget<T>(AIndex: Integer): T;
begin
  Result := Safe<T>.Cast(FWidgetList[AIndex]);
end;

class function TdxPDFCustomField.FieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftUnknown;
end;

class function TdxPDFCustomField.WidgetClass: TdxPDFCustomWidgetClass;
begin
  Result := TdxPDFCustomWidget;
end;

destructor TdxPDFCustomField.Destroy;
begin
  DestroySubClasses;
  inherited;
end;

procedure TdxPDFCustomField.BeginUpdate;
begin
  TdxPDFObjectAccess(FField).BeginUpdate;
  inherited BeginUpdate;
end;

procedure TdxPDFCustomField.EndUpdate;
begin
  inherited EndUpdate;
  TdxPDFObjectAccess(FField).EndUpdate;
end;

procedure TdxPDFCustomField.Clear;
begin
  BeginUpdate;
  try
    DoClear;
  finally
    EndUpdate;
  end;
end;

procedure TdxPDFCustomField.Reset;
begin
  BeginUpdate;
  try
    FField.ResetEditValue;
  finally
    EndUpdate;
  end;
end;

procedure TdxPDFCustomField.DoChanged;
begin
  if FValueChanged then
  begin
    FValueChanged := False;
    dxCallNotify(OnEditValueChanged, Self);
  end;
end;


function TdxPDFCustomField.CreateSubItem(AField: TdxPDFInteractiveFormField): TdxPDFCustomField;
begin
  Result := TdxPDFFormFieldTreeNode.CreateField(AField);
end;

procedure TdxPDFCustomField.CreateSubClasses;

  procedure CreateWidget(AInternalField: TdxPDFInteractiveFormField; AField: TdxPDFCustomField);
  var
    AWidget: TdxPDFWidgetAnnotation;
  begin
    AWidget := AInternalField.Widget as TdxPDFWidgetAnnotation;
    if AWidget <> nil then
      FWidgetList.Add(WidgetClass.Create(AWidget, AField));
  end;

var
  AField: TdxPDFCustomField;
  AKid: TdxPDFInteractiveFormField;
  I: Integer;
begin
  FItemList := TdxFastObjectList.Create;
  FWidgetList := TdxFastObjectList.Create;

  CreateWidget(FField, Self);
  if FField.Kids = nil then
    Exit;
  for I := 0 to FField.Kids.Count - 1 do
  begin
    AKid := FField.Kids[I];
    if (AKid.Widget <> nil) and (FField.ClassType = AKid.ClassType) then
    begin
      AField := CreateSubItem(AKid);;
      FItemList.Add(AField);
      CreateWidget(AKid, AField);
    end;
  end;
end;

procedure TdxPDFCustomField.DestroySubClasses;
begin
  FreeAndNil(FWidgetList);
  FreeAndNil(FItemList);
end;

procedure TdxPDFCustomField.DoClear;
begin
  // do nothing
end;

procedure TdxPDFCustomField.Initialize;
begin
  // do nothing
end;

procedure TdxPDFCustomField.SetExportable(const AValue: Boolean);
begin
  FField.Exportable := AValue;
end;

function TdxPDFCustomField.GetExportable: Boolean;
begin
  Result := FField.Exportable;
end;

function TdxPDFCustomField.GetEditValue: string;
begin
  Result := TdxPDFInteractiveFormFieldAccess(FField).EditValue.Text;
end;

function TdxPDFCustomField.GetFullName: string;
begin
  Result := FField.FullName;
end;

function TdxPDFCustomField.GetReadOnly: Boolean;
begin
  Result := FField.ReadOnly;
end;

function TdxPDFCustomField.GetRequired: Boolean;
begin
  Result := FField.Required;
end;

function TdxPDFCustomField.GetWidgetCount: Integer;
begin
  Result := FWidgetList.Count;
end;

procedure TdxPDFCustomField.SetEditValue(const AValue: string);
begin
  FField.SetEditValue(AValue);
end;

procedure TdxPDFCustomField.SetReadOnly(const AValue: Boolean);
begin
  FField.ReadOnly := AValue;
end;

procedure TdxPDFCustomField.SetRequired(const AValue: Boolean);
begin
  FField.Required := AValue;
end;

procedure TdxPDFCustomField.OnEditValueChangedHandler(ASender: TObject);
begin
  FValueChanged := True;
  Changed;
end;

procedure TdxPDFCustomField.OnEditValueChangingHandler(const AOldValue, ANewValue: string; var AAccept: Boolean);
begin
  if not IsLocked and Assigned(OnEditValueChanging) then
    OnEditValueChanging(Self, AOldValue, ANewValue, AAccept);
end;

{ TdxPDFCustomNonExportableField }

procedure TdxPDFCustomNonExportableField.Initialize;
begin
  inherited Initialize;
  Exportable := False;
end;

procedure TdxPDFCustomNonExportableField.SetExportable(const AValue: Boolean);
begin
  inherited SetExportable(False);
end;

{ TdxPDFChoiceField }

class function TdxPDFChoiceField.WidgetClass: TdxPDFCustomWidgetClass;
begin
  Result := TdxPDFChoiceFieldWidget;
end;

function TdxPDFChoiceField.AddItem(const AValue: string): Integer;
begin
  Result := AddItem(AValue, AValue);
end;

function TdxPDFChoiceField.AddItem(const AValue: TdxPDFChoiceFieldValue): Integer;
begin
  Result := GetField.AddItem(AValue);
end;

function TdxPDFChoiceField.AddItem(const AValue, AExportValue: string): Integer;
begin
  Result := AddItem(TdxPDFChoiceFieldValue.Create(AValue, AExportValue));
end;

function TdxPDFChoiceField.IndexOf(const AValue: string): Integer;
begin
  Result := GetField.IndexOf(AValue);
end;

function TdxPDFChoiceField.IndexOfExportValue(const AValue: string): Integer;
begin
  Result := GetField.IndexOfExportValue(AValue);
end;

procedure TdxPDFChoiceField.ClearItems;
begin
  GetField.ClearItems;
end;

procedure TdxPDFChoiceField.DeleteItem(AIndex: Integer);
begin
  GetField.DeleteItem(AIndex);
end;

procedure TdxPDFChoiceField.InsertItem(AIndex: Integer; const AValue: string);
begin
  InsertItem(AIndex, AValue, AValue);
end;

procedure TdxPDFChoiceField.InsertItem(AIndex: Integer; const AValue, AExportValue: string);
begin
  InsertItem(AIndex, TdxPDFChoiceFieldValue.Create(AValue, AExportValue));
end;

procedure TdxPDFChoiceField.InsertItem(AIndex: Integer; const AValue: TdxPDFChoiceFieldValue);
begin
  GetField.InsertItem(AIndex, AValue);
end;

procedure TdxPDFChoiceField.MoveItem(ACurrentIndex, ANewIndex: Integer);
begin
  GetField.MoveItem(ACurrentIndex, ANewIndex);
end;

procedure TdxPDFChoiceField.DoClear;
begin
  ItemIndex := -1;
end;

function TdxPDFChoiceField.GetField: TdxPDFInteractiveFormChoiceField;
begin
  Result := inherited Field as TdxPDFInteractiveFormChoiceField;
end;

function TdxPDFChoiceField.IsValidIndex(AIndex: Integer): Boolean;
begin
  Result := InRange(AIndex, -1, ItemCount - 1);
end;

procedure TdxPDFChoiceField.DoClearSelection;
begin
  GetField.ClearEditValue;
end;

procedure TdxPDFChoiceField.DoSelectAll;
var
  AValueList: TStringList;
  I: Integer;
begin
  if not MultiSelect or ReadOnly then
    Exit;
  AValueList := TStringList.Create;
  try
    for I := 0 to ItemList.Count - 1 do
      AValueList.Add(Items[I].Value);
    EditValue := AValueList.Text
  finally
    AValueList.Free;
  end;
end;

procedure TdxPDFChoiceField.SetSelected(AIndex: Integer; ASelected: Boolean);
var
  AValueList: TStringList;
begin
  AValueList := TStringList.Create;
  try
    AValueList.Assign(GetField.ExportValueList);
    if ASelected and not SelectedIndexes.Contains(AIndex) then
      AValueList.Add(Items[AIndex].ExportValue)
    else
      AValueList.Delete(AIndex);
    EditValue := AValueList.Text;
  finally
    AValueList.Free;
  end;
end;

function TdxPDFChoiceField.GetImmediatePost: Boolean;
begin
  Result := GetField.CommitOnSelectionChange;
end;

function TdxPDFChoiceField.GetItem(AIndex: Integer): TdxPDFChoiceFieldValue;
begin
  Result := ItemList[AIndex];
end;

function TdxPDFChoiceField.GetItemCount: Integer;
begin
  Result:= ItemList.Count;
end;

function TdxPDFChoiceField.GetItemIndex: Integer;
begin
  if SelectedIndexes.Count > 0 then
    Result := SelectedIndexes.Last
  else
    Result := -1;
end;

function TdxPDFChoiceField.GetItemList: TdxPDFChoiceFieldValueList;
begin
  Result := GetField.Items;
end;

function TdxPDFChoiceField.GetMultiSelect: Boolean;
begin
  Result := GetField.MultiSelect;
end;

function TdxPDFChoiceField.GetSelectedCount: Integer;
begin
  Result := GetField.SelectedIndexes.Count;
end;

function TdxPDFChoiceField.GetSelected(AIndex: Integer): Boolean;
begin
  Result := GetField.SelectedIndexes.Contains(AIndex);
end;

function TdxPDFChoiceField.GetSelectedIndexes: TdxIntegerList;
begin
  Result := GetField.SelectedIndexes;
end;

function TdxPDFChoiceField.GetSorted: Boolean;
begin
  Result := GetField.Sorted;
end;

function TdxPDFChoiceField.GetTopIndex: Integer;
begin
  Result := GetField.TopIndex;
end;

function TdxPDFChoiceField.GetWidget(AIndex: Integer): TdxPDFChoiceFieldWidget;
begin
  Result := DoGetWidget<TdxPDFChoiceFieldWidget>(AIndex);
end;

procedure TdxPDFChoiceField.SetImmediatePost(const AValue: Boolean);
begin
  if GetField.CommitOnSelectionChange <> AValue then
  begin
    GetField.CommitOnSelectionChange := AValue;
    Changed;
  end;
end;

procedure TdxPDFChoiceField.SetItemIndex(const AIndex: Integer);
begin
  if not IsValidIndex(AIndex) then
    Exit;
  if AIndex = -1 then
    DoClearSelection
  else
    EditValue := Items[AIndex].ExportValue;
end;

procedure TdxPDFChoiceField.SetMultiSelect(const AValue: Boolean);
begin
  if GetField.MultiSelect <> AValue then
  begin
    GetField.MultiSelect := AValue;
    if not MultiSelect and (SelectedIndexes.Count > 1) then
      GetField.SetExportEditValue(Items[SelectedIndexes.Last].ExportValue);
  end;
end;

procedure TdxPDFChoiceField.SetSorted(const AValue: Boolean);
begin
  GetField.Sorted := AValue;
end;

procedure TdxPDFChoiceField.SetTopIndex(const AValue: Integer);
begin
  GetField.TopIndex := AValue;
end;

{ TdxPDFListBoxField }

class function TdxPDFListBoxField.FieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftListBox;
end;

procedure TdxPDFListBoxField.ClearSelection;
begin
  DoClearSelection;
end;

procedure TdxPDFListBoxField.SelectAll;
begin
  DoSelectAll;
end;

{ TdxPDFComboBoxField }

class function TdxPDFComboBoxField.FieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftComboBox;
end;

function TdxPDFComboBoxField.GetEditable: Boolean;
begin
  Result := GetField.Editable;
end;

function TdxPDFComboBoxField.GetExportText: string;
begin
  if ItemIndex <> -1 then
    Result := Items[ItemIndex].ExportValue
  else
    Result := '';
end;

function TdxPDFComboBoxField.GetSpellCheck: Boolean;
begin
  Result := GetField.SpellCheck;
end;

function TdxPDFComboBoxField.GetText: string;
begin
  if ItemIndex <> -1 then
    Result := Items[ItemIndex].Value
  else
    Result := '';
end;

procedure TdxPDFComboBoxField.SetEditable(const AValue: Boolean);
begin
  if GetField.Editable <> AValue then
  begin
    GetField.Editable := AValue;
    Changed;
  end;
end;

procedure TdxPDFComboBoxField.SetSpellCheck(const AValue: Boolean);
begin
  if GetField.SpellCheck <> AValue then
  begin
    GetField.SpellCheck := AValue;
    Changed;
  end;
end;

{ TdxPDFCheckBoxFieldWidget }

function TdxPDFCheckBoxFieldWidget.GetButtonStyle: TdxPDFButtonStyle;
begin
  Result := Annotation.ButtonStyle;
end;

function TdxPDFCheckBoxFieldWidget.GetField: TdxPDFCheckBoxField;
begin
  Result := inherited Field as TdxPDFCheckBoxField;
end;

procedure TdxPDFCheckBoxFieldWidget.SetButtonStyle(const AValue: TdxPDFButtonStyle);
begin
  Annotation.ButtonStyle := AValue;
end;

{ TdxPDFCheckBoxField }

class function TdxPDFCheckBoxField.WidgetClass: TdxPDFCustomWidgetClass;
begin
  Result := TdxPDFCheckBoxFieldWidget;
end;

class function TdxPDFCheckBoxField.FieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftCheckBox;
end;

procedure TdxPDFCheckBoxField.DoClear;
begin
  Checked := False;
end;

function TdxPDFCheckBoxField.GetChecked: Boolean;
var
  AFieldValue: string;
begin
  if WidgetCount > 0 then
    AFieldValue := Widgets[0].Field.EditValue
  else
    AFieldValue := GetField.Value;
  Result := (AFieldValue <> GetField.OffStateName) and (AFieldValue <> '');
end;

function TdxPDFCheckBoxField.GetField: TdxPDFInteractiveFormButtonField;
begin
  Result := FField as TdxPDFInteractiveFormButtonField;
end;

function TdxPDFCheckBoxField.GetToggleToOff: Boolean;
begin
  Result := GetField.ToggleToOff;
end;

function TdxPDFCheckBoxField.GetWidget(AIndex: Integer): TdxPDFCheckBoxFieldWidget;
begin
  Result := DoGetWidget<TdxPDFCheckBoxFieldWidget>(AIndex);
end;

procedure TdxPDFCheckBoxField.SetChecked(const AValue: Boolean);
var
  AStateName: string;
begin
  if AValue then
    AStateName := GetField.OnStateName
  else
    AStateName := GetField.OffStateName;
  EditValue := AStateName;
end;

procedure TdxPDFCheckBoxField.SetToggleToOff(const AValue: Boolean);
begin
  GetField.ToggleToOff := AValue;
end;

{ TdxPDFButtonFieldAppearanceIconOptions }

constructor TdxPDFButtonFieldAppearanceIconOptions.Create(AWidget: TdxPDFButtonFieldWidget);
begin
  inherited Create;
  FWidget := AWidget;
end;

function TdxPDFButtonFieldAppearanceIconOptions.GetAppearanceCharacteristics: TdxPDFWidgetAppearanceCharacteristics;
begin
  Result := FWidget.Annotation.AppearanceCharacteristics;
end;

function TdxPDFButtonFieldAppearanceIconOptions.GetFitToAnnotationBounds: Boolean;
begin
  Result := IconFit.FitToAnnotationBounds;
end;

function TdxPDFButtonFieldAppearanceIconOptions.GetHorizontalPosition: Double;
begin
  Result := IconFit.HorizontalPosition;
end;

function TdxPDFButtonFieldAppearanceIconOptions.GetIconFit: TdxPDFIconFit;
begin
  Result := AppearanceCharacteristics.IconFit;
end;

function TdxPDFButtonFieldAppearanceIconOptions.GetScaleCondition: TdxPDFIconScalingCircumstances;
begin
  Result := IconFit.ScalingCircumstances;
end;

function TdxPDFButtonFieldAppearanceIconOptions.GetScaleType: TdxPDFIconScalingType;
begin
  Result := IconFit.ScalingType;
end;

function TdxPDFButtonFieldAppearanceIconOptions.GetVerticalPosition: Double;
begin
  Result := IconFit.VerticalPosition;
end;

procedure TdxPDFButtonFieldAppearanceIconOptions.SetFitToAnnotationBounds(const AValue: Boolean);
begin
  IconFit.FitToAnnotationBounds := AValue;
end;

procedure TdxPDFButtonFieldAppearanceIconOptions.SetHorizontalPosition(const AValue: Double);
begin
  IconFit.HorizontalPosition := AValue;
end;

procedure TdxPDFButtonFieldAppearanceIconOptions.SetScaleCondition(const AValue: TdxPDFIconScalingCircumstances);
begin
  IconFit.ScalingCircumstances := AValue;
end;

procedure TdxPDFButtonFieldAppearanceIconOptions.SetScaleType(const AValue: TdxPDFIconScalingType);
begin
  IconFit.ScalingType := AValue;
end;

procedure TdxPDFButtonFieldAppearanceIconOptions.SetVerticalPosition(const AValue: Double);
begin
  IconFit.VerticalPosition := AValue;
end;

{ TdxPDFButtonFieldWidget }

procedure TdxPDFButtonFieldWidget.CreateSubClasses;
begin
  inherited CreateSubClasses;
  FIconOptions := TdxPDFButtonFieldAppearanceIconOptions.Create(Self);
end;

procedure TdxPDFButtonFieldWidget.DestroySubClasses;
begin
  FreeAndNil(FIconOptions);
  inherited DestroySubClasses;
end;

function TdxPDFButtonFieldWidget.GetAlternateCaption: string;
begin
  Result := Annotation.AppearanceCharacteristics.AlternateCaption;
end;

function TdxPDFButtonFieldWidget.GetCaption: string;
begin
  Result := Annotation.AppearanceCharacteristics.Caption;
end;

function TdxPDFButtonFieldWidget.GetHint: string;
begin
  Result := Caption;
end;

function TdxPDFButtonFieldWidget.GetRolloverCaption: string;
begin
  Result := Annotation.AppearanceCharacteristics.RolloverCaption;
end;

function TdxPDFButtonFieldWidget.GetTextPosition: TdxPDFWidgetAnnotationTextPosition;
begin
  Result := Annotation.AppearanceCharacteristics.TextPosition;
end;

procedure TdxPDFButtonFieldWidget.SetAlternateCaption(const AValue: string);
begin
  Annotation.AppearanceCharacteristics.AlternateCaption := AValue;
end;

procedure TdxPDFButtonFieldWidget.SetCaption(const AValue: string);
begin
  Annotation.AppearanceCharacteristics.Caption := AValue;
end;

procedure TdxPDFButtonFieldWidget.SetHint(const AValue: string);
begin
  Caption := AValue;
end;

procedure TdxPDFButtonFieldWidget.SetRolloverCaption(const AValue: string);
begin
  Annotation.AppearanceCharacteristics.RolloverCaption := AValue;
end;

procedure TdxPDFButtonFieldWidget.SetTextPosition(const AValue: TdxPDFWidgetAnnotationTextPosition);
begin
  Annotation.AppearanceCharacteristics.TextPosition := AValue;
end;

{ TdxPDFButtonField }

class function TdxPDFButtonField.FieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftPushButton;
end;

class function TdxPDFButtonField.WidgetClass: TdxPDFCustomWidgetClass;
begin
  Result := TdxPDFButtonFieldWidget;
end;

procedure TdxPDFButtonField.SetExportable(const AValue: Boolean);
begin
  inherited SetExportable(False);
end;

function TdxPDFButtonField.GetWidget(AIndex: Integer): TdxPDFButtonFieldWidget;
begin
  Result := DoGetWidget<TdxPDFButtonFieldWidget>(AIndex);
end;

{ TdxPDFRadioGroupFieldItem }

constructor TdxPDFRadioGroupFieldItem.Create(AField: TdxPDFInteractiveFormField; AGroup: TdxPDFRadioGroupField);
begin
  inherited Create(AField);
  FGroup := AGroup;
end;

class function TdxPDFRadioGroupFieldItem.FieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftRadioGroup;
end;

procedure TdxPDFRadioGroupFieldItem.DoChanged;
begin
  dxCallNotify(OnEditValueChanged, Self);
end;

class function TdxPDFRadioGroupFieldItem.WidgetClass: TdxPDFCustomWidgetClass;
begin
  Result := TdxPDFRadioButtonFieldWidget;
end;

function TdxPDFRadioGroupFieldItem.GetAnnotation: TdxPDFWidgetAnnotation;
begin
  Result := FField.Widget as TdxPDFWidgetAnnotation;
end;

function TdxPDFRadioGroupFieldItem.GetCheckedStateName: string;
begin
  Result := GetAnnotation.GetOnAppearanceName;
end;

function TdxPDFRadioGroupFieldItem.GetField: TdxPDFInteractiveFormButtonField;
begin
  Result := FField as TdxPDFInteractiveFormButtonField;
end;

function TdxPDFRadioGroupFieldItem.GetRadiosInUnison: Boolean;
begin
  Result := GetField.RadiosInUnison;
end;

function TdxPDFRadioGroupFieldItem.GetToggleToOff: Boolean;
begin
  Result := GetField.ToggleToOff;
end;

function TdxPDFRadioGroupFieldItem.GetWidget: TdxPDFRadioButtonFieldWidget;
begin
  Result := Group.Widgets[Group.IndexOf(Self)];
end;

procedure TdxPDFRadioGroupFieldItem.SetRadiosInUnison(const AValue: Boolean);
begin
  GetField.RadiosInUnison := AValue;
end;

procedure TdxPDFRadioGroupFieldItem.SetToggleToOff(const AValue: Boolean);
begin
  GetField.ToggleToOff := AValue;
end;

{ TdxPDFRadioGroupField }

class function TdxPDFRadioGroupField.FieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftRadioGroup;
end;

function TdxPDFRadioGroupField.IndexOf(AItem: TdxPDFRadioGroupFieldItem): Integer;
begin
  Result := ItemList.IndexOf(AItem);
end;

class function TdxPDFRadioGroupField.WidgetClass: TdxPDFCustomWidgetClass;
begin
  Result := TdxPDFRadioButtonFieldWidget;
end;

function TdxPDFRadioGroupField.CreateSubItem(AField: TdxPDFInteractiveFormField): TdxPDFCustomField;
begin
  Result := TdxPDFRadioGroupFieldItem.Create(AField, Self);
end;

procedure TdxPDFRadioGroupField.DoClear;
begin
  ItemIndex := -1;
end;

function TdxPDFRadioGroupField.GetField: TdxPDFInteractiveFormButtonField;
begin
  Result := FField as TdxPDFInteractiveFormButtonField;
end;

function TdxPDFRadioGroupField.GetItem(AIndex: Integer): TdxPDFRadioGroupFieldItem;
begin
  Result := ItemList[AIndex] as TdxPDFRadioGroupFieldItem;
end;

function TdxPDFRadioGroupField.GetItemCount: Integer;
begin
  Result := ItemList.Count;
end;

function TdxPDFRadioGroupField.GetItemIndex: Integer;
var
  AState: string;
  I: Integer;
begin
  AState := State;
  Result := IfThen((AState = GetField.OffStateName) or (AState = ''), -1);
  if Result <> -1 then
    for I := 0 to ItemCount - 1 do
      if Items[I].CheckedStateName = AState then
      begin
        Result := I;
        Break;
      end;
end;

function TdxPDFRadioGroupField.GetState: string;
begin
  Result := GetField.State;
end;

function TdxPDFRadioGroupField.GetWidget(AIndex: Integer): TdxPDFRadioButtonFieldWidget;
begin
  Result := DoGetWidget<TdxPDFRadioButtonFieldWidget>(AIndex);
end;

procedure TdxPDFRadioGroupField.SetItemIndex(const AValue: Integer);
var
  AIndex: Integer;
  AState: string;
begin
  AIndex := IfThen(AValue >= 0, Min(ItemCount - 1, AValue) , -1);
  if AIndex = -1 then
    AState := GetField.OffStateName
  else
    AState := Items[AIndex].CheckedStateName;
  GetField.State := AState;
end;

{ TdxPDFTextField }

class function TdxPDFTextField.FieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftText;
end;

function TdxPDFTextField.IsComposite: Boolean;
begin
  Result := GetField.IsComposite;
end;

function TdxPDFTextField.GetDefaultText: string;
begin
  Result := GetField.DefaultText;
end;

function TdxPDFTextField.GetField: TdxPDFInteractiveFormTextField;
begin
  Result := FField as TdxPDFInteractiveFormTextField;
end;

function TdxPDFTextField.GetHint: string;
begin
  Result := FField.AlternateName;
end;

class function TdxPDFTextField.WidgetClass: TdxPDFCustomWidgetClass;
begin
  Result := TdxPDFTextFieldWidget;
end;

procedure TdxPDFTextField.DoClear;
begin
  Text := '';
end;

function TdxPDFTextField.GetInputType: TdxPDFTextFieldInputType;
begin
  Result := GetField.InputType;
end;

function TdxPDFTextField.GetMaxLength: Integer;
begin
  Result := GetField.MaxLen;
end;

function TdxPDFTextField.GetMultiLine: Boolean;
begin
  Result := GetField.MultiLine;
end;

function TdxPDFTextField.GetScrollable: Boolean;
begin
  Result := GetField.Scrollable;
end;

function TdxPDFTextField.GetSpellCheck: Boolean;
begin
  Result := GetField.SpellCheck;
end;

function TdxPDFTextField.GetText: string;
begin
  Result := GetField.Text;
end;

function TdxPDFTextField.GetWidget(AIndex: Integer): TdxPDFTextFieldWidget;
begin
  Result := DoGetWidget<TdxPDFTextFieldWidget>(AIndex);
end;

procedure TdxPDFTextField.SetInputType(const AValue: TdxPDFTextFieldInputType);
begin
  GetField.InputType := AValue;
end;

procedure TdxPDFTextField.SetMaxLength(const AValue: Integer);
begin
  GetField.MaxLen := AValue;
end;

procedure TdxPDFTextField.SetMultiLine(const AValue: Boolean);
begin
  GetField.MultiLine := AValue;
end;

procedure TdxPDFTextField.SetScrollable(const AValue: Boolean);
begin
  GetField.Scrollable := AValue;
end;

procedure TdxPDFTextField.SetSpellCheck(const AValue: Boolean);
begin
  GetField.SpellCheck := AValue;
end;

procedure TdxPDFTextField.SetText(const AValue: string);
begin
  GetField.Text := AValue;
end;

{ TdxPDFSignatureField }

class function TdxPDFSignatureField.FieldType: TdxPDFInteractiveFormFieldType;
begin
  Result := ftSignature;
end;

{ TdxPDFForm }

constructor TdxPDFForm.Create(ADocument: TObject);
begin
  inherited Create;
  FDocument := ADocument as TdxPDFDocument;
  FFieldNameList := TStringList.Create;
  FFields := TdxPDFStringObjectDictionary<TdxPDFCustomField>.Create([doOwnsValues]);
  FAnnotationWidgetMap := TDictionary<TObject, TdxPDFCustomWidget>.Create;
  PopulateFields;
end;

destructor TdxPDFForm.Destroy;
begin
  FreeAndNil(FAnnotationWidgetMap);
  FreeAndNil(FFields);
  FreeAndNil(FFieldNameList);
  inherited Destroy;
end;

procedure TdxPDFForm.LoadDataFromFile(const AFileName: string);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    LoadDataFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TdxPDFForm.LoadDataFromStream(AStream: TStream);
var
  AData: TdxPDFFormData;
begin
  AData := TdxPDFFormData.Create;
  try
    AData.LoadFromStream(AStream);
    LoadData(AData);
  finally
    AData.Free;
  end;
end;

procedure TdxPDFForm.SaveDataToFile(const AFileName: string);
begin
  CreateFormDataAndExecute(
    procedure(AFormData: TdxPDFFormData)
    begin
      AFormData.SaveToFile(AFileName);
    end);
end;

procedure TdxPDFForm.SaveDataToStream(AStream: TStream; AFormat: TdxPDFFormDataFormat);
begin
  CreateFormDataAndExecute(
    procedure(AFormData: TdxPDFFormData)
    begin
      AFormData.SaveToStream(AStream, AFormat);
    end);
end;

procedure TdxPDFForm.ClearValues;
begin
  ForEach(
    procedure(AField: TdxPDFCustomField)
    begin
      AField.Clear;
    end);
end;

procedure TdxPDFForm.Flatten;
begin
  ForEach(
    procedure(AField: TdxPDFCustomField)
    begin
      Flatten(AField);
    end);
end;

procedure TdxPDFForm.ForEach(AProc: TdxPDFFormForEachFieldProc);
var
  AField: TdxPDFCustomField;
begin
  if not Assigned(AProc) then
    Exit;
  BeginUpdate;
  try
    for AField in Self do
      AProc(AField);
  finally
    EndUpdate;
  end;
end;

procedure TdxPDFForm.Flatten(AField: TdxPDFCustomField);
begin
  if AField <> nil then
  begin
    TdxPDFDocumentAccess(FDocument).AcroForm.Delete(AField.Field, True);
    FNeedRefresh := True;
    Update;
  end;
end;

procedure TdxPDFForm.Reset;
begin
  ForEach(
    procedure(AField: TdxPDFCustomField)
    begin
      AField.Reset;
    end);
end;

function TdxPDFForm.GetButtonField(const AFullName: string): TdxPDFButtonField;
begin
  Result := GetField(AFullName) as TdxPDFButtonField;
end;

function TdxPDFForm.GetCheckBoxField(const AFullName: string): TdxPDFCheckBoxField;
begin
  Result := GetField(AFullName) as TdxPDFCheckBoxField;
end;

function TdxPDFForm.GetComboBoxField(const AFullName: string): TdxPDFComboBoxField;
begin
  Result := GetField(AFullName) as TdxPDFComboBoxField;
end;

function TdxPDFForm.GetField(const AFullName: string): TdxPDFCustomField;
begin
  Result := FFields[AFullName];
end;

function TdxPDFForm.GetListBoxField(const AFullName: string): TdxPDFListBoxField;
begin
  Result := GetField(AFullName) as TdxPDFListBoxField;
end;

function TdxPDFForm.GetRadioGroupField(const AFullName: string): TdxPDFRadioGroupField;
begin
  Result := GetField(AFullName) as TdxPDFRadioGroupField;
end;

function TdxPDFForm.GetTextField(const AFullName: string): TdxPDFTextField;
begin
  Result := GetField(AFullName) as TdxPDFTextField;
end;

function TdxPDFForm.TryGetButtonField(const AFullName: string; out AField: TdxPDFButtonField): Boolean;
begin
  Result := DoTryGetField(AFullName, TdxPDFButtonField, AField);
end;

function TdxPDFForm.TryGetCheckBoxField(const AFullName: string; out AField: TdxPDFCheckBoxField): Boolean;
begin
  Result := DoTryGetField(AFullName, TdxPDFCheckBoxField, AField);
end;

function TdxPDFForm.TryGetComboBoxField(const AFullName: string; out AField: TdxPDFComboBoxField): Boolean;
begin
  Result := DoTryGetField(AFullName, TdxPDFComboBoxField, AField);
end;

function TdxPDFForm.TryGetField(const AFullName: string; out AField: TdxPDFCustomField): Boolean;
begin
  Result := DoTryGetField(AFullName, TdxPDFCustomField, AField);
end;

function TdxPDFForm.TryGetListBoxField(const AFullName: string; out AField: TdxPDFListBoxField): Boolean;
begin
  Result := DoTryGetField(AFullName, TdxPDFListBoxField, AField);
end;

function TdxPDFForm.TryGetRadioGroupField(const AFullName: string; out AField: TdxPDFRadioGroupField): Boolean;
begin
  Result := DoTryGetField(AFullName, TdxPDFRadioGroupField, AField);
end;

function TdxPDFForm.TryGetTextField(const AFullName: string; out AField: TdxPDFTextField): Boolean;
begin
  Result := DoTryGetField(AFullName, TdxPDFTextField, AField);
end;

function TdxPDFForm.DoGetEnumerator: TEnumerator<TdxPDFCustomField>;
begin
  Result := FFields.Values.GetEnumerator;
end;

function TdxPDFForm.CreateData: TdxPDFFormData;
var
  ACatalog: TdxPDFCatalog;
  AField: TdxPDFInteractiveFormField;
  AFieldData: TdxPDFFormData;
  I: Integer;
begin
  Result := TdxPDFFormData.Create;
  ACatalog := GetState.Catalog;
  if ACatalog.AcroForm <> nil then
    for I := 0 to ACatalog.AcroForm.Fields.Count - 1 do
    begin
      AField := ACatalog.AcroForm.Fields[I];
      if AField.Exportable then
      begin
        AFieldData := CreateFormData(AField);
        if AFieldData <> nil then
          Result[AField.Name] := AFieldData;
      end;
    end;
end;

procedure TdxPDFForm.BeginUpdate;
begin
  TdxPDFDocument(FDocument).BeginUpdate;
end;

procedure TdxPDFForm.EndUpdate;
begin
  TdxPDFDocument(FDocument).EndUpdate;
end;

procedure TdxPDFForm.LoadData(AData: TdxPDFFormData);
var
  ADocumentFormData: TdxPDFFormData;
begin
  ADocumentFormData := CreateData;
  BeginUpdate;
  try
    ADocumentFormData.Assign(AData);
  finally
    EndUpdate;
    ADocumentFormData.Free;
  end;
end;

procedure TdxPDFForm.Update;
begin
  if not IsLocked then
  begin
    if not FNeedRefresh then
      Exit;
    FNeedRefresh := False;
    FAnnotationWidgetMap.Clear;
    FFields.Clear;
    FFieldNameList.Clear;
    PopulateFields;
  end
  else
    FNeedRefresh := True;
end;

procedure TdxPDFForm.OnFieldEditValueChangedHandler(ASender: TObject);
begin
  TdxPDFDocumentAccess(FDocument).DoFieldEditValueChanged(ASender);
end;

procedure TdxPDFForm.OnFieldEditValueChangingHandler(ASender: TdxPDFCustomField; const AOldValue, ANewValue: Variant;
  var AAccept: Boolean);
begin
  TdxPDFDocumentAccess(FDocument).DoFieldEditValueChanging(ASender, AOldValue, ANewValue, AAccept);
end;

function TdxPDFForm.GetAcroForm: TdxPDFInteractiveForm;
begin
  Result := (GetState as TdxPDFDocumentState).AcroForm;
end;

function TdxPDFForm.GetState: TdxPDFDocumentState;
begin
  Result := TdxPDFDocumentAccess(FDocument).State;
end;

function TdxPDFForm.GetFieldCount: Integer;
begin
  Result := FFields.Count;
end;

function TdxPDFForm.GetFieldNames: TStringList;
var
  AName: string;
begin
  if FFieldNameList = nil then
    FFieldNameList := TStringList.Create
  else
    FFieldNameList.Clear;
  for AName in FFields.Keys do
    FFieldNameList.Add(AName);
  Result := FFieldNameList;
end;

function TdxPDFForm.CreateFormData(AField: TdxPDFInteractiveFormField): TdxPDFFormData;
var
  AChild: TdxPDFInteractiveFormField;
  AData: TdxPDFFormData;
  AIsButtonField: Boolean;
  I: Integer;
begin
  if (AField.Widget <> nil) and (AField.Widget is TdxPDFWidgetAnnotation) then
    TdxPDFWidgetAnnotation(AField.Widget).EnsureAppearance;

  AIsButtonField := AField is TdxPDFInteractiveFormButtonField;
  if AIsButtonField and TdxPDFInteractiveFormButtonField(AField).IsPushButton or (AField.Name = '') then
    Exit(nil);

  Result := TdxPDFFormData.Create(AField);

  if not AIsButtonField and (AField.Kids <> nil) then
    for I := 0 to AField.Kids.Count - 1 do
    begin
      AChild := AField.Kids[I];
      AData := CreateFormData(AChild);
      if AData <> nil then
        Result[AChild.Name] := AData;
    end;
end;

function TdxPDFForm.DoTryGetField(const AFullName: string; AFieldClass: TdxPDFCustomFieldClass; out AField): Boolean;
var
  AObject: TdxPDFCustomField;
begin
  Result := FFields.TryGetValue(AFullName, AObject) and Safe.Cast(AObject, AFieldClass, AField);
end;

function TdxPDFForm.IsLocked: Boolean;
begin
  Result := TdxPDFDocumentAccess(FDocument).IsLocked;
end;

procedure TdxPDFForm.CreateFormDataAndExecute(const AAction: TProc<TdxPDFFormData>);
var
  AFormData: TdxPDFFormData;
begin
  if not Assigned(AAction) then
    Exit;
  AFormData := CreateData;
  try
    AAction(AFormData);
  finally
    AFormData.Free;
  end;
end;

class function TdxPDFForm.GetUniqueName<T>(ADictionary: TdxPDFStringObjectDictionary<T>; const AName: String): String;
var
  Index:  Integer;
begin
  Result := AName;
  Index := 0;
  while ADictionary.ContainsKey(Result) do
  begin
    Inc(Index);
    Result := Format('%s (%d)', [AName, Index]);
  end;
end;

procedure TdxPDFForm.PopulateFields;

  procedure RegisterWidget(AField: TdxPDFCustomField);
  var
    AWidget: TdxPDFCustomWidget;
    I: Integer;
  begin
    for I := 0 to AField.WidgetCount - 1 do
    begin
      AWidget := AField.WidgetList[I] as TdxPDFCustomWidget;
      FAnnotationWidgetMap.Add(AWidget.Annotation, AWidget);
    end;
  end;

var
  AFieldTree: TdxPDFFormFieldTreeNode;
  AForm: TdxPDFInteractiveForm;
  ANode, AKid: TdxPDFFormFieldTreeNode;
  AQueue: TQueue<TdxPDFFormFieldTreeNode>;
begin
  AForm := GetAcroForm;
  if AForm = nil then
    Exit;
  AFieldTree := TdxPDFFormFieldTreeNode.Create(Self, nil, AForm.Fields);
  try
    AQueue := TQueue<TdxPDFFormFieldTreeNode>.Create;
    try
      AQueue.Enqueue(AFieldTree);
      while AQueue.Count > 0 do
      begin
        ANode := AQueue.Dequeue;
        if ANode.Kids.Count = 0 then
        begin
          if ANode.Field <> nil then
          begin
            FFields.Add(GetUniqueName<TdxPDFCustomField>(FFields, ANode.InternalField.FullName), ANode.Field);
            RegisterWidget(ANode.Field);
          end;
        end
        else
          for AKid in ANode.Kids.Values do
            AQueue.Enqueue(AKid);
      end;
    finally
      FreeAndNil(AQueue);
    end;
  finally
    AFieldTree.Free;
  end;
end;

end.


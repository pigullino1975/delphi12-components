{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Model Diagram for ExpressEntityMapping Framework         }
{                                                                    }
{           Copyright (c) 2016-2024 Developer Express Inc.           }
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
{   (DCU, OBJ, DLL, DPU, SO, ETC.) ARE CONFIDENTIAL AND PROPRIETARY  }
{   TRADE SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER }
{   IS LICENSED TO DISTRIBUTE THE EXPRESSENTITYMAPPING FRAMEWORK     }
{   AS PART OF AN EXECUTABLE PROGRAM ONLY.                           }
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

unit dxEMFModelObjects;

{$SCOPEDENUMS ON}
{$I cxVer.inc}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils,
  Generics.Collections,
  dxCore, dxCoreClasses, dxXmlDoc, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxCustomData,
  cxClasses, dxEMF.Types, dxEMF.DB.Model,
  dxEMFToolTypes;

const
  AssociationImageIndex = 5;
  AssociationsImageIndex = AssociationImageIndex;
  DataModelImageIndex = 0;
  EntitiesImageIndex = 2;
  EntityImageIndex = 1;
  EntityKeyPropertyImageIndex = 4;
  EntityPropertyImageIndex = 3;
  InheritanceImageIndex = 6;
  InheritancesImageIndex = InheritanceImageIndex;

  AssociationOverlayImageIndex = 8;
  AssociationSelfToSelfOverlayImageIndex = 9;
  InvalidEntityOverlayImageIndex = 7;

type
  TNamedPersistent = class;
  TNamedPersistentClass = class of TNamedPersistent;
  TAssociation = class;
  TAssociationEndOptions = class;
  TEntityProperty = class;
  TEntity = class;
  TDataModel = class;

  IEMFDesigner = interface
  ['{8DED1E77-521F-47F6-A040-912CEEEAC0DD}']
    procedure DeleteObject(AItem: TNamedPersistent);
    procedure RegisterDataType(ADataType: TDataType);
    function GetKnownDataTypes: TDictionary<string, TDataType>;
    function GetModel: TDataModel;
    procedure ItemAdded(AItem: TNamedPersistent);
    procedure ItemRemoved(AItem: TNamedPersistent);
    procedure ItemNameChanged(AItem: TNamedPersistent);
    procedure ItemPropertiesChanged(AItem: TNamedPersistent);
    procedure Modified;
    procedure SelectObject(AItem: TNamedPersistent);
    property Model: TDataModel read GetModel;
  end;

  { TNamedPersistent }

  TNamedPersistent = class(TPersistent)
  strict private
    FChildren: TObjectList<TNamedPersistent>;
    FIsNameAssigned: Boolean;
    FListeners: TList<TNamedPersistent>;
    FName: string;
    FParent: TNamedPersistent;
    FRestoreName: string;
    FValid: Boolean;
    FValidationErrorText: string;
  private
    procedure SetName(const Value: string);
  protected
    procedure AddChild(AChild: TNamedPersistent);
    procedure AddListener(AListener: TNamedPersistent);
    function AddNewChild: TNamedPersistent; virtual;
    function CanHaveChildren: Boolean; virtual;
    procedure CheckDefaultName; virtual;
    function CreateChildByNodeName(const AXmlNodeName: string): TNamedPersistent; virtual;
    function CreateUniqueName(const ABaseName: string): string; virtual;
    procedure DoSetName(const Value: string); virtual;
    procedure ItemDeleting(AItem: TNamedPersistent); virtual;
    function GetBaseName: string; virtual;
    function GetDefaultName: string; virtual;
    function GetDisplayName: string; virtual;
    function GetDisplayClassName: string; virtual;
    procedure RemoveChild(AChild: TNamedPersistent);
    class function GetXmlNodeName: string; virtual;
    function IsNamePermanent: Boolean; virtual;
    function IsNameUnique(const AName: string): Boolean;
    function IsNameValid(const Value: string): Boolean; virtual;
    procedure PropertyChanged;
    procedure RemoveListener(AListener: TNamedPersistent);
    procedure RestoreProperties(ANode: TdxXmlNode); virtual;
    procedure SetDefaultProperties; virtual;
    procedure StoreProperties(ANode: TdxXmlNode); virtual;
    property IsNameAssigned: Boolean read FIsNameAssigned write FIsNameAssigned;
    property RestoreName: string read FRestoreName;
  public
    constructor Create(AParent: TNamedPersistent); virtual;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function CanDelete: Boolean; virtual;
    function CanEditName: Boolean; virtual;
    function Contains(AItem: TNamedPersistent; ARecursive: Boolean = True): Boolean;
    procedure Delete;
    procedure DoAfterRestore; virtual;
    function FindChildByName(const AName: string): TNamedPersistent;
    function GetImageIndex: Integer; virtual;
    function GetOverlayImageIndex: Integer; virtual;
    function IsPropertyVisible(const APropertyName: string): Boolean; virtual;
    function IsValidatable: Boolean; virtual;
    procedure ResetProperties; virtual;
    // store/restore
    procedure Restore(ANode: TdxXmlNode); virtual;
    procedure Store(AParentXmlNode: TdxXmlNode); virtual;

    property Children: TObjectList<TNamedPersistent> read FChildren;
    property DisplayName: string read GetDisplayName;
    property DisplayClassName: string read GetDisplayClassName;
    property Parent: TNamedPersistent read FParent;
    property Valid: Boolean read FValid write FValid;
    property ValidationErrorText: string read FValidationErrorText write FValidationErrorText;
  published
    property Name: string read FName write SetName;
  end;

  TEntityPropertyDataTypeOptions = class(TcxOwnedPersistent)
  strict private
    FDataType: string;
    FEntity: TEntity;
    function GetEntityProperty: TEntityProperty;
    procedure SetDataType(const Value: string);
    procedure SetEntity(Value: TEntity);
  protected
    procedure DoAssign(Source: TPersistent); override;
    function GetDataType: string; virtual;
  public
    constructor Create(AOwner: TPersistent); override;
    property EntityProperty: TEntityProperty read GetEntityProperty;
  published
    property DataType: string read FDataType write SetDataType;
    property Entity: TEntity read FEntity write SetEntity;
  end;

  { TCustomEntityProperty }

  TCustomEntityProperty = class(TNamedPersistent)
  private
    FAssociationEnd: TAssociationEndOptions;
  protected
    function GetDisplayClassName: string; override;
  public
    property AssociationEnd: TAssociationEndOptions read FAssociationEnd;
  end;

  { TEntityProperty }

  TEntityProperty = class(TCustomEntityProperty)
  strict private
    FColumnDataType: string;
    FColumnName: string;
    FDataTypeOptions: TEntityPropertyDataTypeOptions;
    FDefaultValue: string;
    FDisplayFormat: string;
    FDisplayLabel: string;
    FDisplayWidth: Integer;
    FEditFormat: string;
    FEditMask: string;
    FIdGenerator: TdxGeneratorType;
    FLookupResultField: string;
    FMaxLength: Integer;
    FMaxValue: Double;
    FMinValue: Double;
    FOptions: TEntityPropertyOptions;
    FPrecision: Integer;
    FReferenceEntityRestoreName: string;
    FSequenceName: string;
    procedure CreateDataTypeOptions;
    function GetDataType: string;
    procedure SetColumnDataType(const Value: string);
    procedure SetColumnName(const Value: string);
    procedure SetDataTypeOptions(const Value: TEntityPropertyDataTypeOptions);
    procedure SetDefaultValue(const Value: string);
    procedure SetDisplayFormat(const Value: string);
    procedure SetDisplayLabel(const Value: string);
    procedure SetDisplayWidth(const Value: Integer);
    procedure SetEditFormat(const Value: string);
    procedure SetEditMask(const Value: string);
    procedure SetIdGenerator(const Value: TdxGeneratorType);
    procedure SetLookupResultField(const Value: string);
    procedure SetMaxLength(const Value: Integer);
    procedure SetMaxValue(const Value: Double);
    procedure SetMinValue(const Value: Double);
    procedure SetOptions(const Value: TEntityPropertyOptions);
    procedure SetPrecision(const Value: Integer);
    procedure SetSequenceName(const Value: string);
  protected
    procedure DoAfterRestoreAllEntities;
    class function GetXmlNodeName: string; override;
    procedure ItemDeleting(AItem: TNamedPersistent); override;
    procedure RestoreProperties(ANode: TdxXmlNode); override;
    procedure SetAssociationEnd(AValue: TAssociationEndOptions);
    procedure SetDefaultProperties; override;
    procedure StoreProperties(ANode: TdxXmlNode); override;
  public
    constructor Create(AParent: TNamedPersistent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function CanDelete: Boolean; override;
    procedure DoAfterRestore; override;
    function GetImageIndex: Integer; override;
    function GetOverlayImageIndex: Integer; override;
    function IsPropertyVisible(const APropertyName: string): Boolean; override;
    property DataType: string read GetDataType;
  published
    property ColumnDataType: string read FColumnDataType write SetColumnDataType;
    property ColumnName: string read FColumnName write SetColumnName;
    property DataTypeOptions: TEntityPropertyDataTypeOptions read FDataTypeOptions write SetDataTypeOptions;
    property DefaultValue: string read FDefaultValue write SetDefaultValue;
    property DisplayFormat: string read FDisplayFormat write SetDisplayFormat;
    property DisplayLabel: string read FDisplayLabel write SetDisplayLabel;
    property DisplayWidth: Integer read FDisplayWidth write SetDisplayWidth default 0;
    property EditFormat: string read FEditFormat write SetEditFormat;
    property EditMask: string read FEditMask write SetEditMask;
    property IdGenerator: TdxGeneratorType read FIdGenerator write SetIdGenerator default TdxGeneratorType.None;
    property LookupResultField: string read FLookupResultField write SetLookupResultField;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property MaxValue: Double read FMaxValue write SetMaxValue;
    property MinValue: Double read FMinValue write SetMinValue;
    property Options: TEntityPropertyOptions read FOptions write SetOptions default [];
    property Precision: Integer read FPrecision write SetPrecision default 15;
    property SequenceName: string read FSequenceName write SetSequenceName;
  end;

  { TEntityRelationshipProperty }

  TEntityRelationshipProperty = class(TCustomEntityProperty)
  protected
    function GetBaseName: string; override;
    function GetDefaultName: string; override;
  public
    constructor Create(AParent: TNamedPersistent; AAssociationEnd: TAssociationEndOptions); reintroduce; virtual;
    function GetImageIndex: Integer; override;
    function GetOverlayImageIndex: Integer; override;
    // store/restore
    procedure Restore(ANode: TdxXmlNode); override;
    procedure Store(AParentXmlNode: TdxXmlNode); override;
  end;

  { TOptionsInheritance }

  TOptionsInheritance = class(TcxOwnedPersistent)
  strict private
    FDiscriminatorColumnSize: Integer;
    FDiscriminatorColumnName: string;
    FDiscriminatorType: TdxDiscriminatorType;
    FDiscriminatorValue: string;
    FMapInheritanceType: TMapInheritanceType;
    procedure SetDiscriminatorColumnSize(const Value: Integer);
    procedure SetDiscriminatorColumnName(const Value: string);
    procedure SetDiscriminatorType(const Value: TdxDiscriminatorType);
    procedure SetDiscriminatorValue(const Value: string);
    procedure SetMapInheritanceType(const Value: TMapInheritanceType);
  protected
    procedure DoAssign(Source: TPersistent); override;
  published
    property DiscriminatorColumnSize: Integer read FDiscriminatorColumnSize write SetDiscriminatorColumnSize default 0;
    property DiscriminatorColumnName: string read FDiscriminatorColumnName write SetDiscriminatorColumnName;
    property DiscriminatorType: TdxDiscriminatorType read FDiscriminatorType write SetDiscriminatorType default TdxDiscriminatorType.String;
    property DiscriminatorValue: string read FDiscriminatorValue write SetDiscriminatorValue;
    property MapInheritanceType: TMapInheritanceType read FMapInheritanceType write SetMapInheritanceType default TMapInheritanceType.None;
  end;

  { TEntity }

  TEntity = class(TNamedPersistent)
  strict private
    FBaseEntityRestoreName: string;
    FBaseEntity: TEntity;
    FDataType: string;
    FDataTypeAssigned: Boolean;
    FIndexes: TStrings;
    FOptionsInheritance: TOptionsInheritance;
    FSchemaName: string;
    FTableName: string;
    function GetDefaultDataType: string;
    procedure SetIndexes(Value: TStrings);
    procedure SetBaseEntity(const Value: TEntity);
    procedure SetDataType(const Value: string);
    procedure SetOptionsInheritance(const Value: TOptionsInheritance);
    procedure SetSchemaName(const Value: string);
    procedure SetTableName(const Value: string);
  protected
    function AddNewChild: TNamedPersistent; override;
    function AddRelationProperty(AAssociationEnd: TAssociationEndOptions): TEntityRelationshipProperty;
    function CanHaveChildren: Boolean; override;
    procedure RecreateInheritance;
    function CreateChildByNodeName(const AXmlNodeName: string): TNamedPersistent; override;
    procedure DoSetName(const Value: string); override;
    function GetDisplayName: string; override;
    function GetRelationProperty(AAssociation: TAssociation): TEntityRelationshipProperty;
    class function GetXmlNodeName: string; override;
    procedure ItemDeleting(AItem: TNamedPersistent); override;
    procedure DoAfterRestoreAllEntities;
    function GetDisplayClassName: string; override;
    procedure RestoreProperties(ANode: TdxXmlNode); override;
    procedure StoreProperties(ANode: TdxXmlNode); override;
  public
    constructor Create(AParent: TNamedPersistent); override;
    destructor Destroy; override;
    function AddProperty: TEntityProperty;
    function CanDelete: Boolean; override;
    procedure DoAfterRestore; override;
    function GetImageIndex: Integer; override;
    function HasPrimaryKey: Boolean;
    function IsInheritedFrom(AEntity: TEntity): Boolean;
    function IsValidatable: Boolean; override;
    procedure RemoveRelationProperty(AAssociation: TAssociation);
  published
    property BaseEntity: TEntity read FBaseEntity write SetBaseEntity;
    property DataType: string read FDataType write SetDataType;
    property Indexes: TStrings read FIndexes write SetIndexes;
    property OptionsInheritance: TOptionsInheritance read FOptionsInheritance write SetOptionsInheritance;
    property SchemaName: string read FSchemaName write SetSchemaName;
    property TableName: string read FTableName write SetTableName;
  end;

  { TDataModelChilds }

  TDataModelChilds = class(TNamedPersistent)
  private
    function GetCount: Integer;
    function GetName: string;
  protected
    function CanHaveChildren: Boolean; override;
    function IsNamePermanent: Boolean; override;
  public
    property Count: Integer read GetCount;
  published
    property Name: string read GetName;
  end;

  { TEntities }

  TEntities = class(TDataModelChilds)
  strict private
    function GetItem(Index: Integer): TEntity;
  protected
    function AddNewChild: TNamedPersistent; override;
    function CreateUniqueName(const ABaseName: string): string; override;
    class function GetXmlNodeName: string; override;
  public
    function GetImageIndex: Integer; override;
    // store/restore
    procedure Restore(ANode: TdxXmlNode); override;

    property Items[Index: Integer]: TEntity read GetItem; default;
  published
  end;

  { TAssociationEndOptions }

  TAssociationEndOptions = class(TcxOwnedPersistent)
  strict private
    FEntity: TEntity;
    function GetAssociation: TAssociation;
  protected
    procedure CheckDefaultName; virtual;
    function GetEntityProperty: TCustomEntityProperty; virtual;
    procedure SetEntity(const Value: TEntity);
  public
    function GetOppositeEnd: TAssociationEndOptions;
    property EntityProperty: TCustomEntityProperty read GetEntityProperty;
    property Entity: TEntity read FEntity;
    property Association: TAssociation read GetAssociation;
  end;

  { TAssociationManyEndOptions }

  TAssociationManyEndOptions = class(TAssociationEndOptions)
  strict private
    function GetCollectionPropertyName: string;
    procedure SetCollectionPropertyName(const Value: string);
  protected
    procedure CheckDefaultName; override;
    procedure DoAssign(Source: TPersistent); override;
    function GetEntityProperty: TCustomEntityProperty; override;
  published
    property CollectionPropertyName: string read GetCollectionPropertyName write SetCollectionPropertyName;
  end;

  { TAssociationOneEndOptions }

  TAssociationOneEndOptions = class(TAssociationEndOptions)
  strict private
    FReferenceProperty: TEntityProperty;
    function GetReferencePropertyName: string;
    procedure CheckDefaultNames;
    procedure SetReferenceProperty(AValue: TEntityProperty);
    procedure SetReferencePropertyName(const Value: string);
  protected
    procedure DoAssign(Source: TPersistent); override;
    function GetEntityProperty: TCustomEntityProperty; override;
  public
    destructor Destroy; override;
    property ReferenceProperty: TEntityProperty read FReferenceProperty write SetReferenceProperty;
  published
    property ReferencePropertyName: string read GetReferencePropertyName write SetReferencePropertyName;
  end;

  { TAssociation }

  TAssociation = class(TNamedPersistent)
  strict private
    FType: TAssociationType;
    FDeleteRule: TAssociationDeleteRule;
    FEnd1: TAssociationEndOptions;
    FEnd2: TAssociationEndOptions;
    procedure AddRelationProperty;
    function GetEntity1: TEntity;
    function GetEntity2: TEntity;
    procedure RecreateAssociationEnd1;
    procedure RemoveRelationProperty;
    procedure SetEntity1(const Value: TEntity);
    procedure SetEntity2(const Value: TEntity);
    procedure SetDeleteRule(const Value: TAssociationDeleteRule);
  protected
    class function GetXmlNodeName: string; override;
    function GetDefaultName: string; override;
    function GetDisplayClassName: string; override;
    procedure ItemDeleting(AItem: TNamedPersistent); override;
    procedure RestoreProperties(ANode: TdxXmlNode); override;
    procedure StoreProperties(ANode: TdxXmlNode); override;
  public
    constructor Create(AParent: TNamedPersistent); override;
    destructor Destroy; override;
    function CanDelete: Boolean; override;
    function GetImageIndex: Integer; override;
    function GetOppositeEnd(AEnd: TAssociationEndOptions): TAssociationEndOptions;
    function GetOppositeEndEntity(AEntity: TEntity): TEntity;
    function GetOverlayImageIndex: Integer; override;
    function IsRelationshipManyEnd(AEntity: TEntity): Boolean;
    function IsValid: Boolean;
    function IsValidatable: Boolean; override;
    procedure SetType(const Value: TAssociationType);

    property Entity1: TEntity read GetEntity1 write SetEntity1;
    property Entity2: TEntity read GetEntity2 write SetEntity2;
  published
    property &Type: TAssociationType read FType;
    property DeleteRule: TAssociationDeleteRule read FDeleteRule write SetDeleteRule default TAssociationDeleteRule.SetNULL;
    property End1: TAssociationEndOptions read FEnd1;
    property End2: TAssociationEndOptions read FEnd2;
  end;

  { TAssociations }

  TAssociations = class(TDataModelChilds)
  strict private
    function GetItem(Index: Integer): TAssociation;
  protected
    function AddNewChild: TNamedPersistent; override;
    function CreateUniqueName(const ABaseName: string): string; override;
    class function GetXmlNodeName: string; override;
  public
    function GetImageIndex: Integer; override;
    property Items[Index: Integer]: TAssociation read GetItem; default;
  end;

  { TInheritance }

  TInheritance = class(TNamedPersistent)
  strict private
    FDerivedEntity: TEntity;
    function GetType: TMapInheritanceType;
    function GetBaseEntity: TEntity;
  protected
    function GetBaseName: string; override;
    function GetDefaultName: string; override;
    function GetDisplayClassName: string; override;
  public
    constructor Create(AParent: TNamedPersistent; ADerivedEntity: TEntity); reintroduce; virtual;
    function CanDelete: Boolean; override;
    function GetImageIndex: Integer; override;
    property &Type: TMapInheritanceType read GetType;
    property BaseEntity: TEntity read GetBaseEntity;
    property DerivedEntity: TEntity read FDerivedEntity;
  end;

  { TInheritances }

  TInheritances = class(TDataModelChilds)
  private
    function GetItem(Index: Integer): TInheritance;
  protected
    function CreateUniqueName(const ABaseName: string): string; override;
    function GetBaseName: string; override;
  public
    procedure CheckDefaultNames;
    function FindInheritanceByDerivedEntity(AEntity: TEntity): TInheritance;
    function GetImageIndex: Integer; override;
    // store/restore
    procedure Restore(ANode: TdxXmlNode); override;
    procedure Store(AParentXmlNode: TdxXmlNode); override;

    property Items[Index: Integer]: TInheritance read GetItem; default;
  end;

  { TDataModel }

  TDataModel = class(TNamedPersistent)
  strict private
    FAssociations: TAssociations;
    FContextName: string;
    FEntities: TEntities;
    FCodeGeneratorEntityRegistrationType: TEntityRegistrationType;
    FInheritances: TInheritances;
    FIsContextNameAssigned: Boolean;
    procedure CreateSubclasses;
    procedure SetContextName(const Value: string);
    procedure UpdateDefaultContextName;
  protected
    function CanHaveChildren: Boolean; override;
    function CreateChildByNodeName(const AXmlNodeName: string): TNamedPersistent; override;
    procedure DoSetName(const Value: string); override;
    class function GetXmlNodeName: string; override;
    procedure RestoreProperties(ANode: TdxXmlNode); override;
    procedure SetDefaultProperties; override;
    procedure StoreProperties(ANode: TdxXmlNode); override;
  public
    constructor Create(AParent: TNamedPersistent); override;
    function AddAssociation: TAssociation;
    function AddEntity: TEntity;
    function AddInheritance(ADerivedEntity: TEntity): TInheritance;
    function FindAssociationByName(const AName: string): TAssociation;
    function FindEntityByName(const AName: string): TEntity;
    function GetImageIndex: Integer; override;
    procedure ResetProperties; override;
    property Associations: TAssociations read FAssociations;
    property Entities: TEntities read FEntities;
    property Inheritances: TInheritances read FInheritances;
  published
    property CodeGeneratorEntityRegistrationType: TEntityRegistrationType read FCodeGeneratorEntityRegistrationType write FCodeGeneratorEntityRegistrationType default TEntityRegistrationType.DeclarativeAttributes;
    property ContextName: string read FContextName write SetContextName;
  end;

function GetCollectionDefaultName(const AOppositeEntityName: string): string;
function GetAssociationDefaultName(const AEnity1Name, AEntity2Name: string): string;
function GetInheritanceDefaultName(const ADerivedEntityName, ABaseEntityName: string): string;

function GetItemClassByXmlNodeName(const ANodeName: string): TNamedPersistentClass;
function FindEntityByName(const AName: string): TEntity;
function GetDefaultEntityTypeName(const AEntityName: string): string;
function EMFDesigner: IEMFDesigner;
procedure RegisterEMFDesigner(AValue: IEMFDesigner);
procedure UnregisterEMFDesigner(AValue: IEMFDesigner);

function GetORMAncestor(AEntity: TEntity): TEntity;
function GetRootORMAncestor(AEntity: TEntity): TEntity;
function HasORMAncestor(AEntity: TEntity): Boolean;
function IsBaseORMAncestor(AEntity: TEntity): Boolean;

implementation

uses
  SysConst, dxEMFToolTypeToStrConverters, dxEMFToolConsts;

var
  NamedPersistentClasses: TDictionary<string, TNamedPersistentClass>;
  FEMFDesigner: TObject;

  NullableTypesDictionary: TDictionary<string, string>;
  NotNullableTypesDictionary: TDictionary<string, Byte>;

function GetNullableType(const ATypeName: string): string;
begin
  if not NullableTypesDictionary.TryGetValue(ATypeName, Result) then
    Result := Format('TdxNullableValue<%s>', [ATypeName]);
end;

function IsNotNullableType(const ATypeName: string): Boolean;
begin
  Result := NotNullableTypesDictionary.ContainsKey(ATypeName);
end;

function GetCollectionDefaultName(const AOppositeEntityName: string): string;
begin
  Result := Format('%s_%s', [AOppositeEntityName, 'Collection']);
end;

function GetAssociationDefaultName(const AEnity1Name, AEntity2Name: string): string;
begin
  Result := Format('%s_%s', [AEnity1Name, AEntity2Name]);
end;

function GetInheritanceDefaultName(const ADerivedEntityName, ABaseEntityName: string): string;
begin
  Result := Format('%s_%s', [ADerivedEntityName, ABaseEntityName]);
end;

function GetDefaultEntityTypeName(const AEntityName: string): string;
begin
  Result := 'T' + AEntityName;
end;

function GetItemClassByXmlNodeName(const ANodeName: string): TNamedPersistentClass;
begin
  if not NamedPersistentClasses.TryGetValue(ANodeName, Result) then
    Result := nil;
end;

function FindEntityByName(const AName: string): TEntity;
begin
  Result := EMFDesigner.Model.FindEntityByName(AName);
end;

function EMFDesigner: IEMFDesigner;
begin
  Supports(FEMFDesigner, IEMFDesigner, Result);
end;

procedure RegisterEMFDesigner(AValue: IEMFDesigner);
begin
  FEMFDesigner := AValue as TObject;
end;

procedure UnregisterEMFDesigner(AValue: IEMFDesigner);
begin
  FEMFDesigner := nil;
end;

function GetORMAncestor(AEntity: TEntity): TEntity;
begin
  if (AEntity.BaseEntity <> nil) and (AEntity.OptionsInheritance.MapInheritanceType <> TMapInheritanceType.None) then
    Result := AEntity.BaseEntity
  else
    Result := nil;
end;

function GetRootORMAncestor(AEntity: TEntity): TEntity;
begin
  Result := AEntity;
  while HasORMAncestor(Result) do
    Result := Result.BaseEntity;
end;

function HasORMAncestor(AEntity: TEntity): Boolean;
begin
  Result := GetORMAncestor(AEntity) <> nil;
end;

function IsBaseORMAncestor(AEntity: TEntity): Boolean;
var
  AItem: TNamedPersistent;
  ACurrentEntity: TEntity;
begin
  Result := False;
  if not HasORMAncestor(AEntity) then
    for AItem in EMFDesigner.Model.Entities.Children do
    begin
      ACurrentEntity := AItem as TEntity;
      if GetORMAncestor(ACurrentEntity) = AEntity then
      begin
        Result := True;
        Break;
      end;
    end;
end;

{ TNamedPersistent }

constructor TNamedPersistent.Create(AParent: TNamedPersistent);
begin
  inherited Create;
  FParent := AParent;
  SetDefaultProperties;
  if FParent <> nil then
    Parent.AddChild(Self);
  FChildren := TObjectList<TNamedPersistent>.Create;
  FListeners := TList<TNamedPersistent>.Create;
end;

destructor TNamedPersistent.Destroy;
begin
  FreeAndNil(FChildren);
  FreeAndNil(FListeners);
  inherited;
end;

function TNamedPersistent.Contains(AItem: TNamedPersistent; ARecursive: Boolean = True): Boolean;
var
  AChild: TNamedPersistent;
begin
  Result := FChildren.Contains(AItem);
  if not Result and ARecursive then
    for AChild in FChildren do
    begin
      Result := AChild.Contains(AItem);
      if Result then
        Break;
    end;
end;

procedure TNamedPersistent.Delete;
begin
  Parent.RemoveChild(Self);
end;

procedure TNamedPersistent.ResetProperties;
begin
  // need now only for persistent (not deletable) nodes like DataModel
end;

procedure TNamedPersistent.Restore(ANode: TdxXmlNode);
var
  I: Integer;
  AChildXmlNode: TdxXmlNode;
  AChild: TNamedPersistent;
begin
  RestoreProperties(ANode);
  if CanHaveChildren then
    for I := 0 to ANode.Count - 1 do
    begin
      AChildXmlNode := ANode.Items[I];
      AChild := CreateChildByNodeName(dxXMLStringToString(AChildXmlNode.Name));
      if AChild <> nil then
        AChild.Restore(AChildXmlNode);
    end;
end;

procedure TNamedPersistent.RestoreProperties(ANode: TdxXmlNode);
begin
  if not IsNamePermanent then
  begin
    FRestoreName := ANode.Attributes.GetValueAsString('Name', Name);
    Name := FRestoreName;
  end;
end;

procedure TNamedPersistent.StoreProperties(ANode: TdxXmlNode);
begin
  if not IsNamePermanent then
    ANode.Attributes.Add('Name').ValueAsString := Name;
end;

procedure TNamedPersistent.Store(AParentXmlNode: TdxXmlNode);
var
  AXmlNode: TdxXmlNode;
  AChild: TNamedPersistent;
begin
  AXmlNode := AParentXmlNode.AddChild(dxStringToXMLString(GetXmlNodeName));
  StoreProperties(AXmlNode);
  for AChild in FChildren do
    AChild.Store(AXmlNode);
end;

procedure TNamedPersistent.AddChild(AChild: TNamedPersistent);
begin
  Children.Add(AChild);
end;

procedure TNamedPersistent.AddListener(AListener: TNamedPersistent);
begin
  if FListeners.IndexOf(AListener) < 0 then
  begin
    FListeners.Add(AListener);
    AListener.AddListener(Self);
  end;
end;

function TNamedPersistent.AddNewChild: TNamedPersistent;
begin
  Result := nil;
end;

procedure TNamedPersistent.AfterConstruction;
begin
  inherited AfterConstruction;
  EMFDesigner.ItemAdded(Self);
end;

procedure TNamedPersistent.BeforeDestruction;
begin
//  EMFDesigner.ItemRemoved(Self);
  while FListeners.Count > 0 do
    FListeners[FListeners.Count - 1].ItemDeleting(Self);
  EMFDesigner.ItemRemoved(Self);  // diagram need notification after association and relation properties were removed
  inherited BeforeDestruction;
end;

function TNamedPersistent.CanDelete: Boolean;
begin
  Result := False;
end;

function TNamedPersistent.CanEditName: Boolean;
begin
  Result := not IsNamePermanent;
end;

function TNamedPersistent.CanHaveChildren: Boolean;
begin
  Result := False;
end;

procedure TNamedPersistent.CheckDefaultName;
begin
  if not IsNameAssigned then
  begin
    Name := GetDefaultName;
    IsNameAssigned := False;
  end;
end;

function TNamedPersistent.CreateChildByNodeName(const AXmlNodeName: string): TNamedPersistent;
begin
  Result := AddNewChild;  // check if node name valid
end;

function TNamedPersistent.CreateUniqueName(const ABaseName: string): string;
var
  I: Integer;
begin
  for I := 1 to MaxInt do
  begin
    Result := cxGenerateComponentName(nil, 'T' + ABaseName, '', '', I);  // method remove first 'T' letter !
    if IsNameUnique(Result) then
      Break;
  end;
end;

procedure TNamedPersistent.DoAfterRestore;
begin
end;

procedure TNamedPersistent.DoSetName(const Value: string);
begin
  if not IsNameValid(Value) then
    raise EEMFModelNameValidError.CreateFmt(SInvalidName, [Value, DisplayClassName]);
  if IsNameUnique(Value) then
    FName := Value
  else
    FName := CreateUniqueName(Value);
  EMFDesigner.ItemNameChanged(Self);
end;

procedure TNamedPersistent.ItemDeleting(AItem: TNamedPersistent);
begin
  RemoveListener(AItem);
end;

function TNamedPersistent.GetBaseName: string;
begin
  Result := GetXmlNodeName;
end;

function TNamedPersistent.FindChildByName(const AName: string): TNamedPersistent;
var
  AItem: TNamedPersistent;
begin
  Result := nil;
  for AItem in FChildren do
    if SameText(AItem.Name, AName) then
    begin
      Result := AItem;
      Break;
    end;
end;

function TNamedPersistent.GetDefaultName: string;
begin
  raise EEMFModelError.Create(SAbstractError);
end;

function TNamedPersistent.GetDisplayName: string;
begin
  Result := Name;
end;

function TNamedPersistent.GetDisplayClassName: string;
begin
  Result := ClassName;
end;

function TNamedPersistent.GetImageIndex: Integer;
begin
  Result := -1;
end;

function TNamedPersistent.GetOverlayImageIndex: Integer;
begin
  if IsValidatable and not Valid then
    Result := InvalidEntityOverlayImageIndex
  else
    Result := -1;
end;

class function TNamedPersistent.GetXmlNodeName: string;
begin
  raise EEMFModelError.Create(SAbstractError);
end;

function TNamedPersistent.IsValidatable: Boolean;
begin
  Result := False;
end;

function TNamedPersistent.IsNamePermanent: Boolean;
begin
  Result := False;
end;

function TNamedPersistent.IsNameUnique(const AName: string): Boolean;
var
  AChild: TNamedPersistent;
begin
  Result := True;
  if Parent <> nil then
    for AChild in Parent.Children do
    begin
      if (AChild <> Self) and SameText(AChild.Name, AName) then
      begin
        Result := False;
        Break;
      end;
    end;
end;

function TNamedPersistent.IsNameValid(const Value: string): Boolean;
begin
  Result := IsValidIdent(Value);
end;

function TNamedPersistent.IsPropertyVisible(const APropertyName: string): Boolean;
begin
  Result := True;
end;

procedure TNamedPersistent.RemoveChild(AChild: TNamedPersistent);
begin
  FChildren.Remove(AChild);
end;

procedure TNamedPersistent.PropertyChanged;
begin
  EMFDesigner.ItemPropertiesChanged(Self);
end;

procedure TNamedPersistent.RemoveListener(AListener: TNamedPersistent);
begin
  if FListeners.IndexOf(AListener) >= 0 then
  begin
    FListeners.Remove(AListener);
    AListener.RemoveListener(Self);
  end;
end;

procedure TNamedPersistent.SetDefaultProperties;
begin
  FName := CreateUniqueName(GetBaseName);
end;

procedure TNamedPersistent.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FIsNameAssigned := True;
    DoSetName(Value);
  end;
end;

constructor TEntityProperty.Create(AParent: TNamedPersistent);
begin
  inherited Create(AParent);
  FPrecision := 15;
end;

destructor TEntityProperty.Destroy;
begin
  FreeAndNil(FDataTypeOptions);
  inherited;
end;

procedure TEntityProperty.Assign(Source: TPersistent);
begin
  if Source is TEntityProperty then
  begin
    ColumnDataType := TEntityProperty(Source).ColumnDataType;
    ColumnName := TEntityProperty(Source).ColumnName;
    DataTypeOptions := TEntityProperty(Source).DataTypeOptions;
    DefaultValue := TEntityProperty(Source).DefaultValue;
    DisplayFormat := TEntityProperty(Source).DisplayFormat;
    DisplayLabel := TEntityProperty(Source).DisplayLabel;
    DisplayWidth := TEntityProperty(Source).DisplayWidth;
    EditFormat := TEntityProperty(Source).EditFormat;
    EditMask := TEntityProperty(Source).EditMask;
    IdGenerator := TEntityProperty(Source).IdGenerator;
    LookupResultField := TEntityProperty(Source).LookupResultField;
    MaxLength := TEntityProperty(Source).MaxLength;
    MaxValue := TEntityProperty(Source).MaxValue;
    MinValue := TEntityProperty(Source).MinValue;
    Options := TEntityProperty(Source).Options;
    Precision := TEntityProperty(Source).Precision;
    SequenceName := TEntityProperty(Source).SequenceName;
  end;
end;

function TEntityProperty.CanDelete: Boolean;
begin
  Result := True;
end;

procedure TEntityProperty.CreateDataTypeOptions;
begin
  FDataTypeOptions := TEntityPropertyDataTypeOptions.Create(Self);
end;

procedure TEntityProperty.DoAfterRestore;
begin
  DoAfterRestoreAllEntities;
end;

procedure TEntityProperty.DoAfterRestoreAllEntities;
begin
  if FReferenceEntityRestoreName <> '' then
  begin
    DataTypeOptions.Entity := FindEntityByName(FReferenceEntityRestoreName);
    FReferenceEntityRestoreName := '';
  end;
end;

function TEntityProperty.GetDataType: string;

  function IsDataTypeEntity: Boolean;
  var
    I: Integer;
  begin
    for I := 0 to Parent.Parent.Children.Count - 1 do
      if SameText(TEntity(Parent.Parent.Children[I]).DataType, DataTypeOptions.GetDataType) then
        Exit(True);
    Result := False;
  end;

begin
  Result := DataTypeOptions.GetDataType;
  if (TEntityPropertyOption.Nullable in FOptions) and not IsNotNullableType(Result) then
  begin
    if not IsDataTypeEntity then
      Result := GetNullableType(Result);
  end;
end;

function TEntityProperty.GetImageIndex: Integer;
begin
  if TEntityPropertyOption.PrimaryKey in Options then
    Result := EntityKeyPropertyImageIndex
  else
    Result := EntityPropertyImageIndex;
end;

function TEntityProperty.GetOverlayImageIndex: Integer;
begin
  if AssociationEnd <> nil then
  begin
    if AssociationEnd.Association.Entity1 = AssociationEnd.Association.Entity2 then
      Result := AssociationSelfToSelfOverlayImageIndex
    else
      Result := AssociationOverlayImageIndex;
  end
  else
    Result := inherited GetOverlayImageIndex;
end;

class function TEntityProperty.GetXmlNodeName: string;
begin
  Result := 'Property';
end;

function TEntityProperty.IsPropertyVisible(const APropertyName: string): Boolean;

  function IsVisibleForReferenceProperty(const APropertyName: string): Boolean;
  const
    ANotReferenceProperty: array [0..3] of string = ('DataTypeOptions', 'MaxLength', 'IdGenerator', 'DefaultValue');
  var
    I: Integer;
  begin
    Result := True;
    for I := 0 to High(ANotReferenceProperty) do
      if SameText(APropertyName, ANotReferenceProperty[I]) then
      begin
        Result := False;
        Break;
      end;
  end;

begin
  Result := inherited IsPropertyVisible(APropertyName);
  if Result then
  begin
    if AssociationEnd <> nil then
      Result := IsVisibleForReferenceProperty(APropertyName)
    else
      if SameText(APropertyName, 'SequenceName') then
        Result := (TEntityPropertyOption.PrimaryKey in FOptions) and (IdGenerator = TdxGeneratorType.Sequence)
      else
        Result := (TEntityPropertyOption.PrimaryKey in FOptions) or not SameText(APropertyName, 'IdGenerator');
  end;
end;

procedure TEntityProperty.ItemDeleting(AItem: TNamedPersistent);
begin
  inherited ItemDeleting(AItem);
  if (AssociationEnd <> nil) and (AssociationEnd.Association = AItem) then
    SetAssociationEnd(nil)
  else
    if DataTypeOptions.Entity = AItem then
      DataTypeOptions.Entity := nil;
end;

procedure TEntityProperty.RestoreProperties(ANode: TdxXmlNode);
var
  AGenerator: TdxGeneratorType;
  AGeneratorStr: string;
  AOptions: TEntityPropertyOptions;
  APropertyOption: TEntityPropertyOption;
begin
  inherited RestoreProperties(ANode);
  ColumnDataType := ANode.Attributes.GetValueAsString('ColumnDataType', ColumnDataType);
  ColumnName := ANode.Attributes.GetValueAsString('ColumnName', ColumnName);

  DataTypeOptions.DataType := ANode.Attributes.GetValueAsString('DataType', DataTypeOptions.DataType);
  FReferenceEntityRestoreName := ANode.Attributes.GetValueAsString('Entity');

  DefaultValue := ANode.Attributes.GetValueAsString('DefaultValue', DefaultValue);
  AGeneratorStr := ANode.Attributes.GetValueAsString('GeneratorType');
  for AGenerator := Low(TdxGeneratorType) to High(TdxGeneratorType) do
    if SameText(GeneratorTypeToStr[AGenerator], AGeneratorStr) then
    begin
      IdGenerator := AGenerator;
      Break;
    end;
  SequenceName := ANode.Attributes.GetValueAsString('SequenceName', SequenceName);
  MaxLength := ANode.Attributes.GetValueAsInteger('MaxLength', MaxLength);

  for APropertyOption := Low(TEntityPropertyOption) to High(TEntityPropertyOption) do
    if ANode.Attributes.GetValueAsBoolean(dxStringToXMLString(EntityPropertyOptionToString[APropertyOption])) then
      Include(AOptions, APropertyOption);
  Options := AOptions;

  DisplayFormat := ANode.Attributes.GetValueAsString('DisplayFormat', DisplayFormat);
  DisplayLabel := ANode.Attributes.GetValueAsString('DisplayLabel', DisplayLabel);
  DisplayWidth := ANode.Attributes.GetValueAsInteger('DisplayWidth', DisplayWidth);
  EditFormat := ANode.Attributes.GetValueAsString('EditFormat', EditFormat);
  EditMask := ANode.Attributes.GetValueAsString('EditMask', EditMask);
  LookupResultField := ANode.Attributes.GetValueAsString('LookupResultField', LookupResultField);
  MaxValue := ANode.Attributes.GetValueAsFloat('MaxValue', MaxValue);
  MinValue := ANode.Attributes.GetValueAsFloat('MinValue', MinValue);
  Precision := ANode.Attributes.GetValueAsInteger('Precision', Precision);

  if SameText(Parent.RestoreName, FReferenceEntityRestoreName) then
    FReferenceEntityRestoreName := Parent.Name;
end;

procedure TEntityProperty.SetAssociationEnd(AValue: TAssociationEndOptions);
begin
  if AssociationEnd <> AValue then
  begin
    if AssociationEnd <> nil then
      RemoveListener(AssociationEnd.Association);
    FAssociationEnd := AValue;
    if AssociationEnd <> nil then
      AddListener(AssociationEnd.Association);
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetColumnDataType(const Value: string);
begin
  if FColumnDataType <> Value then
  begin
    FColumnDataType := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.StoreProperties(ANode: TdxXmlNode);
var
  APropertyOption: TEntityPropertyOption;
begin
  inherited StoreProperties(ANode);
  if ColumnDataType <> '' then
    ANode.Attributes.Add('ColumnDataType').ValueAsString := ColumnDataType;
  if ColumnName <> '' then
    ANode.Attributes.Add('ColumnName').ValueAsString := ColumnName;

  if not SameText(DataTypeOptions.DataType, 'string') then
    ANode.Attributes.Add('DataType').ValueAsString := DataTypeOptions.DataType;
  if DataTypeOptions.Entity <> nil then
    ANode.Attributes.Add('Entity').ValueAsString := DataTypeOptions.Entity.Name;

  if DefaultValue <> '' then
    ANode.Attributes.Add('DefaultValue').ValueAsString := DefaultValue;
  if IdGenerator <> TdxGeneratorType.None then
    ANode.Attributes.Add('GeneratorType').ValueAsString := GeneratorTypeToStr[IdGenerator];
  if SequenceName <> '' then
    ANode.Attributes.Add('SequenceName').ValueAsString := SequenceName;
  if MaxLength <> 0 then
    ANode.Attributes.Add('MaxLength').ValueAsInteger := MaxLength;

  for APropertyOption := Low(TEntityPropertyOption) to High(TEntityPropertyOption) do
    if APropertyOption in FOptions then
      ANode.Attributes.Add(dxStringToXMLString(EntityPropertyOptionToString[APropertyOption])).ValueAsBoolean := True;

  if DisplayFormat <> '' then
    ANode.Attributes.Add('DisplayFormat').ValueAsString := DisplayFormat;
  if DisplayLabel <> '' then
    ANode.Attributes.Add('DisplayLabel').ValueAsString := DisplayLabel;
  if DisplayWidth <> 0 then
    ANode.Attributes.Add('DisplayWidth').ValueAsInteger := DisplayWidth;
  if EditFormat <> '' then
    ANode.Attributes.Add('EditFormat').ValueAsString := EditFormat;
  if EditMask <> '' then
    ANode.Attributes.Add('EditMask').ValueAsString := EditMask;
  if LookupResultField <> '' then
    ANode.Attributes.Add('LookupResultField').ValueAsString := LookupResultField;
  if MaxValue <> 0 then
    ANode.Attributes.Add('MaxValue').ValueAsFloat := MaxValue;
  if MinValue <> 0 then
    ANode.Attributes.Add('MinValue').ValueAsFloat := MinValue;
  if Precision <> 15 then
    ANode.Attributes.Add('Precision').ValueAsInteger := Precision;
end;

procedure TEntityProperty.SetColumnName(const Value: string);
begin
  if FColumnName <> Value then
  begin
    FColumnName := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetDataTypeOptions(const Value: TEntityPropertyDataTypeOptions);
begin
  FDataTypeOptions.Assign(Value);
end;

procedure TEntityProperty.SetDefaultProperties;
begin
  inherited SetDefaultProperties;
  CreateDataTypeOptions;
end;

procedure TEntityProperty.SetDefaultValue(const Value: string);
begin
  if FDefaultValue <> Value then
  begin
    FDefaultValue := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetDisplayFormat(const Value: string);
begin
  if FDisplayFormat <> Value then
  begin
    FDisplayFormat := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetDisplayLabel(const Value: string);
begin
  if FDisplayLabel <> Value then
  begin
    FDisplayLabel := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetDisplayWidth(const Value: Integer);
begin
  if FDisplayWidth <> Value then
  begin
    FDisplayWidth := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetEditFormat(const Value: string);
begin
  if FEditFormat <> Value then
  begin
    FEditFormat := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetEditMask(const Value: string);
begin
  if FEditMask <> Value then
  begin
    FEditMask := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetIdGenerator(const Value: TdxGeneratorType);
begin
  if FIdGenerator <> Value then
  begin
    FIdGenerator := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetLookupResultField(const Value: string);
begin
  if FLookupResultField <> Value then
  begin
    FLookupResultField := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetMaxLength(const Value: Integer);
begin
  if FMaxLength <> Value then
  begin
    FMaxLength := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetMaxValue(const Value: Double);
begin
  if FMaxValue <> Value then
  begin
    FMaxValue := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetMinValue(const Value: Double);
begin
  if FMinValue <> Value then
  begin
    FMinValue := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetOptions(const Value: TEntityPropertyOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetPrecision(const Value: Integer);
begin
  if FPrecision <> Value then
  begin
    FPrecision := Value;
    PropertyChanged;
  end;
end;

procedure TEntityProperty.SetSequenceName(const Value: string);
begin
  if FSequenceName <> Value then
  begin
    FSequenceName := Value;
    PropertyChanged;
  end;
end;

{ TEntity }

constructor TEntity.Create(AParent: TNamedPersistent);
begin
  inherited Create(AParent);
  FOptionsInheritance := TOptionsInheritance.Create(Self);
  FIndexes := TStringList.Create;
  FDataType := GetDefaultDataType;
end;

destructor TEntity.Destroy;
begin
  BaseEntity := nil; // delete inheritance object if exists
  FreeAndNil(FIndexes);
  FreeAndNil(FOptionsInheritance);
  inherited Destroy;
end;

function TEntity.AddProperty: TEntityProperty;
begin
  Result := AddNewChild as TEntityProperty;
end;

function TEntity.AddRelationProperty(AAssociationEnd: TAssociationEndOptions): TEntityRelationshipProperty;
begin
  Result := TEntityRelationshipProperty.Create(Self, AAssociationEnd);
end;

function TEntity.AddNewChild: TNamedPersistent;
begin
  Result := TEntityProperty.Create(Self);
end;

function TEntity.CanDelete: Boolean;
begin
  Result := True;
end;

function TEntity.GetImageIndex: Integer;
begin
  Result := EntityImageIndex;
end;

function TEntity.HasPrimaryKey: Boolean;
var
  AItem: TNamedPersistent;
  AEntityProperty: TEntityProperty;
begin
  Result := False;
  for AItem in Children do
    if AItem is TEntityProperty then
    begin
      AEntityProperty := TEntityProperty(AItem);
      if TEntityPropertyOption.PrimaryKey in AEntityProperty.Options then
      begin
        Result := True;
        Break;
      end;
    end;
end;

function TEntity.IsInheritedFrom(AEntity: TEntity): Boolean;
begin
  if BaseEntity <> nil then
    Result := (BaseEntity = AEntity) or BaseEntity.IsInheritedFrom(AEntity)
  else
    Result := False;
end;

function TEntity.CanHaveChildren: Boolean;
begin
  Result := True;
end;

procedure TEntity.RecreateInheritance;
var
  AInheritance: TInheritance;
begin
  AInheritance := EMFDesigner.Model.Inheritances.FindInheritanceByDerivedEntity(Self);
  if (AInheritance <> nil) and (BaseEntity = nil) then
    EMFDesigner.DeleteObject(AInheritance);
  if BaseEntity <> nil then
  begin
    if AInheritance = nil then
      EMFDesigner.Model.AddInheritance(Self)
    else
      AInheritance.CheckDefaultName;
    EMFDesigner.SelectObject(Self);
  end;
end;

function TEntity.CreateChildByNodeName(const AXmlNodeName: string): TNamedPersistent;
begin
  if SameText(AXmlNodeName, TEntityProperty.GetXmlNodeName) then
    Result := inherited CreateChildByNodeName(AXmlNodeName)
  else
    Result := nil;
end;

procedure TEntity.DoAfterRestore;
begin
  DoAfterRestoreAllEntities;
end;

procedure TEntity.DoSetName(const Value: string);
var
  AItem: TNamedPersistent;
  AEntityProperty: TCustomEntityProperty;
  AAssociation: TAssociation;
  AAssociationEnd: TAssociationEndOptions;
begin
  inherited DoSetName(Value);
  if not FDataTypeAssigned then
    DataType := GetDefaultDataType;
  for AItem in Children do
  begin
    AEntityProperty := AItem as TCustomEntityProperty;
    AAssociationEnd := AEntityProperty.AssociationEnd;
    if AAssociationEnd <> nil then
    begin
      AAssociation := AAssociationEnd.Association;
      AAssociation.CheckDefaultName;
      AAssociationEnd.CheckDefaultName;
      AAssociationEnd.GetOppositeEnd.CheckDefaultName;
    end;
  end;
//  EMFDesigner.Model.Associations.CheckDefaultNames;
  EMFDesigner.Model.Inheritances.CheckDefaultNames;
end;

function TEntity.GetDefaultDataType: string;
begin
  Result := GetDefaultEntityTypeName(Name);
end;

function TEntity.GetDisplayName: string;
begin
  Result := Name;
  if BaseEntity <> nil then
    Result := Format('%s(%s)', [Result, BaseEntity.Name]);
end;

function TEntity.GetRelationProperty(AAssociation: TAssociation): TEntityRelationshipProperty;
var
  I: Integer;
begin
  Result := nil;
  for I := Children.Count - 1 downto 0 do
    if Children[I] is TEntityRelationshipProperty then
      if TEntityRelationshipProperty(Children[I]).AssociationEnd.Association = AAssociation then
      begin
        Result := TEntityRelationshipProperty(Children[I]);
        Break;
      end;
end;

class function TEntity.GetXmlNodeName: string;
begin
  Result := 'Entity';
end;

function TEntity.IsValidatable: Boolean;
begin
  Result := True;
end;

procedure TEntity.RemoveRelationProperty(AAssociation: TAssociation);
var
  AProperty: TEntityRelationshipProperty;
begin
  AProperty := GetRelationProperty(AAssociation);
  if AProperty <> nil then
    EMFDesigner.DeleteObject(AProperty);
end;

procedure TEntity.ItemDeleting(AItem: TNamedPersistent);
begin
  inherited ItemDeleting(AItem);
  if AItem is TAssociation then
    RemoveRelationProperty(TAssociation(AItem))
  else
    if BaseEntity = AItem then
      BaseEntity := nil
    else
      if (AItem is TInheritance) and
        (TInheritance(AItem).BaseEntity = BaseEntity) then
        BaseEntity := nil;
end;

procedure TEntity.DoAfterRestoreAllEntities;
var
  I: Integer;
begin
  if FBaseEntityRestoreName <> '' then
  begin
    BaseEntity := FindEntityByName(FBaseEntityRestoreName);
    FBaseEntityRestoreName := '';
  end;
  for I := 0 to Children.Count - 1 do
    if Children[I] is TEntityProperty then
      TEntityProperty(Children[I]).DoAfterRestoreAllEntities;
end;

function TEntity.GetDisplayClassName: string;
begin
  Result := 'entity';
end;

procedure TEntity.RestoreProperties(ANode: TdxXmlNode);
var
  ASubNode, AChildNode: TdxXmlNode;
  I: Integer;
  ADiscriminatorType: TdxDiscriminatorType;
  ADiscriminatorTypeStr: string;
  AInheritanceTypeStr: string;
  AInheritanceType: TMapInheritanceType;
begin
  inherited RestoreProperties(ANode);
  if ANode.FindChild('Indexes', ASubNode) then
    for I := 0 to ASubNode.Count - 1 do
    begin
      AChildNode := ASubNode[I];
      if SameText(dxXMLStringToString(AChildNode.Name), 'Index') then
        FIndexes.Add(dxXMLStringToString(AChildNode.Text));
    end;
  SchemaName := ANode.Attributes.GetValueAsString('SchemaName', SchemaName);
  TableName := ANode.Attributes.GetValueAsString('TableName', TableName);
  DataType := ANode.Attributes.GetValueAsString('DataType', GetDefaultDataType);
  OptionsInheritance.DiscriminatorValue := ANode.Attributes.GetValueAsString('DiscriminatorValue', OptionsInheritance.DiscriminatorValue);
  ADiscriminatorTypeStr := ANode.Attributes.GetValueAsString('DiscriminatorType');
  for ADiscriminatorType := Low(TdxDiscriminatorType) to High(TdxDiscriminatorType) do
    if SameText(DiscriminatorTypeToStr[ADiscriminatorType], ADiscriminatorTypeStr) then
    begin
      OptionsInheritance.DiscriminatorType := ADiscriminatorType;
      Break;
    end;
  OptionsInheritance.DiscriminatorColumnName := ANode.Attributes.GetValueAsString('DiscriminatorColumnName',
    OptionsInheritance.DiscriminatorColumnName);
  OptionsInheritance.DiscriminatorColumnSize := ANode.Attributes.GetValueAsInteger('DiscriminatorColumnSize',
    OptionsInheritance.DiscriminatorColumnSize);
  AInheritanceTypeStr := ANode.Attributes.GetValueAsString('MapInheritanceType');
  for AInheritanceType := Low(TMapInheritanceType) to High(TMapInheritanceType) do
    if SameText(MapInheritanceTypeToStr[AInheritanceType], AInheritanceTypeStr) then
    begin
      OptionsInheritance.MapInheritanceType := AInheritanceType;
      Break;
    end;
  FBaseEntityRestoreName := ANode.Attributes.GetValueAsString('BaseEntity');
end;

procedure TEntity.SetIndexes(Value: TStrings);
begin
  FIndexes.Assign(Value);
end;

procedure TEntity.SetBaseEntity(const Value: TEntity);
begin
  if FBaseEntity <> Value then
  begin
    if FBaseEntity <> nil then
      RemoveListener(FBaseEntity);
    FBaseEntity := Value;
    if FBaseEntity <> nil then
      AddListener(FBaseEntity);
    RecreateInheritance;
    EMFDesigner.ItemNameChanged(Self);
  end;
end;

procedure TEntity.SetDataType(const Value: string);
begin
  if FDataType <> Value then
  begin
    FDataType := Value;
    FDataTypeAssigned := not SameText(FDataType, GetDefaultDataType);
    PropertyChanged;
  end;
end;

procedure TEntity.SetOptionsInheritance(const Value: TOptionsInheritance);
begin
  FOptionsInheritance.Assign(Value);
end;

procedure TEntity.SetSchemaName(const Value: string);
begin
  if FSchemaName <> Value then
  begin
    FSchemaName := Value;
    PropertyChanged;
  end;
end;

procedure TEntity.SetTableName(const Value: string);
begin
  if FTableName <> Value then
  begin
    FTableName := Value;
    PropertyChanged;
  end;
end;

procedure TEntity.StoreProperties(ANode: TdxXmlNode);
var
  ASubNode, AChildNode: TdxXmlNode;
  I: Integer;
begin
  inherited StoreProperties(ANode);
  if FIndexes.Count > 0 then
  begin
    ASubNode := ANode.AddChild('Indexes');
    for I := 0 to FIndexes.Count - 1 do
    begin
      AChildNode := ASubNode.AddChild('Index');
      AChildNode.Text := dxStringToXMLString(FIndexes[I]);
    end;
  end;
  if not SameText(FDataType, GetDefaultDataType) then
    ANode.Attributes.Add('DataType').ValueAsString := DataType;
  if SchemaName <> '' then
    ANode.Attributes.Add('SchemaName').ValueAsString := SchemaName;
  if TableName <> '' then
    ANode.Attributes.Add('TableName').ValueAsString := TableName;
  if OptionsInheritance.DiscriminatorValue <> '' then
    ANode.Attributes.Add('DiscriminatorValue').ValueAsString := OptionsInheritance.DiscriminatorValue;
  if OptionsInheritance.DiscriminatorType <> TdxDiscriminatorType.String then
    ANode.Attributes.Add('DiscriminatorType').ValueAsString := DiscriminatorTypeToStr[OptionsInheritance.DiscriminatorType];
  if OptionsInheritance.DiscriminatorColumnName <> '' then
    ANode.Attributes.Add('DiscriminatorColumnName').ValueAsString := OptionsInheritance.DiscriminatorColumnName;
  if OptionsInheritance.DiscriminatorColumnSize > 0 then
    ANode.Attributes.Add('DiscriminatorColumnSize').ValueAsInteger := OptionsInheritance.DiscriminatorColumnSize;
  if OptionsInheritance.MapInheritanceType <> TMapInheritanceType.None then
    ANode.Attributes.Add('MapInheritanceType').ValueAsString := MapInheritanceTypeToStr[OptionsInheritance.MapInheritanceType];
  if BaseEntity <> nil then
    ANode.Attributes.Add('BaseEntity').ValueAsString := BaseEntity.Name;
end;

{ TDataModelChilds }

function TDataModelChilds.CanHaveChildren: Boolean;
begin
  Result := True;
end;

function TDataModelChilds.GetCount: Integer;
begin
  Result := Children.Count;
end;

function TDataModelChilds.GetName: string;
begin
  Result := inherited Name;
end;

function TDataModelChilds.IsNamePermanent: Boolean;
begin
  Result := True;
end;

{ TDataModel }

constructor TDataModel.Create(AParent: TNamedPersistent);
begin
  inherited Create(AParent);
  CreateSubclasses;
  UpdateDefaultContextName;
end;

function TDataModel.AddAssociation: TAssociation;
begin
  Result := FAssociations.AddNewChild as TAssociation;
end;

function TDataModel.AddEntity: TEntity;
begin
  Result := FEntities.AddNewChild as TEntity;
end;

function TDataModel.AddInheritance(ADerivedEntity: TEntity): TInheritance;
begin
  Result := TInheritance.Create(Inheritances, ADerivedEntity);
end;

function TDataModel.FindAssociationByName(const AName: string): TAssociation;
begin
  Result := FAssociations.FindChildByName(AName) as TAssociation;
end;

function TDataModel.FindEntityByName(const AName: string): TEntity;
begin
  Result := FEntities.FindChildByName(AName) as TEntity;
end;

function TDataModel.GetImageIndex: Integer;
begin
  Result := DataModelImageIndex;
end;

function TDataModel.CanHaveChildren: Boolean;
begin
  Result := True;
end;

function TDataModel.CreateChildByNodeName(const AXmlNodeName: string): TNamedPersistent;
begin
  if SameText(AXmlNodeName, 'Entities') then
    Result := FEntities
  else
    if SameText(AXmlNodeName, 'Associations') then
      Result := FAssociations
    else
      Result := inherited CreateChildByNodeName(AXmlNodeName);
end;

procedure TDataModel.CreateSubclasses;
begin
  FEntities := TEntities.Create(Self);
  FAssociations := TAssociations.Create(Self);
  FInheritances := TInheritances.Create(Self);
end;

procedure TDataModel.DoSetName(const Value: string);
begin
  inherited DoSetName(Value);
  UpdateDefaultContextName;
end;

class function TDataModel.GetXmlNodeName: string;
begin
  Result := 'DataModel';
end;

procedure TDataModel.ResetProperties;
begin
  SetDefaultProperties;
  UpdateDefaultContextName;
end;

procedure TDataModel.RestoreProperties(ANode: TdxXmlNode);
var
  AModelType: TEntityRegistrationType;
  AModelTypeStr: string;
begin
  inherited RestoreProperties(ANode);
  ContextName := ANode.Attributes.GetValueAsString('ContextName', ContextName);
  AModelTypeStr := ANode.Attributes.GetValueAsString('CodeGeneratorEntityRegistrationType');
  for AModelType := Low(TEntityRegistrationType) to High(TEntityRegistrationType) do
    if SameText(CodeGeneratorEntityRegistrationTypeToStr[AModelType], AModelTypeStr) then
    begin
      CodeGeneratorEntityRegistrationType := AModelType;
      Break;
    end;
end;

procedure TDataModel.SetContextName(const Value: string);
begin
  if FContextName <> Value then
  begin
    FIsContextNameAssigned := True;
    FContextName := Value;
    PropertyChanged;
  end;
end;

procedure TDataModel.SetDefaultProperties;
begin
  inherited SetDefaultProperties;
  FCodeGeneratorEntityRegistrationType := TEntityRegistrationType.DeclarativeAttributes;
end;

procedure TDataModel.StoreProperties(ANode: TdxXmlNode);
begin
  inherited StoreProperties(ANode);
  if ContextName <> '' then
    ANode.Attributes.Add('ContextName').ValueAsString := ContextName;
  ANode.Attributes.Add('CodeGeneratorEntityRegistrationType').ValueAsString := CodeGeneratorEntityRegistrationTypeToStr[FCodeGeneratorEntityRegistrationType];
end;

procedure TDataModel.UpdateDefaultContextName;
begin
  if not FIsContextNameAssigned then
  begin
    ContextName := Name + 'Context';
    FIsContextNameAssigned := False;
  end;
end;

{ TEntities }

function TEntities.GetImageIndex: Integer;
begin
  Result := EntitiesImageIndex;
end;

function TEntities.AddNewChild: TNamedPersistent;
begin
  Result := TEntity.Create(Self);
end;

function TEntities.CreateUniqueName(const ABaseName: string): string;
begin
  Result := 'Entities';
end;

function TEntities.GetItem(Index: Integer): TEntity;
begin
  Result := TEntity(Children[Index]);
end;

class function TEntities.GetXmlNodeName: string;
begin
  Result := 'Entities';
end;

procedure TEntities.Restore(ANode: TdxXmlNode);
var
  I: Integer;
begin
  inherited Restore(ANode);
  for I := 0 to Count - 1 do
    Items[I].DoAfterRestoreAllEntities;
end;

{ TAssociations }

constructor TAssociation.Create(AParent: TNamedPersistent);
begin
  inherited Create(AParent);
  FEnd2 := TAssociationOneEndOptions.Create(Self);
  FType := TAssociationType.OneToMany;
  RecreateAssociationEnd1;
end;

destructor TAssociation.Destroy;
begin
  FreeAndNil(FEnd2);
  FreeAndNil(FEnd1);
  inherited Destroy;
end;

function TAssociations.GetImageIndex: Integer;
begin
  Result := AssociationsImageIndex;
end;

function TAssociations.AddNewChild: TNamedPersistent;
begin
  Result := TAssociation.Create(Self);
end;

function TAssociations.CreateUniqueName(const ABaseName: string): string;
begin
  Result := 'Associations';
end;

function TAssociations.GetItem(Index: Integer): TAssociation;
begin
  Result := TAssociation(Children[Index]);
end;

class function TAssociations.GetXmlNodeName: string;
begin
  Result := 'Associations';
end;

procedure TAssociation.AddRelationProperty;
begin
  if IsValid then
  begin
    if End2 is TAssociationManyEndOptions then
      Entity2.AddRelationProperty(End2);
    if End1 is TAssociationManyEndOptions then
      Entity1.AddRelationProperty(End1);
    End1.CheckDefaultName;
    End2.CheckDefaultName;
    EMFDesigner.SelectObject(Self);
  end;
end;

function TAssociation.GetDefaultName: string;

  function GetEntityName(AEntity: TEntity): string;
  begin
    if AEntity <> nil then
      Result := AEntity.Name
    else
      Result := '';
  end;

begin
  if (Entity1 = nil) and (Entity2 = nil) then
    Result := CreateUniqueName(GetBaseName)
  else
    Result := GetAssociationDefaultName(GetEntityName(Entity1), GetEntityName(Entity2));
end;

function TAssociation.CanDelete: Boolean;
begin
  Result := True;
end;

function TAssociation.GetDisplayClassName: string;
begin
  Result := 'association';
end;

function TAssociation.GetEntity1: TEntity;
begin
  Result := nil;
  if End1 <> nil then
    Result := End1.Entity;
end;

function TAssociation.GetEntity2: TEntity;
begin
  Result := nil;
  if End2 <> nil then
    Result := End2.Entity;
end;

function TAssociation.GetImageIndex: Integer;
begin
  if &Type = TAssociationType.OneToOne then
    Result := AssociationsImageIndex
  else
    Result := AssociationImageIndex;
end;

function TAssociation.GetOppositeEnd(AEnd: TAssociationEndOptions): TAssociationEndOptions;
begin
  if AEnd = End1 then
    Result := End2
  else
    Result := End1;
end;

function TAssociation.GetOppositeEndEntity(AEntity: TEntity): TEntity;
begin
  if AEntity = Entity1 then
    Result := Entity2
  else
    Result := Entity1;
end;

function TAssociation.GetOverlayImageIndex: Integer;
begin
  if Entity1 = Entity2 then
    Result := AssociationSelfToSelfOverlayImageIndex
  else
    Result := inherited GetOverlayImageIndex;
end;

class function TAssociation.GetXmlNodeName: string;
begin
  Result := 'Association';
end;

function TAssociation.IsRelationshipManyEnd(AEntity: TEntity): Boolean;
begin
  Result := (AEntity = Entity1) and (&Type = TAssociationType.OneToMany);
end;

function TAssociation.IsValid: Boolean;
begin
  Result := (Entity1 <> nil) and (Entity2 <> nil);
end;

function TAssociation.IsValidatable: Boolean;
begin
  Result := True;
end;

procedure TAssociation.ItemDeleting(AItem: TNamedPersistent);
begin
  inherited ItemDeleting(AItem);
  if (Entity1 = AItem) or (Entity2 = AItem) then
  begin
    if Entity1 = AItem then
      Entity1 := nil;
    if Entity2 = AItem then
      Entity2 := nil;
    EMFDesigner.DeleteObject(Self);
  end
  else
  begin
    if (End1 is TAssociationOneEndOptions) and
      (AItem = TAssociationOneEndOptions(End1).ReferenceProperty) or
      (End2 is TAssociationOneEndOptions) and
      (AItem = TAssociationOneEndOptions(End2).ReferenceProperty) then
      EMFDesigner.DeleteObject(Self);
  end;
end;

procedure TAssociation.RecreateAssociationEnd1;
begin
  Entity1 := nil;
  FreeAndNil(FEnd1);
  if &Type = TAssociationType.OneToOne then
    FEnd1 := TAssociationOneEndOptions.Create(Self)
  else
    FEnd1 := TAssociationManyEndOptions.Create(Self);
end;

procedure TAssociation.RemoveRelationProperty;
begin
  if Entity2 <> nil then
    Entity2.RemoveRelationProperty(Self);
  if Entity1 <> nil then
    Entity1.RemoveRelationProperty(Self);
end;

procedure TAssociation.RestoreProperties(ANode: TdxXmlNode);
var
  AAssociationType: TAssociationType;
  AAssociationTypeStr: string;
  AEntityName: string;
  ADeleteRule: TAssociationDeleteRule;
  ADeleteRuleStr: string;
  ARelationshipPropertyName, AReferencePropertyName: string;
begin
  inherited RestoreProperties(ANode);
  AAssociationTypeStr := ANode.Attributes.GetValueAsString('Type');
  for AAssociationType := Low(TAssociationType) to High(TAssociationType) do
    if SameText(AssociationTypeToString[AAssociationType], AAssociationTypeStr) then
    begin
      SetType(AAssociationType);
      Break;
    end;

  AEntityName := ANode.Attributes.GetValueAsString('Entity1');
  Entity1 := FindEntityByName(AEntityName);
  AEntityName := ANode.Attributes.GetValueAsString('Entity2');
  Entity2 := FindEntityByName(AEntityName);

  ADeleteRuleStr := ANode.Attributes.GetValueAsString('AssociationDeleteRule');
  for ADeleteRule := Low(TAssociationDeleteRule) to High(TAssociationDeleteRule) do
    if SameText(DeleteRuleToString[ADeleteRule], ADeleteRuleStr) then
    begin
      DeleteRule := ADeleteRule;
      Break;
    end;
  if End1 is TAssociationManyEndOptions then
  begin
    ARelationshipPropertyName := ANode.Attributes.GetValueAsString('Entity1CollectionPropertyName');
    if ARelationshipPropertyName <> '' then
      TAssociationManyEndOptions(End1).CollectionPropertyName := ARelationshipPropertyName;
  end
  else
  begin
    AReferencePropertyName := ANode.Attributes.GetValueAsString('Entity1RefrenceProperty');
    (End1 as TAssociationOneEndOptions).ReferenceProperty := Entity1.FindChildByName(AReferencePropertyName) as TEntityProperty;
  end;
  AReferencePropertyName := ANode.Attributes.GetValueAsString('Entity2RefrenceProperty');
  (End2 as TAssociationOneEndOptions).ReferenceProperty := Entity2.FindChildByName(AReferencePropertyName) as TEntityProperty;

  if SameText(Name, GetDefaultName) then
    IsNameAssigned := False;
end;

procedure TAssociation.SetEntity1(const Value: TEntity);
begin
  if Entity1 <> Value then
  begin
    if (Entity1 <> nil) and (Entity1 <> Entity2) then
      RemoveListener(Entity1);
    RemoveRelationProperty;
    End1.SetEntity(Value);
    if Entity1 <> nil then
      AddListener(Entity1);
    AddRelationProperty;
    CheckDefaultName;
    PropertyChanged;
  end;
end;

procedure TAssociation.SetEntity2(const Value: TEntity);
begin
  if Entity2 <> Value then
  begin
    if (Entity2 <> nil) and (Entity1 <> Entity2) then
      RemoveListener(Entity2);
    RemoveRelationProperty;
    End2.SetEntity(Value);
    if Entity2 <> nil then
      AddListener(Entity2);
    AddRelationProperty;
    CheckDefaultName;
    PropertyChanged;
  end;
end;

procedure TAssociation.SetType(const Value: TAssociationType);
begin
  if FType <> Value then
  begin
    FType := Value;
    RecreateAssociationEnd1;
    PropertyChanged;
  end;
end;

procedure TAssociation.SetDeleteRule(const Value: TAssociationDeleteRule);
begin
  if FDeleteRule <> Value then
  begin
    FDeleteRule := Value;
    PropertyChanged;
  end;
end;

procedure TAssociation.StoreProperties(ANode: TdxXmlNode);
begin
  inherited StoreProperties(ANode);
  if Entity1 <> nil then
    ANode.Attributes.Add('Entity1').ValueAsString := Entity1.Name;
  if Entity2 <> nil then
    ANode.Attributes.Add('Entity2').ValueAsString := Entity2.Name;
  if End1 is TAssociationManyEndOptions then
  begin
    if not SameText(TAssociationManyEndOptions(End1).CollectionPropertyName, Entity2.Name) then
       ANode.Attributes.Add('Entity1CollectionPropertyName').ValueAsString := TAssociationManyEndOptions(End1).CollectionPropertyName;
  end
  else
    if End1 is TAssociationOneEndOptions then
      if TAssociationOneEndOptions(End1).ReferencePropertyName <> '' then
        ANode.Attributes.Add('Entity1RefrenceProperty').ValueAsString := TAssociationOneEndOptions(End1).ReferencePropertyName;
  if &Type <> TAssociationType.OneToOne then
    ANode.Attributes.Add('Type').ValueAsString := AssociationTypeToString[&Type];
  if DeleteRule <> TAssociationDeleteRule.SetNULL then
    ANode.Attributes.Add('AssociationDeleteRule').ValueAsString := DeleteRuleToString[DeleteRule];
  if (End2 as TAssociationOneEndOptions).ReferencePropertyName <> '' then
    ANode.Attributes.Add('Entity2RefrenceProperty').ValueAsString := TAssociationOneEndOptions(End2).ReferencePropertyName;
end;

procedure RegisterXmlNodeAndNamedPersistentMapping(AItemClasses: array of TNamedPersistentClass);
var
  I: Integer;
begin
  for I := 0 to High(AItemClasses) do
    NamedPersistentClasses.Add(AItemClasses[I].GetXmlNodeName, AItemClasses[I]);
end;

{ TEntityRelationshipProperty }

constructor TEntityRelationshipProperty.Create(AParent: TNamedPersistent; AAssociationEnd: TAssociationEndOptions);
begin
  inherited Create(AParent);
  FAssociationEnd := AAssociationEnd;
  CheckDefaultName;
end;

function TEntityRelationshipProperty.GetBaseName: string;
begin
  Result := 'RelationProperty';
end;

function TEntityRelationshipProperty.GetImageIndex: Integer;
begin
  Result := AssociationImageIndex;
end;

procedure TEntityRelationshipProperty.Restore(ANode: TdxXmlNode);
begin
// Do nothing
end;

procedure TEntityRelationshipProperty.Store(AParentXmlNode: TdxXmlNode);
begin
// Do nothing
end;

function TEntityRelationshipProperty.GetDefaultName: string;
var
  AOppositeEnd: TAssociationEndOptions;
begin
  AOppositeEnd := AssociationEnd.GetOppositeEnd;
  Result := GetCollectionDefaultName(AOppositeEnd.Entity.Name);
end;

function TEntityRelationshipProperty.GetOverlayImageIndex: Integer;
begin
  if AssociationEnd.Association.Entity1 = AssociationEnd.Association.Entity2 then
    Result := AssociationSelfToSelfOverlayImageIndex
  else
    Result := inherited GetOverlayImageIndex;
end;

{ TOptionsInheritance }

procedure TOptionsInheritance.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TOptionsInheritance then
  begin
    DiscriminatorColumnSize := TOptionsInheritance(Source).DiscriminatorColumnSize;
    DiscriminatorType := TOptionsInheritance(Source).DiscriminatorType;
    DiscriminatorValue := TOptionsInheritance(Source).DiscriminatorValue;
    DiscriminatorColumnName := TOptionsInheritance(Source).DiscriminatorColumnName;
    MapInheritanceType := TOptionsInheritance(Source).MapInheritanceType;
  end;
end;

procedure TOptionsInheritance.SetDiscriminatorColumnSize(const Value: Integer);
begin
  if FDiscriminatorColumnSize <> Value then
  begin
    FDiscriminatorColumnSize := Value;
    (Owner as TNamedPersistent).PropertyChanged;
  end;
end;

procedure TOptionsInheritance.SetDiscriminatorColumnName(const Value: string);
begin
  if FDiscriminatorColumnName <> Value then
  begin
    FDiscriminatorColumnName := Value;
    (Owner as TNamedPersistent).PropertyChanged;
  end;
end;

procedure TOptionsInheritance.SetDiscriminatorType(const Value: TdxDiscriminatorType);
begin
  if FDiscriminatorType <> Value then
  begin
    FDiscriminatorType := Value;
    (Owner as TNamedPersistent).PropertyChanged;
  end;
end;

procedure TOptionsInheritance.SetDiscriminatorValue(const Value: string);
begin
  if FDiscriminatorValue <> Value then
  begin
    FDiscriminatorValue := Value;
    (Owner as TNamedPersistent).PropertyChanged;
  end;
end;

procedure TOptionsInheritance.SetMapInheritanceType(const Value: TMapInheritanceType);
var
  AInheritance: TInheritance;
begin
  if FMapInheritanceType <> Value then
  begin
    FMapInheritanceType := Value;
    // need for connection line on diagramm changed
    AInheritance := EMFDesigner.Model.Inheritances.FindInheritanceByDerivedEntity(Owner as TEntity);
    if AInheritance <> nil then
      AInheritance.PropertyChanged;
    //
    (Owner as TNamedPersistent).PropertyChanged;
  end;
end;

function TAssociationEndOptions.GetOppositeEnd: TAssociationEndOptions;
begin
  Result := Association.GetOppositeEnd(Self);
end;

procedure TAssociationEndOptions.CheckDefaultName;
begin
end;

function TAssociationEndOptions.GetAssociation: TAssociation;
begin
  Result := Owner as TAssociation;
end;

function TAssociationEndOptions.GetEntityProperty: TCustomEntityProperty;
begin
  Result := nil;
end;

procedure TAssociationEndOptions.SetEntity(const Value: TEntity);
begin
  FEntity := Value;
end;

procedure TInheritances.CheckDefaultNames;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].CheckDefaultName;
end;

function TInheritances.CreateUniqueName(const ABaseName: string): string;
begin
  Result := 'Inheritances';
end;

function TInheritances.FindInheritanceByDerivedEntity(AEntity: TEntity): TInheritance;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if Items[I].DerivedEntity = AEntity then
    begin
      Result := Items[I];
      Break;
    end;
end;

function TInheritances.GetBaseName: string;
begin
  Result := 'Inheritances';
end;

function TInheritances.GetImageIndex: Integer;
begin
  Result := InheritancesImageIndex;
end;

function TInheritances.GetItem(Index: Integer): TInheritance;
begin
  Result := TInheritance(Children[Index]);
end;

procedure TInheritances.Restore(ANode: TdxXmlNode);
begin
  // do nothing
end;

procedure TInheritances.Store(AParentXmlNode: TdxXmlNode);
begin
  // do nothing
end;

function TInheritance.CanDelete: Boolean;
begin
  Result := True;
end;

{ TInheritance }

constructor TInheritance.Create(AParent: TNamedPersistent; ADerivedEntity: TEntity);
begin
  inherited Create(AParent);
  FDerivedEntity := ADerivedEntity;
  AddListener(ADerivedEntity);
  CheckDefaultName;
end;

function TInheritance.GetType: TMapInheritanceType;
begin
  Result := DerivedEntity.OptionsInheritance.MapInheritanceType;
end;

function TInheritance.GetBaseEntity: TEntity;
begin
  Result := DerivedEntity.BaseEntity;
end;

function TInheritance.GetBaseName: string;
begin
  Result := 'Inheritance';
end;

function TInheritance.GetDefaultName: string;
begin
  Result := GetInheritanceDefaultName(FDerivedEntity.Name, BaseEntity.Name);
end;

function TInheritance.GetDisplayClassName: string;
begin
  Result := 'inheritance';
end;

function TInheritance.GetImageIndex: Integer;
begin
  Result := InheritanceImageIndex;
end;

{ TAssociationManyEndOptions }

procedure TAssociationManyEndOptions.CheckDefaultName;
var
  AProperty: TEntityRelationshipProperty;
begin
  if Entity <> nil then
  begin
    AProperty := Entity.GetRelationProperty(Association);
    if AProperty <> nil then
      AProperty.CheckDefaultName;
  end;
end;

procedure TAssociationManyEndOptions.DoAssign(Source: TPersistent);
begin
  inherited;
  if Source is TAssociationManyEndOptions then
    CollectionPropertyName := TAssociationManyEndOptions(Source).CollectionPropertyName;
end;

function TAssociationManyEndOptions.GetCollectionPropertyName: string;
var
  ARelationProperty: TCustomEntityProperty;
begin
  Result := '';
  if Entity <> nil then
  begin
    ARelationProperty := EntityProperty;
    if ARelationProperty <> nil then
      Result := ARelationProperty.Name;
  end;
end;

function TAssociationManyEndOptions.GetEntityProperty: TCustomEntityProperty;
begin
  if Entity <> nil then
    Result := Entity.GetRelationProperty(Association)
  else
    Result := inherited GetEntityProperty;
end;

procedure TAssociationManyEndOptions.SetCollectionPropertyName(const Value: string);
var
  ARelationProperty: TCustomEntityProperty;
begin
  if Entity <> nil then
  begin
    ARelationProperty := EntityProperty;
    if ARelationProperty <> nil then
      ARelationProperty.Name := Value;
  end;
end;

{ TAssociationOneEndOptions }

destructor TAssociationOneEndOptions.Destroy;
begin
  ReferenceProperty := nil;
  inherited Destroy;
end;

{ TAssociationOneEndOptions }

procedure TAssociationOneEndOptions.DoAssign(Source: TPersistent);
begin
  inherited;
  if Source is TAssociationOneEndOptions then
    ReferencePropertyName := TAssociationOneEndOptions(Source).ReferencePropertyName;
end;

function TAssociationOneEndOptions.GetReferencePropertyName: string;
begin
  if FReferenceProperty <> nil then
    Result := FReferenceProperty.Name
  else
    Result := '';
end;

procedure TAssociationOneEndOptions.CheckDefaultNames;
var
  AOppositeEnd: TAssociationEndOptions;
begin
  Association.CheckDefaultName;
  AOppositeEnd := GetOppositeEnd;
  if AOppositeEnd <> nil then
    AOppositeEnd.CheckDefaultName;
end;

function TAssociationOneEndOptions.GetEntityProperty: TCustomEntityProperty;
begin
  Result := ReferenceProperty;
end;

procedure TAssociationOneEndOptions.SetReferenceProperty(AValue: TEntityProperty);
begin
  if FReferenceProperty <> AValue then
  begin
    if FReferenceProperty <> nil then
      FReferenceProperty.SetAssociationEnd(nil);
    FReferenceProperty := AValue;
    if FReferenceProperty <> nil then
      FReferenceProperty.SetAssociationEnd(Self);
    CheckDefaultNames;
    Association.PropertyChanged;
  end;
end;

procedure TAssociationOneEndOptions.SetReferencePropertyName(const Value: string);
begin
  if FReferenceProperty <> nil then
  begin
    FReferenceProperty.Name := Value;
    CheckDefaultNames;
  end;
end;

{ TEntityPropertyDataTypeOptions }

constructor TEntityPropertyDataTypeOptions.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FDataType := 'string';
end;

procedure TEntityPropertyDataTypeOptions.DoAssign(Source: TPersistent);
begin
  inherited DoAssign(Source);
  if Source is TEntityPropertyDataTypeOptions then
    DataType := TEntityPropertyDataTypeOptions(Source).DataType;
end;

function TEntityPropertyDataTypeOptions.GetEntityProperty: TEntityProperty;
begin
  Result := Owner as TEntityProperty;
end;

function TEntityPropertyDataTypeOptions.GetDataType: string;
begin
  if Entity <> nil then
    Result := Entity.DataType
  else
    Result := DataType;
end;

procedure TEntityPropertyDataTypeOptions.SetDataType(const Value: string);
begin
  if FDataType <> Value then
  begin
    FDataType := Value;
    EntityProperty.PropertyChanged;
  end;
end;

procedure TEntityPropertyDataTypeOptions.SetEntity(Value: TEntity);
begin
  if FEntity <> Value then
  begin
    if FEntity <> nil then
      FEntity.RemoveListener(EntityProperty);
    FEntity := Value;
    if FEntity <> nil then
      FEntity.AddListener(EntityProperty);
    EntityProperty.PropertyChanged;
  end;
end;

function TCustomEntityProperty.GetDisplayClassName: string;
begin
  Result := 'property';
end;


procedure PopulateNullableTypesDictionary;
var
  AStrings: TStringList;
  I: Integer;
begin
  AStrings := TStringList.Create;
  try
    AStrings.Delimiter := ';';
    AStrings.DelimitedText := SStandardNullableTypes;
    for I := 0 to AStrings.Count - 1 do
      NullableTypesDictionary.Add(AStrings.Names[I], AStrings.ValueFromIndex[I]);
    AStrings.Clear;
    AStrings.DelimitedText := SStandardNotNullableTypes;
    for I := 0 to AStrings.Count - 1 do
      NotNullableTypesDictionary.Add(AStrings[I], 0);
  finally
    AStrings.Free;
  end;
end;

initialization
  NamedPersistentClasses := TDictionary<string, TNamedPersistentClass>.Create;
  RegisterXmlNodeAndNamedPersistentMapping([TAssociation, TEntity, TEntityProperty]);

  NullableTypesDictionary := TDictionary<string, string>.Create;
  NotNullableTypesDictionary := TDictionary<string, Byte>.Create;
  PopulateNullableTypesDictionary;

finalization
  FreeAndNil(NamedPersistentClasses);

  FreeAndNil(NullableTypesDictionary);
  FreeAndNil(NotNullableTypesDictionary);

end.


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

unit dxEMFToolConsts;

{$SCOPEDENUMS ON}

interface

uses
  dxCore,
  dxEMF.Types,
  dxEMF.DB.Model,
  dxEMFToolTypes;

const
  SEditorCaption = 'Entity Model Designer';

  SInvalidName = '''''%s'''' is not a valid %s name.';
  SIncorrectDataTypeName = 'Incorrect data type name.';
  SPasUnitsCreationSuccess = 'Code file generation successfully completed.';
  SPasUnitsCreationFailed = 'Code file generation failed because %s.';
  SPasUnitsWillBeRecreated = 'Newly generated code files will overwrite %s. Do you want to proceed?';
  SDestroyCurrentModelQuery = 'This will clear the entity model. Do you want to proceed?';
  SDestroyCurrentDiagramQuery = 'This will clear the diagram. Do you want to proceed?';
  SDiscardChangesQuery = 'Do you want to discard your changes and close this window?';
  SSaveChangesQuery = 'Do you want to save your changes?';
  SConnectionInvalid = 'Connection is not valid.';
  SDeleteSelectedObjectQuery = 'Do you want to delete this object?';
  SDeleteEntityPropertyAndAssociationConfirmation = 'This will delete the ''%s'' property and its ''%s'' association.' + dxCRLF +
    'Do you want to proceed?';
  SCreateAssociationQuery = 'Do you want to create an association between the ''%s'' and ''%s'' entities using the ''%s'' foreign key?';
  SInvalidOptionsReenterQuery = 'Some option settings are not valid and cannot be saved.' + dxCRLF +
    'Correct the settings and save them again.';
  SEnterValidPropertyName = 'Enter a valid property name';
  SEnterValidDataType = 'Enter a valid data type';
  SUnknownDataType = 'Unknown data type. Check the spelling and specify the unit in which it is declared.';
  SMaxValueTooLong = 'The specified maximum length exceeds the limit set by the active connection';
  SEnterValidColumnDataType = 'Enter a valid column data type';
  SEnterValidColumnName = 'Enter a valid column name';
  SEnterValidSequenceName = 'Enter a valid sequence name';
  SEnterValidAssociationName = 'Enter a valid association name';
  SEnterValidAssociationEntity = 'Select an entity';
  SEnterValidAssociationReferenceProperty = 'Select a reference property';
  SEnterValidCollectionPropertyName = 'Enter a valid collection property name';
  SOneEntityNeededError = 'The entity model must contain at least one entity.';
  STwoEntitiesNeededError = 'The entity model must contain at least two entities.';
  SSuccessfulConnection = 'Connection successful.';
  SConnectionFailed = 'Connection failed: ';
  SEnterValidDatabase = 'Specify a database to connect';
  SEnterValidPassword = 'Specify a password for authentication';
  SEnterValidServer = 'Specify a server to connect';
  SEnterValidUsername = 'Specify a username for authentication';
  SUnitNameEditorTitle = 'Specify Unit Name';
  SInputUnitNameQuery = 'Specify the unit in which the ''%s'' type is declared.';
  SHasNoPrimaryKey = 'has no primary key';
  SNotValid = 'is not valid';
  SDeleteEntityPropertyConfirmation = 'Do you want to delete this property?';
  SEnterValidEntityName = 'Enter a valid entity name';
  SEnterValidTableName = 'Enter a valid table name';
  SEnterValidDiscriminatorValue = 'Enter a unique and valid %s discriminator value';
  SEnterValidInheritanceBaseEntity = 'Select an entity that does not inherit from a derived entity.';
  SNoDataProviderSelectedError = 'No database connection settings are specified.';
  SEnterValidDataTypeReferencedEntity = 'Select an entity';
  SUpdateModelFromEmptyDatabaseStructureError = 'The database structure is empty. Refresh it before creating a model.';
  SAddAssociationReferenceProperty = 'Add a new reference property';
  SEditAssociationReferenceProperty = 'Edit a reference property';
  SEditConnectionString = 'Edit connection string';
  SResetDiagramLayoutConfirmation = 'This will reset the diagram''s layout. Do you want to proceed?';

  SDelphiReservedWords: string = 'and;array;as;asm;begin;case;class;const;constructor;destructor;dispinterface;div;do;downto;else;' +
  'end;except;exports;file;finalization;finally;for;function;goto;if;implementation;in;inherited;initialization;inline;' +
  'interface;is;label;library;mod;nil;not;object;of;or;packed;procedure;program;property;raise;record;repeat;resourcestring;' +
  'set;shl;shr;string;then;threadvar;to;try;type;unit;until;uses;var;while;with;xor';

  SDelphiDirectives: string = 'absolute;abstract;assembler;automated;cdecl;contains;default;delayed;deprecated;dispid;dynamic;' +
  'experimental;export;external;far;final;forward;helper;implements;index;inline;library;local;message;name;near;nodefault;' +
  'operator;out;overload;override;package;pascal;platform;private;protected;public;published;read;readonly;reference;register;' +
  'reintroduce;requires;resident;safecall;sealed;static;stdcall;strict;stored;unsafe;varargs;virtual;winapi;write;writeonly';

  SStandardDataTypes: string = 'Boolean;Byte;Cardinal;Char;Comp;Currency;Double;Extended;Int64;Integer;NativeInt;' +
    'NativeUInt;ShortInt;ShortString;Single;SmallInt;string;TDate;TDateTime;TTime;UInt64;WideString;Word';
  SStandardDateTimeDataTypes: string = 'TDate;TDateTime;TTime';
  SStandardFractionalNumericDataTypes: string = 'Comp;Currency;Double;Extended;Single';
  SStandardIntegerNumericDataTypes: string = 'Byte;Cardinal;Int64;Integer;NativeInt;NativeUInt;ShortInt;SmallInt;UInt64;Word;';
  SStandardOrdinalDataTypes: string = 'Boolean;Byte;Char;Int64;Integer;NativeInt;NativeUInt;ShortInt;SmallInt;UInt64;Word';
  SStandardNullableTypes: string = 'Boolean=TdxNullableBoolean;string=TdxNullableString;' +
  'Byte=TdxNullableByte;ShortInt=TdxNullableShortInt;SmallInt=TdxNullableSmallInt;Word=TdxNullableWord;Integer=TdxNullableInteger;' +
  'Int64=TdxNullableInt64;' +
  'Single=TdxNullableSingle;Double=TdxNullableDouble;Currency=TdxNullableCurrency;' +
  'TDateTime=TdxNullableDateTime;TDate=TdxNullableDate;TTime=TdxNullableTime;'+
  'TGUID=TdxNullableGUID';
  SStandardNotNullableTypes: string = 'TBytes;TStrings;TStringList;TGraphics;TdxSmartImage';

  SSimpleClassConstructor = '{_fieldname_} := {_classtype_}.Create';
  SSimpleClassDestructor = 'FreeAndNil({_fieldname_})';
  SSimpleClassSetter = '{_fieldname_}.Assign(AValue)';

  KnownDataTypes: array [0..3] of TDataType = (
    (Name: 'TBytes'; UnitName: 'SysUtils'),
    (Name: 'TdxSmartImage'; ConstructorCode: SSimpleClassConstructor; DestructorCode: SSimpleClassDestructor; Setter: SSimpleClassSetter; UnitName: 'dxGDIPlusClasses'),
    (Name: 'TBitmap'; ConstructorCode: SSimpleClassConstructor; DestructorCode: SSimpleClassDestructor; Setter: SSimpleClassSetter; UnitName: 'Graphics'),
    (Name: 'TStringList'; ConstructorCode: SSimpleClassConstructor; DestructorCode: SSimpleClassDestructor; Setter: SSimpleClassSetter; UnitName: 'Classes')
  );

  SPackageDirectives = '{$R *.res};' +
    '{$IFDEF IMPLICITBUILDING This IFDEF should not be used by users};' +
    '{$ALIGN 8};' +
    '{$ASSERTIONS ON};' +
    '{$BOOLEVAL OFF};' +
    '{$DEBUGINFO OFF};' +
    '{$EXTENDEDSYNTAX ON};' +
    '{$IMPORTEDDATA ON};' +
    '{$IOCHECKS ON};' +
    '{$LOCALSYMBOLS ON};' +
    '{$LONGSTRINGS ON};' +
    '{$OPENSTRINGS ON};' +
    '{$OPTIMIZATION OFF};' +
    '{$OVERFLOWCHECKS OFF};' +
    '{$RANGECHECKS OFF};' +
    '{$REFERENCEINFO ON};' +
    '{$SAFEDIVIDE OFF};' +
    '{$STACKFRAMES ON};' +
    '{$TYPEDADDRESS OFF};' +
    '{$VARSTRINGCHECKS ON};' +
    '{$WRITEABLECONST OFF};' +
    '{$MINENUMSIZE 1};' +
    '{$IMAGEBASE $400000};' +
    '{$DEFINE DEBUG};' +
    '{$ENDIF IMPLICITBUILDING};' +
    '{$IMPLICITBUILD ON}';


implementation

end.


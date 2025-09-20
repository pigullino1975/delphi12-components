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

unit dxEMFToolTypeToStrConverters;

{$I cxVer.inc}

interface

uses
  dxCore,
  dxEMF.Types, dxEMF.DB.Model,
  dxEMFToolTypes, dxEMFToolConsts;

const
  AssociationTypeToString: array [TAssociationType] of string = (
    'OneToOne', 'OneToMany');//, 'ManyToMany');
  DeleteRuleToString: array [TAssociationDeleteRule] of string = (
    'SetNULL', 'Cascade');
  EntityPropertyOptionToString: array [TEntityPropertyOption] of string = (
    'Blob', 'Delayed', 'Indexed', 'NonPersistent', 'PrimaryKey', 'Unique', 'Nullable', 'ReadOnly');

  EntityPropertyOptionToColumnAttributeName: array [TEntityPropertyOption] of string = (
    'Blob', 'Delayed', 'Indexed', 'NonPersistent', 'Key', 'Unique', 'Nullable', 'ReadOnly');

  ColumnDataTypeToEntityPropertyDataType: array [TdxDBColumnType] of string = (
    'string',
    'Boolean',
    'Byte',
    'ShortInt',
    'Char',
    'Currency',
    'Double',
    'Single',
    'Integer',
    'Cardinal',
    'SmallInt',
    'Word',
    'Int64',
    'UInt64',
    'string',
    'TDateTime',
    'TGUID',
    'TBytes',
    'TTimeSpan'
  );
  GeneratorTypeToStr: array [TdxGeneratorType] of string = (
    'None',
//    'Custom',
//    'Increment',
    'Identity',
//    'HiLo',
//    'SequenceHiLo',
    'Guid',
    'SequentialGuid',
    'Sequence'
  );
  ColumnDataTypeToStr: array [TdxDBColumnType] of string = (
    'Unknown',
    'Boolean',
    'Byte',
    'SByte',
    'Char',
    'Decimal',
    'Double',
    'Single',
    'Int32',
    'UInt32',
    'Int16',
    'UInt16',
    'Int64',
    'UInt64',
    'String',
    'DateTime',
    'Guid',
    'ByteArray',
    'TimeSpan'
  );
  DiscriminatorTypeToStr: array [TdxDiscriminatorType] of string = (
    'String',
    'Integer'
  );
  MapInheritanceTypeToStr: array[TMapInheritanceType] of string = (
    'None',
    'ParentTable',
    'OwnTable'
  );
  dxMapInheritanceTypeToStr: array[TdxMapInheritanceType] of string = (
    'ParentTable',
    'OwnTable'
  );
  AssociationDeleteRuleToDisplayName: array [TAssociationDeleteRule] of string = (
    'Set NULL',
    'Cascade'
  );
  AssociationTypeToDisplayName: array [TAssociationType] of string = (
    'One-to-One',
    'One-to-Many'
  );

  CodeGeneratorEntityRegistrationTypeToStr: array [TEntityRegistrationType] of string = (
    'DeclarativeAttributes',
    'RegistrationFunction'
  );

implementation

end.

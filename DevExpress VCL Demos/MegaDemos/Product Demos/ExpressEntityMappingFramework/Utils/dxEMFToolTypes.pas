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

unit dxEMFToolTypes;

{$SCOPEDENUMS ON}
{$I cxVer.inc}

interface

uses
  dxCore;

type
  EEMFModelError = class(EdxException);
  EEMFModelNameValidError = class(EEMFModelError);
  EEMFDataTypeNameValidError = class(EEMFModelError);
  EEMFDatabaseConnectionError = class(EEMFModelError);

  TEntityPropertyOption = (Blob, Delayed, Indexed, NonPersistent, PrimaryKey, Unique, Nullable, ReadOnly);
  TEntityPropertyOptions = set of TEntityPropertyOption;

  TDataType = record
    Name: string;
    ConstructorCode: string;
    DestructorCode: string;
    Setter: string;
    UnitName: string;
  end;

  TMapInheritanceType = (
    None,
    ParentTable,
    OwnTable);

  TAssociationType = (OneToOne, OneToMany);//, atManyToMany);

  TAssociationDeleteRule = (SetNULL, Cascade);

  TEntityRegistrationType = (DeclarativeAttributes, RegistrationFunction);

implementation

end.

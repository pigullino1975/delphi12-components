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

unit dxEMFModelValidator;

{$I cxVer.inc}

interface

uses
  Windows, SysUtils, Classes, StrUtils,
  dxEMFModelObjects, dxEMFToolConsts, dxEMFToolTypes;

type
  TdxEMFModelValidator = class
    class function Validate(AModel: TDataModel): Boolean;
    class function CheckValid(AModel: TDataModel; var AErrorStr: string): Boolean;
  end;

implementation

{ TdxEMFModelValidator }

class function TdxEMFModelValidator.CheckValid(AModel: TDataModel; var AErrorStr: string): Boolean;

  function DoValidate(AItem: TNamedPersistent; var AErrorStr: string): Boolean;
  var
    ASubItem: TNamedPersistent;
  begin
    Result := not AItem.IsValidatable or AItem.Valid;
    if Result then
      for ASubItem in AItem.Children do
      begin
        Result := DoValidate(ASubItem, AErrorStr);
        if not Result then
          Break;
      end
    else
      AErrorStr := Format('the ''%s'' %s %s', [AItem.Name, AItem.DisplayClassName, AItem.ValidationErrorText]);
  end;

begin
  Result := DoValidate(AModel, AErrorStr);
end;

class function TdxEMFModelValidator.Validate(AModel: TDataModel): Boolean;
var
  AItem: TNamedPersistent;
  AEntity: TEntity;
  AAssociation: TAssociation;
begin
//  AModel.Valid := AModel.ContextName = '';
  Result := True;
  for AItem in AModel.Entities.Children do
  begin
    AEntity := AItem as TEntity;
    if (AEntity.BaseEntity = nil) and not AEntity.HasPrimaryKey then
    begin
      Result := False;
      AEntity.Valid := False;
      AEntity.ValidationErrorText := SHasNoPrimaryKey;
    end
    else
      AEntity.Valid := True;
  end;
  for AItem in AModel.Associations.Children do
  begin
    AAssociation := AItem as TAssociation;
    AAssociation.Valid := AAssociation.IsValid;
    if not AAssociation.Valid then
      AAssociation.ValidationErrorText := SNotValid;
    Result := Result and AAssociation.Valid;
  end;
end;

end.

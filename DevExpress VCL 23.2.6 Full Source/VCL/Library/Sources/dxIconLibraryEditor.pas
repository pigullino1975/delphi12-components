{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           Express Cross Platform Library classes                   }
{                                                                    }
{           Copyright (c) 2000-2024 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSCROSSPLATFORMLIBRARY AND ALL   }
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

unit dxIconLibraryEditor;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Contnrs, cxGraphics, cxControls,
  cxContainer, cxEdit, Menus, ExtCtrls, StdCtrls, cxButtons, cxImage, cxListBox, cxTextEdit, cxMaskEdit,
  cxButtonEdit, dxGalleryControl, cxCheckListBox, ExtDlgs, dxGallery, cxClasses, cxGeometry, dxGDIPlusClasses,
  dxIconLibraryEditorHelpers, ComCtrls, dxCore, dxIconLibrary, ImgList, cxLookAndFeels, cxLookAndFeelPainters,
  ActnList, cxImageList, cxCustomListBox, cxCheckBox, dxSmartImage, dxPictureEditor, dxLayoutLookAndFeels, dxThreading,
  dxLayoutContainer, dxLayoutControl, dxLayoutcxEditAdapters, dxSkinsCore, dxLayoutControlAdapters, System.Actions,
  dxFormattedLabel, dxCoreGraphics;

type
  TdxfmImagePicker = class;

  TdxPopulateGalleryMode = (gpmGroups, gpmSearch);

  { TdxSearchString }

  TdxSearchString = record
    Data: string;
    DataAssigned: Boolean;

    class function Create(const S: string): TdxSearchString; static;
    function Check(const S: string): Boolean; inline;
  end;

  TLibraryContentType = (lctRaster, lctVector);
  TdxIconLibraryGalleries = array [TLibraryContentType] of TdxGalleryControl;

  { TdxLoadImagesTask }

  TdxLoadImagesTask = class(TdxTask)
  strict private
    FImagesToLoad: TList;
    FLoadedImages: TThreadList;
    FTargetGalleries: TdxIconLibraryGalleries;
    FUpdateTimer: TcxTimer;

    procedure SyncAssignImages;
    procedure SyncComplete;
    procedure SyncReleaseResources;
    procedure TimerHandler(Sender: TObject);
  protected
    procedure Complete; override;
    procedure Execute; override;
  public
    constructor Create(ATarget: TdxIconLibraryGalleries; AImagesToLoad: TList);
    destructor Destroy; override;
  end;

  { TdxCustomPopulateHelper }

  TdxCustomPopulateHelper = class
  private
    FImagePicker: TdxfmImagePicker;
    FSelection: TdxGalleryControl;

    FGalleries: TdxIconLibraryGalleries;
    FCollectionCheckList: array [TLibraryContentType] of TcxCheckListBox;
    FCategoryCheckList: array [TLibraryContentType] of TcxCheckListBox;
    FSizeCheckList: array [TLibraryContentType] of TcxCheckListBox;
    FGalleryGroupSearch: array [TLibraryContentType] of TdxGalleryControlGroup;
    FGalleryGroupHidden: array [TLibraryContentType] of TdxGalleryControlGroup;
    FFilterEdit: array [TLibraryContentType] of TcxCustomTextEdit;
    function GetIconLibrary: TdxIconLibrary;
  protected
    function AddGalleryGroup(const ACaption: string; AGallery: TdxGalleryControl; ReplaceExisting, AVisible: Boolean): TdxGalleryControlGroup;
    procedure BeginUpdate;
    procedure EndUpdate;
    function GetIndexForGalleryGroup(const ANameItem: string; AGallery: TdxGalleryControl): Integer;
    function IsListBoxCheckedByText(ACheckListBox: TcxCheckListBox; const AText: string): Boolean;
    procedure PopulateCore; virtual; abstract;

    property IconLibrary: TdxIconLibrary read GetIconLibrary;
    property Selection: TdxGalleryControl read FSelection;
  public
    constructor Create(AImagePicker: TdxfmImagePicker); virtual;
    procedure Populate;
  end;

  { TdxPopulateContentHelper }

  TdxPopulateContentHelper = class(TdxCustomPopulateHelper)
  public const
    DefaultImageSize: TSize = (cx: 16; cy: 16);
  strict private const
    TAG_UNUSED = $123;
    TAG_USED = 0;
  protected
    function AddCheckListBoxItem(ACheckListBox: TcxCheckListBox; const AText: string; AChecked: Boolean): Boolean;
    procedure AddGalleryItem(AImageItem: TdxIconLibraryImage);
    procedure DeleteUnusedItems(ACheckListBox: TcxCheckListBox);
    function FindCheckListBoxItem(ACheckListBox: TcxCheckListBox; const AText: string; out AItem: TcxCheckListBoxItem): Boolean;
    function MakeHint(AImageItem: TdxIconLibraryImage): string;
    procedure MarkItemsUnused(ACheckListBox: TcxCheckListBox);
    function GetIndexForCheckListItem(ACheckListBox: TcxCheckListBox; const AText: string): Integer;
  private
  protected
    procedure PopulateCore; override;
  end;

  { TdxPopulateGalleryHelper }

  TdxPopulateGalleryHelper = class(TdxCustomPopulateHelper)
  strict private const
    NoPreviewImageIndex = 9;
  strict private
    FImagesToLoad: TList;
    FIsDestroying: Boolean;
    FLoadImagesTaskHandle: THandle;
    FMaxSize: TSize;

    procedure LoadImagesTaskComplete;
    procedure StartLoadImagesThread;
    procedure StopLoadImagesThread;
    function GetGalleryItem(AIconLibraryImage: TdxIconLibraryImage): TdxGalleryControlItem;
    function GetIndexForItem(AGroup: TdxGalleryControlGroup; const ANameItem: string): Integer;
    procedure PopulateGalleryGroups(ACollectionItem: TdxIconLibrarySet; AContentType: TLibraryContentType; const ASearchString: TdxSearchString);
    procedure PopulateGalleryImages(AGroup: TdxGalleryControlGroup; ACategory: TdxIconLibraryCategory; AContentType: TLibraryContentType; const ASearchString: TdxSearchString);
  protected
    procedure DestroyGalleryItem(AImage: TdxIconLibraryImage); inline;
    procedure DestroyGalleryItems(ACategory: TdxIconLibraryCategory); overload;
    procedure DestroyGalleryItems(ASet: TdxIconLibrarySet); overload;
    procedure DestroyGalleryItems; overload;
    procedure PopulateCore; override;
  public
    constructor Create(AImagePicker: TdxfmImagePicker); override;
    destructor Destroy; Override;
    procedure WaitForLoadImagesThread;
  end;

  { TdxfmImagePicker }

  TdxfmImagePicker = class(TdxPictureEditorDialog, IdxIconLibraryListener)
    actF3: TAction;
    beFind: TcxButtonEdit;
    clbCategories: TcxCheckListBox;
    clbCollection: TcxCheckListBox;
    clbSize: TcxCheckListBox;
    dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    gcIcons: TdxGalleryControl;
    gcSelection: TdxGalleryControl;
    gcSelectionGroup: TdxGalleryControlGroup;
    lbCategories: TdxLayoutLabeledItem;
    liCategories: TdxLayoutItem;
    liCollections: TdxLayoutItem;
    liGallery: TdxLayoutItem;
    liPadding1: TdxLayoutEmptySpaceItem;
    liSearchBox: TdxLayoutItem;
    liSelection: TdxLayoutItem;
    liSize: TdxLayoutItem;
    miCheckSelected: TMenuItem;
    miIconsAddToSelection: TMenuItem;
    miIconsDeselectAll: TMenuItem;
    miIconsDeselectAllinThisGroup: TMenuItem;
    miIconsSelectAll: TMenuItem;
    miIconsSelectAllinThisGroup: TMenuItem;
    miIconsSelectionDeleteSelected: TMenuItem;
    miIconsSelectionDeselectAll: TMenuItem;
    miIconsSelectionLocateInIconLibrary: TMenuItem;
    miIconsSelectionSelectAll: TMenuItem;
    miIconsShowInExplorer: TMenuItem;
    miLine1: TMenuItem;
    miLine3: TMenuItem;
    miLine4: TMenuItem;
    miSelectAll: TMenuItem;
    miSelectNone: TMenuItem;
    miUncheckSelected: TMenuItem;
    pmIconGallery: TPopupMenu;
    pmIconsSelection: TPopupMenu;
    pmSelection: TPopupMenu;
    dxLayoutSplitterItem1: TdxLayoutSplitterItem;
    dxLayoutSplitterItem2: TdxLayoutSplitterItem;
    lgFontIcons: TdxLayoutGroup;
    gcIconsFont: TdxGalleryControl;
    FontItemsDefaultGroup: TdxGalleryControlGroup;
    FontIconsHiddenGroup: TdxGalleryControlGroup;
    liFontIcons: TdxLayoutItem;
    beFindFontIcons: TcxButtonEdit;
    liFontIconsFind: TdxLayoutItem;
    lblNotes: TdxFormattedLabel;
    liNotes: TdxLayoutItem;
    btnColorBlack: TcxButton;
    btnColorRed: TcxButton;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutItem2: TdxLayoutItem;
    dxLayoutItem3: TdxLayoutItem;
    btnColorGreen: TcxButton;
    dxLayoutItem4: TdxLayoutItem;
    btnColorBlue: TcxButton;
    dxLayoutItem5: TdxLayoutItem;
    btnColorYellow: TcxButton;
    dxLayoutItem6: TdxLayoutItem;
    btnColorWhite: TcxButton;
    dxLayoutGroup3: TdxLayoutGroup;
    PrintDialog1: TPrintDialog;
    dxLayoutLabeledItem1: TdxLayoutLabeledItem;
    ilStandartColors: TcxImageList;
    lgtsFontIcons: TdxLayoutGroup;
    lgtsDXRasterImageGallery: TdxLayoutGroup;
    dxLayoutGroup5: TdxLayoutGroup;
    dxLayoutLabeledItem2: TdxLayoutLabeledItem;
    btnAddLibraryCollectionRaster: TcxButton;
    btnRemoveFolderRaster: TcxButton;
    dxLayoutItem7: TdxLayoutItem;
    dxLayoutItem15: TdxLayoutItem;
    dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup;
    lgtsDXVectorImageGallery: TdxLayoutGroup;
    dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup;
    dxLayoutGroup6: TdxLayoutGroup;
    gcIconsVector: TdxGalleryControl;
    dxLayoutItem16: TdxLayoutItem;
    clbCategoriesVector: TcxCheckListBox;
    dxLayoutItem18: TdxLayoutItem;
    clbCollectionVector: TcxCheckListBox;
    dxLayoutItem19: TdxLayoutItem;
    dxLayoutGroup7: TdxLayoutGroup;
    dxLayoutGroup12: TdxLayoutGroup;
    dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem;
    dxLayoutLabeledItem3: TdxLayoutLabeledItem;
    AlignmentConstraint1: TdxLayoutAlignmentConstraint;
    beFindVector: TcxButtonEdit;
    liSearchBoxVector: TdxLayoutItem;
    dxLayoutGroup13: TdxLayoutGroup;
    dxLayoutLabeledItem4: TdxLayoutLabeledItem;
    btnRemoveFolderVector: TcxButton;
    btnAddCollectionVector: TcxButton;
    dxLayoutItem20: TdxLayoutItem;
    dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup;
    alActions: TActionList;
    actAddLibraryCollection: TAction;
    actRemoveCollectionVector: TAction;
    actRemoveCollectionRaster: TAction;
    ilCollections: TcxImageList;
    dxLayoutCxLookAndFeelCompact: TdxLayoutCxLookAndFeel;
    dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup;
    dxLayoutEmptySpaceItem2: TdxLayoutEmptySpaceItem;
    tmrSearchInGallery: TTimer;

    procedure actF3Execute(Sender: TObject);
    procedure beFindPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
    procedure beFindPropertiesChange(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure clbCategoriesClickCheck(Sender: TObject; AIndex: Integer; APrevState, ANewState: TcxCheckBoxState);
    procedure clbCollectionClickCheck(Sender: TObject; AIndex: Integer; APrevState, ANewState: TcxCheckBoxState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure gcIconsDblClick(Sender: TObject);
    procedure gcSelectionDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure gcSelectionDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure miIconsAddToSelectionClick(Sender: TObject);
    procedure miIconsDeselectAllClick(Sender: TObject);
    procedure miIconsSelectAllinThisGroupClick(Sender: TObject);
    procedure miIconsSelectionDeleteSelectedClick(Sender: TObject);
    procedure miIconsSelectionDeselectAllClick(Sender: TObject);
    procedure miIconsSelectionLocateInIconLibraryClick(Sender: TObject);
    procedure miIconsShowInExplorerClick(Sender: TObject);
    procedure miSelectClick(Sender: TObject);
    procedure miUncheckSelectedClick(Sender: TObject);
    procedure lgMainPageControlTabChanged(Sender: TObject);
    procedure pmIconGalleryPopup(Sender: TObject);
    procedure pmIconsSelectionPopup(Sender: TObject);
    procedure pmSelectionPopup(Sender: TObject);
    procedure clbSizeClickCheck(Sender: TObject; AIndex: Integer; APrevState, ANewState: TcxCheckBoxState);
    procedure tsFontIconsShow(Sender: TObject);
    procedure beFontIconsFindProperties(Sender: TObject; AButtonIndex: Integer);
    procedure beFontIconsFindPropertiesChange(Sender: TObject);
    procedure gcIconsFontDblClick(Sender: TObject);
    procedure btnColorClick(Sender: TObject);
    procedure clbCategoriesVectorClickCheck(Sender: TObject; AIndex: Integer; APrevState, ANewState: TcxCheckBoxState);
    procedure clbCollectionVectorClickCheck(Sender: TObject; AIndex: Integer; APrevState, ANewState: TcxCheckBoxState);
    procedure alActionsUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actAddLibraryCollectionExecute(Sender: TObject);
    procedure actRemoveCollectionVectorExecute(Sender: TObject);
    procedure actRemoveCollectionRasterExecute(Sender: TObject);
    procedure dxFormClose(Sender: TObject; var Action: TCloseAction);
    procedure tmrSearchInGalleryTimer(Sender: TObject);
  strict private
    FFontIconsPopulated: Boolean;
    FMultiSelect: Boolean;
    FPopulateGalleryHelper: TdxPopulateGalleryHelper;
    FPopulateGalleryLockCount: Integer;
    FSelectedGroup: TdxGalleryControlGroup;
    FLastTabSheetIndex: Integer;
    FPreferPictureEdit: Boolean;

    procedure ClearSelection;
    procedure CorrectCheckBoxSizes;
    function Locate(const AFileName: string): Boolean; overload;
    function Locate(const ACollection, ACategory, AName, ASize: string): Boolean; overload;
    function LocateItem(const ACollection, ACategory, AName, ASize: string): TdxGalleryControlItem;
    procedure PopulateContent;
    procedure PopulateGallery;
    procedure SetMultiSelect(AValue: Boolean);
    procedure SetSelectedFontIconsColor(const AColorName: string);
    procedure UpdateGalleryItemsSelection(AGallery: TdxGalleryControl; ASelect: Boolean); overload;
    procedure UpdateGalleryItemsSelection(AGroup: TdxGalleryControlGroup; ASelect: Boolean); overload;
    procedure UpdateCurrentTab;
    procedure UpdateSelectionBoxSize;
    procedure UpdateLibrarySetting(const ASettingName, AChangedValue: string; ANewState: TcxCheckBoxState; ASettings: TStringList);
  private
    function GetActiveGallery: TdxGalleryControl;
    function GetActiveFindEdit: TcxButtonEdit;
  protected
    procedure Initialize; override;
    procedure LoadSettings(APicture: TPicture); override;
    procedure SaveSettings(APicture: TPicture); override;

    procedure Select(AList: TcxCheckListBox; const ANames: array of string; ADropPreviousSelection: Boolean);
    procedure SelectSize(const ASize: string); overload;
    procedure SelectSize(const ASize: TSize); overload;

    procedure AddToSelection(AImageItem: TdxGalleryControlItem; AFromLibrary: Boolean = True);
    function GetIconLibraryImage(AGalleryControlItem: TdxGalleryControlItem): TdxIconLibraryImage;
    function HasSelectedButNotAddedItems: Boolean;
    function HasSelection: Boolean;

    // IdxIconLibraryListener
    procedure OnChanged(Sender: TdxIconLibraryCollection);
    procedure OnChanging(Sender: TdxIconLibraryCollection);
    procedure OnRemoving(Sender: TdxIconLibraryCustomObject); overload;

    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect;
    property ActiveGallery: TdxGalleryControl read GetActiveGallery;
    property ActiveFindEdit: TcxButtonEdit read GetActiveFindEdit;
    function GetFontIconFileName(AGalleryControlItem: TdxGalleryControlItem): string;
  public
    function Execute(const AFiles: TStrings; const ASuggestedImageSize: TSize): Boolean; overload;
    function Execute(var AFileName: string): Boolean; overload;

    property PreferPictureEdit: Boolean read FPreferPictureEdit write FPreferPictureEdit;
  end;

  { TdxImagePickerFormHelper }

  TdxImagePickerFormHelper = class(TInterfacedObject,
    IdxAdvancedPictureEditor,
    IdxImageCollection,
    IdxImageCollectionEditor,
    IdxImageCollectionEditorLocate)
  strict private
    FImagePicker: TdxfmImagePicker;

    function GetImagePicker: TdxfmImagePicker;
  protected
    // IdxAdvancedPictureEditor
    function Execute(APicture: TPicture; AGraphicClass: TGraphicClass; AImportList: TStrings;
      APreferSmartImage, APreferPictureEdit: Boolean): Boolean; overload;
    // IdxImageCollectionEditor
    function Execute(AFiles: TStrings; const ASuggestedImageSize: TSize): Boolean; overload;
    // IdxImageCollectionEditorLocate
    function Execute(var AFileName: string): Boolean; overload;
    // IdxImageCollection
    function GetImageInfo(const AFileName: string; AImageInfo: TcxImageInfo): Boolean;

    property ImagePicker: TdxfmImagePicker read GetImagePicker;
  public
    destructor Destroy; override;
  end;

var
  dxIconLibrary: TdxIconLibrary;

procedure dxExecuteImagePicker(APicture: TPicture; AImportList: TStrings = nil);

implementation

{$R *.dfm}

uses
  Math, Clipbrd, RTTI, cxShellCommon, StrUtils, dxDPIAwareUtils,
  dxMessageDialog, dxStringHelper, dxFontIconsImageLoader, dxFontIconsMetadata, dxSVGImage;

const
  dxThisUnitName = 'dxIconLibraryEditor';

const
  sdxAddToSelectionConfirmation = 'The selected items have not been added to the Selection box. Would you like to add them?';
  sdxLocateFailed = 'Cannot locate the selected image in the DevExpress Icon Library';
  sdxGalleryDeselectAllInGroup = 'Deselect All in %s';
  sdxGalleryGroupHidden = 'Hidden';
  sdxGalleryGroupSearchResult = 'Search Result';
  sdxGalleryItemHint = '%s'#13#10'Category: %s'#13#10'Collection: %s'#13#10'Path: %s';
  sdxGallerySelectAllInGroup = 'Select All in %s';
  sdxFontIconPrefix = 'FontIcons://';

var
  dxIconLibrarySizes: TStringList;

  dxIconLibraryCollections: array [TLibraryContentType] of TStringList;
  dxIconLibraryCategories: array [TLibraryContentType] of TStringList;

type
  TdxLayoutItemAccess = class(TdxLayoutItem);
  TdxGalleryControlItemAccess = class(TdxGalleryControlItem);

function MakeSortedStringList: TStringList;
begin
  Result := TStringList.Create;
  Result.Duplicates := dupIgnore;
  Result.Sorted := True;
end;

function GetSelectedItemText(ACheckListBox: TcxCheckListBox): string;
begin
  Result := '';
  if ACheckListBox.ItemIndex <> -1 then
    Result := ACheckListBox.Items[ACheckListBox.ItemIndex].Text
end;

function GetImageContentType(AGalleryImage: TdxIconLibraryImage): TLibraryContentType;
begin
  if EndsText('.svg', AGalleryImage.FileName) then
    Result := lctVector
  else
    Result := lctRaster;
end;

procedure InitIconLibrarySettings;
const
  Collections: array [TLibraryContentType] of string = (sdxIconLibraryCollections, sdxIconLibraryCollectionsVector);
  Categories: array [TLibraryContentType] of string = (sdxIconLibraryCategories, sdxIconLibraryCategoriesVector);
var
  ACollectionInd, ACategoryIndex: Integer;
  ASettingsValue: TValue;
  AContentType: TLibraryContentType;
begin
  for AContentType := Low(TLibraryContentType) to High(TLibraryContentType) do
  begin
    if not Assigned(dxIconLibraryCollections[AContentType]) then
    begin
      dxIconLibraryCollections[AContentType] := MakeSortedStringList;
      ASettingsValue := ReadIconLibrarySettings(Collections[AContentType]);
      if not ASettingsValue.IsEmpty then
        dxIconLibraryCollections[AContentType].Text := ASettingsValue.AsString
      else
      begin
        if AContentType = lctVector then
          dxIconLibraryCollections[AContentType].Add('SVG Images')
        else
          for ACollectionInd := 0 to dxIconLibrary.Count - 1 do
            dxIconLibraryCollections[AContentType].Add(dxIconLibrary.Items[ACollectionInd].DisplayName);
      end;
    end;
    if not Assigned(dxIconLibraryCategories[AContentType]) then
    begin
      dxIconLibraryCategories[AContentType] := MakeSortedStringList;
      ASettingsValue := ReadIconLibrarySettings(Categories[AContentType]);
      if not ASettingsValue.IsEmpty then
        dxIconLibraryCategories[AContentType].Text := ASettingsValue.AsString
      else
        for ACollectionInd := 0 to dxIconLibrary.Count - 1 do
          for ACategoryIndex := 0 to dxIconLibrary.Items[ACollectionInd].Count - 1 do
            dxIconLibraryCategories[AContentType].Add(dxIconLibrary.Items[ACollectionInd].Items[ACategoryIndex].DisplayName);
    end;
  end;
  if not Assigned(dxIconLibrarySizes) then
  begin
    dxIconLibrarySizes := MakeSortedStringList;
    ASettingsValue := ReadIconLibrarySettings(sdxIconLibrarySizes);
    if not ASettingsValue.IsEmpty then
      dxIconLibrarySizes.Text := ASettingsValue.AsString
    else
    begin
      dxIconLibrarySizes.Add('16x16');
      dxIconLibrarySizes.Add('32x32');
    end;
  end;
end;

procedure FreeIconLibrarySettings;
var
  AContentType: TLibraryContentType;
begin
  for AContentType := Low(TLibraryContentType) to High(TLibraryContentType) do
  begin
    FreeAndNil(dxIconLibraryCollections[AContentType]);
    FreeAndNil(dxIconLibraryCategories[AContentType]);
  end;
  FreeAndNil(dxIconLibrarySizes);
end;

type
  TdxGalleryControlAccess = class(TdxGalleryControl);
  TdxGalleryControlGroupAccess = class(TdxGalleryControlGroup);

function Contains(const AName: string; const ANames: array of string): Boolean;
var
  I: Integer;
begin
  for I := Low(ANames) to High(ANames) do
  begin
    if dxSameText(AName, ANames[I]) then
      Exit(True);
  end;
  Result := False;
end;

procedure dxExecuteImagePicker(APicture: TPicture; AImportList: TStrings = nil);
var
  ADialog: TdxfmImagePicker;
begin
  ADialog := TdxfmImagePicker.Create(nil);
  try
    ADialog.ImportList := AImportList;
    ADialog.Execute(APicture);
  finally
    ADialog.Free;
  end;
end;

procedure CreateIconLibrary;
var
  APaths: TStringList;
  I: Integer;
begin
  dxIconLibrary := TdxIconLibrary.Create(dxGetIconLibraryPath);
  APaths := TStringList.Create;
  try
    FillUsersIconLibraryPaths(APaths);
    for I := 0 to APaths.Count - 1 do
      dxIconLibrary.AddUserCollection(APaths.Names[I], APaths.ValueFromIndex[I]);
  finally
    APaths.Free;
  end;
  dxIconLibrary.Refresh;
end;

procedure DestroyIconLibrary;
begin
  FreeAndNil(dxIconLibrary);
end;

{ TdxSearchString }

function TdxSearchString.Check(const S: string): Boolean;
begin
  if DataAssigned then
    Result := Pos(Data, AnsiLowerCase(S)) > 0
  else
    Result := True;
end;

class function TdxSearchString.Create(const S: string): TdxSearchString;
begin
  Result.Data := AnsiLowerCase(S);
  Result.DataAssigned := S <> '';
end;

{ TdxImagePickerFormHelper }

destructor TdxImagePickerFormHelper.Destroy;
begin
  FreeAndNil(FImagePicker);
  inherited Destroy;
end;

function TdxImagePickerFormHelper.Execute(APicture: TPicture; AGraphicClass: TGraphicClass; AImportList: TStrings; APreferSmartImage,
  APreferPictureEdit: Boolean): Boolean;
begin
  ImagePicker.PreferSmartImage := APreferSmartImage;
  ImagePicker.GraphicClass := AGraphicClass;
  ImagePicker.ImportList := AImportList;
  ImagePicker.PreferPictureEdit := APreferPictureEdit;
  Result := ImagePicker.Execute(APicture);
end;

function TdxImagePickerFormHelper.Execute(AFiles: TStrings; const ASuggestedImageSize: TSize): Boolean;
begin
  Result := ImagePicker.Execute(AFiles, ASuggestedImageSize);
end;

function TdxImagePickerFormHelper.Execute(var AFileName: string): Boolean;
begin
  Result := ImagePicker.Execute(AFileName);
end;

function TdxImagePickerFormHelper.GetImageInfo(const AFileName: string; AImageInfo: TcxImageInfo): Boolean;
var
  ACollection, ACategory, AName, ADisplayName, ASize: string;
  AFontIconTag, AFontIconSource: string;
  ABraceInd: Integer;
  AStream: TStringStream;
begin
  if EndsText('.ico', AFileName) then
    Exit(False);
  if StartsText(sdxFontIconPrefix, AFileName) then
  begin
    if not (Copy(AFileName, Length(sdxFontIconPrefix) + 1, 1) = '{') then
      Exit(False);
    ABraceInd := Pos('}', AFileName);
    AFontIconTag := Copy(AFileName, Length(sdxFontIconPrefix) + 2, ABraceInd - Length(sdxFontIconPrefix) - 2);
    AFontIconSource := Copy(AFileName, ABraceInd + 1, Length(AFileName));
    AImageInfo.Reset;
    AImageInfo.ImageClass := TdxSmartImage;
    AStream := TStringStream.Create(AFontIconSource);
    try
      AImageInfo.Image.LoadFromStream(AStream);
    finally
      AStream.Free;
    end;
    AImageInfo.FileName := sdxFontIconPrefix + AFontIconTag;
    AImageInfo.Keywords := 'FontIcons;' + AFontIconTag;
    Result := True;
  end
  else
  begin
    AImageInfo.Reset;
    AImageInfo.ImageClass := TdxSmartImage;
    AImageInfo.Image.LoadFromFile(AFileName);
    Result := True;
    if TdxIconLibraryFileName.Parse(AFileName, ACollection, ACategory, AName, ADisplayName, ASize) then
    begin
      AImageInfo.FileName := TdxIconLibraryFileName.Build(ACollection, ACategory, AName, 0, 0, True);
      AImageInfo.Keywords := ACategory + PathSep + StringReplace(ADisplayName, '_', PathSep, [rfReplaceAll]);
    end
    else
      AImageInfo.FileName := AFileName;
  end;
end;

function TdxImagePickerFormHelper.GetImagePicker: TdxfmImagePicker;
begin
  if FImagePicker = nil then
    FImagePicker := TdxfmImagePicker.Create(nil);
  Result := FImagePicker;
end;

{ TdxLoadImagesTask }

constructor TdxLoadImagesTask.Create(ATarget: TdxIconLibraryGalleries; AImagesToLoad: TList);
begin
  FTargetGalleries := ATarget;
  FImagesToLoad := TList.Create;
  FImagesToLoad.Assign(AImagesToLoad);
  FLoadedImages := TThreadList.Create;
  FUpdateTimer := cxCreateTimer(TimerHandler);
end;

destructor TdxLoadImagesTask.Destroy;
begin
  FreeAndNil(FLoadedImages);
  FreeAndNil(FImagesToLoad);
  inherited;
end;

procedure TdxLoadImagesTask.Complete;
begin
  dxCallThreadMethod(SyncComplete, tmcmSync);
end;

procedure TdxLoadImagesTask.Execute;
var
  AImage: TdxIconLibraryImage;
  I: Integer;
begin
  for I := 0 to FImagesToLoad.Count - 1 do
  begin
    AImage := TdxIconLibraryImage(FImagesToLoad.List[I]);
    try
      AImage.LoadFromFile;
    except
    end;
    FLoadedImages.Add(AImage);
    if Canceled then Break;
  end;
end;

procedure TdxLoadImagesTask.SyncAssignImages;
var
  AIconLibraryImage: TdxIconLibraryImage;
  AList: TList;
  AContentType: TLibraryContentType;
  AErrorMessage: string;
begin
  AErrorMessage := '';
  AList := FLoadedImages.LockList;
  try
    if AList.Count > 0 then
    begin
      for AContentType:= Low(TLibraryContentType) to High(TLibraryContentType) do
        FTargetGalleries[AContentType].BeginUpdate;
      try
        while not Canceled and (AList.Count > 0) do
        begin
          AIconLibraryImage := TdxIconLibraryImage(AList.List[0]);
          try
            TdxGalleryControlItem(AIconLibraryImage.Tag).Glyph.Assign(AIconLibraryImage.Image);
          except
            on E: Exception do
            begin
              TdxGalleryControlItem(AIconLibraryImage.Tag).Glyph.Clear;
              if AErrorMessage <> '' then
                AErrorMessage := AErrorMessage + sLineBreak;
              if not (E is EdxException) then
                AErrorMessage := AErrorMessage + E.ClassName + ': ';
              AErrorMessage := AErrorMessage + E.Message + sLineBreak + AIconLibraryImage.Name;
            end;
          end;
          AIconLibraryImage.Image.Clear;
          AList.Delete(0);
        end;
      finally
        for AContentType:= Low(TLibraryContentType) to High(TLibraryContentType) do
          FTargetGalleries[AContentType].EndUpdate;
      end;
    end;
  finally
    FLoadedImages.UnlockList;
    if AErrorMessage <> '' then
      TdxUIThreadSyncService.EnqueueInvokeInUIThread(nil, procedure()
        begin
          raise EdxException.Create(AErrorMessage);
        end);
  end;
end;

procedure TdxLoadImagesTask.SyncComplete;
begin
  FreeAndNil(FUpdateTimer);

  if Canceled then
    SyncReleaseResources
  else
    SyncAssignImages;

  inherited Complete;
end;

procedure TdxLoadImagesTask.SyncReleaseResources;
var
  I: Integer;
begin
  with FLoadedImages.LockList do
  try
    for I := 0 to Count - 1 do
      TdxIconLibraryImage(List[I]).Image.Clear;
  finally
    FLoadedImages.UnlockList;
  end;
end;

procedure TdxLoadImagesTask.TimerHandler(Sender: TObject);
begin
  SyncAssignImages;
end;

{ TdxCustomPopulateHelper }

constructor TdxCustomPopulateHelper.Create(AImagePicker: TdxfmImagePicker);
begin
  inherited Create;
  FImagePicker := AImagePicker;
  FSelection := FImagePicker.gcSelection;
  FGalleries[lctRaster] := FImagePicker.gcIcons;
  FCollectionCheckList[lctRaster] := FImagePicker.clbCollection;
  FCategoryCheckList[lctRaster] := FImagePicker.clbCategories;
  FSizeCheckList[lctRaster] := FImagePicker.clbSize;
  FGalleryGroupSearch[lctRaster] := AddGalleryGroup(sdxGalleryGroupSearchResult, FGalleries[lctRaster], False, False);
  FGalleryGroupHidden[lctRaster] := AddGalleryGroup(sdxGalleryGroupHidden,       FGalleries[lctRaster], False, False);
  FFilterEdit[lctRaster] := FImagePicker.beFind;

  FGalleries[lctVector] := FImagePicker.gcIconsVector;
  FCollectionCheckList[lctVector] := FImagePicker.clbCollectionVector;
  FCategoryCheckList[lctVector] := FImagePicker.clbCategoriesVector;
  FSizeCheckList[lctVector] := nil;
  FGalleryGroupSearch[lctVector] := AddGalleryGroup(sdxGalleryGroupSearchResult, FGalleries[lctVector], False, False);
  FGalleryGroupHidden[lctVector] := AddGalleryGroup(sdxGalleryGroupHidden,       FGalleries[lctVector], False, False);
  FFilterEdit[lctVector] := FImagePicker.beFindVector;
end;

function TdxCustomPopulateHelper.AddGalleryGroup(const ACaption: string; AGallery: TdxGalleryControl; ReplaceExisting, AVisible: Boolean): TdxGalleryControlGroup;
var
  AGroupIndex: Integer;
begin
  if ReplaceExisting then
    AGroupIndex := GetIndexForGalleryGroup(ACaption, AGallery)
  else
    AGroupIndex := AGallery.Gallery.Groups.Count;
  Result := AGallery.Gallery.Groups.Add;
  Result.Index := AGroupIndex;
  Result.Visible := AVisible;
  Result.Caption := ACaption;
end;

procedure TdxCustomPopulateHelper.BeginUpdate;
var
  AContentType: TLibraryContentType;
begin
  for AContentType:= Low(TLibraryContentType) to High(TLibraryContentType) do
  begin
    FCollectionCheckList[AContentType].Items.BeginUpdate;
    FCategoryCheckList[AContentType].Items.BeginUpdate;
    if Assigned(FSizeCheckList[AContentType]) then
      FSizeCheckList[AContentType].Items.BeginUpdate;
    FGalleries[AContentType].BeginUpdate;
 end;
end;

procedure TdxCustomPopulateHelper.EndUpdate;
var
  AContentType: TLibraryContentType;
begin
  for AContentType:= Low(TLibraryContentType) to High(TLibraryContentType) do
  begin
    FCollectionCheckList[AContentType].Items.EndUpdate;
    FCategoryCheckList[AContentType].Items.EndUpdate;
    if Assigned(FSizeCheckList[AContentType]) then
      FSizeCheckList[AContentType].Items.EndUpdate;
    FGalleries[AContentType].EndUpdate;
  end;
end;

procedure TdxCustomPopulateHelper.Populate;
begin
  BeginUpdate;
  try
    PopulateCore;
  finally
    EndUpdate;
  end;
end;

function TdxCustomPopulateHelper.GetIconLibrary: TdxIconLibrary;
begin
  Result := dxIconLibrary;
end;

function TdxCustomPopulateHelper.GetIndexForGalleryGroup(const ANameItem: string; AGallery: TdxGalleryControl): Integer;
begin
  Result := 0;
  while (Result < AGallery.Gallery.Groups.Count) and (AnsiCompareStr(ANameItem, AGallery.Gallery.Groups[Result].Caption) > 0) do
    Inc(Result);
end;

function TdxCustomPopulateHelper.IsListBoxCheckedByText(ACheckListBox: TcxCheckListBox; const AText: string): Boolean;
var
  AIndex: Integer;
begin
  AIndex := ACheckListBox.Items.IndexOf(AText);
  Result := (AIndex > -1) and ACheckListBox.Items[AIndex].Checked;
end;

{ TdxPopulateContentHelper }

procedure TdxPopulateContentHelper.PopulateCore;
var
  iGroup, iCategory, iImage: Integer;
  AGalleryImage: TdxIconLibraryImage;
  ACollectionList, ACategoryList, ASizes: array[TLibraryContentType] of TStringList;
  I: Integer;
  AContentType: TLibraryContentType;
begin
  for AContentType:= Low(TLibraryContentType) to High(TLibraryContentType) do
  begin
    MarkItemsUnused(FCollectionCheckList[AContentType]);
    MarkItemsUnused(FCategoryCheckList[AContentType]);
    if Assigned(FSizeCheckList[AContentType]) then
      MarkItemsUnused(FSizeCheckList[AContentType]);

    ACollectionList[AContentType] := MakeSortedStringList;
    ACategoryList[AContentType] := MakeSortedStringList;
    ASizes[AContentType] := MakeSortedStringList;
  end;
  try
    for iGroup := 0 to IconLibrary.Count - 1 do
      for iCategory := 0 to IconLibrary[iGroup].Count - 1 do
        for iImage := 0 to IconLibrary[iGroup][iCategory].Count - 1 do
        begin
          AGalleryImage := IconLibrary[iGroup][iCategory][iImage];
          if not FileExists(AGalleryImage.FileName) then
            Continue;
          AContentType := GetImageContentType(AGalleryImage);
          ACollectionList[AContentType].Add(AGalleryImage.CollectionName);
          ACategoryList[AContentType].Add(AGalleryImage.CategoryName);
          if Assigned(ASizes[AContentType]) then
            ASizes[AContentType].Add(AGalleryImage.ImageSizeAsString);
          AddGalleryItem(AGalleryImage);
        end;
    for AContentType:= Low(TLibraryContentType) to High(TLibraryContentType) do
    begin
      for I := 0 to ACollectionList[AContentType].Count - 1 do
        AddCheckListBoxItem(FCollectionCheckList[AContentType], ACollectionList[AContentType][I], (dxIconLibraryCollections[AContentType].IndexOf(ACollectionList[AContentType][I]) <> -1));

      for I := 0 to ACategoryList[AContentType].Count - 1 do
      begin
        AddCheckListBoxItem(FCategoryCheckList[AContentType], ACategoryList[AContentType][I], (dxIconLibraryCategories[AContentType].IndexOf(ACategoryList[AContentType][I]) <> -1));
        AddGalleryGroup(ACategoryList[AContentType][I], FGalleries[AContentType], True, True);
      end;

      if Assigned(FSizeCheckList[AContentType]) then
        for I := 0 to ASizes[AContentType].Count - 1 do
          AddCheckListBoxItem(FSizeCheckList[AContentType], ASizes[AContentType][I], (dxIconLibrarySizes.IndexOf(ASizes[AContentType][I]) <> -1));
    end;
  finally
    for AContentType:= Low(TLibraryContentType) to High(TLibraryContentType) do
    begin
      DeleteUnusedItems(FCollectionCheckList[AContentType]);
      DeleteUnusedItems(FCategoryCheckList[AContentType]);
      if Assigned(FSizeCheckList[AContentType]) then
        DeleteUnusedItems(FSizeCheckList[AContentType]);
      ACollectionList[AContentType].Free;
      ACategoryList[AContentType].Free;
      ASizes[AContentType].Free;
    end;
  end;
end;

function TdxPopulateContentHelper.AddCheckListBoxItem(ACheckListBox: TcxCheckListBox; const AText: string; AChecked: Boolean): Boolean;
var
  AItem: TcxCheckListBoxItem;
  AItemIndex: Integer;
begin
  Result := False;
  if not FindCheckListBoxItem(ACheckListBox, AText, AItem) then
  begin
    AItemIndex := GetIndexForCheckListItem(ACheckListBox, AText);

    AItem := ACheckListBox.Items.Add;
    AItem.Index := AItemIndex;
    AItem.Text := AText;
    AItem.Checked := AChecked;
    Result := True;
  end;
  AItem.Tag := TAG_USED;
end;

procedure TdxPopulateContentHelper.AddGalleryItem(AImageItem: TdxIconLibraryImage);
var
  AGalleryItem: TdxGalleryControlItem;
begin
  if AImageItem.Tag = 0 then
  begin
    AGalleryItem := TdxGalleryControlItem.Create(nil);
    AImageItem.Tag := TdxNativeInt(AGalleryItem);
    AGalleryItem.Caption := AImageItem.DisplayName;
    AGalleryItem.Hint := MakeHint(AImageItem);
    AGalleryItem.Tag := TdxNativeInt(AImageItem);
  end;
end;

procedure TdxPopulateContentHelper.DeleteUnusedItems(ACheckListBox: TcxCheckListBox);
var
  AItem: TcxCheckListBoxItem;
  I: Integer;
begin
  ACheckListBox.Items.BeginUpdate;
  try
    for I := ACheckListBox.Items.Count - 1 downto 0 do
    begin
      AItem := ACheckListBox.Items[I];
      if AItem.Tag = TAG_UNUSED then
        AItem.Free;
    end;
  finally
    ACheckListBox.Items.EndUpdate;
  end;
end;

function TdxPopulateContentHelper.FindCheckListBoxItem(
  ACheckListBox: TcxCheckListBox; const AText: string; out AItem: TcxCheckListBoxItem): Boolean;
var
  I: Integer;
begin
  for I := 0 to ACheckListBox.Items.Count - 1 do
  begin
    AItem := ACheckListBox.Items[I];
    if AItem.Text = AText then
      Exit(True);
  end;
  Result := False;
end;

function TdxPopulateContentHelper.MakeHint(AImageItem: TdxIconLibraryImage): string;
begin
  Result := Format(sdxGalleryItemHint, [AImageItem.DisplayName, AImageItem.CategoryName, AImageItem.CollectionName, AImageItem.Name]);
end;

procedure TdxPopulateContentHelper.MarkItemsUnused(ACheckListBox: TcxCheckListBox);
var
  I: Integer;
begin
  for I := 0 to ACheckListBox.Items.Count - 1 do
    ACheckListBox.Items[I].Tag := TAG_UNUSED;
end;

function TdxPopulateContentHelper.GetIndexForCheckListItem(ACheckListBox: TcxCheckListBox; const AText: string): Integer;
begin
  Result := 0;
  while (Result < ACheckListBox.Items.Count) and (AnsiCompareStr(AText, ACheckListBox.Items[Result].Text) > 0) do
    Inc(Result);
end;

{ TdxPopulateGalleryHelper }

constructor TdxPopulateGalleryHelper.Create(AImagePicker: TdxfmImagePicker);
begin
  inherited Create(AImagePicker);
  FImagesToLoad := TList.Create;
end;

destructor TdxPopulateGalleryHelper.Destroy;
begin
  FIsDestroying := True;
  StopLoadImagesThread;
  DestroyGalleryItems;
  FreeAndNil(FImagesToLoad);
  inherited Destroy;
end;

procedure TdxPopulateGalleryHelper.PopulateCore;
var
  AGroup: TdxGalleryControlGroup;
  ASearchString: TdxSearchString;
  I: Integer;
  AContentType: TLibraryContentType;
begin
  StopLoadImagesThread;

  FMaxSize := TdxPopulateContentHelper.DefaultImageSize;
  for AContentType := Low(TLibraryContentType) to High(TLibraryContentType) do
  begin
    ASearchString := TdxSearchString.Create(FFilterEdit[AContentType].Text);
    for I := 0 to FGalleries[AContentType].Gallery.Groups.Count - 1 do
      FGalleries[AContentType].Gallery.Groups[I].Visible := False;

    for I := 0 to IconLibrary.Count - 1 do
      PopulateGalleryGroups(IconLibrary[I], AContentType, ASearchString);

    for I := 0 to FGalleries[AContentType].Gallery.Groups.Count - 1 do
    begin
      AGroup := FGalleries[AContentType].Gallery.Groups[I];
      AGroup.Visible := (AGroup <> FGalleryGroupHidden[AContentType]) and (AGroup.ItemCount > 0);
    end;
  end;
  StartLoadImagesThread;
end;

procedure TdxPopulateGalleryHelper.LoadImagesTaskComplete;
begin
  FLoadImagesTaskHandle := 0;
end;

procedure TdxPopulateGalleryHelper.StartLoadImagesThread;
begin
  if FLoadImagesTaskHandle = 0 then
    FLoadImagesTaskHandle := dxTasksDispatcher.Run(TdxLoadImagesTask.Create(FGalleries, FImagesToLoad), LoadImagesTaskComplete, tmcmSync);
  FImagesToLoad.Clear;
end;

procedure TdxPopulateGalleryHelper.StopLoadImagesThread;
begin
  if FLoadImagesTaskHandle <> 0 then
    dxTasksDispatcher.Cancel(FLoadImagesTaskHandle, True);
end;

procedure TdxPopulateGalleryHelper.WaitForLoadImagesThread;
begin
  if FLoadImagesTaskHandle <> 0 then
    dxTasksDispatcher.WaitFor(FLoadImagesTaskHandle);
end;

procedure TdxPopulateGalleryHelper.DestroyGalleryItems(ASet: TdxIconLibrarySet);
var
  I: Integer;
begin
  for I := 0 to ASet.Count - 1 do
    DestroyGalleryItems(ASet.Items[I]);
end;

procedure TdxPopulateGalleryHelper.DestroyGalleryItem(AImage: TdxIconLibraryImage);
var
  AItem: TdxGalleryItem;
begin
  if not FIsDestroying then
  begin
    Selection.BeginUpdate;
    try
      while True do
      begin
        AItem := Selection.Gallery.FindItemByTag(TdxNativeInt(AImage));
        if AItem <> nil then
          AItem.Free
        else
          Break;
      end;
    finally
      Selection.EndUpdate;
    end;
  end;

  GetGalleryItem(AImage).Free;
  AImage.Tag := 0;
end;

procedure TdxPopulateGalleryHelper.DestroyGalleryItems(ACategory: TdxIconLibraryCategory);
var
  I: Integer;
begin
  for I := 0 to ACategory.Count - 1 do
    DestroyGalleryItem(ACategory.Items[I]);
end;

procedure TdxPopulateGalleryHelper.DestroyGalleryItems;
var
  I : Integer;
begin
  for I := 0 to IconLibrary.Count - 1 do
    DestroyGalleryItems(IconLibrary.Items[I]);
end;

function TdxPopulateGalleryHelper.GetGalleryItem(AIconLibraryImage: TdxIconLibraryImage): TdxGalleryControlItem;
begin
  Result := TdxGalleryControlItem(AIconLibraryImage.Tag);
end;

function TdxPopulateGalleryHelper.GetIndexForItem(AGroup: TdxGalleryControlGroup; const ANameItem: string): Integer;
var
  ACompareResult: Integer;
  AHigh: Integer;
  ALow: Integer;
  AMiddle: Integer;
begin
  if AGroup.ItemCount = 0 then
    Exit(0);

  ALow := 0;
  AHigh := AGroup.ItemCount - 1;
  while ALow <= AHigh do
  begin
    AMiddle := ALow + (AHigh - ALow) shr 1;
    ACompareResult := AnsiCompareText(AGroup.Items[AMiddle].Caption, ANameItem);
    if ACompareResult < 0 then
      ALow := AMiddle + 1
    else
      AHigh := AMiddle - 1;
  end;
  Result := ALow;
end;

procedure TdxPopulateGalleryHelper.PopulateGalleryGroups(ACollectionItem: TdxIconLibrarySet; AContentType: TLibraryContentType; const ASearchString: TdxSearchString);
var
  ACategoryItem: TdxIconLibraryCategory;
  AGroup: TdxGalleryControlGroup;
  AnItem: TdxGalleryControlItem;
  AIsCategoryVisible: Boolean;
  AIsCollectionVisible: Boolean;
  I, J: Integer;
begin
  AIsCollectionVisible := IsListBoxCheckedByText(FCollectionCheckList[AContentType], ACollectionItem.DisplayName);
  for I := 0 to ACollectionItem.Count - 1 do
  begin
    ACategoryItem := ACollectionItem[I];
    AIsCategoryVisible := AIsCollectionVisible and IsListBoxCheckedByText(FCategoryCheckList[AContentType], ACategoryItem.DisplayName);
    if AIsCategoryVisible then
    begin
      if ASearchString.DataAssigned then
        AGroup := FGalleryGroupSearch[AContentType]
      else
        if not FGalleries[AContentType].Gallery.Groups.FindByCaption(ACategoryItem.DisplayName, AGroup) then
          raise EdxException.CreateFmt('Internal Error: %s group was not found', [ACategoryItem.DisplayName]);
      PopulateGalleryImages(AGroup, ACategoryItem, AContentType, ASearchString);
    end
    else
      for J := 0 to ACategoryItem.Count - 1 do
        if GetImageContentType(ACategoryItem[J]) = AContentType then
        begin
          AnItem := GetGalleryItem(ACategoryItem[J]);
          if Assigned(AnItem) then
            AnItem.Group := FGalleryGroupHidden[AContentType];
        end;
  end;
end;

procedure TdxPopulateGalleryHelper.PopulateGalleryImages(AGroup: TdxGalleryControlGroup; ACategory: TdxIconLibraryCategory;
  AContentType: TLibraryContentType; const ASearchString: TdxSearchString);
var
  AGalleryItem: TdxGalleryControlItem;
  AImageItem: TdxIconLibraryImage;
  I: Integer;
begin
  for I := 0 to ACategory.Count - 1 do
  if (GetImageContentType(ACategory[I]) = AContentType) then
  begin
    AImageItem := ACategory[I];
    AGalleryItem := GetGalleryItem(AImageItem);
    if (not Assigned(FSizeCheckList[AContentType]) or IsListBoxCheckedByText(FSizeCheckList[AContentType], AImageItem.ImageSizeAsString))
      and ASearchString.Check(AImageItem.Name) then
    begin
      AGalleryItem.Group := AGroup;
      AGalleryItem.Index := GetIndexForItem(AGroup, AImageItem.DisplayName);
      AGalleryItem.ImageIndex := NoPreviewImageIndex;
      FMaxSize := cxSizeMax(FMaxSize, AImageItem.ImageSize);
      if AGalleryItem.Glyph.Empty then
        FImagesToLoad.Add(AImageItem);
    end
    else
      AGalleryItem.Group := FGalleryGroupHidden[AContentType];
  end;
end;

{ TdxfmImagePicker }

function TdxfmImagePicker.Execute(var AFileName: string): Boolean;
begin
  Result := False;
  MultiSelect := False;
  PopulateContent;
  PopulateGallery;
  CorrectCheckBoxSizes;
  if Locate(AFileName) then
  begin
    Result := (ShowModal = mrOk) and HasSelection;
    if Result then
    begin
      if ActiveGallery = gcIconsFont then
        AFileName := GetFontIconFileName(ActiveGallery.Gallery.GetCheckedItem)
      else
        AFileName := GetIconLibraryImage(ActiveGallery.Gallery.GetCheckedItem).FileName;
    end;
    ClearSelection;
  end
  else
    dxMessageDlg(sdxLocateFailed, mtWarning, [mbOk], 0);
end;

function TdxfmImagePicker.Execute(const AFiles: TStrings; const ASuggestedImageSize: TSize): Boolean;
var
  I: Integer;
  AnImage: TdxIconLibraryImage;
begin
  MultiSelect := True;
  PopulateContent;
  SelectSize(ASuggestedImageSize);
  PopulateGallery;
  CorrectCheckBoxSizes;
  if (FLastTabSheetIndex <> -1) and not PreferPictureEdit then
    lgMainPageControl.ItemIndex := FLastTabSheetIndex
  else
    lgMainPageControl.ItemIndex := lgtsDXVectorImageGallery.Index;
  Result := (ShowModal = mrOk) and HasSelection;
  if Result then
  begin
    AFiles.Capacity := Max(AFiles.Capacity, AFiles.Count + gcSelectionGroup.ItemCount);
    for I := 0 to gcSelectionGroup.ItemCount - 1 do
    begin
      AnImage := GetIconLibraryImage(gcSelectionGroup.Items[I]);
      if Assigned(AnImage) then
        AFiles.Add(AnImage.FileName)
      else if Supports(gcSelectionGroup.Items[I].Glyph, IdxVectorImage) then
        AFiles.Add(GetFontIconFileName(gcSelectionGroup.Items[I]))
      else
        AFiles.Add('');
    end;
  end;

  ClearSelection;
end;

procedure TdxfmImagePicker.Initialize;
begin
  inherited Initialize;
  MultiSelect := False;
  PopulateContent;
  PopulateGallery;
  CorrectCheckBoxSizes;
end;

procedure TdxfmImagePicker.lgMainPageControlTabChanged(Sender: TObject);
begin
  inherited;
  UpdateCurrentTab;
end;

procedure TdxfmImagePicker.SaveSettings(APicture: TPicture);
var
  ACheckedItem: TdxGalleryControlItem;
begin
  if lgMainPageControl.Items[lgMainPageControl.ItemIndex] = lgtsDXRasterImageGallery then
  begin
    ACheckedItem := gcIcons.Gallery.GetCheckedItem;
    if (ACheckedItem = nil) or not ACheckedItem.Group.Visible then
      Exit;
    SetImage(ACheckedItem.Glyph);
  end
  else if lgMainPageControl.Items[lgMainPageControl.ItemIndex] = lgtsDXVectorImageGallery then
  begin
    ACheckedItem := gcIconsVector.Gallery.GetCheckedItem;
    if (ACheckedItem = nil) or not ACheckedItem.Group.Visible then
      Exit;
    SetImage(ACheckedItem.Glyph);
  end
  else if lgMainPageControl.Items[lgMainPageControl.ItemIndex] = lgtsFontIcons then
  begin
    ACheckedItem := gcIconsFont.Gallery.GetCheckedItem;
    if (ACheckedItem = nil) or not ACheckedItem.Group.Visible then
      Exit;
    SetImage(ACheckedItem.Glyph);
  end;
  inherited;
end;

procedure TdxfmImagePicker.Select(AList: TcxCheckListBox; const ANames: array of string; ADropPreviousSelection: Boolean);
var
  AItem: TcxCheckListBoxItem;
  I: Integer;
begin
  AList.Items.BeginUpdate;
  try
    for I := 0 to AList.Count - 1 do
    begin
      AItem := AList.Items[I];
      AItem.Checked := not ADropPreviousSelection and AItem.Checked or Contains(AItem.Text, ANames);
    end;
  finally
    AList.Items.EndUpdate;
  end;
end;

procedure TdxfmImagePicker.SelectSize(const ASize: string);
var
  AItem: TcxCheckListBoxItem;
  I: Integer;
begin
  clbSize.Items.BeginUpdate;
  try
    for I := 0 to clbSize.Count - 1 do
    begin
      AItem := clbSize.Items[I];
      AItem.Checked := (dxIconLibrarySizes.IndexOf(AItem.Text) <> -1) or (AItem.Text = ASize);
    end;
  finally
    clbSize.Items.EndUpdate;
  end;
end;

procedure TdxfmImagePicker.SelectSize(const ASize: TSize);
begin
  if cxSizeIsEmpty(ASize) then
    SelectSize(EmptyStr)
  else
    SelectSize(cxSizeToString(ASize));
end;

procedure TdxfmImagePicker.alActionsUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  actRemoveCollectionRaster.Enabled := dxIconLibrary.IsUserCollection(GetSelectedItemText(clbCollection));
  actRemoveCollectionVector.Enabled := dxIconLibrary.IsUserCollection(GetSelectedItemText(clbCollectionVector));
end;

procedure TdxfmImagePicker.AddToSelection(AImageItem: TdxGalleryControlItem; AFromLibrary: Boolean = True);
var
  AItem: TdxGalleryControlItem;
begin
  gcSelection.BeginUpdate;
  try
    AItem := gcSelectionGroup.Items.Add;
    AItem.Caption := AImageItem.Caption;
    AItem.Hint := AImageItem.Hint;
    AItem.Glyph.Assign(AImageItem.Glyph);
    if AFromLibrary then
      AItem.Tag := AImageItem.Tag;
  finally
    gcSelection.EndUpdate;
  end;
end;

function TdxfmImagePicker.GetActiveFindEdit: TcxButtonEdit;
begin
  if lgMainPageControl.ItemIndex = lgtsFontIcons.Index then
    Result := beFindFontIcons
  else if lgMainPageControl.ItemIndex = lgtsDXVectorImageGallery.Index then
    Result := beFindVector
  else if lgMainPageControl.ItemIndex = lgtsDXRasterImageGallery.Index then
    Result := beFind
  else
    Result := nil;
end;

function TdxfmImagePicker.GetActiveGallery: TdxGalleryControl;
begin
  if lgMainPageControl.ItemIndex = lgtsFontIcons.Index then
    Result := gcIconsFont
  else if lgMainPageControl.ItemIndex = lgtsDXVectorImageGallery.Index then
    Result := gcIconsVector
  else if lgMainPageControl.ItemIndex = lgtsDXRasterImageGallery.Index then
    Result := gcIcons
  else
    Result := nil;
end;

function TdxfmImagePicker.GetFontIconFileName(AGalleryControlItem: TdxGalleryControlItem): string;
var
  AStream: TStringStream;
begin
  AStream := TStringStream.Create;
  try
    AGalleryControlItem.Glyph.SaveToStreamByCodec(AStream, TdxSVGImageCodec);
    Result := sdxFontIconPrefix + '{' + AGalleryControlItem.Hint + '}' + AStream.DataString
  finally
    AStream.Free;
  end;
end;

function TdxfmImagePicker.GetIconLibraryImage(AGalleryControlItem: TdxGalleryControlItem): TdxIconLibraryImage;
begin
  Result := TdxIconLibraryImage(AGalleryControlItem.Tag);
end;

function TdxfmImagePicker.HasSelectedButNotAddedItems: Boolean;
var
  AList: TList;
  I: Integer;
begin
  if MultiSelect then
  begin
    AList := TList.Create;
    try
      ActiveGallery.Gallery.GetCheckedItems(AList);
      for I := 0 to AList.Count - 1 do
      begin
        if gcSelection.Gallery.FindItemByTag(TdxGalleryControlItem(AList.List[I]).Tag) = nil then
          Exit(True);
      end;
    finally
      AList.Free;
    end;
  end;
  Result := False;
end;

function TdxfmImagePicker.HasSelection: Boolean;
begin
  if MultiSelect then
    Result := gcSelectionGroup.ItemCount > 0
  else
    Result := ActiveGallery.Gallery.GetCheckedItem <> nil;
end;

procedure TdxfmImagePicker.OnChanged(Sender: TdxIconLibraryCollection);
begin
  PopulateContent;
  PopulateGallery;
  FPopulateGalleryHelper.EndUpdate;
  CorrectCheckBoxSizes;
  HideHourglassCursor;
end;

procedure TdxfmImagePicker.OnChanging(Sender: TdxIconLibraryCollection);
begin
  ShowHourglassCursor;
  FPopulateGalleryHelper.BeginUpdate;
end;

procedure TdxfmImagePicker.OnRemoving(Sender: TdxIconLibraryCustomObject);
begin
  if Sender is TdxIconLibrarySet then
    FPopulateGalleryHelper.DestroyGalleryItems(TdxIconLibrarySet(Sender))
  else if Sender is TdxIconLibraryCategory then
    FPopulateGalleryHelper.DestroyGalleryItems(TdxIconLibraryCategory(Sender))
  else if Sender is TdxIconLibraryImage then
    FPopulateGalleryHelper.DestroyGalleryItem(TdxIconLibraryImage(Sender));
end;

procedure TdxfmImagePicker.ClearSelection;
begin
  gcSelectionGroup.Items.Clear;
  UpdateGalleryItemsSelection(gcIcons, False);
end;

procedure TdxfmImagePicker.CorrectCheckBoxSizes;
begin
  clbCollection.Height := clbCollection.GetHeight(IfThen(clbCollection.Items.Count > 8, 8, clbCollection.Items.Count));
  clbCollectionVector.Height := clbCollectionVector.GetHeight(IfThen(clbCollectionVector.Items.Count > 8, 8, clbCollectionVector.Items.Count));
  clbSize.Height := clbSize.GetHeight(IfThen(clbSize.Items.Count > 5, 5, clbSize.Items.Count));
end;

procedure TdxfmImagePicker.dxFormClose(Sender: TObject; var Action: TCloseAction);
  procedure UpdateListValues(AList: TStringList; ACheckListbox: TcxCheckListBox);
  var
    I: Integer;
  begin
    AList.Clear;
    for I := 0 to ACheckListbox.Count - 1 do
      if ACheckListbox.Items[I].Checked then
        AList.Add(ACheckListbox.Items[I].Text);
  end;

begin
  inherited;
  if not PreferPictureEdit then
    FLastTabSheetIndex := lgMainPageControl.ItemIndex;
  UpdateListValues(dxIconLibraryCategories[lctRaster], clbCategories);
  UpdateListValues(dxIconLibraryCategories[lctVector], clbCategoriesVector);
  SaveIconLibrarySettings(sdxIconLibraryCategories, dxIconLibraryCategories[lctRaster].Text);
  SaveIconLibrarySettings(sdxIconLibraryCategoriesVector, dxIconLibraryCategories[lctVector].Text);
end;

function TdxfmImagePicker.Locate(const AFileName: string): Boolean;
var
  ACollection, ACategory, AName, ADisplayName, ASize: string;
begin
  Result := TdxIconLibraryFileName.Parse(AFileName, ACollection, ACategory,
    AName, ADisplayName, ASize) and Locate(ACollection, ACategory, AName, ASize);
end;

procedure TdxfmImagePicker.LoadSettings(APicture: TPicture);
begin
  inherited;
  if PreferPictureEdit then 
    lgMainPageControl.ItemIndex := lgtsPictureEditor.Index
  else if FLastTabSheetIndex <> -1 then
    lgMainPageControl.ItemIndex := FLastTabSheetIndex;
end;

function TdxfmImagePicker.Locate(const ACollection, ACategory, AName, ASize: string): Boolean;
var
  AItem: TdxGalleryControlItem;
begin
  AItem := LocateItem(ACollection, ACategory, AName, ASize);
  if AItem = nil then
  begin
    Inc(FPopulateGalleryLockCount);
    try
      beFind.EditValue := '';
      Select(clbCollection, [ACollection], True);
      Select(clbCategories, [ACategory], False);
      SelectSize(ASize);
      beFindVector.EditValue := '';
      Select(clbCollectionVector, [ACollection], True);
      Select(clbCategoriesVector, [ACategory], False);
    finally
      Dec(FPopulateGalleryLockCount);
      PopulateGallery;
    end;
    AItem := LocateItem(ACollection, ACategory, AName, ASize);
  end;

  Result := AItem <> nil;
  if Result then
  begin
    if TdxGalleryControlItemAccess(AItem).GalleryControl = gcIcons then
      lgMainPageControl.ItemIndex := lgtsDXRasterImageGallery.Index
    else if TdxGalleryControlItemAccess(AItem).GalleryControl = gcIconsVector then
      lgMainPageControl.ItemIndex := lgtsDXVectorImageGallery.Index
    else if TdxGalleryControlItemAccess(AItem).GalleryControl = gcIconsFont then
      lgMainPageControl.ItemIndex := lgtsFontIcons.Index;
    UpdateGalleryItemsSelection(ActiveGallery, False);
    ActiveGallery.MakeItemVisible(AItem);
    AItem.Checked := True;
  end;
end;

function TdxfmImagePicker.LocateItem(const ACollection, ACategory, AName, ASize: string): TdxGalleryControlItem;
var
  AGroup: TdxGalleryControlGroup;
  AGroupIndex: Integer;
  AImage: TdxIconLibraryImage;
  AItemIndex: Integer;
  AGalleries: array [0..1] of TdxGalleryControl;
  I: Integer;
begin
  AGalleries[0] := gcIcons;
  AGalleries[1] := gcIconsVector;
  for I := Low(AGalleries) to High(AGalleries) do
    for AGroupIndex := 0 to AGalleries[I].Gallery.Groups.Count - 1 do
    begin
      AGroup := AGalleries[I].Gallery.Groups[AGroupIndex];
      if AGroup.Visible then
        for AItemIndex := 0 to AGroup.Items.Count - 1 do
        begin
          AImage := GetIconLibraryImage(AGroup.Items[AItemIndex]);
          if dxSameText(AImage.DisplayName, AName) and
            dxSameText(AImage.CategoryName, ACategory) and
            dxSameText(AImage.CollectionName, ACollection)
          then
            Exit(AGroup.Items[AItemIndex]);
        end;
    end;
  Result := nil;
end;

procedure TdxfmImagePicker.PopulateContent;
begin
  with TdxPopulateContentHelper.Create(Self) do
  try
    Populate;
  finally
    Free;
  end;
end;

procedure TdxfmImagePicker.PopulateGallery;
begin
  if FPopulateGalleryLockCount = 0 then
    FPopulateGalleryHelper.Populate;
end;

procedure TdxfmImagePicker.SetMultiSelect(AValue: Boolean);
begin
  FMultiSelect := AValue;
  lgtsPictureEditor.Visible := not MultiSelect;
  liSelection.Visible := MultiSelect;
  if MultiSelect then
  begin
    gcIcons.OptionsBehavior.ItemCheckMode := icmMultiple;
    gcIcons.DragMode := TDragMode.dmAutomatic;
    gcIconsVector.OptionsBehavior.ItemCheckMode := icmMultiple;
    gcIconsVector.DragMode := TDragMode.dmAutomatic;
    gcIconsFont.OptionsBehavior.ItemCheckMode := icmMultiple;
    gcIconsFont.DragMode := TDragMode.dmAutomatic;
  end
  else
  begin
    gcIcons.OptionsBehavior.ItemCheckMode := icmSingleRadio;
    gcIcons.DragMode := TDragMode.dmManual;
    gcIconsVector.OptionsBehavior.ItemCheckMode := icmSingleRadio;
    gcIconsVector.DragMode := TDragMode.dmManual;
    gcIconsFont.OptionsBehavior.ItemCheckMode := icmSingleRadio;
    gcIconsFont.DragMode := TDragMode.dmManual;
  end;
end;

procedure TdxfmImagePicker.SetSelectedFontIconsColor(const AColorName: string);
var
  AChecked: TObjectList;
  AnItem: TdxGalleryControlItem;
  ASvgBuilder: TdxFontIconSvgBuilder;
  ASvgImage: TdxSvgImage;
  I: Integer;
begin
  AChecked := TObjectList.Create(False);
  ASvgBuilder := TdxFontIconSvgBuilder.Create;
  try
    ASvgBuilder.ColorName := AColorName;
    gcIconsFont.Gallery.GetCheckedItems(AChecked);
    if AChecked.Count = 0 then
      gcIconsFont.Gallery.GetAllItems(AChecked);
    gcIconsFont.BeginUpdate;
    try
      for I := 0 to AChecked.Count - 1 do
      begin
        AnItem := TdxGalleryControlItem(AChecked.List[I]);
        ASvgImage := ASvgBuilder.Build(AnItem.Tag);
        try
          AnItem.Glyph.Assign(ASvgImage);
        finally
          ASvgImage.Free;
        end;
      end;
    finally
      gcIconsFont.EndUpdate;
    end;
  finally
    AChecked.Free;
    ASvgBuilder.Free;
  end;
end;

procedure TdxfmImagePicker.UpdateGalleryItemsSelection(AGallery: TdxGalleryControl; ASelect: Boolean);
var
  I: Integer;
begin
  AGallery.BeginUpdate;
  try
    for I := 0 to AGallery.Gallery.Groups.Count - 1 do
      UpdateGalleryItemsSelection(AGallery.Gallery.Groups[I], ASelect);
  finally
    AGallery.EndUpdate;
  end;
end;

procedure TdxfmImagePicker.UpdateCurrentTab;
begin
  if lgMainPageControl.Items[lgMainPageControl.ItemIndex] = lgtsDXRasterImageGallery then
    ActiveControl := gcIcons
  else if lgMainPageControl.Items[lgMainPageControl.ItemIndex] = lgtsDXVectorImageGallery then
    ActiveControl := gcIconsVector
  else if lgMainPageControl.Items[lgMainPageControl.ItemIndex] = lgtsFontIcons then
  begin
    ActiveControl := gcIconsFont;
    if not FFontIconsPopulated then
    begin
      TdxFontIconsGalleryLoader.Populate(gcIconsFont);
      FFontIconsPopulated := True;
    end;
  end;
end;

procedure TdxfmImagePicker.UpdateGalleryItemsSelection(AGroup: TdxGalleryControlGroup; ASelect: Boolean);
var
  I: Integer;
begin
  if (AGroup <> nil) and (AGroup.Visible or not ASelect) then
  begin
    TdxGalleryControlGroupAccess(AGroup).GalleryControl.BeginUpdate;
    try
      AGroup.Items.BeginUpdate;
      try
        for I := 0 to AGroup.ItemCount - 1 do
          AGroup.Items[I].Checked := ASelect;
      finally
        AGroup.Items.EndUpdate(False);
      end;
    finally
      TdxGalleryControlGroupAccess(AGroup).GalleryControl.EndUpdate;
    end;
  end;
end;

procedure TdxfmImagePicker.UpdateLibrarySetting(const ASettingName, AChangedValue: string; ANewState: TcxCheckBoxState; ASettings: TStringList);
var
  AValueInd: Integer;
begin
  case ANewState of
    cbsUnchecked:
      begin
        AValueInd := ASettings.IndexOf(AChangedValue);
        if AValueInd <> -1 then
          ASettings.Delete(AValueInd);
      end;
    cbsChecked:
      ASettings.Add(AChangedValue);
  end;
  SaveIconLibrarySettings(ASettingName, ASettings.Text);
end;

procedure TdxfmImagePicker.UpdateSelectionBoxSize;
var
  AGallery: TdxGalleryControlAccess;
begin
  AGallery := TdxGalleryControlAccess(gcSelection);
  if AGallery.ViewInfo.RowCount > 0 then
    AGallery.Height := cxMarginsHeight(AGallery.ViewInfo.ContentOffset) +
      AGallery.BorderSize * 2 + cxRectHeight(AGallery.ViewInfo.ContentBounds) -
      AGallery.ViewInfo.ItemSize.cy * Max(AGallery.ViewInfo.RowCount - 2, 0);
end;

procedure TdxfmImagePicker.FormCreate(Sender: TObject);
begin
  inherited;
  FLastTabSheetIndex := -1;
  FPopulateGalleryHelper := TdxPopulateGalleryHelper.Create(Self);

  clbSize.InnerCheckListBox.MultiSelect := True;
  clbCollection.InnerCheckListBox.MultiSelect := True;
  clbCategories.InnerCheckListBox.MultiSelect := True;
  clbCollectionVector.InnerCheckListBox.MultiSelect := True;
  clbCategoriesVector.InnerCheckListBox.MultiSelect := True;

  dxIconLibrary.Listeners.Add(Self);
  UpdateCurrentTab;
  UpdateSelectionBoxSize;
  lgtsFontIcons.Visible := IsWin10OrLater;
end;

procedure TdxfmImagePicker.FormDestroy(Sender: TObject);
begin
  dxIconLibrary.Listeners.Remove(Self);
  FreeAndNil(FPopulateGalleryHelper);
  inherited;
end;

procedure TdxfmImagePicker.beFindPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
begin
  ActiveFindEdit.Text := '';
end;

procedure TdxfmImagePicker.beFindPropertiesChange(Sender: TObject);
const
  PopulateModeToImageIndex: array[Boolean] of Integer = (0, 1);
begin
  ActiveFindEdit.Properties.Buttons[0].ImageIndex := PopulateModeToImageIndex[ActiveFindEdit.Text <> ''];
  tmrSearchInGallery.Enabled := False;
  tmrSearchInGallery.Enabled := True;
end;

procedure TdxfmImagePicker.beFontIconsFindProperties(Sender: TObject; AButtonIndex: Integer);
begin
  ActiveFindEdit.Text := '';
end;

procedure TdxfmImagePicker.beFontIconsFindPropertiesChange(Sender: TObject);
var
  I, J: Integer;
  L: TList;
  ASearchString: string;
  AItem: TdxGalleryControlItem;
  ATags: TArray<string>;
  AHidden: Boolean;
begin
  ASearchString := Trim(beFindFontIcons.Text);
  L := TList.Create;
  gcIconsFont.BeginUpdate;
  try
    gcIconsFont.Gallery.GetAllItems(L);
    for I := 0 to L.Count - 1 do
    begin
      AItem := TdxGalleryControlItem(L[I]);
      if ASearchString = '' then
        AHidden := False
      else
      begin
        if not TdxFontIconTags.Map.TryGetValue(AItem.Tag, ATags) then
          ATags := TArray<string>.Create(TdxFontIconsGalleryLoader.DefaultCaption + AItem.Tag.ToString);
        if Length(ATags) = 1 then
          AHidden := not TdxStringHelper.StartsWith(ATags[0], ASearchString)
        else
        begin
          AHidden := True;
          for J := 1 to High(ATags) do
            if TdxStringHelper.StartsWith(ATags[J], ASearchString) then
            begin
              AHidden := False;
              Break;
            end;
        end;
      end;
      if AHidden then
        AItem.Group := FontIconsHiddenGroup
      else
        AItem.Group := FontItemsDefaultGroup;
    end;
  finally
    L.Free;
    gcIconsFont.EndUpdate;
  end;
  beFindFontIcons.Properties.Buttons[0].ImageIndex := Ord(ASearchString <> '');
end;

procedure TdxfmImagePicker.btnColorClick(Sender: TObject);
const
  ColorNames: array [0..5] of string = ('Black', 'Red', 'Green', 'Blue', 'Yellow', 'White');
var
  AColorIndex: Integer;
begin
  AColorIndex := (Sender as TcxButton).OptionsImage.ImageIndex;
  SetSelectedFontIconsColor(ColorNames[AColorIndex]);
end;

procedure TdxfmImagePicker.btnOkClick(Sender: TObject);
begin
  if MultiSelect and HasSelectedButNotAddedItems then
  begin
    case dxMessageDlg(sdxAddToSelectionConfirmation, mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        miIconsAddToSelectionClick(nil);
      mrCancel:
        Exit;
    end;
  end;
  ModalResult := mrOk;
end;

procedure TdxfmImagePicker.clbCategoriesClickCheck(Sender: TObject; AIndex: Integer; APrevState, ANewState: TcxCheckBoxState);
begin
  UpdateLibrarySetting(sdxIconLibraryCategories, clbCategories.Items.Items[AIndex].Text, ANewState, dxIconLibraryCategories[lctRaster]);
  ActiveGallery.Gallery.Groups[AIndex].Visible := (ANewState = cbsChecked) and (ActiveFindEdit.Text = '');
  PopulateGallery;
end;

procedure TdxfmImagePicker.clbCategoriesVectorClickCheck(Sender: TObject; AIndex: Integer; APrevState, ANewState: TcxCheckBoxState);
begin
  UpdateLibrarySetting(sdxIconLibraryCategoriesVector, clbCategoriesVector.Items.Items[AIndex].Text, ANewState, dxIconLibraryCategories[lctVector]);
  ActiveGallery.Gallery.Groups[AIndex].Visible := (ANewState = cbsChecked) and (ActiveFindEdit.Text = '');
  PopulateGallery;
end;

procedure TdxfmImagePicker.clbCollectionClickCheck(Sender: TObject; AIndex: Integer; APrevState, ANewState: TcxCheckBoxState);
begin
  UpdateLibrarySetting(sdxIconLibraryCollections, clbCollection.Items.Items[AIndex].Text, ANewState, dxIconLibraryCollections[lctRaster]);
  PopulateGallery;
end;

procedure TdxfmImagePicker.clbCollectionVectorClickCheck(Sender: TObject; AIndex: Integer; APrevState, ANewState: TcxCheckBoxState);
begin
  UpdateLibrarySetting(sdxIconLibraryCollectionsVector, clbCollectionVector.Items.Items[AIndex].Text, ANewState, dxIconLibraryCollections[lctVector]);
  PopulateGallery;
end;

procedure TdxfmImagePicker.clbSizeClickCheck(Sender: TObject; AIndex: Integer; APrevState, ANewState: TcxCheckBoxState);
begin
  UpdateLibrarySetting(sdxIconLibrarySizes, clbSize.Items.Items[AIndex].Text, ANewState, dxIconLibrarySizes);
  PopulateGallery;
end;

procedure TdxfmImagePicker.gcIconsDblClick(Sender: TObject);
var
  AItem: TdxGalleryControlItem;
begin
  AItem := ActiveGallery.Gallery.Groups.GetItemAtPos(ActiveGallery.MouseDownPos);
  if AItem <> nil then
  begin
    UpdateGalleryItemsSelection(ActiveGallery, False);
    AItem.Checked := True;
    if MultiSelect then
      miIconsAddToSelectionClick(nil)
    else
      ModalResult := mrOk;
  end;
end;

procedure TdxfmImagePicker.gcSelectionDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  I: Integer;
  AnSourceItem: TdxGalleryControlItem;
  ADestItem: TdxGalleryItem;
begin
  inherited;
  if TdxGalleryControlDragObject(Source).Control = gcIconsFont then
    for I := 0 to TdxGalleryControlDragObject(Source).SelectedItems.Count - 1 do
    begin
      AnSourceItem := TObject(TdxGalleryControlDragObject(Source).SelectedItems[I]) as TdxGalleryControlItem;
      ADestItem := gcSelection.Gallery.FindItemByTag(AnSourceItem.Tag);
      if ADestItem <> nil then
        ADestItem.Tag := 0;
    end;
  UpdateSelectionBoxSize;
end;

procedure TdxfmImagePicker.gcSelectionDragOver(
  Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TdxGalleryControlDragObject;
  if Accept then
    gcSelection.Controller.DragCopy := TdxGalleryControlDragObject(Source).Control <> Sender;
end;

procedure TdxfmImagePicker.miIconsSelectionDeleteSelectedClick(Sender: TObject);
var
  AIndex: Integer;
  ASelection: TList;
begin
  ASelection := TList.Create;
  try
    gcSelection.Gallery.GetCheckedItems(ASelection);
    if ASelection.Count > 0 then
    begin
      gcSelection.BeginUpdate;
      try
        gcSelection.Gallery.UncheckAll;
        AIndex := TdxGalleryControlItem(ASelection.Last).Index;
        if AIndex + 1 < gcSelectionGroup.ItemCount then
          gcSelectionGroup.Items[AIndex + 1].Checked := True;
        for AIndex := 0 to ASelection.Count - 1 do
          TObject(ASelection.List[AIndex]).Free;
        if (gcSelectionGroup.ItemCount > 0) and (gcSelection.Gallery.GetCheckedItem = nil) then
          gcSelectionGroup.Items[gcSelectionGroup.ItemCount - 1].Checked := True;
      finally
        gcSelection.EndUpdate;
      end;
      UpdateSelectionBoxSize;
    end;
  finally
    ASelection.Free;
  end;
end;

procedure TdxfmImagePicker.miIconsDeselectAllClick(Sender: TObject);
begin
  UpdateGalleryItemsSelection(ActiveGallery, TComponent(Sender).Tag <> 0)
end;

procedure TdxfmImagePicker.miIconsSelectAllinThisGroupClick(Sender: TObject);
begin
  UpdateGalleryItemsSelection(FSelectedGroup, TComponent(Sender).Tag <> 0);
end;

procedure TdxfmImagePicker.miIconsAddToSelectionClick(Sender: TObject);
var
  AChecked: TList;
  I: Integer;
begin
  if MultiSelect and Assigned(ActiveGallery) then
  begin
    FPopulateGalleryHelper.WaitForLoadImagesThread;
    AChecked := TList.Create;
    try
      ActiveGallery.Gallery.GetCheckedItems(AChecked);
      if AChecked.Count > 0 then
      begin
        gcSelection.BeginUpdate;
        try
          for I := 0 to AChecked.Count - 1 do
            AddToSelection(TdxGalleryControlItem(AChecked.List[I]));
        finally
          gcSelection.EndUpdate;
        end;
        UpdateSelectionBoxSize;
      end;
    finally
      AChecked.Free;
    end;
  end;
end;

procedure TdxfmImagePicker.miIconsSelectionDeselectAllClick(Sender: TObject);
begin
  UpdateGalleryItemsSelection(gcSelection, TComponent(Sender).Tag <> 0);
end;

procedure TdxfmImagePicker.miSelectClick(Sender: TObject);
var
  AActiveComponent: TComponent;
  ACheckListBox: TcxCustomCheckListBox;
  I: Integer;
begin
  AActiveComponent := TComponent(ActiveControl);
  if AActiveComponent is TcxCustomInnerCheckListBox then
  begin
    ACheckListBox := TcxCustomInnerCheckListBox(AActiveComponent).Container;
    for I := 0 to ACheckListBox.Items.Count - 1 do
      ACheckListBox.Selected[I] := TComponent(Sender).Tag <> 0;
  end;
end;

procedure TdxfmImagePicker.miIconsShowInExplorerClick(Sender: TObject);
var
  ACheckedItem: TdxGalleryControlItem;
begin
  ACheckedItem := ActiveGallery.Gallery.GetCheckedItem;
  if ACheckedItem <> nil then
    dxShowInExplorer(GetIconLibraryImage(ACheckedItem).FileName);
end;

procedure TdxfmImagePicker.miIconsSelectionLocateInIconLibraryClick(Sender: TObject);
var
  AImage: TdxIconLibraryImage;
  AItem: TdxGalleryControlItem;
begin
  AItem := gcSelection.Gallery.GetCheckedItem;
  if AItem <> nil then
  begin
    AImage := GetIconLibraryImage(AItem);
    if not Locate(AImage.CollectionName, AImage.CategoryName, AImage.DisplayName, AImage.ImageSizeAsString) then
      dxMessageDlg(sdxLocateFailed, mtWarning, [mbOk], 0);
  end;
end;

procedure TdxfmImagePicker.miUncheckSelectedClick(Sender: TObject);
const
  StateMap: array[Boolean] of TcxCheckBoxState = (cbsUnchecked, cbsChecked);
var
  ACheckListBox: TcxCheckListBox;
  ANewState: TcxCheckBoxState;
  APrevState: TcxCheckBoxState;
  I: Integer;
begin
  if pmSelection.PopupComponent is TcxCustomInnerCheckListBox then
  begin
    ACheckListBox := TcxCustomInnerCheckListBox(pmSelection.PopupComponent).Container as TcxCheckListBox;
    ActiveGallery.BeginUpdate;
    try
      Inc(FPopulateGalleryLockCount);
      try
        for I := 0 to ACheckListBox.Items.Count - 1 do
        begin
          if ACheckListBox.Selected[I] then
          begin
            ANewState := StateMap[TComponent(Sender).Tag <> 0];
            APrevState := StateMap[ACheckListBox.Items[I].Checked];
            if APrevState <> ANewState then
            begin
              ACheckListBox.Items[I].Checked := ANewState = cbsChecked;
              if Assigned(ACheckListBox.OnClickCheck) then
                ACheckListBox.OnClickCheck(ACheckListBox, I, APrevState, ANewState);
            end;
          end;
        end;
      finally
        Dec(FPopulateGalleryLockCount);
      end;
      PopulateGallery;
    finally
      ActiveGallery.EndUpdate;
    end;
  end;
end;

procedure TdxfmImagePicker.pmIconGalleryPopup(Sender: TObject);
var
  AHasSelection, AStandartGallery: Boolean;
  ASelectedGroupName: string;
begin
  AHasSelection := ActiveGallery.Gallery.GetCheckedItem <> nil;
  AStandartGallery := ((ActiveGallery = gcIcons) or (ActiveGallery = gcIconsVector));

  if MultiSelect and AStandartGallery then
    FSelectedGroup := ActiveGallery.Gallery.Groups.GetGroupAtPos(ActiveGallery.ScreenToClient(GetMouseCursorPos))
  else
    FSelectedGroup := nil;

  if FSelectedGroup <> nil then
    ASelectedGroupName := FSelectedGroup.Caption
  else
    ASelectedGroupName := '';

  miIconsAddToSelection.Visible := MultiSelect;
  miIconsAddToSelection.Enabled := AHasSelection;
  miIconsShowInExplorer.Visible := AHasSelection and AStandartGallery;

  miIconsDeselectAll.Enabled := AHasSelection;
  miIconsDeselectAll.Visible := MultiSelect;
  miIconsDeselectAllinThisGroup.Enabled := AHasSelection;
  miIconsDeselectAllinThisGroup.Caption := Format(sdxGalleryDeselectAllInGroup, [ASelectedGroupName]);
  miIconsDeselectAllinThisGroup.Visible := FSelectedGroup <> nil;

  miIconsSelectAll.Visible := MultiSelect;
  miIconsSelectAllinThisGroup.Caption := Format(sdxGallerySelectAllInGroup, [ASelectedGroupName]);
  miIconsSelectAllinThisGroup.Visible := FSelectedGroup <> nil;
end;

procedure TdxfmImagePicker.pmIconsSelectionPopup(Sender: TObject);
var
  ASelection: TList;
begin
  ASelection := TList.Create;
  try
    gcSelection.Gallery.GetCheckedItems(ASelection);
    miIconsSelectionDeleteSelected.Enabled := ASelection.Count > 0;
    miIconsSelectionDeselectAll.Enabled := ASelection.Count > 0;
    miIconsSelectionLocateInIconLibrary.Enabled := ASelection.Count = 1;
  finally
    ASelection.Free;
  end;
end;

procedure TdxfmImagePicker.pmSelectionPopup(Sender: TObject);
begin
  miCheckSelected.Visible := pmSelection.PopupComponent is TcxCustomInnerCheckListBox;
  miUncheckSelected.Visible := pmSelection.PopupComponent is TcxCustomInnerCheckListBox;
end;

procedure TdxfmImagePicker.actAddLibraryCollectionExecute(Sender: TObject);
var
  AnIconSet: TdxIconLibrarySet;
  I, ACategoryInd: Integer;
begin
  with TFileOpenDialog.Create(nil) do
    try
      Title := 'Select Directory';
      Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
      OkButtonLabel := 'Select';
      DefaultFolder := '';
      FileName := '';
      if Execute then
      begin
        AnIconSet := dxIconLibrary.AddUserCollection(ExtractFileName(FileName), FileName);
        PopulateContent;
        if AnIconSet.IsEmpty then
        begin
          dxIconLibrary.RemoveUserCollection(FileName);
          raise Exception.Create('The selected directory has no subdirectories with supported image files.');
        end;
        RegisterUserIconLibraryCollection(ExtractFileName(FileName), FileName);
        clbCategories.Items.BeginUpdate;
        clbCategoriesVector.Items.BeginUpdate;
        try
          for I := 0 to AnIconSet.Count -1 do
          begin
            ACategoryInd := clbCategories.Items.IndexOf(AnIconSet.Items[I].DisplayName);
            if ACategoryInd <> -1 then
              clbCategories.Items[ACategoryInd].Checked := True;
            ACategoryInd := clbCategoriesVector.Items.IndexOf(AnIconSet.Items[I].DisplayName);
            if ACategoryInd <> -1 then
              clbCategoriesVector.Items[ACategoryInd].Checked := True;
          end;
        finally
          clbCategories.Items.EndUpdate;
          clbCategoriesVector.Items.EndUpdate;
        end;
        PopulateGallery;
        CorrectCheckBoxSizes;
      end;
    finally
      Free;
    end;
end;

procedure TdxfmImagePicker.actF3Execute(Sender: TObject);
begin
  if Assigned(ActiveFindEdit) then
    ActiveFindEdit.SetFocus;
end;

procedure TdxfmImagePicker.actRemoveCollectionRasterExecute(Sender: TObject);
var
  ACollectionName: string;
begin
  ACollectionName := GetSelectedItemText(clbCollection);
  if ACollectionName <> '' then
  begin
    UnregisterUserIconLibraryCollection(ACollectionName);
    dxIconLibrary.RemoveUserCollection(ACollectionName);
    dxIconLibrary.Refresh;
  end;
end;

procedure TdxfmImagePicker.actRemoveCollectionVectorExecute(Sender: TObject);
var
  ACollectionName: string;
begin
  ACollectionName := GetSelectedItemText(clbCollectionVector);
  if ACollectionName <> '' then
  begin
    UnregisterUserIconLibraryCollection(ACollectionName);
    dxIconLibrary.RemoveUserCollection(ACollectionName);
    dxIconLibrary.Refresh;
  end;
end;

procedure TdxfmImagePicker.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  if Assigned(ActiveFindEdit) and ActiveFindEdit.Focused then
    case Msg.CharCode of
      VK_ESCAPE:
        begin
          ActiveFindEdit.Text := '';
          Handled := True;
        end;
      VK_RETURN:
        begin
          ActiveGallery.SetFocus;
          Handled := True;
        end;
    end;
end;

procedure TdxfmImagePicker.gcIconsFontDblClick(Sender: TObject);
var
  AChecked: TList;
  I: Integer;
begin
  AChecked := TList.Create;
  try
    gcIconsFont.Gallery.GetCheckedItems(AChecked);
    if AChecked.Count > 0 then
    begin
      if MultiSelect then
      begin
        gcSelection.BeginUpdate;
        try
          for I := 0 to AChecked.Count - 1 do
            AddToSelection(TdxGalleryControlItem(AChecked.List[I]), False);
        finally
          gcSelection.EndUpdate;
        end;
      end
      else
        ModalResult := mrOk;
    end;
  finally
    AChecked.Free;
  end;
end;

procedure TdxfmImagePicker.tmrSearchInGalleryTimer(Sender: TObject);
begin
  tmrSearchInGallery.Enabled := False;
  PopulateGallery;
end;

procedure TdxfmImagePicker.tsFontIconsShow(Sender: TObject);
begin
  if not FFontIconsPopulated then
  begin
    TdxFontIconsGalleryLoader.Populate(gcIconsFont);
    FFontIconsPopulated := True;
  end;
end;

initialization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  CreateIconLibrary;
  InitIconLibrarySettings;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.InitializationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
finalization
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationStarted(dxThisUnitName, SysInit.HInstance);{$ENDIF}
  DestroyIconLibrary;
  FreeIconLibrarySettings;
  {$IFDEF DX_INITIALIZATION_LOGGING}TdxUnitSectionsLogger.FinalizationFinished(dxThisUnitName, SysInit.HInstance);{$ENDIF}
end.

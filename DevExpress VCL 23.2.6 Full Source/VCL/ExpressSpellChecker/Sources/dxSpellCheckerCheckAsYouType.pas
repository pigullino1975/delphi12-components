{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressSpellChecker                                      }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSSPELLCHECKER AND ALL           }
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

unit dxSpellCheckerCheckAsYouType;

{$I cxVer.inc}

interface

uses
  System.UITypes,
  Types, Windows, SysUtils, Messages, Classes, Graphics, cxClasses, Controls, Forms, StdCtrls, ExtCtrls, Menus,
  Generics.Defaults, Generics.Collections,
  cxControls, cxLookAndFeels, dxSpellChecker, cxEdit, cxGeometry, cxGraphics,
  dxSpellCheckerRules, dxSpellCheckerAlgorithms, dxSpellCheckerAdapters, dxSpellCheckerCore, dxCoreClasses, dxCore;

type
  TdxSpellCheckerCheckAsYouTypeMode = class;
  TdxSpellCheckerCheckAsYouTypeManager = class;

  { TdxSpellCheckerCheckAsYouTypeCurrentWordInfo }

  TdxSpellCheckerCheckAsYouTypeCurrentWordInfo = packed record
    IsMisspelled: Boolean;
    PositionFinish: IdxSpellCheckerPosition;
    PositionStart: IdxSpellCheckerPosition;
  end;

  { TdxSpellCheckerSpelledWord }

  TdxSpellCheckerSpelledWordClass = class of TdxSpellCheckerSpelledWord;
  TdxSpellCheckerSpelledWord = class
  strict private
    FDirty: Boolean;
    FPositionFinish: IdxSpellCheckerPosition;
    FPositionStart: IdxSpellCheckerPosition;
    FWord: string;
  public
    constructor Create(const AWord: string; const APositionStart, APositionFinish: IdxSpellCheckerPosition); virtual;
    procedure Assign(AWord: TdxSpellCheckerSpelledWord); virtual;
    function Contains(const AIndex: IdxSpellCheckerPosition): Boolean;
    function UpdatePosition(const AStart, AFinish: IdxSpellCheckerPosition): Boolean;

    property Dirty: Boolean read FDirty write FDirty;
    property PositionStart: IdxSpellCheckerPosition read FPositionStart;
    property PositionFinish: IdxSpellCheckerPosition read FPositionFinish;
    property Word: string read FWord;
  end;

  { TdxSpellCheckerSpelledWordList }

  TdxSpellCheckerSpelledWordList = class(TcxObjectList)
  strict private
    function GetItem(AIndex: TdxListIndex): TdxSpellCheckerSpelledWord; inline;
  protected
    function GetSpellCheckerWordClass: TdxSpellCheckerSpelledWordClass; virtual;
  public
    function AddWord(const AWord: string; const APositionStart, APositionFinish: IdxSpellCheckerPosition): TdxSpellCheckerSpelledWord;
    function FindWord(const AWord: string; ADirtyOnly: Boolean; out AItem: TdxSpellCheckerSpelledWord): Boolean;
    procedure MarkItemsDirty;
    procedure RemoveDirtyItems;
    procedure RemoveItem(AItem: TdxSpellCheckerSpelledWord);

    property Items[Index: TdxListIndex]: TdxSpellCheckerSpelledWord read GetItem; default;
  end;

  { TdxSpellCheckerMisspelledWord }

  TdxSpellCheckerMisspelledWord = class(TdxSpellCheckerSpelledWord)
  strict private
    FBounds: array of TRect;
    FShowSquiggle: Boolean;
    FSpellingCode: TdxSpellCheckerSpellingCode;

    function GetUnderlineRect(Index: Integer): TRect;
    function GetUnderlineRectCount: Integer;
  public
    constructor Create(const AWord: string; const APositionStart, APositionFinish: IdxSpellCheckerPosition); override;
    destructor Destroy; override;
    procedure AddRect(const R: TRect);
    procedure Assign(AWord: TdxSpellCheckerSpelledWord); override;
    function Clone: TdxSpellCheckerMisspelledWord;
    function Contains(const APoint: TPoint): Boolean; overload;
    procedure DeleteUnderlineRects;
    //
    property ShowSquiggle: Boolean read FShowSquiggle write FShowSquiggle;
    property SpellingCode: TdxSpellCheckerSpellingCode read FSpellingCode write FSpellingCode;
    property UnderlineRect[Index: Integer]: TRect read GetUnderlineRect;
    property UnderlineRectCount: Integer read GetUnderlineRectCount;
  end;

  { TdxSpellCheckerMisspelledWordList }

  TdxSpellCheckerMisspelledWordList = class(TdxSpellCheckerSpelledWordList)
  strict private
    FValid: Boolean;

    function GetItem(AIndex: TdxListIndex): TdxSpellCheckerMisspelledWord; inline;
  protected
    function GetSpellCheckerWordClass: TdxSpellCheckerSpelledWordClass; override;
  public
    function AddWord(const AWord: string; const APositionStart, APositionFinish: IdxSpellCheckerPosition): TdxSpellCheckerMisspelledWord;
    function FindWord(const AWord: string; AUncheckedOnly: Boolean; out AItem: TdxSpellCheckerMisspelledWord): Boolean;
    function ItemAtIndex(const AIndex: IdxSpellCheckerPosition; out AWord: TdxSpellCheckerMisspelledWord): Boolean;
    function ItemAtPos(const APoint: TPoint; out AWord: TdxSpellCheckerMisspelledWord): Boolean;

    property Items[Index: TdxListIndex]: TdxSpellCheckerMisspelledWord read GetItem; default;
    property Valid: Boolean read FValid write FValid;
  end;

  { TdxSpellCheckerPainter }

  TdxSpellCheckerPainter = class
  strict private
    FLineColor: TColor;
    FLineStyle: TdxSpellCheckerUnderlineStyle;

    procedure SetLineColor(const Value: TColor);
  protected
    procedure Draw(DC: HDC; const R: TRect; ALineStyleNeeded: Boolean);
    procedure DrawLine(DC: HDC; const R: TRect); virtual;
    procedure DrawWavyLine(DC: HDC; const R: TRect); virtual;
  public
    constructor Create(ALineColor: TColor);
    procedure DrawWord(DC: HDC; ALineStyleNeeded: Boolean; AWord: TdxSpellCheckerMisspelledWord);

    property LineColor: TColor read FLineColor write SetLineColor;
    property LineStyle: TdxSpellCheckerUnderlineStyle read FLineStyle write FLineStyle;
  end;

  { TdxSpellCheckerCheckAsYouTypeThread }

  TdxSpellCheckerCheckAsYouTypeThread = class(TcxThread)
  strict private
    FCheckMode: TdxSpellCheckerCheckAsYouTypeMode;
    FTextChanged: Boolean;

    function CanContinue: Boolean;
  protected
    procedure DoSpelling;
    procedure DoSpellingBegin(ARetry: Boolean);
    procedure DoSpellingDone(ARetry: Boolean);
    procedure Execute; override;
  public
    constructor Create(ACheckMode: TdxSpellCheckerCheckAsYouTypeMode);
    //
    property CheckMode: TdxSpellCheckerCheckAsYouTypeMode read FCheckMode;
    property TextChanged: Boolean read FTextChanged write FTextChanged;
  end;

  { TdxSpellCheckerCheckAsYouTypeViewInfo }

  TdxSpellCheckerCheckAsYouTypeViewInfo = class
  strict private
    FRectsToDraw: TdxRectList;
    FRectsToErase: TdxRectList;
    FUpdateRgn: TcxRegionHandle;

    procedure AddWordToList(AList: TdxRectList; AWord: TdxSpellCheckerMisspelledWord);
    function GetUpdateRegion: TcxRegionHandle;
  protected
    procedure Changed;
    procedure FreeRegionHandle;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure AddToDrawRegion(const AList: TdxSpellCheckerMisspelledWordList);
    procedure AddToEraseRegion(const AList: TdxSpellCheckerMisspelledWordList);
    procedure ClearRegions;

    property RectsToDraw: TdxRectList read FRectsToDraw;
    property RectsToErase: TdxRectList read FRectsToErase;
    property UpdateRegion: TcxRegionHandle read GetUpdateRegion;
  end;

  { TdxSpellCheckerCheckAsYouTypeMode }

  TdxSpellCheckerCheckAsYouTypeMode = class(TdxSpellCheckerCustomCheckMode)
  strict private
    FCheckThread: TdxSpellCheckerCheckAsYouTypeThread;
    FCorrectWords: TdxSpellCheckerSpelledWordList;
    FCurrentWordInfo: TdxSpellCheckerCheckAsYouTypeCurrentWordInfo;
    FCurrentWordInfoLock: TRTLCriticalSection;
    FCursorPosition: IdxSpellCheckerPosition;
    FDelayTimer: TcxTimer;
    FLock: TRTLCriticalSection;
    FManager: TdxSpellCheckerCheckAsYouTypeManager;
    FMisspelledWords: TdxSpellCheckerMisspelledWordList;
    FSelectionFinish: IdxSpellCheckerPosition;
    FSelectionStart: IdxSpellCheckerPosition;
    FSyncHelper: THandle;
    FTypingPosition: IdxSpellCheckerPosition;
    FViewInfo: TdxSpellCheckerCheckAsYouTypeViewInfo;
    FVisibleAreaFinish: IdxSpellCheckerPosition;
    FVisibleAreaStart: IdxSpellCheckerPosition;

    function CheckMisspelledItem: Boolean;
    function GetAdapter: IdxSpellCheckerCheckAsYouTypeAdapter;
    function GetPainter: TdxSpellCheckerPainter;
    //
    procedure DelayTimerEvent(Sender: TObject);
    procedure SyncHelperWndProc(var Message: TMessage);
  protected
    procedure Changed(AChangeType: TdxChangeType); virtual;
    procedure SetMisspelledWordInfo(AWord: TdxSpellCheckerMisspelledWord);
    procedure UpdateByDictionary(ADictionary: TdxCustomSpellCheckerDictionary); override;
    procedure UpdateTextInfo; override;

    // Internal Events
    procedure LayoutChanged;
    procedure SelectionChanged;
    procedure SpellingBegin(AIsFirstIteration: Boolean);
    procedure SpellingDone(AIsLastIteration: Boolean);
    procedure TextChanged;

    // Threading
    function CanStartSpellingThread: Boolean; virtual;
    procedure PauseSpellingThread;
    procedure StartSpellingThread(ADelayed: Boolean); overload;
    procedure StartSpellingThread; overload; virtual;

    // Async methods
    procedure AddMisspelledWord(const AWord: string); overload;
    procedure AddMisspelledWord(const AWord: string; AIsCurrentWord: Boolean); overload;
    function GetNextWord(out AWord: string): Boolean; override;
    function InternalCheckWord(var AWord: string): Boolean; override;
    function InternalProcessWord(const AWord: string): Boolean; override;
    function IsCharVisible(const APosition: IdxSpellCheckerPosition): Boolean;
    function IsValidWord(const AWord: string): Boolean; override;
    function IsWordVisible: Boolean;

    property CursorPosition: IdxSpellCheckerPosition read FCursorPosition;
    property DelayTimer: TcxTimer read FDelayTimer;
    property SelectionFinish: IdxSpellCheckerPosition read FSelectionFinish;
    property SelectionStart: IdxSpellCheckerPosition read FSelectionStart;
    property SyncHelper: THandle read FSyncHelper;
    property TypingPosition: IdxSpellCheckerPosition read FTypingPosition;
    property VisibleAreaFinish: IdxSpellCheckerPosition read FVisibleAreaFinish;
    property VisibleAreaStart: IdxSpellCheckerPosition read FVisibleAreaStart;
  public
    constructor Create(AOwner: TdxCustomSpellChecker; AAdapter: IdxSpellCheckerAdapter); override;
    destructor Destroy; override;

    procedure Add; override;
    procedure Change(const AWord: string); override;
    procedure Delete; override;
    procedure Draw(DC: HDC);
    procedure Ignore; override;
    procedure IgnoreAll; override;

    procedure Lock;
    procedure Unlock;

    property Adapter: IdxSpellCheckerCheckAsYouTypeAdapter read GetAdapter;
    property CheckThread: TdxSpellCheckerCheckAsYouTypeThread read FCheckThread;
    property CorrectWords: TdxSpellCheckerSpelledWordList read FCorrectWords;
    property Manager: TdxSpellCheckerCheckAsYouTypeManager read FManager;
    property MisspelledWords: TdxSpellCheckerMisspelledWordList read FMisspelledWords;
    property Painter: TdxSpellCheckerPainter read GetPainter;
    property ViewInfo: TdxSpellCheckerCheckAsYouTypeViewInfo read FViewInfo;
  end;

  { TdxSpellCheckerCheckAsYouTypeManager }

  TdxSpellCheckerCheckAsYouTypeManager = class(TdxSpellCheckerCustomCheckAsYouTypeManager)
  strict private
    FInternalPopupMenu: TPopupMenu;
    FMisspelledItem: TdxSpellCheckerMisspelledWord;
    FPainter: TdxSpellCheckerPainter;

    function GetAdapter: IdxSpellCheckerCheckAsYouTypeAdapter;
    function GetCheckMode: TdxSpellCheckerCheckAsYouTypeMode;
    procedure SetMisspelledItem(AValue: TdxSpellCheckerMisspelledWord);
  protected
    function CreateAdapter(AControl: TWinControl; out AAdapter: IdxSpellCheckerAdapter): Boolean; override;
    function GetCheckModeClass: TdxSpellCheckerCustomCheckModeClass; override;

    procedure DoActiveChanged; override;
    procedure DoFinalizeController; override;
    procedure DoOptionsChanged; override;
    procedure ManualCheckStateChanged; override;
    procedure RedrawEditor;
    procedure ValidateAdapter; override;

    // Popup
    function CanPopup(const P: TPoint): Boolean; virtual;
    procedure CreateInternalPopupMenu; virtual;
    procedure CreateItems(APopup: TPopupMenu; AOwner: TComponent); virtual;
    procedure HandlerMenuItem(ASender: TObject);
    procedure HandlerSuggestion(AIndex: Integer; AIsAutoCorrect: Boolean);

    property InternalPopupMenu: TPopupMenu read FInternalPopupMenu write FInternalPopupMenu;
  public
    constructor Create(ASpellChecker: TdxCustomSpellChecker); override;
    destructor Destroy; override;
    procedure Refresh(AChangeType: TdxChangeType = ctMedium); override;

    procedure DrawMisspellings(AControl: TWinControl; DC: HDC = 0); override;
    procedure LayoutChanged(AControl: TWinControl); override;
    function QueryPopup(APopup: TComponent; const P: TPoint): Boolean; override;
    procedure SelectionChanged(AControl: TWinControl); override;
    procedure TextChanged(AControl: TWinControl); override;

    property Adapter: IdxSpellCheckerCheckAsYouTypeAdapter read GetAdapter;
    property CheckMode: TdxSpellCheckerCheckAsYouTypeMode read GetCheckMode;
    property MisspelledItem: TdxSpellCheckerMisspelledWord read FMisspelledItem write SetMisspelledItem;
    property Painter: TdxSpellCheckerPainter read FPainter;
  end;


implementation

uses
  Math, cxRichEdit, cxRichEditUtils, dxOffice11, cxTextEdit, ComCtrls, RichEdit, Dialogs, ComObj,
  dxSpellCheckerStrs, cxContainer, dxSpellCheckerDialogs, dxSpellCheckerUtils, dxDrawRichTextUtils,
  dxMessageDialog;

const
  dxThisUnitName = 'dxSpellCheckerCheckAsYouType';

const
  dxSpellCheckerCheckAsYouTypeTimeDelay = 200;
  dxSpellCheckerUnderlineSize = 3;

  SYNC_SPELLING_BEGIN = 1;
  SYNC_SPELLING_END   = 2;

type
  TdxCustomSpellCheckerAccess = class(TdxCustomSpellChecker);

function InRange(const AIndex, AStart, AFinish: IdxSpellCheckerPosition): Boolean;
begin
  Result := (AIndex.Compare(AStart) >= 0) and (AIndex.Compare(AFinish) <= 0);
end;

{ TdxSpellCheckerSpelledWord }

constructor TdxSpellCheckerSpelledWord.Create(const AWord: string; const APositionStart, APositionFinish: IdxSpellCheckerPosition);
begin
  inherited Create;
  FWord := AWord;
  FPositionFinish := APositionFinish;
  FPositionStart := APositionStart;
end;

procedure TdxSpellCheckerSpelledWord.Assign(AWord: TdxSpellCheckerSpelledWord);
begin
  if AWord <> nil then
  begin
    FDirty := AWord.FDirty;
    FPositionStart := AWord.FPositionStart;
    FPositionFinish := AWord.FPositionFinish;
    FWord := AWord.Word;
  end;
end;

function TdxSpellCheckerSpelledWord.Contains(const AIndex: IdxSpellCheckerPosition): Boolean;
begin
  Result := (AIndex.Compare(PositionStart) >= 0) and (AIndex.Compare(PositionFinish) < 0);
end;

function TdxSpellCheckerSpelledWord.UpdatePosition(const AStart, AFinish: IdxSpellCheckerPosition): Boolean;
begin
  Result := (AStart.Compare(PositionStart) <> 0) or (AFinish.Compare(PositionFinish) <> 0);
  if Result then
  begin
    FPositionStart := AStart;
    FPositionFinish := AFinish;
  end;
end;

{ TdxSpellCheckerSpelledWordList }

function TdxSpellCheckerSpelledWordList.AddWord(const AWord: string;
  const APositionStart, APositionFinish: IdxSpellCheckerPosition): TdxSpellCheckerSpelledWord;
begin
  Result := GetSpellCheckerWordClass.Create(AWord, APositionStart, APositionFinish);
  Add(Result);
end;

function TdxSpellCheckerSpelledWordList.FindWord(const AWord: string;
  ADirtyOnly: Boolean; out AItem: TdxSpellCheckerSpelledWord): Boolean;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    AItem := Items[I];
    if (AWord = AItem.Word) and (not ADirtyOnly or AItem.Dirty) then
      Exit(True);
  end;
  Result := False;
end;

procedure TdxSpellCheckerSpelledWordList.MarkItemsDirty;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    Items[I].Dirty := True;
end;

procedure TdxSpellCheckerSpelledWordList.RemoveDirtyItems;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
  begin
    if Items[I].Dirty then
      FreeAndDelete(I);
  end;
end;

procedure TdxSpellCheckerSpelledWordList.RemoveItem(AItem: TdxSpellCheckerSpelledWord);
begin
  if Remove(AItem) >= 0 then
    AItem.Free;
end;

function TdxSpellCheckerSpelledWordList.GetSpellCheckerWordClass: TdxSpellCheckerSpelledWordClass;
begin
  Result := TdxSpellCheckerSpelledWord;
end;

function TdxSpellCheckerSpelledWordList.GetItem(AIndex: TdxListIndex): TdxSpellCheckerSpelledWord;
begin
  Result := TdxSpellCheckerSpelledWord(inherited Items[AIndex]);
end;

{ TdxSpellCheckerMisspelledWord }

constructor TdxSpellCheckerMisspelledWord.Create(const AWord: string;
  const APositionStart, APositionFinish: IdxSpellCheckerPosition);
begin
  inherited Create(AWord, APositionStart, APositionFinish);
  FShowSquiggle := True;
end;

destructor TdxSpellCheckerMisspelledWord.Destroy;
begin
  DeleteUnderlineRects;
  inherited Destroy;
end;

procedure TdxSpellCheckerMisspelledWord.AddRect(const R: TRect);
var
  AIndex: Integer;
begin
  AIndex := Length(FBounds);
  SetLength(FBounds, AIndex + 1);
  FBounds[AIndex] := R;
end;

procedure TdxSpellCheckerMisspelledWord.Assign(AWord: TdxSpellCheckerSpelledWord);

  procedure AssignBounds(AWord: TdxSpellCheckerMisspelledWord);
  var
    I: Integer;
  begin
    SetLength(FBounds, Length(AWord.FBounds));
    for I := 0 to Length(AWord.FBounds) - 1 do
      FBounds[I] := AWord.FBounds[I];
  end;

begin
  inherited Assign(AWord);
  if AWord is TdxSpellCheckerMisspelledWord then
  begin
    AssignBounds(TdxSpellCheckerMisspelledWord(AWord));
    FShowSquiggle := TdxSpellCheckerMisspelledWord(AWord).ShowSquiggle;
    FSpellingCode := TdxSpellCheckerMisspelledWord(AWord).SpellingCode;
  end;
end;

function TdxSpellCheckerMisspelledWord.Clone: TdxSpellCheckerMisspelledWord;
begin
  Result := TdxSpellCheckerMisspelledWord.Create('', nil, nil);
  Result.Assign(Self);
end;

function TdxSpellCheckerMisspelledWord.Contains(const APoint: TPoint): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Length(FBounds) - 1 do
  begin
    Result := PtInRect(FBounds[I], APoint);
    if Result then
      Break;
  end;
end;

procedure TdxSpellCheckerMisspelledWord.DeleteUnderlineRects;
begin
  SetLength(FBounds, 0);
end;

function TdxSpellCheckerMisspelledWord.GetUnderlineRect(Index: Integer): TRect;
begin
  Result := FBounds[Index];
  Inc(Result.Bottom);
  Result.Top := Result.Bottom - dxSpellCheckerUnderlineSize;
end;

function TdxSpellCheckerMisspelledWord.GetUnderlineRectCount: Integer;
begin
  Result := Length(FBounds);
end;

{ TdxSpellCheckerMisspelledWordList }

function TdxSpellCheckerMisspelledWordList.AddWord(const AWord: string;
  const APositionStart, APositionFinish: IdxSpellCheckerPosition): TdxSpellCheckerMisspelledWord;
begin
  Result := TdxSpellCheckerMisspelledWord(inherited AddWord(AWord, APositionStart, APositionFinish));
end;

function TdxSpellCheckerMisspelledWordList.FindWord(const AWord: string;
  AUncheckedOnly: Boolean; out AItem: TdxSpellCheckerMisspelledWord): Boolean;
begin
  Result := inherited FindWord(AWord, AUncheckedOnly, TdxSpellCheckerSpelledWord(AItem));
end;

function TdxSpellCheckerMisspelledWordList.ItemAtIndex(
  const AIndex: IdxSpellCheckerPosition; out AWord: TdxSpellCheckerMisspelledWord): Boolean;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    AWord := Items[I];
    if AWord.Contains(AIndex) then
      Exit(True);
  end;
  Result := False;
end;

function TdxSpellCheckerMisspelledWordList.ItemAtPos(const APoint: TPoint; out AWord: TdxSpellCheckerMisspelledWord): Boolean;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Items[I].Contains(APoint) then
    begin
      AWord := Items[I];
      Exit(True);
    end;
  Result := False;
end;

function TdxSpellCheckerMisspelledWordList.GetSpellCheckerWordClass: TdxSpellCheckerSpelledWordClass;
begin
  Result := TdxSpellCheckerMisspelledWord;
end;

function TdxSpellCheckerMisspelledWordList.GetItem(AIndex: TdxListIndex): TdxSpellCheckerMisspelledWord;
begin
  Result := TdxSpellCheckerMisspelledWord(inherited Items[AIndex]);
end;

{ TdxSpellCheckerCheckAsYouTypeThread }

constructor TdxSpellCheckerCheckAsYouTypeThread.Create(ACheckMode: TdxSpellCheckerCheckAsYouTypeMode);
begin
  FCheckMode := ACheckMode;
  inherited Create(False, True);
end;

function TdxSpellCheckerCheckAsYouTypeThread.CanContinue: Boolean;
begin
  Result := Running and not TextChanged;
end;

procedure TdxSpellCheckerCheckAsYouTypeThread.DoSpelling;
var
  AWord: string;
begin
  while CanContinue and CheckMode.GetNextWord(AWord) do
  begin
    if CheckMode.IsWordVisible then
    begin
      if not CanContinue then
        Break;
      if CheckMode.InternalProcessWord(AWord) then
        Continue;
      if not CheckMode.InternalCheckWord(AWord) then
      begin
        if CanContinue then
          CheckMode.AddMisspelledWord(AWord)
        else
          Break;
      end;
    end;
    CheckMode.PrevWord := AWord;
    CheckMode.FMisspellingStart := CheckMode.FMisspellingFinish;
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeThread.DoSpellingBegin(ARetry: Boolean);
begin
  SendMessage(CheckMode.SyncHelper, WM_USER, SYNC_SPELLING_BEGIN, Ord(ARetry));
end;

procedure TdxSpellCheckerCheckAsYouTypeThread.DoSpellingDone(ARetry: Boolean);
begin
  SendMessage(CheckMode.SyncHelper, WM_USER, SYNC_SPELLING_END, Ord(ARetry));
end;

procedure TdxSpellCheckerCheckAsYouTypeThread.Execute;
var
  ARetry: Boolean;
begin
  while not (Terminated or Destroying) do
  begin
    CheckForPause;

    if Running then
    try
      ARetry := False;
      repeat
        TextChanged := False;
        DoSpellingBegin(ARetry);
        try
          DoSpelling;
          ARetry := Running and TextChanged;
        finally
          DoSpellingDone(ARetry);
        end;
      until not ARetry;
    except
      // do nothing
    end;

    Pause;
  end;
end;

{ TdxSpellCheckerCheckAsYouTypeMode }

constructor TdxSpellCheckerCheckAsYouTypeMode.Create(AOwner: TdxCustomSpellChecker; AAdapter: IdxSpellCheckerAdapter);
begin
  InitializeCriticalSectionAndSpinCount(FLock, 1000);
  inherited Create(AOwner, AAdapter);
  InitializeCriticalSectionAndSpinCount(FCurrentWordInfoLock, 1000);

  FManager := TdxSpellCheckerCheckAsYouTypeManager(TdxCustomSpellCheckerAccess(AOwner).CheckAsYouTypeManager);
  FCorrectWords := TdxSpellCheckerSpelledWordList.Create;
  FMisspelledWords := TdxSpellCheckerMisspelledWordList.Create;
  FViewInfo := TdxSpellCheckerCheckAsYouTypeViewInfo.Create;
  FCheckThread := TdxSpellCheckerCheckAsYouTypeThread.Create(Self);
  FDelayTimer := cxCreateTimer(DelayTimerEvent, dxSpellCheckerCheckAsYouTypeTimeDelay div 2, False);
  FSyncHelper := AllocateHWnd(SyncHelperWndProc);
  Changed(ctHard);
end;

destructor TdxSpellCheckerCheckAsYouTypeMode.Destroy;
begin
  cxClearObjectLinks(Self);

  FreeAndNil(FDelayTimer);
  FreeAndNil(FCheckThread);
  FreeAndNil(FCorrectWords);
  FreeAndNil(FMisspelledWords);
  FreeAndNil(FViewInfo);
  DeallocateHWnd(FSyncHelper);

  DeleteCriticalSection(FCurrentWordInfoLock);
  DeleteCriticalSection(FLock);
  inherited Destroy;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.Add;
begin
  if CheckMisspelledItem then
    inherited Add;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.Change(const AWord: string);
begin
  if CheckMisspelledItem then
    inherited Change(AWord);
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.Delete;
begin
  if CheckMisspelledItem then
    inherited Delete;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.Draw(DC: HDC);
var
  AIsLineDrawStyleNeeded: Boolean;
  I: Integer;
begin
  if MisspelledWords.Valid then
  begin
    Lock;
    try
      if MisspelledWords.Valid then
      begin
        AIsLineDrawStyleNeeded := Adapter.IsLineDrawStyleNeeded;
        for I := MisspelledWords.Count - 1 downto 0 do
          Painter.DrawWord(DC, AIsLineDrawStyleNeeded, MisspelledWords.Items[I])
      end;
    finally
      Unlock;
    end;
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.Ignore;
begin
  if CheckMisspelledItem then
    inherited Ignore;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.IgnoreAll;
begin
  if CheckMisspelledItem then
    inherited IgnoreAll;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.Lock;
begin
  EnterCriticalSection(FLock);
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.Unlock;
begin
  LeaveCriticalSection(FLock);
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.Changed(AChangeType: TdxChangeType);
begin
  Manager.MisspelledItem := nil;
  if AChangeType >= ctMedium then
  begin
    Lock;
    try
      if AChangeType >= ctHard then
        CorrectWords.Clear;
      MisspelledWords.Valid := False;
      UpdateMeaningfulCharacters;
      UpdateTextInfo;
      StartSpellingThread(True);
      Manager.RedrawEditor;
    finally
      Unlock;
    end;
  end
  else
    StartSpellingThread;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.SetMisspelledWordInfo(AWord: TdxSpellCheckerMisspelledWord);
begin
  FMisspellingStart := AWord.PositionStart;
  FMisspellingFinish := AWord.PositionFinish;
  FMisspelledWord := AWord.Word;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.LayoutChanged;
begin
  Lock;
  try
    Manager.MisspelledItem := nil;
    MisspelledWords.Valid := False;
    StartSpellingThread(True);
  finally
    Unlock;
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.SelectionChanged;
var
  ASelectionFinish: IdxSpellCheckerPosition;
  ASelectionStart: IdxSpellCheckerPosition;
  AStartSpellingThread: Boolean;
begin
  AStartSpellingThread := False;

  EnterCriticalSection(FCurrentWordInfoLock);
  try
    if FCurrentWordInfo.IsMisspelled then
    begin
      Adapter.GetSelection(ASelectionStart, ASelectionFinish);
      AStartSpellingThread :=
        not InRange(ASelectionStart, FCurrentWordInfo.PositionStart, FCurrentWordInfo.PositionFinish) or
        (SelectionFinish <> nil) and (SelectionStart <> nil) and
        (ASelectionFinish.Subtract(ASelectionStart).Compare(SelectionFinish.Subtract(SelectionStart)) <> 0)
    end;
  finally
    LeaveCriticalSection(FCurrentWordInfoLock);
  end;

  if AStartSpellingThread then
    StartSpellingThread(True);
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.SpellingBegin(AIsFirstIteration: Boolean);
begin
  PrevWord := '';
  CreateTextController;
  Adapter.RefreshParams;
  Adapter.GetSelection(FSelectionStart, FSelectionFinish);
  FCurrentWordInfo.IsMisspelled := False;
  FCursorPosition := FSelectionStart;
  FMisspellingStart := FSpellingStart;
  MisspelledWords.MarkItemsDirty;
  if AIsFirstIteration then
    ViewInfo.ClearRegions;
  ViewInfo.AddToEraseRegion(MisspelledWords);
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.SpellingDone(AIsLastIteration: Boolean);
var
  ADC: HDC;
  ALink: TcxObjectLink;
  ARegion: TcxRegionHandle;
  ARegionBox: TRect;
begin
  if AIsLastIteration then
  begin
    CorrectWords.RemoveDirtyItems;
    MisspelledWords.RemoveDirtyItems;
    MisspelledWords.Valid := True;
    ViewInfo.AddToDrawRegion(MisspelledWords);
    TdxCustomSpellCheckerAccess(SpellChecker).ReleaseCheckModeHelper(Self);

    ARegion := ViewInfo.UpdateRegion;
    if GetRgnBox(ARegion, ARegionBox) <> NULLREGION then
    begin
      ALink := cxAddObjectLink(Self);
      try
        InvalidateRgn(Adapter.EditorHandle, ARegion, False);
        UpdateWindow(Adapter.EditorHandle); 

        if ALink.Ref <> nil then
        begin
          ADC := GetDC(Adapter.EditorHandle);
          try
            Draw(ADC);
          finally
            ReleaseDC(Adapter.EditorHandle, ADC);
          end;
        end;
      finally
        cxRemoveObjectLink(ALink);
      end;
    end;
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.TextChanged;
var
  ASelStart, ASelFinish: IdxSpellCheckerPosition;
begin
  Adapter.GetSelection(ASelStart, ASelFinish);
  Lock;
  try
    FTypingPosition := ASelStart;
  finally
    Unlock;
  end;
  Changed(ctLight);
end;

function TdxSpellCheckerCheckAsYouTypeMode.CanStartSpellingThread: Boolean;
begin
  Result := (Manager.ManualCheckCount = 0) and Manager.IsSpellCheckerReady and not Adapter.ReadOnly and Adapter.Edit.HandleAllocated;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.PauseSpellingThread;
begin
  FCheckThread.Pause(True);
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.StartSpellingThread(ADelayed: Boolean);
begin
  if ADelayed then
  begin
    DelayTimer.Tag := GetTickCount;
    DelayTimer.Enabled := True;
  end
  else
    StartSpellingThread;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.StartSpellingThread;
begin
  DelayTimer.Enabled := False;
  if CanStartSpellingThread then
  begin
    FCheckThread.TextChanged := True;
    FCheckThread.Unpause;
  end
  else
  begin
    PauseSpellingThread;
    if MisspelledWords.Count > 0 then
    begin
      MisspelledWords.Clear;
      Manager.RedrawEditor;
    end;
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.UpdateByDictionary(ADictionary: TdxCustomSpellCheckerDictionary);
begin
  inherited UpdateByDictionary(ADictionary);
  Changed(ctLight);
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.UpdateTextInfo;
var
  AVisibleAreaStart: IdxSpellCheckerPosition;
  AVisibleAreaFinish: IdxSpellCheckerPosition;
begin
  Lock;
  try
    inherited UpdateTextInfo;
    Adapter.GetVisibleTextBounds(AVisibleAreaStart, AVisibleAreaFinish);
    FVisibleAreaFinish := AVisibleAreaFinish;
    FVisibleAreaStart := AVisibleAreaStart;
  finally
    Unlock;
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.AddMisspelledWord(const AWord: string);
begin
  AddMisspelledWord(AWord, InRange(CursorPosition, FMisspellingStart, FMisspellingFinish));
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.AddMisspelledWord(const AWord: string; AIsCurrentWord: Boolean);
var
  AItem: TdxSpellCheckerMisspelledWord;
  ATempItem: TdxSpellCheckerMisspelledWord;
begin
  if AIsCurrentWord then
  begin
    EnterCriticalSection(FCurrentWordInfoLock);
    try
      FCurrentWordInfo.PositionFinish := FMisspellingFinish;
      FCurrentWordInfo.PositionStart := FMisspellingStart;
      FCurrentWordInfo.IsMisspelled := True;
    finally
      LeaveCriticalSection(FCurrentWordInfoLock);
    end;
  end;

  Lock;
  try
    if MisspelledWords.FindWord(AWord, True, AItem) then
    begin
      if AItem.UpdatePosition(FMisspellingStart, FMisspellingFinish) or not MisspelledWords.Valid then
        AItem.DeleteUnderlineRects;
    end
    else
    begin
      AItem := MisspelledWords.AddWord(AWord, FMisspellingStart, FMisspellingFinish);
      if AIsCurrentWord and (TypingPosition <> nil) and (CursorPosition.Compare(TypingPosition) = 0) then
      begin
        if MisspelledWords.ItemAtIndex(FMisspellingStart, ATempItem) and (ATempItem <> AItem) then
          AItem.ShowSquiggle := ATempItem.ShowSquiggle
        else
          AItem.ShowSquiggle := False;
      end;
    end;
    AItem.ShowSquiggle := AItem.ShowSquiggle or not AIsCurrentWord or (SelectionFinish.Compare(SelectionStart) > 0);
    AItem.SpellingCode := LastCode;
    AItem.Dirty := False;

    if AItem.UnderlineRectCount = 0 then 
      ATempItem := AItem.Clone
    else
      ATempItem := nil;
  finally
    Unlock;
  end;

  if ATempItem <> nil then
  try
    Adapter.CalculateBounds(ATempItem.PositionStart, ATempItem.PositionFinish, ATempItem.AddRect);
    Lock;
    try
      if MisspelledWords.IndexOf(AItem) >= 0 then 
        AItem.Assign(ATempItem);
    finally
      Unlock;
    end;
  finally
    ATempItem.Free;
  end;
end;

function TdxSpellCheckerCheckAsYouTypeMode.GetNextWord(out AWord: string): Boolean;
begin
  Lock;
  try
    Result := inherited GetNextWord(AWord);
  finally
    Unlock;
  end;
end;

function TdxSpellCheckerCheckAsYouTypeMode.InternalCheckWord(var AWord: string): Boolean;
begin
  Lock;
  try
    Result := inherited InternalCheckWord(AWord);
  finally
    Unlock;
  end;
end;

function TdxSpellCheckerCheckAsYouTypeMode.InternalProcessWord(const AWord: string): Boolean;
begin
  Result := IsNeedIgnoreWord(AWord);
  if Result then
  begin
    Lock;
    try
      FMisspelledWord := AWord;
      CorrectWords.AddWord(AWord, FMisspellingStart, FMisspellingFinish);
    finally
      Unlock;
    end;
    Skip;
  end;
end;

function TdxSpellCheckerCheckAsYouTypeMode.IsCharVisible(const APosition: IdxSpellCheckerPosition): Boolean;
begin
  Result := InRange(APosition, VisibleAreaStart, VisibleAreaFinish);
end;

function TdxSpellCheckerCheckAsYouTypeMode.IsValidWord(const AWord: string): Boolean;
var
  AItem: TdxSpellCheckerSpelledWord;
begin
  Lock;
  try
    Result := not WideSameStr(AWord, PrevWord) and CorrectWords.FindWord(AWord, False, AItem);
    if Result then
      AItem.Dirty := False
    else
    begin
      Result := inherited IsValidWord(AWord);
      if Result then
        CorrectWords.AddWord(AWord, FMisspellingStart, FMisspellingFinish);
    end;
  finally
    Unlock;
  end;
end;

function TdxSpellCheckerCheckAsYouTypeMode.IsWordVisible: Boolean;
begin
  Lock;
  try
    Result := IsCharVisible(FMisspellingStart) or IsCharVisible(FMisspellingFinish);
  finally
    Unlock;
  end;
end;

function TdxSpellCheckerCheckAsYouTypeMode.CheckMisspelledItem: Boolean;
begin
  Result := Manager.MisspelledItem <> nil;
  if Result then
    SetMisspelledWordInfo(Manager.MisspelledItem);
end;

function TdxSpellCheckerCheckAsYouTypeMode.GetAdapter: IdxSpellCheckerCheckAsYouTypeAdapter;
begin
  Result := inherited Adapter as IdxSpellCheckerCheckAsYouTypeAdapter;
end;

function TdxSpellCheckerCheckAsYouTypeMode.GetPainter: TdxSpellCheckerPainter;
begin
  Result := Manager.Painter;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.SyncHelperWndProc(var Message: TMessage);
begin
  try
    if Message.Msg <> WM_USER then
      Message.Result := DefWindowProc(FSyncHelper, Message.Msg, Message.wParam, Message.lParam)
    else
      case Message.WParam of
        SYNC_SPELLING_BEGIN:
          SpellingBegin(Message.LParam = 0);
        SYNC_SPELLING_END:
          SpellingDone(Message.LParam = 0);
      end;
  except
    Application.HandleException(Self);
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeMode.DelayTimerEvent(Sender: TObject);
begin
  if GetTickCount - DWORD(DelayTimer.Tag) >= dxSpellCheckerCheckAsYouTypeTimeDelay then
  begin
    DelayTimer.Enabled := False;
    StartSpellingThread;
  end;
end;

{ TdxSpellCheckerCheckAsYouTypeViewInfo }

constructor TdxSpellCheckerCheckAsYouTypeViewInfo.Create;
begin
  FRectsToDraw := TdxRectList.Create;
  FRectsToErase := TdxRectList.Create;
end;

destructor TdxSpellCheckerCheckAsYouTypeViewInfo.Destroy;
begin
  FreeRegionHandle;
  FreeAndNil(FRectsToDraw);
  FreeAndNil(FRectsToErase);
  inherited Destroy;
end;

procedure TdxSpellCheckerCheckAsYouTypeViewInfo.AddToDrawRegion(const AList: TdxSpellCheckerMisspelledWordList);
var
  AWordItem: TdxSpellCheckerMisspelledWord;
  I: Integer;
begin
  for I := 0 to AList.Count - 1 do
  begin
    AWordItem := AList.Items[I];
    if AWordItem.ShowSquiggle and not AWordItem.Dirty then
      AddWordToList(RectsToDraw, AWordItem);
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeViewInfo.AddToEraseRegion(const AList: TdxSpellCheckerMisspelledWordList);
var
  AWordItem: TdxSpellCheckerMisspelledWord;
  I: Integer;
begin
  for I := 0 to AList.Count - 1 do
  begin
    AWordItem := AList.Items[I];
    if AWordItem.ShowSquiggle then
      AddWordToList(RectsToErase, AWordItem);
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeViewInfo.AddWordToList(AList: TdxRectList; AWord: TdxSpellCheckerMisspelledWord);
var
  I: Integer;
begin
  AList.Capacity := Max(AList.Capacity, AList.Count + AWord.UnderlineRectCount);
  for I := 0 to AWord.UnderlineRectCount - 1 do
    AList.Add(cxRectInflate(AWord.UnderlineRect[I], 1));
  Changed;
end;

procedure TdxSpellCheckerCheckAsYouTypeViewInfo.ClearRegions;
begin
  FRectsToDraw.Clear;
  FRectsToErase.Clear;
  FreeRegionHandle;
end;

procedure TdxSpellCheckerCheckAsYouTypeViewInfo.Changed;
begin
  FreeRegionHandle;
end;

procedure TdxSpellCheckerCheckAsYouTypeViewInfo.FreeRegionHandle;
begin
  if FUpdateRgn <> 0 then
  begin
    DeleteObject(FUpdateRgn);
    FUpdateRgn := 0;
  end;
end;

function TdxSpellCheckerCheckAsYouTypeViewInfo.GetUpdateRegion: TcxRegionHandle;

  procedure AddUnique(ARegion: TcxRegionHandle; AList1, AList2: TdxRectList);
  var
    ATempRegion: TcxRegionHandle;
    I: Integer;
  begin
    for I := 0 to AList1.Count - 1 do
    begin
      if not AList2.Contains(AList1[I]) then
      begin
        ATempRegion := CreateRectRgnIndirect(AList1[I]);
        CombineRgn(ARegion, ARegion, ATempRegion, RGN_OR);
        DeleteObject(ATempRegion);
      end;
    end;
  end;

begin
  if FUpdateRgn = 0 then
  begin
    FUpdateRgn := CreateRectRgn(0, 0, 0, 0);
    AddUnique(FUpdateRgn, RectsToErase, RectsToDraw);
    AddUnique(FUpdateRgn, RectsToDraw, RectsToErase);
  end;
  Result := FUpdateRgn;
end;

{ TdxSpellCheckerCheckAsYouTypeManager }

constructor TdxSpellCheckerCheckAsYouTypeManager.Create(ASpellChecker: TdxCustomSpellChecker);
begin
  inherited Create(ASpellChecker);
  FPainter := TdxSpellCheckerPainter.Create(clRed);
end;

destructor TdxSpellCheckerCheckAsYouTypeManager.Destroy;
begin
  MisspelledItem := nil;
  FinalizeController;
  FreeAndNil(FPainter);
  FreeAndNil(FInternalPopupMenu);
  inherited Destroy;
end;

function TdxSpellCheckerCheckAsYouTypeManager.CanPopup(const P: TPoint): Boolean;

  function IsQueryPopupAtMisspelledWord: Boolean;
  var
    AItem: TdxSpellCheckerMisspelledWord;
    ASelStart, ASelFinish: IdxSpellCheckerPosition;
  begin
    CheckMode.Lock;
    try
      if cxPointIsEqual(cxInvalidPoint, P) then
      begin
        Adapter.GetSpellingBounds(ASelStart, ASelFinish);
        Result := CheckMode.MisspelledWords.ItemAtIndex(ASelStart, AItem);
      end
      else
        Result := CheckMode.MisspelledWords.ItemAtPos(P, AItem);

      if Result then
        MisspelledItem := AItem
      else
        MisspelledItem := nil;
    finally
      CheckMode.Unlock;
    end;
  end;

begin
  Result := Active and (CheckMode <> nil) and (Options.PopupMenuItems <> []) and
    (Adapter.Edit.HandleAllocated and (GetFocus = Adapter.EditorHandle)) and IsQueryPopupAtMisspelledWord;
end;

function TdxSpellCheckerCheckAsYouTypeManager.CreateAdapter(AControl: TWinControl; out AAdapter: IdxSpellCheckerAdapter): Boolean;
begin
  Result := inherited CreateAdapter(AControl, AAdapter) and Supports(AAdapter, IdxSpellCheckerCheckAsYouTypeAdapter);
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.CreateInternalPopupMenu;
begin
  FreeAndNil(FInternalPopupMenu);
  FInternalPopupMenu := TPopupMenu.Create(nil);
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.CreateItems(APopup: TPopupMenu; AOwner: TComponent);

  procedure AddItem(var APosition: Integer; ATag: Integer; const ACaption: string; ASubMenuItem: TMenuItem = nil);
  var
    AItem: TMenuItem;
  begin
    AItem := TMenuItem.Create(AOwner);
    AItem.Caption := ACaption;
    if not AItem.IsLine then
    begin
      AItem.Tag := ATag;
      AItem.OnClick := HandlerMenuItem;
      AItem.AutoHotkeys := maManual;
    end;

    if ASubMenuItem <> nil then
      ASubMenuItem.Add(AItem)
    else
      APopup.Items.Insert(APosition, AItem);

    Inc(APosition);
  end;

  procedure GenerateAutoCorrectItems(var APosition: Integer; ASuggestionList: TdxSpellCheckerSuggestionList);
  var
    I: Integer;
    ASubMenuItem: TMenuItem;
  begin
    if APosition > 0 then
      AddItem(APosition, 0, cLineCaption);
    AddItem(APosition, -1, cxGetResourceString(@sdxSpellCheckerAutoCorrect));
    ASubMenuItem := AOwner.Components[AOwner.ComponentCount - 1] as TMenuItem;
    I := 0;
    if ASuggestionList.Count > 0 then
    begin
      while (I < ASuggestionList.Count) and (I < Options.SuggestionCount) do
        AddItem(I, -I - 2, ASuggestionList[I].Word, ASubMenuItem);
      AddItem(I, 0, cLineCaption, ASubMenuItem);
    end;
    AddItem(I, Ord(scmiAutoCorrect), cxGetResourceString(@sdxSpellCheckerAutoCorrectOptionsFormCaption), ASubMenuItem);
  end;

  procedure GenerateItemsForMisspelledWord(var APosition: Integer);
  var
    ASuggestionList: TdxSpellCheckerSuggestionList;
  begin
    ASuggestionList := SpellChecker.GetSuggestions(TdxSpellCheckerMisspelledWord(MisspelledItem).Word);
    try
      APosition := 0;
      if scmiSuggestions in Options.PopupMenuItems then
      begin
        while (APosition < ASuggestionList.Count) and (APosition < Options.SuggestionCount) do
          AddItem(APosition, Ord(High(TdxSpellCheckerPopupMenuItem)) + 1 + APosition, ASuggestionList[APosition].Word);
      end;
      if APosition > 0 then
        AddItem(APosition, 0, cLineCaption);
      if scmiIgnore in Options.PopupMenuItems then
        AddItem(APosition, Ord(scmiIgnore), cxGetResourceString(@sdxSpellCheckerIgnoreButton));
      if scmiIgnoreAll in Options.PopupMenuItems then
        AddItem(APosition, Ord(scmiIgnoreAll), cxGetResourceString(@sdxSpellCheckerIgnoreAllButton));
      if (scmiAddToDictionary in Options.PopupMenuItems) and SpellChecker.HasEnabledUserDictionary then
        AddItem(APosition, Ord(scmiAddToDictionary), cxGetResourceString(@sdxSpellCheckerAddButton));
      if SpellChecker.AutoCorrectOptions.Active and (scmiAutoCorrect in Options.PopupMenuItems) then
        GenerateAutoCorrectItems(APosition, ASuggestionList);
    finally
      FreeAndNil(ASuggestionList);
    end;
  end;

  procedure GenerateItemsForRepeatedWord(var APosition: Integer);
  begin
    APosition := 0;
    if scmiDelete in Options.PopupMenuItems then
      AddItem(APosition, Ord(scmiDelete), cxGetResourceString(@sdxSpellCheckerDeleteButton));
  end;

var
  I: Integer;
begin
  if Assigned(MisspelledItem) then
  begin
    I := 0;
    case MisspelledItem.SpellingCode of
      scMisspelled:
        GenerateItemsForMisspelledWord(I);
      scRepeatedWords:
        GenerateItemsForRepeatedWord(I);
    end;
    if I > 0 then
      AddItem(I, 0, cLineCaption);
    if scmiSpelling in Options.PopupMenuItems then
    begin
      AddItem(I, Ord(scmiSpelling), cxGetResourceString(@sdxSpellCheckerSpellingFormCaption));
      AddItem(I, 0, cLineCaption);
    end;
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.DoActiveChanged;
begin
  if Active then
    CheckStart(FindControl(GetFocus))
  else
    CheckFinish;
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.DoFinalizeController;
begin
  RedrawEditor;
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.DoOptionsChanged;
begin
  Painter.LineColor := Options.UnderlineColor;
  Painter.LineStyle := Options.UnderlineStyle;
  RedrawEditor;
end;

function TdxSpellCheckerCheckAsYouTypeManager.GetCheckModeClass: TdxSpellCheckerCustomCheckModeClass;
begin
  Result := TdxSpellCheckerCheckAsYouTypeMode;
end;

function TdxSpellCheckerCheckAsYouTypeManager.GetAdapter: IdxSpellCheckerCheckAsYouTypeAdapter;
begin
  Result := inherited Adapter as IdxSpellCheckerCheckAsYouTypeAdapter;
end;

function TdxSpellCheckerCheckAsYouTypeManager.GetCheckMode: TdxSpellCheckerCheckAsYouTypeMode;
begin
  Result := TdxSpellCheckerCheckAsYouTypeMode(inherited CheckMode);
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.ManualCheckStateChanged;
begin
  inherited ManualCheckStateChanged;
  if CheckMode <> nil then
    CheckMode.Changed(ctMedium);
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.HandlerMenuItem(ASender: TObject);
var
  ACommand: Integer;
  AIndex: Integer;
begin
  if Assigned(MisspelledItem) then
  begin
    ACommand := TMenuItem(ASender).Tag;
    case ACommand of
      Ord(scmiAutoCorrect):
        dxShowAutoCorrectOptionsDialog(SpellChecker, SpellChecker.DialogLookAndFeel);
      Ord(scmiIgnore):
        CheckMode.Ignore;
      Ord(scmiIgnoreAll):
        CheckMode.IgnoreAll;
      Ord(scmiAddToDictionary):
        CheckMode.Add;
      Ord(scmiDelete):
        CheckMode.Delete;
      Ord(scmiSpelling):
        StartManualSpelling(Adapter);
    else
      if (ACommand > Ord(High(TdxSpellCheckerPopupMenuItem))) or (ACommand < -1) then
      begin
        if ACommand < -1 then
          AIndex := -ACommand - 2
        else
          AIndex := ACommand - Ord(High(TdxSpellCheckerPopupMenuItem)) - 1;

        HandlerSuggestion(AIndex, ACommand < -1);
      end;
    end;
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.HandlerSuggestion(AIndex: Integer; AIsAutoCorrect: Boolean);
var
  ASuggestionList: TdxSpellCheckerSuggestionList;
  AItem: TdxSpellCheckerReplacement;
  AWord: string;
begin
  ASuggestionList := SpellChecker.GetSuggestions(MisspelledItem.Word);
  try
    if ASuggestionList.Count >= AIndex then
    begin
      if AIsAutoCorrect then
      begin
        AWord := MisspelledItem.Word;
        AItem := SpellChecker.AutoCorrectOptions.Replacements.FindReplacement(AWord);
        if AItem = nil then
          SpellChecker.AutoCorrectOptions.Replacements.Add(AWord, ASuggestionList[AIndex].Word)
        else
          if dxMessageDlg(Format(cxGetResourceString(@sdxSpellCheckerAutoCorrectReplacementExistMessageFormat), [AWord]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
            SpellChecker.AutoCorrectOptions.Replacements.Add(AWord, ASuggestionList[AIndex].Word);
      end;
      CheckMode.Change(ASuggestionList[AIndex].Word);
    end;
  finally
    FreeAndNil(ASuggestionList);
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.DrawMisspellings(AControl: TWinControl; DC: HDC = 0);
begin
  ValidateAdapter;
  if (CheckMode <> nil) and (Edit = AControl) and Edit.HandleAllocated then
  begin
    if DC <> 0 then
      CheckMode.Draw(DC)
    else
    begin
      DC := GetDC(Edit.Handle);
      try
        CheckMode.Draw(DC);
      finally
        ReleaseDC(Edit.Handle, DC);
      end;
    end;
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.LayoutChanged(AControl: TWinControl);
begin
  ValidateAdapter;
  if Edit = AControl then
  begin
    if CheckMode <> nil then
      CheckMode.LayoutChanged;
  end;
end;

function TdxSpellCheckerCheckAsYouTypeManager.QueryPopup(APopup: TComponent; const P: TPoint): Boolean;

  function GetPopupPos: TPoint;
  var
    R: TRect;
  begin
    with MisspelledItem do
      R := UnderlineRect[UnderlineRectCount - 1];
    Result := cxPoint(R.Left, R.Bottom);
    if not PtInRect(Adapter.Edit.ClientRect, cxPoint(R.Left, R.Top)) then
    begin
      GetCaretPos(Result);
      Result.Y := R.Bottom;
    end;
    Result := Adapter.Edit.ClientToScreen(Result);
  end;

var
  AItemsOwner: TComponent;
begin
  Result := CanPopup(P);
  if Result then
  begin
    if Options.PopupMenu <> nil then
    begin
      InnerShowPopupMenu(Options.PopupMenu, GetPopupPos);
      Exit;
    end;

    AItemsOwner := TComponent.Create(nil);
    try
      if not Options.ModifyControlPopupMenu or not (APopup is TPopupMenu) then
      begin
        CreateInternalPopupMenu;
        APopup := InternalPopupMenu;
      end;
      CreateItems(TPopupMenu(APopup), AItemsOwner);
      InnerShowPopupMenu(APopup, GetPopupPos);
      Application.ProcessMessages;
    finally
      AItemsOwner.Free;
    end;
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.RedrawEditor;
begin
  if Adapter <> nil then
    cxInvalidateRect(Adapter.Edit);
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.ValidateAdapter;
var
  AContainer: IcxCompoundControl;
  AControl: TWinControl;
begin
  inherited ValidateAdapter;
  if Adapter = nil then
  begin
    AControl := FindControl(GetFocus);
    if (AControl <> nil) and Supports(AControl, IcxCompoundControl, AContainer) then
      CheckStart(AContainer.ActiveControl);
  end;
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.Refresh(AChangeType: TdxChangeType = ctMedium);
begin
  if CheckMode <> nil then
    CheckMode.Changed(AChangeType);
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.SelectionChanged(AControl: TWinControl);
begin
  ValidateAdapter;
  if Edit = AControl then
    CheckMode.SelectionChanged;
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.TextChanged(AControl: TWinControl);
begin
  ValidateAdapter;
  if Edit = AControl then
    CheckMode.TextChanged;
end;

procedure TdxSpellCheckerCheckAsYouTypeManager.SetMisspelledItem(AValue: TdxSpellCheckerMisspelledWord);
begin
  if AValue <> FMisspelledItem then
  begin
    FreeAndNil(FMisspelledItem);
    if AValue <> nil then
    begin
      FMisspelledItem := TdxSpellCheckerMisspelledWord.Create('', nil, nil);
      FMisspelledItem.Assign(AValue);
    end;
  end;
end;

{ TdxSpellCheckerPainter }

constructor TdxSpellCheckerPainter.Create(ALineColor: TColor);
begin
  inherited Create;
  LineColor := ALineColor;
end;

procedure TdxSpellCheckerPainter.Draw(DC: HDC; const R: TRect; ALineStyleNeeded: Boolean);
begin
  if (LineStyle = usLine) or (LineStyle = usAuto) and ALineStyleNeeded then
    DrawLine(DC, R)
  else
    DrawWavyLine(DC, R);
end;

procedure TdxSpellCheckerPainter.DrawLine(DC: HDC; const R: TRect);
begin
  FillRectByColor(DC, cxRectCenterVertically(R, 1), LineColor);
end;

procedure TdxSpellCheckerPainter.DrawWavyLine(DC: HDC; const R: TRect);

  procedure CalculateWavyLine(out P: TPoints);
  var
    ADelta: Integer;
    ATop: Boolean;
    I, X: Integer;
  begin
    X := R.Left;
    ATop := True;
    ADelta := dxSpellCheckerUnderlineSize - 1;
    SetLength(P, (R.Right - R.Left) div ADelta + 2);
    for I := 0 to Length(P) - 1 do
    begin
      P[I] := Point(X, IfThen(ATop, R.Top, R.Bottom - 1));
      ATop := not ATop;
      Inc(X, ADelta);
    end;
  end;

var
  P: TPoints;
begin
  if not cxRectIsEmpty(R) then
  begin
    CalculateWavyLine(P);
    try
      cxPaintCanvas.BeginPaint(DC);
      try
        cxPaintCanvas.SetClipRegion(TcxRegion.Create(R), roSet);
        cxPaintCanvas.Pen.Color := LineColor;
        cxPaintCanvas.Polyline(P);
      finally
        cxPaintCanvas.EndPaint;
      end;
    finally
      P := nil;
    end;
  end;
end;

procedure TdxSpellCheckerPainter.DrawWord(DC: HDC; ALineStyleNeeded: Boolean; AWord: TdxSpellCheckerMisspelledWord);
var
  I: Integer;
begin
  if AWord.ShowSquiggle then
  begin
    for I := 0 to AWord.UnderlineRectCount - 1 do
      Draw(DC, AWord.UnderlineRect[I], ALineStyleNeeded);
  end;
end;

procedure TdxSpellCheckerPainter.SetLineColor(const Value: TColor);
begin
  FLineColor := ColorToRGB(Value);
end;

end.

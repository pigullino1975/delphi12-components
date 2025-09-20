//---------------------------------------------------------------------------

#ifndef ImpDlgFH
#define ImpDlgFH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "QImport3Wizard.hpp"
#include <Db.hpp>
#include <DBGrids.hpp>
#include <ExtCtrls.hpp>
#include <Grids.hpp>
#include <ComCtrls.hpp>
#include <DB.hpp>
#include <DBClient.hpp>
//---------------------------------------------------------------------------
class TfmImpDlg : public TForm
{
__published:	// IDE-managed Components
    TQImport3Wizard *QImportWizard1;
    TPanel *Panel1;
    TButton *btImport;
    TDataSource *DataSource1;
    TCheckBox *chbUseBeforePost;
    TButton *Button1;
    TPageControl *pcDestinations;
    TTabSheet *tshDataSet;
    TDBGrid *dgrDataSet;
    TTabSheet *tshDBGrid;
    TTabSheet *tshListView;
    TTabSheet *tshStringGrid;
    TDBGrid *DBGrid;
    TListView *ListView;
    TStringGrid *StringGrid;
    TClientDataSet *Table1;
    void __fastcall FormCreate(TObject *Sender);
    void __fastcall FormDestroy(TObject *Sender);
    void __fastcall btImportClick(TObject *Sender);
    void __fastcall QImportWizard1AfterImport(TObject *Sender);
    void __fastcall QImportWizard1BeforePost(TObject *Sender, TQImportRow *Row,
      bool &Accept);
    void __fastcall Button1Click(TObject *Sender);
    void __fastcall pcDestinationsChange(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfmImpDlg(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfmImpDlg *fmImpDlg;
//---------------------------------------------------------------------------
#endif

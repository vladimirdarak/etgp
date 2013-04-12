unit USettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, DbCtrls;

type

  { TfrmSettings }

  TfrmSettings = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    edtEmail: TDBEdit;
    edtPhone: TDBEdit;
    edtPhone1: TDBEdit;
    edtState: TDBEdit;
    edtCompanyName1: TDBEdit;
    edtICO: TDBEdit;
    edtCompanyName: TDBEdit;
    edtDBName: TLabeledEdit;
    edtDBPass: TLabeledEdit;
    edtDIC: TDBEdit;
    edtPSC: TDBEdit;
    edtCity: TDBEdit;
    gbDBConnection: TGroupBox;
    edtDBHost: TLabeledEdit;
    edtDBPort: TLabeledEdit;
    edtDBUser: TLabeledEdit;
    gbInitials: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    pnlActions: TPanel;
    pcSettings: TPageControl;
    tsOwner: TTabSheet;
    tsConnection: TTabSheet;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

uses
  UMainForm;

{$R *.lfm}

{ TfrmSettings }

procedure TfrmSettings.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin

end;

end.


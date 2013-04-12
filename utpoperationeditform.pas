unit UTPOperationEditForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DbCtrls, Buttons, DBGrids, ExtCtrls, ComCtrls, ZDataset, ZSequence;

type

  { TfrmTPOperationEdit }

  TfrmTPOperationEdit = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    cbOpName: TDBLookupComboBox;
    cbMachine: TDBLookupComboBox;
    edtOpTime: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    mDesc: TDBMemo;
    edtOpNumber: TDBEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnClear: TSpeedButton;
    procedure btnClearClick(Sender: TObject);
    procedure cbOpNameChange(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmTPOperationEdit: TfrmTPOperationEdit;

implementation

uses
  UTemplatesForm, UMainForm;

{$R *.lfm}

{ TfrmTPOperationEdit }

procedure TfrmTPOperationEdit.btnClearClick(Sender: TObject);
begin
  with frmMain do
  begin
    qryOps['machine_id'] := NULL;
  end;
end;

procedure TfrmTPOperationEdit.cbOpNameChange(Sender: TObject);
begin

end;

procedure TfrmTPOperationEdit.ToolButton1Click(Sender: TObject);
begin
  //ShowOperationToolEditForm(true);
end;

end.


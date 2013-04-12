unit UPartCodingForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DbCtrls, Buttons, ExtCtrls;

type

  { TfrmPartCoding }

  TfrmPartCoding = class(TForm)
    btnClose: TBitBtn;
    btnOK: TBitBtn;
    cbSemiproductDim: TDBLookupComboBox;
    cbSemiproductType: TDBLookupComboBox;
    cbTechnology: TDBLookupComboBox;
    cbSemiproductWeight: TDBLookupComboBox;
    cbSemiproductMaterial: TDBLookupComboBox;
    gbPartCoding: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblSemiType: TLabel;
    lblSemiType1: TLabel;
    lblSemiSize: TLabel;
    lblSemiType3: TLabel;
    lblSemiWeight: TLabel;
    lblSemiType5: TLabel;
    lblSemiMat: TLabel;
    lblSemiTechnology: TLabel;
    lblSemiType8: TLabel;
    pnlDlgActions: TPanel;
    pnlGTCode: TPanel;
    procedure btnOKClick(Sender: TObject);
    procedure cbSemiproductDimChange(Sender: TObject);
    procedure cbSemiproductTypeChange(Sender: TObject);
    procedure cbTechnologyChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure qrSemiproductTypeAfterScroll(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmPartCoding: TfrmPartCoding;

implementation

{ TfrmPartCoding }

procedure TfrmPartCoding.cbSemiproductTypeChange(Sender: TObject);
begin

end;

procedure TfrmPartCoding.cbTechnologyChange(Sender: TObject);
begin
  {if Sender is TDBLookupComboBox then
    if TDBLookupComboBox(Sender).KeyValue = null then
      lblSemiTechnology.Caption:='X'
    else
      lblSemitechnology.Caption:=String(TDBLookupComboBox(Sender).KeyValue);}
end;

procedure TfrmPartCoding.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := true;
  if(ModalResult = mrOK) then
  begin
    if (cbTechnology.KeyValue = null) then
    begin
      CanClose := false;
      MessageDlg('Chyba', format('Pole "%s" je povinné', ['Technológia']), mtError, [mbOk], mrOk);
      cbTechnology.SetFocus;
      exit;
    end;

    if (cbSemiproductType.KeyValue = null) then
    begin
      CanClose := false;
      MessageDlg('Chyba', format('Pole "%s" je povinné', ['Základný tvar']), mtError, [mbOk], mrOk);
      cbSemiproductType.SetFocus;
      exit;
    end;

    if (cbSemiproductDim.KeyValue = null) then
    begin
      CanClose := false;
      MessageDlg('Chyba', format('Pole "%s" je povinné', ['Rozmery']), mtError, [mbOk], mrOk);
      cbSemiproductDim.SetFocus;
      exit;
    end;

    if (cbSemiproductWeight.KeyValue = null) then
    begin
      CanClose := false;
      MessageDlg('Chyba', format('Pole "%s" je povinné', ['Váha']), mtError, [mbOk], mrOk);
      cbSemiproductWeight.SetFocus;
      exit;
    end;

    if (cbSemiproductMaterial.KeyValue = null) then
    begin
      CanClose := false;
      MessageDlg('Chyba', format('Pole "%s" je povinné', ['Materiál']), mtError, [mbOk], mrOk);
      cbSemiproductMaterial.SetFocus;
      exit;
    end;
  end;
end;

procedure TfrmPartCoding.FormShow(Sender: TObject);
begin
  cbTechnology.ItemIndex:=-1;
  cbSemiproductType.ItemIndex:=-1;
  cbSemiproductDim.Items.Clear;
  cbSemiproductWeight.ItemIndex:=-1;
  cbSemiproductMaterial.ItemIndex:=-1;
end;

procedure TfrmPartCoding.cbSemiproductDimChange(Sender: TObject);
begin

end;

procedure TfrmPartCoding.btnOKClick(Sender: TObject);
begin

end;

procedure TfrmPartCoding.qrSemiproductTypeAfterScroll(DataSet: TDataSet);
begin

end;

{$R *.lfm}

end.


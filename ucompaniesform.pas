unit UCompaniesForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, DBGrids, DbCtrls, Buttons, ZDataset;

type

  { TfrmCompanies }

  TfrmCompanies = class(TForm)
    btnClose: TBitBtn;
    edtFilterState: TEdit;
    edtFilterPSC: TEdit;
    edtFilterName: TEdit;
    edtFilterStreet: TEdit;
    edtFilterCity: TEdit;
    gbFilter: TDBGroupBox;
    grdCompanies: TDBGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    tbActions: TToolBar;
    btnAdd: TToolButton;
    btnEdit: TToolButton;
    btnDelete: TToolButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure edtFilterNameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure ShowCompanyEditForm(IsNew: boolean);
    procedure SaveCompany;
    procedure DiscardCompany;
    procedure DeleteCompany;
    procedure DoSearchCompany;
    procedure SearchCompany(Sender: TObject; var Key: Word; Shoft: TShiftState);
  end;

var
  frmCompanies: TfrmCompanies;

implementation

uses
  UCompanyEditForm, UTools, UMainForm;

{$R *.lfm}

{ TfrmCompanies }

procedure TfrmCompanies.edtFilterNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TfrmCompanies.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  frmMain.qryCompanies.Filtered:=false;
end;

procedure TfrmCompanies.FormCreate(Sender: TObject);
begin
  edtFilterName.OnKeyUp := @SearchCompany;
  edtFilterStreet.OnKeyUp := @SearchCompany;
  edtFilterCity.OnKeyUp := @SearchCompany;
  edtFilterPSC.OnKeyUp := @SearchCompany;
  edtFilterState.OnKeyUp := @SearchCompany;
end;

procedure TfrmCompanies.btnAddClick(Sender: TObject);
begin
  ShowCompanyEditForm(true);
end;

procedure TfrmCompanies.btnDeleteClick(Sender: TObject);
begin
  DeleteCompany;
end;

procedure TfrmCompanies.btnEditClick(Sender: TObject);
begin
  ShowCompanyEditForm(false);
end;

procedure TfrmCompanies.ShowCompanyEditForm(IsNew: boolean);
begin
  try
    with frmCompanyEdit do
    begin

      if IsNew then
      begin
        Caption := 'Pridať nového odberateľa';
        frmMain.qryCompanies.Append;
      end else
      begin
        Caption := 'Upraviť odberateľa';
        frmMain.qryCompanies.Edit;
      end;

      case ShowModal of
        mrOk: SaveCompany;
        mrCancel: DiscardCompany;
      end;
    end;
  finally

  end;
end;

procedure TfrmCompanies.SaveCompany;
begin
  try
    frmMain.dbConnection.StartTransaction;
    try
      frmMain.qryCompanies.ApplyUpdates;
    finally
      frmMain.dbConnection.Commit;
      DoRefresh(frmMain.qryCompanies, 'company_id');
    end;
  except
    frmMain.dbConnection.Rollback;
  end;
end;

procedure TfrmCompanies.DiscardCompany;
begin
  frmMain.qryCompanies.CancelUpdates;
end;

procedure TfrmCompanies.DeleteCompany;
var
  vCount: Integer;
begin
  vCount := GetRecordCount(frmMain.dbConnection, 'technological_process', ['company_id'], [frmMain.qryCompanies.FieldByName('company_id').AsInteger]);

  if vCount > 0 then
    MessageDlg('Chyba', Plural('Zvoleného odberateľa nieje možné vymazať pretože existuje %s', ['technologický postup', 'technologické postupy', 'technologických postupov'], vCount), mtError, [mbOk], mrOk)
  else
    if MessageDlg('Varovanie', 'Naozaj chcete zvoleného odberateľa zmazať?', mtWarning, [mbYes, mbNo], mrNo) = mrYes then
    begin
      try
        frmMain.dbConnection.StartTransaction;
        try
          frmMain.qryCompanies.Delete;
        finally
          frmMain.dbConnection.Commit;
          DoRefresh(frmMain.qryCompanies, 'company_id');
        end;
      except
        on E: Exception do
        begin
          ShowMessage(E.Message);
          frmMain.dbConnection.Rollback;
        end;
      end;
    end;
end;

procedure TfrmCompanies.SearchCompany(Sender: TObject; var Key: Word; Shoft: TShiftState);
begin
  case Key of
    13: DoSearchCompany;
    8: begin
      if(TEdit(Sender).Text = '') then
        DoSearchCompany;
    end;
  end;
end;

procedure TfrmCompanies.DoSearchCompany;
var
  fStr, vWhere: String;
  vWheres: TStringList;
  i: Integer;
begin
  vWheres := TStringList.Create;

  try
    fStr := '';
    vWhere := '';

    if trim(edtFilterName.Text) <> '' then
      vWheres.Add('company_name LIKE ' + QuotedStr('*'+edtFilterName.Text+'*'));

    if trim(edtFilterStreet.Text) <> '' then
      vWheres.Add('street LIKE ' + QuotedStr('*'+edtFilterStreet.Text+'*'));

    if trim(edtFilterCity.Text) <> '' then
      vWheres.Add('city LIKE ' + QuotedStr('*'+edtFilterCity.Text+'*'));

    if trim(edtFilterPSC.Text) <> '' then
      vWheres.Add('psc LIKE ' + QuotedStr('*'+edtFilterPSC.Text+'*'));

    if trim(edtFilterState.Text) <> '' then
      vWheres.Add('state LIKE ' + QuotedStr('*'+edtFilterState.Text+'*'));

    for i := 0 to vWheres.Count-1 do
    begin
      if i > 0 then
        vWhere := ' AND ' + vWheres[i]
      else
        vWhere := vWheres[i];

      fStr := fStr + vWhere;
    end;

    if fStr <> '' then
    begin
      frmMain.qryCompanies.Filter:=fStr;
      frmMain.qryCompanies.Filtered:=true;
    end else
      frmMain.qryCompanies.Filtered:=false;
  finally
  end;
end;

end.


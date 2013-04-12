unit UOptimalTPForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DbCtrls, Buttons, EditBtn, ComCtrls, DBGrids, PairSplitter, types, db, Grids,
  ZDataset;

const
  {C_SQL_INSERT_OPERATIONS = 'INSERT INTO operation (technological_process_id, operation_number, machine_id, operation_desc, operation_time, operation_name_id)' +
	  '(SELECT :technological_process_id, operation_number, machine_id, operation_desc, operation_time, operation_name_id' +
	  'FROM operation WHERE template_id = :template_id ORDER BY operation_number)';}
  C_SQL_ALL_OPERATIONS = 'SELECT * FROM operation WHERE template_id = :template_id ORDER BY operation_number ASC';

type

  { TfrmOptimalTP }

  TfrmOptimalTP = class(TForm)
    btnFixtureAdd: TToolButton;
    btnFixtureDelete: TToolButton;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnToolAdd: TToolButton;
    btnToolDelete: TToolButton;
    cbCompany: TDBLookupComboBox;
    cbTechnology: TDBLookupComboBox;
    cbSemiproductDimensions: TDBLookupComboBox;
    cbSemiproductWeight: TDBLookupComboBox;
    cbMaterial: TDBLookupComboBox;
    Label18: TLabel;
    Label19: TLabel;
    cbSemiproductType: TDBLookupComboBox;
    grdFixtures: TDBGrid;
    grdOperations: TDBGrid;
    edtPartWeight: TDBEdit;
    edtCreated: TDBEdit;
    edtChecked: TDBEdit;
    edtApproved: TDBEdit;
    edtDateAssign: TDateEdit;
    edtDateIssue: TDateEdit;
    edtDrawingNumber: TDBEdit;
    edtQuantity: TDBEdit;
    edtTPName: TDBEdit;
    gbBasic: TGroupBox;
    gbPart: TGroupBox;
    gbOperations: TGroupBox;
    grdTools: TDBGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    pcEditTP: TPageControl;
    btnTemplateImport: TSpeedButton;
    ScrollBox1: TScrollBox;
    tbOperationFixtureActions: TToolBar;
    tbOperationToolActions: TToolBar;
    ToolBar1: TToolBar;
    btnOperationAdd: TToolButton;
    btnOperationEdit: TToolButton;
    btnOperationDelete: TToolButton;
    ToolButton4: TToolButton;
    tsTPOperations: TTabSheet;
    tsTPHeader: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnEditCompaniesClick(Sender: TObject);
    procedure btnFixtureAddClick(Sender: TObject);
    procedure btnFixtureDeleteClick(Sender: TObject);
    procedure btnOperationDeleteClick(Sender: TObject);
    procedure btnOperationEditClick(Sender: TObject);
    procedure btnTemplateImportClick(Sender: TObject);
    procedure btnToolAddClick(Sender: TObject);
    procedure btnToolDeleteClick(Sender: TObject);
    procedure cbNormChange(Sender: TObject);
    procedure cbNormDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure cbSemiproductTypeChange(Sender: TObject);
    procedure DateEdit1Change(Sender: TObject);
    procedure edtDateIssueClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure grdFixturesPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure grdOperationsCellClick(Column: TColumn);
    procedure grdOperationsColEnter(Sender: TObject);
    procedure grdOperationsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure grdOperationsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grdOperationsPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure grdToolsPrepareCanvas(sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnOperationAddClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure ShowOperationEditForm(IsNew: boolean);
    procedure ShowOperationToolEditForm(IsNew: boolean);
    procedure ShowOperationFixtureEditForm(IsNew: boolean);
    procedure ShowTemplateImportForm;

    procedure OperationSave;
    procedure OperationDiscard;
    procedure OperationDelete;
    procedure OperationToolSave;
    procedure OperationToolDiscard;
    procedure OperationToolDelete;
    procedure OperationFixtureSave;
    procedure OperationFixtureDiscard;
    procedure OperationFixtureDelete;
    procedure TemplateImport;

    procedure UpdateActions;
  end;

var
  frmOptimalTP: TfrmOptimalTP;

implementation

{$R *.lfm}

uses
  UMainForm, UTools, UTPOperationEditForm, UOperationToolEditForm,
  UOperationFixtureEditForm, UTemplateChooseForm, UProgressForm;

{ TfrmOptimalTP }

procedure TfrmOptimalTP.FormShow(Sender: TObject);
begin
  UpdateActions;
end;

procedure TfrmOptimalTP.grdFixturesPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  UTools.DBGridPrepareCanvas(Sender, DataCol, Column, 1);
end;

procedure TfrmOptimalTP.grdOperationsCellClick(Column: TColumn);
begin

end;

procedure TfrmOptimalTP.grdOperationsColEnter(Sender: TObject);
begin

end;

procedure TfrmOptimalTP.grdOperationsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  self.UpdateActions;
end;

procedure TfrmOptimalTP.grdOperationsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TfrmOptimalTP.grdOperationsPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  UTools.DBGridPrepareCanvas(Sender, DataCol, Column, 4);
end;

procedure TfrmOptimalTP.grdToolsPrepareCanvas(sender: TObject;
  DataCol: Integer; Column: TColumn; AState: TGridDrawState);
begin
  UTools.DBGridPrepareCanvas(Sender, DataCol, Column, 1);
end;

procedure TfrmOptimalTP.SpeedButton1Click(Sender: TObject);
begin
  frmMain.itmCompanyClick(self);
end;

procedure TfrmOptimalTP.btnOperationAddClick(Sender: TObject);
begin
  self.ShowOperationEditForm(true);
end;

procedure TfrmOptimalTP.btnEditCompaniesClick(Sender: TObject);
begin
  //frmMain.itmCompanyClick(self);
end;

procedure TfrmOptimalTP.btnFixtureAddClick(Sender: TObject);
begin
  ShowOperationFixtureEditForm(true);
end;

procedure TfrmOptimalTP.btnFixtureDeleteClick(Sender: TObject);
begin
  OperationFixtureDelete;
end;

procedure TfrmOptimalTP.btnOperationDeleteClick(Sender: TObject);
begin
  OperationDelete;
end;

procedure TfrmOptimalTP.btnOperationEditClick(Sender: TObject);
begin
  self.ShowOperationEditForm(false);
end;

procedure TfrmOptimalTP.btnTemplateImportClick(Sender: TObject);
begin
  ShowTemplateImportForm;
end;

procedure TfrmOptimalTP.btnToolAddClick(Sender: TObject);
begin
  ShowOperationToolEditForm(true);
end;

procedure TfrmOptimalTP.btnToolDeleteClick(Sender: TObject);
begin
  OperationToolDelete;
end;

procedure TfrmOptimalTP.cbNormChange(Sender: TObject);
begin

end;

procedure TfrmOptimalTP.cbNormDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin

end;

procedure TfrmOptimalTP.cbSemiproductTypeChange(Sender: TObject);
begin

end;

procedure TfrmOptimalTP.BitBtn1Click(Sender: TObject);
begin

end;

procedure TfrmOptimalTP.btnCancelClick(Sender: TObject);
begin

end;

procedure TfrmOptimalTP.DateEdit1Change(Sender: TObject);
begin

end;

procedure TfrmOptimalTP.edtDateIssueClick(Sender: TObject);
begin
  //ShowMEssage(edtDateIssue.Text);
end;

procedure TfrmOptimalTP.FormActivate(Sender: TObject);
begin

end;

procedure TfrmOptimalTP.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := true;

  if ModalResult = mrOK then
  begin
    if (cbTechnology.KeyValue = null) or (cbTechnology.KeyValue) or (cbCompany.KeyValue = null) or (trim(edtTPName.Text) = '') or (trim(edtCreated.Text) = '') then
      pcEditTP.ActivePageIndex:=0;

    if cbCompany.KeyValue = null then
    begin
      CanClose := false;
      MessageDlg('Chyba', format('Pole "%s" je povinné', ['Odberateľ']), mtError, [mbOk], mrOk);
      cbCompany.SetFocus;
      exit;
    end;

    if cbTechnology.KeyValue = null then
    begin
      CanClose := false;
      MessageDlg('Chyba', format('Pole "%s" je povinné', ['Základný tvar súčiastky']), mtError, [mbOk], mrOk);
      cbTechnology.SetFocus;
      exit;
    end;

    if cbTechnology.KeyValue = null then
    begin
      CanClose := false;
      MessageDlg('Chyba', format('Pole "%s" je povinné', ['Technológia']), mtError, [mbOk], mrOk);
      cbTechnology.SetFocus;
      exit;
    end;

    if trim(edtTPName.Text) = '' then
    begin
      CanClose := false;
      MessageDlg('Chyba', format('Pole "%s" je povinné', ['Názov súčiastky']), mtError, [mbOk], mrOk);
      edtTPName.SetFocus;
      exit;
    end;

    if trim(edtCreated.Text) = '' then
    begin
      CanClose := false;
      MessageDlg('Chyba', format('Pole "%s" je povinné', ['Vyhotovil']), mtError, [mbOk], mrOk);
      edtCreated.SetFocus;
      exit;
    end;
  end else
  begin
    if(MessageDlg('Upozornenie', 'Všetky vykonané zmeny sa nenávratne stratia. Naozaj chcete ukončiť?', mtWarning, [mbYes, mbNo], mrYes) = mrYes) then
      CanClose := true
    else
      CanClose := false;
  end;
end;

procedure TfrmOptimalTP.FormKeyPress(Sender: TObject; var Key: char);
begin
  if key = #27 then Close;
end;

procedure TfrmOptimalTP.ShowOperationEditForm(IsNew: boolean);
begin
  grdOperations.Options:=grdOperations.Options-[dgMultiselect];
  with frmTPOperationEdit do
  begin
    Caption := 'Uložiť operáciu';

    if IsNew then
    begin
      Caption := 'Vložiť novú operáciu';
      frmMain.qryOps.Append;
      frmMain.qryOps.FieldByName('operation_number').Value:=(frmMain.qryOps.RecordCount*10)+10;
    end else
      frmMain.qryOps.Edit;

    case ShowModal of
      mrOk: OperationSave;
      mrCancel: OperationDiscard;
    end;

    grdOperations.Options:=grdOperations.Options+[dgMultiselect];
  end;
end;

procedure TfrmOptimalTP.OperationSave;
begin
  frmMain.qryOps['technological_process_id'] := frmMain.qryProcess['technological_process_id'];
  frmMain.qryOps.ApplyUpdates;

  DoRefresh(frmMain.qryOps, 'operation_id');

  self.UpdateActions;
end;

procedure TfrmOptimalTP.OperationDiscard;
begin
  frmMain.qryOps.CancelUpdates;
end;

procedure TfrmOptimalTP.OperationDelete;
var
  vMessage: String;
  vI: Integer;
begin
  vMessage := 'Budú odstránené všetky nástroje a prípravky patriace do zvolenej operácie. Naozaj chcete zvolenú operáciu zmazať?';
  if grdOperations.SelectedRows.Count > 1 then
    vMessage := 'Budú odstránené všetky nástroje a prípravky patriace do zvolených operácí. Naozaj chcete zvolené operácie zmazať?';

  if MessageDlg('Varovanie', vMessage, mtWarning, [mbYes, mbNo], mrNo) = mrYes then
    //frmMain.qryOps.Delete;
    for vI := 0 to grdOperations.SelectedRows.Count-1 do
    begin
      frmMain.qryOps.GotoBookmark(Pointer(grdOperations.SelectedRows.Items[vI]));
      //grdOperations.SelectedRows.Delete;
      frmMain.qryOps.Delete;
    end;
    frmMain.qryOps.Refresh;
    grdOperations.SelectedRows.Clear;

  self.UpdateActions;
end;

procedure TfrmOptimalTP.ShowOperationToolEditForm(IsNew: boolean);
begin
  with frmOperationTool do
  begin
    Caption := 'Pridať operáciu';

    qryTool.Active:=false;
    qryTool.Active:=true;

    frmMain.qryTools.Append;

    if IsNew and (qryTool.RecordCount > 0) then
    begin
      cbToolName.ItemIndex:= 0;
      cbToolName.DataSource.DataSet['tool_id'] := cbToolName.KeyValue;
    end;

    case ShowModal of
      mrOk: OperationToolSave;
      mrCancel: OperationToolDiscard;
    end;
  end;
end;

procedure TfrmOptimalTP.ShowOperationFixtureEditForm(IsNew: boolean);
begin
  with frmOperationFixtureEdit do
  begin
    Caption := 'Pridať prípravok';

    qryFixture.Active:=false;
    qryFixture.Active:=true;

    frmMain.qryFixtures.Append;

    if IsNew and (qryFixture.RecordCount > 0) then
    begin
      cbFixtureName.ItemIndex:= 0;
      cbFixtureName.DataSource.DataSet['fixture_id'] := cbFixtureName.KeyValue;
    end;

    case ShowModal of
      mrOk: OperationFixtureSave;
      mrCancel: OperationFixtureDiscard;
    end;
  end;
end;

procedure TfrmOptimalTP.OperationToolSave;
begin
  frmMain.qryTools['operation_id'] := frmMain.qryOps['operation_id'];
  frmMain.qryTools.ApplyUpdates;

  DoRefresh(frmMain.qryTools, 'operation_tool_id');

  UpdateActions;
end;

procedure TfrmOptimalTP.OperationToolDiscard;
begin
  frmMain.qryTools.CancelUpdates;
end;

procedure TfrmOptimalTP.OperationToolDelete;
begin
  if MessageDlg('Varovanie', 'Naozaj chcete zvolený nástroj zmazať?', mtWarning, [mbYes, mbNo], mrNo) = mrYes then
    frmMain.qryTools.Delete;

  UpdateActions;
end;

procedure TfrmOptimalTP.OperationFixtureSave;
begin
  frmMain.qryFixtures['operation_id'] := frmMain.qryOps['operation_id'];
  frmMain.qryFixtures.ApplyUpdates;

  DoRefresh(frmMain.qryFixtures, 'operation_fixture_id');

  UpdateActions;
end;

procedure TfrmOptimalTP.OperationFixtureDiscard;
begin
  frmMain.qryFixtures.CancelUpdates;
end;

procedure TfrmOptimalTP.OperationFixtureDelete;
begin
  if MessageDlg('Varovanie', 'Naozaj chcete zvolený prípravok zmazať?', mtWarning, [mbYes, mbNo], mrNo) = mrYes then
    frmMain.qryFixtures.Delete;

  UpdateActions;
end;

procedure TfrmOptimalTP.UpdateActions;
begin
  with frmMain do
  begin
    if qryOps.Active then
    begin
      btnOperationEdit.Enabled:=(qryOps.RecordCount > 0) And (grdOperations.SelectedRows.Count < 2);

      btnOperationDelete.Enabled:=(qryOps.RecordCount > 0);
      btnTemplateImport.Enabled:=(frmTemplateChoose.qryTemplates.RecordCount > 0);

      if qryOps.Active then
      begin
        {btnOperationEdit.Enabled:=(qryOps.RecordCount > 0);
        btnOperationDelete.Enabled:=(qryOps.RecordCount > 0);}

        btnToolAdd.Enabled:=(qryOps.RecordCount > 0);
        btnFixtureAdd.Enabled:=(qryOps.RecordCount > 0);
      end;

      with frmMain do
      begin
        if qryTools.Active then
        begin
          btnToolDelete.Enabled:=(qryTools.RecordCount > 0);
        end;

        if qryFixtures.Active then
        begin
          btnFixtureDelete.Enabled:=(qryFixtures.RecordCount > 0);
        end;
      end;

    end;
  end;
end;

procedure TfrmOptimalTP.ShowTemplateImportForm;
begin
  with frmTemplateChoose do
  begin
    grdTemplates.DataSource.DataSet.First;


    case ShowModal of
      mrOK: TemplateImport;
    end;
  end;
end;

procedure TfrmOptimalTP.TemplateImport;
var
  qryO, qryT, qryF: TZQuery;
  tId: integer;
begin
  try
    qryO := TZQuery.Create(nil);
    qryT := TZQuery.Create(nil);
    qryF := TZQuery.Create(nil);

    if(MessageDlg('Upozornenie', 'Všetky doteraz nadefinované operácie sa stratia. Pokračovať?', mtWarning, [mbYes, mbNo], mrYes) = mrYes) then
    begin
      qryO.Connection := frmMain.dbConnection;
      qryT.Connection := frmMain.dbConnection;
      qryF.Connection := frmMain.dbConnection;

      //pred odmazanim operacii musim odmazat vsetky nastroje
      qryT.SQL.Text:='DELETE FROM operation_tool WHERE operation_id IN (SELECT operation_id FROM operation WHERE technological_process_id = :technological_process_id)';
      qryT.ParamByName('technological_process_id').Value:=frmMain.qryProcess.FieldByName('technological_process_id').AsInteger;
      qryT.ExecSQL;
      qryT.Close;
      qryT.SQL.Clear;

      //pred odmazanim operacii musim odmazat vsetky pripravky
      qryF.SQL.Text:='DELETE FROM operation_fixture WHERE operation_id IN (SELECT operation_id FROM operation WHERE technological_process_id = :technological_process_id)';
      qryF.ParamByName('technological_process_id').Value:=frmMain.qryProcess.FieldByName('technological_process_id').AsInteger;
      qryF.ExecSQL;
      qryF.Close;
      qryF.SQL.Clear;

      //odmazem vsetky operacie
      qryO.SQL.Text:='DELETE FROM operation WHERE technological_process_id = :technological_process_id';
      qryO.ParamByName('technological_process_id').Value:=frmMain.qryProcess.FieldByName('technological_process_id').AsInteger;
      qryO.ExecSQL;
      qryO.Close;
      qryO.SQL.Clear;

      DoRefresh(frmMain.qryOps, 'operation_id');

      // vyslektujem vsetky nadefinovane operacie pre zvolenu sablonu
      with qryO do
      begin
        SQL.Text:=C_SQL_ALL_OPERATIONS;
        qryT.SQL.Text:='SELECT * FROM operation_tool WHERE operation_id = :operation_id';
        qryF.SQL.Text:='SELECT * FROM operation_fixture WHERE operation_id = :operation_id';
        ParamByName('template_id').Value:=frmTemplateChoose.qryTemplates.FieldByName('template_id').AsInteger;

        //prejdem vsetky operacie zo sablony a insertnem do operacii zvoleneho TP
        Open;
        First;

        frmProgress.pbProgress.Min:=0;
        frmProgress.pbProgress.Max:=qryO.RecordCount;

        frmProgress.ShowOnTop;
        Application.ProcessMessages;
        while not EOF do
        begin
          with frmMain.qryOps do
          begin
            Insert;
            frmProgress.pbProgress.StepBy(1);
            Application.ProcessMessages;

            frmMain.qryOps['technological_process_id'] := frmMain.qryProcess.FieldByName('technological_process_id').AsInteger;
            frmMain.qryOps['operation_id'] := qryO.FieldByName('operation_id').AsInteger;
            frmMain.qryOps['operation_number'] := qryO.FieldByName('operation_number').AsInteger;
            if qryO.FieldByName('machine_id').AsInteger > 0 then
              frmMain.qryOps['machine_id'] := qryO.FieldByName('machine_id').AsInteger;
            frmMain.qryOps['operation_desc'] := qryO.FieldByName('operation_desc').AsString;
            frmMain.qryOps['operation_time'] := qryO.FieldByName('operation_time').AsInteger;
            frmMain.qryOps['operation_name_id'] := qryO.FieldByName('operation_name_id').AsInteger;
            ApplyUpdates;
          end;

          // resfresh aby sa zobrazili operacie v gride
          DoRefresh(frmMain.qryOps, 'operation_id');
          // potrebne prejst na posledny zaznam koli last_insert_id
          frmMain.qryOps.Last;

          //prejdem vsetky nastroje patriace do operacie zo sablony a insertnem
          //do novovytvorenej operacie zvoleneho TP
          qryT.ParamByName('operation_id').Value:=qryO.FieldByName('operation_id').AsInteger;
          qryT.Open;
          qryT.First;
          while not qryT.EOF do
          begin
            frmMain.qryTools.Insert;
            frmMain.qryTools['operation_id'] := frmMain.qryOps.FieldByName('operation_id').AsInteger;
            frmMain.qryTools['tool_id'] := qryT.FieldByName('tool_id').AsInteger;

            qryT.Next;
            frmMain.qryTools.ApplyUpdates;
          end;
          qryT.Close;

          //prejdem vsetky pripravky patriace do operacie zo sablony a insertnem
          //do novovytvorenej operacie zvoleneho TP
          qryF.ParamByName('operation_id').Value:=qryO.FieldByName('operation_id').AsInteger;
          qryF.Open;
          qryF.First;

          while not qryF.EOF do
          begin
            frmMain.qryFixtures.Insert;
            frmMain.qryFixtures['operation_id'] := frmMain.qryOps.FieldByName('operation_id').AsInteger;
            frmMain.qryFixtures['fixture_id'] := qryF.FieldByName('fixture_id').AsInteger;

            qryF.Next;
            frmMain.qryFixtures.ApplyUpdates;
          end;
          qryF.Close;

          Next;
        end;
        frmProgress.Close;

        frmMain.qryOps.First;
        self.UpdateActions;
      end;
    end;
  finally
    qryT.Free;
    qryF.Free;
    qryO.Free;
  end;
end;

end.


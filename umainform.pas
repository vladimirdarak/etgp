unit UMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LR_Desgn, LR_Class, LR_View, LR_DBSet,
  LR_BarC, LR_E_CSV, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus,
  DBGrids, StdCtrls, ExtCtrls, DbCtrls, ActnList, ZConnection, ZDataset,
  ZConnectionGroup, ZGroupedConnection, ZSqlUpdate, IniFiles, contnrs, LCLType,
  LResources, lr_e_pdf;

const
  C_PG_LIBRARY_NAME = 'libpq.so';
  C_INI_SETTINGS_FILENAME = 'settings.ini';

type
  TConnectionParams = record
    Host: String;
    Port: Integer;
    Database: String;
    User: String;
    Password: String;
  end;

  { TfrmMain }

  TfrmMain = class(TForm)
    dsSemiproductDim: TDatasource;
    dsNorm: TDatasource;
    dsNormSpec: TDatasource;
    dsOps: TDatasource;
    dsFixtures: TDatasource;
    dsMachines: TDatasource;
    dsOperationNames: TDatasource;
    dsProcess: TDatasource;
    dbConnection: TZConnection;
    dsCompanies: TDatasource;
    dsSemiproductWeight: TDatasource;
    dsSemiproductType: TDatasource;
    dsSemiproductMat: TDatasource;
    dsTechnology: TDatasource;
    dsTools: TDatasource;
    edtFilterCompany: TLabeledEdit;
    edtFilterPart: TLabeledEdit;
    edtFilterDrawing: TLabeledEdit;
    frBarCode: TfrBarCodeObject;
    frCSVExport1: TfrCSVExport;
    frDsProcessOperations: TfrDBDataSet;
    frReport: TfrReport;
    frTNPDFExport1: TfrTNPDFExport;
    gridProcess: TDBGrid;
    gbActions: TGroupBox;
    ilPopupActions: TImageList;
    itmFile: TMenuItem;
    itmTools: TMenuItem;
    itmCiselniky: TMenuItem;
    itmSepar: TMenuItem;
    itmClose: TMenuItem;
    itmEdit: TMenuItem;
    itmNew: TMenuItem;
    itmNewOTP: TMenuItem;
    itmTemplates: TMenuItem;
    MenuItem1: TMenuItem;
    itmSettings: TMenuItem;
    itmCompany: TMenuItem;
    MenuItem2: TMenuItem;
    itmEditTP: TMenuItem;
    itmDeleteTP: TMenuItem;
    MenuItem3: TMenuItem;
    itmPrint: TMenuItem;
    itmHelp: TMenuItem;
    itmAbout: TMenuItem;
    mmGlobal: TMainMenu;
    pnlActions: TPanel;
    menuActionsProcess: TPopupMenu;
    qryCompaniesis_root: TBooleanField;
    qryProcessapproved: TStringField;
    qryProcesschecked: TStringField;
    qryProcesscity: TStringField;
    qryProcesscompany_id: TLongintField;
    qryProcesscompany_name: TStringField;
    qryProcesscreated: TStringField;
    qryProcessdate_of_assigment: TDateField;
    qryProcessdate_of_issue: TDateField;
    qryProcessdescription: TMemoField;
    qryProcessdimension_name: TStringField;
    qryProcessdrawing_number: TStringField;
    qryProcessgt_code: TStringField;
    qryProcessmaterial_name: TStringField;
    qryProcesspart_name: TStringField;
    qryProcesspart_weight: TFloatField;
    qryProcesspsc: TStringField;
    qryProcessquality_id: TLongintField;
    qryProcessquantity: TLongintField;
    qryProcesssemiproduct_dimension_id: TLongintField;
    qryProcesssemiproduct_material_id: TLongintField;
    qryProcesssemiproduct_type_id: TLongintField;
    qryProcesssemiproduct_weight_id: TLongintField;
    qryProcessstreet: TStringField;
    qryProcesstechnological_process_id: TLongintField;
    qryProcesstechnology_id: TLongintField;
    qryProcesstechnology_name: TStringField;
    qryProcesstolerance_id: TLongintField;
    qryProcesstype_name: TStringField;
    qryProcessweight_type: TStringField;
    qrySemiproductMatmaterial_desc: TMemoField;
    qrySemiproductMatmaterial_name: TStringField;
    qrySemiproductMatsemiproduct_material_id: TLongintField;
    qrySemiproductWeight: TZQuery;
    qrySemiproductDimdimension_name: TStringField;
    qrySemiproductDimsemiproduct_dimension_id: TLongintField;
    qrySemiproductDimsemiproduct_type_id: TLongintField;
    qrySemiproductType: TZQuery;
    qrySemiproductTypesemiproduct_type_id: TLongintField;
    qrySemiproductTypetype_name: TStringField;
    qrySemiproductMat: TZQuery;
    qrySemiproductWeightsemiproduct_weight_id: TLongintField;
    qrySemiproductWeightweight_desc: TMemoField;
    qrySemiproductWeightweight_type: TStringField;
    qryTechnology: TZQuery;
    qryTechnologytechnology_id: TLongintField;
    qryTechnologytechnology_name: TStringField;
    qryCompanies: TZQuery;
    qryCompaniescity: TStringField;
    qryCompaniescompany_id: TLongintField;
    qryCompaniescompany_name: TStringField;
    qryCompaniesdic: TStringField;
    qryCompaniesemail: TStringField;
    qryCompaniesico: TStringField;
    qryCompaniesphone: TStringField;
    qryCompaniesphone1: TStringField;
    qryCompaniespsc: TStringField;
    qryCompaniesstate: TStringField;
    qryCompaniesstreet: TStringField;
    qryFixtures: TZQuery;
    qryFixturesfixture_desc: TMemoField;
    qryFixturesfixture_id: TLongintField;
    qryFixturesfixture_name: TStringField;
    qryFixturesoperation_fixture_id: TLongintField;
    qryFixturesoperation_id: TLongintField;
    qryMachines: TZQuery;
    qryMachinesmachine_desc: TMemoField;
    qryMachinesmachine_id: TLongintField;
    qryMachinesmachine_name: TStringField;
    qryOperationNames: TZQuery;
    qryOperationNamesoperation_name: TStringField;
    qryOperationNamesoperation_name_id: TLongintField;
    qryOpsmachine_id: TLongintField;
    qryOpsmachine_name: TStringField;
    qryOpsoperation_desc: TMemoField;
    qryOpsoperation_id: TLongintField;
    qryOpsoperation_name: TStringField;
    qryOpsoperation_name_id: TLongintField;
    qryOpsoperation_number: TLongintField;
    qryOpsoperation_time: TFloatField;
    qryOpstechnological_process_id: TLongintField;
    qryOpstemplate_id: TLongintField;
    qryTools: TZQuery;
    qryToolsoperation_id: TLongintField;
    qryToolsoperation_tool_id: TLongintField;
    qryToolstool_description: TMemoField;
    qryToolstool_id: TLongintField;
    qryToolstool_name: TStringField;
    ScrollBox1: TScrollBox;
    StatusBar1: TStatusBar;
    qryProcess: TZQuery;
    ToolBar2: TToolBar;
    btnAddTP: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    btnAddOTP: TToolButton;
    btnEditTP: TToolButton;
    btnDeleteTP: TToolButton;
    ToolButton3: TToolButton;
    updFixtures: TZUpdateSQL;
    updOps: TZUpdateSQL;
    updProcess: TZUpdateSQL;
    updTools: TZUpdateSQL;
    qryOps: TZQuery;
    qrySemiproductDim: TZQuery;
    procedure dbQueryProcessAfterScroll(DataSet: TDataSet);
    procedure edtFilterCompanyChange(Sender: TObject);
    procedure edtFilterCompanyKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtFilterPartKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frDsProcessOperationsFirst(Sender: TObject);
    procedure frDsProcessOperationsNext(Sender: TObject);
    procedure frReportEnterRect(Memo: TStringList; View: TfrView);
    procedure frReportGetValue(const ParName: String; var ParValue: Variant);
    procedure frReportManualBuild(Page: TfrPage);
    procedure gridProcessDblClick(Sender: TObject);
    procedure gridProcessKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure itmAboutClick(Sender: TObject);
    procedure itmCiselnikyClick(Sender: TObject);
    procedure itmCloseClick(Sender: TObject);
    procedure itmCompanyClick(Sender: TObject);
    procedure itmDeleteTPClick(Sender: TObject);
    procedure itmEditTPClick(Sender: TObject);
    procedure itmNewClick(Sender: TObject);
    procedure itmNewOTPClick(Sender: TObject);
    procedure itmSettingsClick(Sender: TObject);
    procedure itmTemplatesClick(Sender: TObject);
    procedure itmPrintClick(Sender: TObject);
    procedure qryNormAfterOpen(DataSet: TDataSet);
    procedure qryNormAfterScroll(DataSet: TDataSet);
    procedure qryNormBeforeScroll(DataSet: TDataSet);
    procedure qryNormSpecAfterOpen(DataSet: TDataSet);
    procedure qryOperationsAfterScroll(DataSet: TDataSet);
    procedure qryOpsAfterOpen(DataSet: TDataSet);
    procedure qryOpsAfterScroll(DataSet: TDataSet);
    procedure qryProcessAfterScroll(DataSet: TDataSet);
    procedure qrySemiproductTypeAfterScroll(DataSet: TDataSet);
    procedure settingsSave(Sender: TObject);
    procedure settingsDiscard(Sender: TObject);
    procedure btnAddTPClick(Sender: TObject);
    procedure btnAddOTPClick(Sender: TObject);
    procedure btnEditTPClick(Sender: TObject);
    procedure btnDeleteTPClick(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure updateMenu;
    procedure ConnectionActivate(Connection: TZConnection; Queries: TObjectList; Status: boolean);
    procedure TestConnection(Sender: TObject);
  private
    { private declarations }
    FSettings: TIniFile;
    FAppPath: string;

    FDBParams: TConnectionParams;
    FDBQueries: TObjectList;
  public
    { public declarations }

    FDBConnected: boolean;

    procedure OnNormChange(Sender: TObject);
    procedure OnSemiproductTypeChange(Sender: TObject);
    procedure OnSemiproductDimChange(Sender: TObject);
    procedure OnSemiproductWeightChange(Sender: TObject);
    procedure OnSemiproductMatChange(Sender: TObject);
    procedure OnSemiproductTechChange(Sender: TObject);
    procedure partCodingOnTechnologyChange(Sender: TObject);
    procedure SaveOptimalTP;
    procedure DiscardOptimalTP;
    procedure Filter(Sender: TObject; var Key: Word; Shoft: TShiftState);
    procedure DoFilter;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  UCiselnikyForm, UPartCodingForm, USettings, UTools, UOptimalTPForm,
  UCompaniesForm, UTemplatesForm, UTemplateChooseForm, UProgressForm, UAboutForm;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.itmCiselnikyClick(Sender: TObject);
begin
  with frmCiselniky do
  begin
    {qMachine.Connection := dbConnection;
    qMachineAttr.Connection := dbConnection;

    qTools.Connection := dbConnection;}

    ShowModal;
  end;
end;

procedure TfrmMain.itmCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.itmCompanyClick(Sender: TObject);
begin
  with frmCompanies do
  begin
    qryCompanies.ParamByName('is_root').Value:=FALSE;
    qryCompanies.Refresh;
    ShowModal;

    DoReactivate(qryCompanies);
  end;
end;

procedure TfrmMain.itmDeleteTPClick(Sender: TObject);
var
  vMessage: String;
  vI: Integer;
begin
  vMessage := 'Naozaj chcete odstrániť zvolený technologický postup?';
  if gridProcess.SelectedRows.Count > 1 then
    vMessage := 'Naozaj chcete odstrániť zvolené technologické postupy?';

  if MessageDlg('Upozornenie', vMessage, mtConfirmation, [mbYes, mbNo], mrYes) = mrYes then
  begin
    qryProcess.Delete;
    //while gridProcess.SelectedRows.Count > 0 do
    {for vI := 0 to gridProcess.SelectedRows.Count-1 do
    begin
      qryProcess.GotoBookmark(Pointer(gridProcess.SelectedRows.Items[vI]));
      qryProcess.Delete;
    end;}
    //gridProcess.SelectedRows.Delete;
    if dbConnection.InTransaction then
      dbConnection.Commit;
  end;

  updateMenu;
end;

procedure TfrmMain.itmEditTPClick(Sender: TObject);
begin
  dbConnection.StartTransaction;

  try
    try
      with frmOptimalTP do
      begin
        pcEditTP.ActivePageIndex:=0;
        edtDateAssign.Date:=qryProcess.FieldByName('date_of_assigment').AsDateTime;
        edtDateIssue.Date:=qryProcess.FieldByName('date_of_issue').AsDateTime;

        qryOps.Refresh;

        {qryNormSpec.Close;
        qryNormSpec.Params.ParamByName('norm_id').Value := qryProcess.FieldByName('norm_id').AsInteger;
        qryNormSpec.Open;}

        qrySemiproductDim.Close;
        qrySemiproductDim.ParamByName('semiproduct_type_id').Value := qryProcess.FieldByName('semiproduct_type_id').AsInteger;
        qrySemiproductDim.Open;

        //cbNorm.OnChange := @OnNormChange;
        with qryCompanies do
        begin
          Close;
          ParamByName('is_root').Value:=FALSE;
          Open;
        end;

        cbSemiproductType.OnChange:=@OnSemiproductTypeChange;
        qryProcess.Edit;

        case ShowModal of
          mrOK: SaveOptimalTP;
          mrCancel: DiscardOptimalTP;
        end;
      end;
    finally

    end;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      DiscardOptimalTP;
    end;
  end;
end;

procedure TfrmMain.itmNewClick(Sender: TObject);
var
  aGTCode: string;
  aQry, aQryO, aQryT, aQryF: TZQuery;
begin
  with frmPartCoding do
  begin
    //qrySemiproductType.Active := true;

    //qryNorm.Active := true;
    //cbNorm.OnChange := @OnNormChange;
    cbSemiproductType.OnChange:=@OnSemiproductTypeChange;
    cbSemiproductDim.OnChange:=@OnSemiproductDimChange;
    cbSemiproductWeight.OnChange:=@OnSemiproductWeightChange;
    cbSemiproductMaterial.OnChange:=@OnSemiproductMatChange;
    cbTechnology.OnChange:=@OnSemiproductTechChange;

    //qryTechnology.Active := true;

    qryProcess.Filtered:=false;
    case ShowModal of
      mrOk: begin
        aGTCode := lblSemiTechnology.Caption + '-' + lblSemiType.Caption + '-' + lblSemiSize.Caption + '.' + lblSemiWeight.Caption + '-' + lblSemiMat.Caption;

        aQry := TZQuery.Create(nil);
        aQry.Connection := dbConnection;

        //najdeme vsetky technologicke postupy ktore vyhovuju zvolenemu GT code
        aQry.SQL.Text := 'SELECT * FROM technological_process WHERE gt_code = :gt_code';
        aQry.Active := true;
        aQry.Close;
        aQry.ParamByName('gt_code').Value:=aGTCode;
        aQry.Open;

        aQry.First;
        if(aQry.RecordCount > 0) then
        begin
          // zrusim Connection autocomit a zacnem transakciu
          dbConnection.StartTransaction;

          try
            try
              with frmOptimalTP do
              begin
                qryProcess.Append;
                qryProcess['part_name'] := 'Nová súčiastka';
                edtDateAssign.Date:=now;
                qryProcess['date_of_assigment'] := edtDateAssign.Date;
                qryProcess['created'] := getSystemUsername;
                qryProcess['technology_id'] := frmPartCoding.cbTechnology.KeyValue;
                qryProcess['semiproduct_type_id'] := frmPartCoding.cbSemiproductType.KeyValue;
                qryProcess['semiproduct_dimension_id'] := frmPartCoding.cbSemiproductDim.KeyValue;
                qryProcess['semiproduct_weight_id'] := frmPartCoding.cbSemiproductWeight.KeyValue;
                qryProcess['semiproduct_material_id'] := frmPartCoding.cbSemiproductMaterial.KeyValue;
                qryProcess.ApplyUpdates;

                qryOps.ParamByName('technological_process_id').Value:=qryProcess.FieldByName('technological_process_id').AsInteger;

                with qryCompanies do
                begin
                  Close;
                  ParamByName('is_root').Value:=FALSE;
                  Open;
                end;

                cbSemiproductType.OnChange:=@OnSemiproductTypeChange;

                qryProcess.Edit;
                //ShowMessage(qryProcess.FieldByName('technological_process_id').AsString);


                pcEditTP.ActivePageIndex:=0;

                aQryO := TZQuery.Create(nil);
                aQryT := TZQuery.Create(nil);
                aQryF := TZQuery.Create(nil);

                aQryO.Connection := dbConnection;
                aQryT.Connection := dbConnection;
                aQryF.Connection := dbConnection;

                aQryO.SQL.Text := 'SELECT * FROM operation WHERE technological_process_id = :technological_process_id ORDER BY operation_number ASC';
                aQryT.SQL.Text:='SELECT * FROM operation_tool WHERE operation_id = :operation_id';
                aQryF.SQL.Text:='SELECT * FROM operation_fixture WHERE operation_id = :operation_id';

                try
                  aQryO.Close;
                  aQryO.ParamByName('technological_process_id').Value := aQry.FieldByName('technological_process_id').AsInteger;
                  //ShowMessage(IntToStr(aQry.FieldByName('technological_process_id').AsInteger));
                  aQryO.Open;
                  //ShowMessage(IntToStr(aQryO.RecordCount));
                  aQryO.First;
                  //prejdeme vsetky operacie

                  with frmProgress do
                  begin
                    pbProgress.Min:=0;
                    pbProgress.Max := aQryO.RecordCount;
                  end;

                  frmProgress.ShowOnTop;
                  Application.ProcessMessages;

                  while not aQryO.EOF do
                  begin
                    frmProgress.pbProgress.StepBy(1);
                    Application.ProcessMessages;
                    //vytvorime novy zaznam v DB
                    qryOps.Insert;

                    //novy zaznam naplnime
                    qryOps['technological_process_id'] := frmMain.qryProcess.FieldByName('technological_process_id').AsInteger;
                    //qryOps['operation_id'] := aQryO.FieldByName('operation_id').AsInteger;
                    qryOps['operation_number'] := aQryO.FieldByName('operation_number').AsInteger;
                    if aQryO.FieldByName('machine_id').AsInteger > 0 then
                      qryOps['machine_id'] := aQryO.FieldByName('machine_id').AsInteger;
                    qryOps['operation_desc'] := aQryO.FieldByName('operation_desc').AsString;
                    qryOps['operation_time'] := aQryO.FieldByName('operation_time').AsInteger;
                    qryOps['operation_name_id'] := aQryO.FieldByName('operation_name_id').AsInteger;

                    //zmeny zapiseme do DB
                    qryOps.ApplyUpdates;

                    // resfresh aby sa zobrazili operacie v gride
                    DoRefresh(qryOps, 'operation_id');
                    // potrebne prejst na posledny zaznam koli last_insert_id
                    qryOps.Last;

                    //prejdem vsetky nastroje patriace do operacie z vyhladaneho TP
                    aQryT.Close;
                    //ShowMessage(IntToStr(aQryO.FieldByName('operation_id').AsInteger));
                    aQryT.ParamByName('operation_id').Value:=aQryO.FieldByName('operation_id').AsInteger;
                    aQryT.Open;

                    aQryT.First;
                    while not aQryT.EOF do
                    begin
                      qryTools.Insert;
                      qryTools['operation_id'] := qryOps.FieldByName('operation_id').AsInteger;
                      qryTools['tool_id'] := aQryT.FieldByName('tool_id').AsInteger;

                      aQryT.Next;
                      qryTools.ApplyUpdates;
                    end;
                    aQryT.Close;

                    //prejdem vsetky pripravky patriace do operacie zo sablony a insertnem
                    //do novovytvorenej operacie zvoleneho TP
                    aQryF.ParamByName('operation_id').Value:=aQryO.FieldByName('operation_id').AsInteger;
                    aQryF.Open;
                    aQryF.First;
                    while not aQryF.EOF do
                    begin
                      frmMain.qryFixtures.Insert;
                      frmMain.qryFixtures['operation_id'] := qryOps.FieldByName('operation_id').AsInteger;
                      frmMain.qryFixtures['fixture_id'] := aQryF.FieldByName('fixture_id').AsInteger;

                      aQryF.Next;
                      qryFixtures.ApplyUpdates;
                    end;
                    aQryF.Close;

                    aQryO.Next;
                  end;
                  frmProgress.Close;
                finally
                  aQryO.Free;
                end;

                qryOps.Refresh;
                qryTools.Refresh;
                qryFixtures.Refresh;

                case ShowModal of
                  mrOK: begin
                    SaveOptimalTP;
                    frmPartCoding.Close;
                  end;
                  mrCancel: DiscardOptimalTP;
                end;
              end;
            finally

            end;
          except
            on E: Exception do
            begin
              ShowMessage(E.Message);
              DiscardOptimalTP;
              dbConnection.Rollback;
            end;
          end;
        //ak nebol najdeny ziadny TP upozornime uzivatela
        end else
        begin

        end;


        {aQry := TZQuery.Create(nil);
        aQry.Connection := dbConnection;
        //najdeme vsetky technologicke postupy ktore vyhovuju zvolenemu GT code
        aQry.SQL := 'SELECT * FROM technological_process WHERE gt_code = :gt_code';
        aQry.Close;
        aQry.ParamByName('gt_code').Value:=aGTCode;
        aQry.Open;

        //ak existuju TP s totoznym GT kodom
        if(RecordCount > 0) then
        begin
          //zvolime prvy zaznam
          aQry.First;

          aQryO := TZQuery.Create(nil);
          aQryO.Connection := dbConnection;
          aQryO.SQL := 'SELECT * FROM operation WHERE technological_process_id = :technological_process_id';

          try
            aQryO.Close;
            aQryO.ParamByName('technological_process_id').Value := aQry.FieldByName('technological_process_id');
            aQryO.Open;

            aQryO.First;
            while not aQryO.EOF do
            begin
              with qryOps do
              begin
                Insert;


              end;
            end;
          finally
            aQryO.Free;
          end;
        //ak sme nenasli ziaden zaznam, otazka, ci chce nadefinovat TP
        end else
        begin

        end; }
        //end;

        //ShowMessage(aGTCode);
      end;

      mrCancel: begin

      end;
    end;
    qryProcess.Filtered:=true;
  end;
end;

procedure TfrmMain.itmNewOTPClick(Sender: TObject);
begin
  // zrusim Connection autocomit a zacnem transakciu
  dbConnection.StartTransaction;

  try
    try
      with frmOptimalTP do
      begin
        qryProcess.Append;
        qryProcess['part_name'] := 'Nová súčiastka';
        edtDateAssign.Date:=now;
        qryProcess['date_of_assigment'] := edtDateAssign.Date;
        qryProcess['created'] := getSystemUsername;

        qryProcess.ApplyUpdates;

        qryOps.ParamByName('technological_process_id').Value:=qryProcess.FieldByName('technological_process_id').AsInteger;

        with qryCompanies do
        begin
          Close;
          ParamByName('is_root').Value:=FALSE;
          Open;
        end;
        //ShowMessage(IntToStr(qryCompanies.RecordCount));
        //cbNorm.OnChange := @OnNormChange;
        cbSemiproductType.OnChange:=@OnSemiproductTypeChange;

        qryProcess.Edit;

        pcEditTP.ActivePageIndex:=0;

        case ShowModal of
          mrOK: SaveOptimalTP;
          mrCancel: DiscardOptimalTP;
        end;
      end;
    finally

    end;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      DiscardOptimalTP;
      dbConnection.Rollback;
    end;
  end;
  updateMenu;
end;

procedure TfrmMain.itmSettingsClick(Sender: TObject);
begin
  with frmSettings do
  begin
    // Database sheet - BEGIN
    edtDBHost.Text := FSettings.ReadString('Database', 'host', 'localhost');
    edtDBPort.Text := FSettings.ReadString('Database', 'port', '5432');
    edtDBName.Text := FSettings.ReadString('Database', 'schema', '');
    edtDBUser.Text := FSettings.ReadString('Database', 'user', '');
    edtDBPass.Text := EnDeCode(FSettings.ReadString('Database', 'pass', ''));

    // Database sheet - END
    tsOwner.TabVisible := (FDBConnected);
    pcSettings.TabIndex:=0;

    if FDBConnected = False then
      MessageDlg('Upozornenie', 'Systému sa nepodarilo nadviazať spojenie s DB, preto nebudú zobrazené všetky možnosti nastavení', mtWarning, [mbOK], mrOk)
    else
      //dbConnection.StartTransaction;

      with qryCompanies do
      begin
        Close;
        ParamByName('is_root').Value:=TRUE;
        Open;

        if RecordCount = 0 then
        begin
          Append;
          FieldByName('company_name').Value:='Názov spoločnosti';
          FieldByName('is_root').Value := TRUE;
          ApplyUpdates;
        end;

        //First;
        Edit;
      end;

    case ShowModal of
      mrOK: settingsSave(frmSettings);
      mrCancel: settingsDiscard(frmSettings);
    end;
  end;
end;

procedure TfrmMain.itmTemplatesClick(Sender: TObject);
begin
  frmTemplates.ShowTemplatesForm;
end;

procedure TfrmMain.itmPrintClick(Sender: TObject);
var
  ReportSL : TStringStream;
begin
  qryOps.Refresh;

  with qryCompanies do
  begin
    Close;
    ParamByName('is_root').Value:=TRUE;
    Open;
  end;

  //ReportSL:=TStringStream.Create(LazarusResources.Find('report-tgp').Value);

  try
    //frReport.LoadFromXMLStream(ReportSL);
    frReport.LoadFromFile(ExtractFilePath(Application.ExeName) + 'reports/report-tgp.lrf');
  finally
    //ReportSL.Free;
  end;
  frReport.ShowReport;
end;

procedure TfrmMain.qryNormAfterOpen(DataSet: TDataSet);
begin

end;

procedure TfrmMain.qryNormAfterScroll(DataSet: TDataSet);
begin
  with frmMain do
  begin
    {qryNormSpec.Close;
    qryNormSPec.ParamByName('norm_id').Value := qryNorm.FieldByName('norm_id').AsInteger;
    //qryNormSPec.ParamByName('norm_id').Value := null;
    {qryNormSpec.Locate('norm_specification_id', qryProcess.FieldByName('norm_specification_id').AsInteger, []);
    ShowMessage(qryNormSpec.FieldByName('norm_specification_name').AsString)}
    qryNormSpec.Open;}
  end;
  {if (qryProcess.State in [dsInsert,dsEdit]) then
    if frmMain.qryNormSpec.RecordCount > 0 then
    begin
      frmMain.qryNormSpec.First;
      frmMain.qryProcess['norm_specification_id'] := frmMain.qryNormSpec.FieldByName('norm_specification_id').AsInteger;
    end;}
end;

procedure TfrmMain.qryNormBeforeScroll(DataSet: TDataSet);
begin

end;

procedure TfrmMain.qryNormSpecAfterOpen(DataSet: TDataSet);
begin

end;

procedure TfrmMain.qryOperationsAfterScroll(DataSet: TDataSet);
begin
  with frmMain do
  begin
    qryTools.Close;
    qryTools.Params.ParamByName('operation_id').Value := DataSet.FieldByName('operation_id').AsInteger;
    qryTools.Open;

    qryFixtures.Close;
    qryFixtures.Params.ParamByName('operation_id').Value := DataSet.FieldByName('operation_id').AsInteger;
    qryFixtures.Open;
  end;

  frmTemplates.UpdateActions;
end;

procedure TfrmMain.qryOpsAfterOpen(DataSet: TDataSet);
begin
  with frmMain do
  begin
    qryTools.Close;
    qryTools.Params.ParamByName('operation_id').Value := DataSet.FieldByName('operation_id').AsInteger;
    qryTools.Open;

    qryFixtures.Close;
    qryFixtures.Params.ParamByName('operation_id').Value := DataSet.FieldByName('operation_id').AsInteger;
    qryFixtures.Open;
  end;
end;

procedure TfrmMain.qryOpsAfterScroll(DataSet: TDataSet);
begin
  with frmMain do
  begin
    qryTools.Close;
    qryTools.Params.ParamByName('operation_id').Value := DataSet.FieldByName('operation_id').AsInteger;
    qryTools.Open;

    qryFixtures.Close;
    qryFixtures.Params.ParamByName('operation_id').Value := DataSet.FieldByName('operation_id').AsInteger;
    qryFixtures.Open;
  end;
end;

procedure TfrmMain.qryProcessAfterScroll(DataSet: TDataSet);
begin
  with qryOps do
  begin
    Close;
    ParamByName('technological_process_id').Value:=DataSet.FieldByName('technological_process_id').AsInteger;
    Open;
  end;
end;

procedure TfrmMain.qrySemiproductTypeAfterScroll(DataSet: TDataSet);
begin

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin

end;

procedure TfrmMain.FormDeactivate(Sender: TObject);
begin

end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  FAppPath := ExtractFilePath(Application.ExeName);
  FSettings := TIniFile.Create(ExtractFilePath(Application.ExeName) + C_INI_SETTINGS_FILENAME);

  //FSettings.WriteString('Database', 'password', EnDeCode('Vlado_28'));

  try
    try
      FDBQueries := TObjectList.create(true);
      //FDBQueries.Add(dbQueryProcess);
      FDBQueries.Add(qryCompanies);
      FDBQueries.Add(qryProcess);
      //FDBQueries.Add(qryOperations);
      FDBQueries.Add(frmTemplates.qryTemplates);
      FDBQueries.Add(frmTemplates.qryTemplateOperations);
      FDBQueries.Add(qryTools);
      FDBQueries.Add(qryFixtures);
      FDBQueries.Add(qryOperationNames);
      FDBQueries.Add(qryMachines);
      FDBQueries.Add(qryOps);
      FDBQueries.Add(qrySemiproductType);
      //FDBQueries.Add(qryNorm);
      //FDBQueries.Add(qryNormSpec);
      FDBQueries.Add(qryTechnology);
      FDBQueries.Add(qrySemiproductDim);
      FDBQueries.Add(frmTemplateChoose.qryTemplates);

      with FDBParams do
      begin
        Host := FSettings.ReadString('Database', 'host', 'localhost');
        Port := FSettings.ReadInteger('Database', 'port', 5432);
        Database := FSettings.ReadString('Database', 'schema', '');
        User := FSettings.ReadString('Database', 'user', '');
        Password := EnDeCode(FSettings.ReadString('Database', 'pass', ''));
      end;

      SetConnectionParams(dbConnection, FDBParams);
      ConnectionActivate(dbConnection, FDBQueries, true);

      if qryProcess.RecordCount > 0 then
        gridProcess.SelectedIndex:=0;

      {if (FDBCOnnected) then
        with dbQueryProcess do
        begin
          Active := false;
          Active := true;
        end;}
    except

    end;
  finally
    updateMenu;
  end;
end;

procedure TfrmMain.frDsProcessOperationsFirst(Sender: TObject);
begin
  with qryTools do
  begin
    Close;
    ParamByName('operation_id').Value:=TfrDbDataSet(Sender).DataSet.FieldByName('operation_id').AsInteger;
    Open;
  end;
end;

procedure TfrmMain.frDsProcessOperationsNext(Sender: TObject);
begin
  with qryTools do
  begin
    Close;
    ParamByName('operation_id').Value:=TfrDbDataSet(Sender).DataSet.FieldByName('operation_id').AsInteger;
    Open;
  end;
end;

procedure TfrmMain.frReportEnterRect(Memo: TStringList; View: TfrView);
begin

end;

procedure TfrmMain.frReportGetValue(const ParName: String; var ParValue: Variant
  );
var
  aMemo: TMemo;
begin
  try
    if (ParName = 'qryProcess."date_of_assigment"') then
      if Trim(qryProcess.FieldByName('date_of_assigment').AsString) <> '' then
        ParValue := FormatDateTime('dd.mm.yyyy', qryProcess.FieldByName('date_of_assigment').AsDateTime);

    if (ParName = 'qryProcess."date_of_issue"') then
      if Trim(qryProcess.FieldByName('date_of_issue').AsString) <> '' then
        ParValue := FormatDateTime('dd.mm.yyyy', qryProcess.FieldByName('date_of_issue').AsDateTime);

    aMemo := nil;
    if(ParName = 'qryTools."tool_name"') then
    begin
      aMemo := TMemo.Create(nil);
      aMemo.Lines.Clear;
      qryTools.First;

      while not qryTools.EOF do
      begin
        aMemo.Lines.Add(qryTools.FieldByName('tool_name').AsString);

        qryTools.Next;
      end;

      ParValue := aMemo.Text;
    end;

    aMemo := nil;
    if(ParName = 'qryFixtures."fixture_name"') then
    begin
      aMemo := TMemo.Create(nil);
      aMemo.Lines.Clear;
      qryFixtures.First;

      while not qryFixtures.EOF do
      begin
        aMemo.Lines.Add(qryFixtures.FieldByName('fixture_name').AsString);

        qryFixtures.Next;
      end;

      ParValue := aMemo.Text;
    end;
  finally
    if aMemo <> nil then
      aMemo.Free;
  end;
end;

procedure TfrmMain.frReportManualBuild(Page: TfrPage);
begin

end;

procedure TfrmMain.gridProcessDblClick(Sender: TObject);
begin
  if qryProcess.RecordCount > 0 then
    btnEditTPClick(Sender);
end;

procedure TfrmMain.gridProcessKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    btnDeleteTPClick(Sender);
end;

procedure TfrmMain.itmAboutClick(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if FSettings <> nil then
    FSettings.Free;

  dbConnection.Free;
end;

procedure TfrmMain.dbQueryProcessAfterScroll(DataSet: TDataSet);
begin

end;

procedure TfrmMain.edtFilterCompanyChange(Sender: TObject);
begin

end;

procedure TfrmMain.edtFilterCompanyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Filter(Sender, Key, Shift);
end;

procedure TfrmMain.edtFilterPartKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Filter(Sender, Key, Shift);
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin

end;

procedure TfrmMain.OnNormChange(Sender: TObject);
begin
  with frmPartCoding do
  begin
    {qryNormSpec.Close;
    qryNormSpec.Params.ParamByName('norm_id').Value := TDBLookupComboBox(Sender).KeyValue;
    qryNormSpec.Open;}
  end;
end;

procedure TfrmMain.OnSemiproductTypeChange(Sender: TObject);
begin
  with frmPartCoding do
  begin
    if Sender is TDBLookupComboBox then
      if TDBLookupComboBox(Sender).KeyValue = null then
        lblSemiType.Caption:='X'
      else
        lblSemiType.Caption:=String(TDBLookupComboBox(Sender).KeyValue);

    qrySemiproductDim.Close;
    qrySemiproductDim.Params.ParamByName('semiproduct_type_id').Value := TDBLookupComboBox(Sender).KeyValue;
    qrySemiproductDim.Open;
  end;
end;

procedure TfrmMain.OnSemiproductDimChange(Sender: TObject);
begin
  with frmPartCoding do
  begin
    if Sender is TDBLookupComboBox then
      if TDBLookupComboBox(Sender).ItemIndex = -1 then
        lblSemiSize.Caption:='X'
      else
        lblSemiSize.Caption:=IntToStr(TDBLookupComboBox(Sender).ItemIndex+1);
  end;
end;

procedure TfrmMain.OnSemiproductWeightChange(Sender: TObject);
begin
  with frmPartCoding do
  begin
    if Sender is TDBLookupComboBox then
      if TDBLookupComboBox(Sender).KeyValue = null then
        lblSemiWeight.Caption:='X'
      else
        lblSemiWeight.Caption:=String(TDBLookupComboBox(Sender).KeyValue);
  end;
end;

procedure TfrmMain.OnSemiproductMatChange(Sender: TObject);
begin
  with frmPartCoding do
  begin
    if Sender is TDBLookupComboBox then
      if TDBLookupComboBox(Sender).KeyValue = null then
        lblSemiMat.Caption:='X'
      else
        lblSemiMat.Caption:=String(TDBLookupComboBox(Sender).KeyValue);
  end;
end;

procedure TfrmMain.OnSemiproductTechChange(Sender: TObject);
begin
  with frmPartCoding do
  begin
    if Sender is TDBLookupComboBox then
      if TDBLookupComboBox(Sender).KeyValue = null then
        lblSemiTechnology.Caption:='X'
      else
        lblSemiTechnology.Caption:=String(TDBLookupComboBox(Sender).KeyValue);

  end;
end;

procedure TfrmMain.partCodingOnTechnologyChange(Sender: TObject);
begin

end;

procedure TfrmMain.settingsSave(Sender: TObject);
begin
  try
    try
      if (Sender is TfrmSettings) then
      begin
        // ulozenie DB nastaveni
        with TfrmSettings(Sender) do
        begin
          FDBparams.Host := edtDBHost.Text;
          FDBparams.Port := StrToInt(edtDBPort.Text);
          FDBparams.Database := edtDBName.Text;
          FDBparams.User := edtDBUser.Text;
          FDBparams.Password := edtDBPass.Text;
        end;

        FSettings.WriteString('Database', 'host', FDBparams.Host);
        FSettings.WriteInteger('Database', 'port', FDBparams.Port);
        FSettings.WriteString('Database', 'schema', FDBparams.Database);
        FSettings.WriteString('Database', 'user', FDBparams.User);
        FSettings.WriteString('Database', 'pass', EnDeCode(FDBparams.Password));
      end;
    except

    end;

    if FDBConnected then
    begin
      qryCompanies.ApplyUpdates;
    end;
  finally
    SetConnectionParams(dbConnection, FDBParams);

    ConnectionActivate(dbConnection, FDBQueries, false);
    ConnectionActivate(dbConnection, FDBQueries, true);

    updateMenu;
  end;
end;

procedure TfrmMain.settingsDiscard(Sender: TObject);
begin
  if FDBConnected And dbConnection.InTransaction then
    dbCOnnection.Rollback;
end;

procedure TfrmMain.btnAddTPClick(Sender: TObject);
begin
  itmNewClick(self);
end;

procedure TfrmMain.btnAddOTPClick(Sender: TObject);
begin
  itmNewOTPClick(self);
end;

procedure TfrmMain.btnEditTPClick(Sender: TObject);
begin
  itmEditTPClick(Self)
end;

procedure TfrmMain.btnDeleteTPClick(Sender: TObject);
begin
  itmDeleteTPClick(self);
end;

procedure TfrmMain.ToolButton3Click(Sender: TObject);
begin
  itmPrintClick(self);
end;

procedure TfrmMain.ToolButton4Click(Sender: TObject);
begin

end;

procedure TfrmMain.ToolButton6Click(Sender: TObject);
begin
  qryOps.Append;
end;

procedure TfrmMain.updateMenu;
begin
  with mmGlobal do
  begin
    itmNew.Enabled:=FDBConnected;
    itmNewOTP.Enabled:=FDBConnected;
    itmCiselniky.Enabled:=FDBConnected;
    itmTemplates.Enabled:=FDBConnected;
    itmCompany.Enabled := FDBConnected;

    btnAddOTP.Enabled:=FDBConnected;
    btnAddTP.Enabled:=FDBConnected;

    itmEditTp.Enabled:= (FDBConnected) And (qryProcess.RecordCount>0);
    itmDeleteTp.Enabled:=(FDBConnected) And (qryProcess.RecordCount>0);

    btnEditTP.Enabled:=(FDBConnected) And (qryProcess.RecordCount>0);
    btnDeleteTP.Enabled:=(FDBConnected) And (qryProcess.RecordCount>0);
  end;
end;

procedure TfrmMain.ConnectionActivate(Connection: TZConnection; Queries: TObjectList; Status: boolean);
var
  i: Integer;
begin
  try
    Connection.Connected:=Status;
    FDBConnected := dbConnection.Connected;
    Status := FDBConnected;

    with Queries do
    begin
      for i:=0 to Count-1 do
      begin
        if (Items[i] is TZQuery) then
          TZQuery(Items[i]).Active:=Status;

        if (Items[i] is TZReadOnlyQuery) then
          TZReadOnlyQuery(Items[i]).Active:=Status;
      end;
    end;
  except
    on E : Exception do
      MessageDlg('Upozornenie', 'Nebolo možné nadviazať spojenie s DB serverom. Skontrolujte nastavenia.', mtError, [mbOk], mrOk);
      //ShowMessage('Nebolo možné nadviazať spojenie s DB serverom. Skontrolujte nastavenia.');
  end;
end;

procedure TfrmMain.TestConnection(Sender: TObject);
var
  vParams: TConnectionParams;
begin
  if (Sender is TfrmSettings) then
  begin
    // ulozenie DB nastaveni
    with TfrmSettings(Sender) do
    begin
      vParams.Host := edtDBHost.Text;
      vParams.Port := StrToInt(edtDBPort.Text);
      vParams.Database := edtDBName.Text;
      vParams.User := edtDBUser.Text;
      vParams.Password := EnDeCode(edtDBPass.Text);
    end;
  end;

  //ShowMessage(Sender.ClassName);
  //SetConnectionParams(dbConnectionTest, vParams);
  {if TryDBConnection(dbConnectionTest) = false then
    MessageDlg('Upozornenie', 'Nebolo možné nadviazať spojenie s DB serverom. Skontrolujte nastavenia.', mtError, [mbOk], mrOk)
  else
    MessageDlg('Informácia', 'Parametre databázového spojenia sú OK.', mtInformation, [mbOk], mrOk);}
end;

procedure TfrmMain.SaveOptimalTP;
begin
  if trim(frmOptimalTP.edtDateAssign.Text) = '/  /' then
  begin
    qryProcess['date_of_assigment'] := null;
  end else
    qryProcess['date_of_assigment'] := frmOptimalTP.edtDateAssign.Date;

  if trim(frmOptimalTP.edtDateIssue.Text) = '/  /' then
  begin
    qryProcess['date_of_issue'] := null;
  end
  else
    qryProcess['date_of_issue'] := frmOptimalTP.edtDateIssue.Date;

  qryProcess['gt_code'] := String(frmOptimalTP.cbTechnology.KeyValue) + '-'
    + String(frmOptimalTP.cbSemiproductType.KeyValue) + '-'
    + IntToStr(frmOptimalTP.cbSemiproductDimensions.ItemIndex+1) + '.'
    + String(frmOptimalTP.cbSemiproductWeight.KeyValue) + '-'
    + String(frmOptimalTP.cbMaterial.KeyValue);

  qryProcess.ApplyUpdates;
  if(dbConnection.InTransaction) then
    dbConnection.Commit;

  DoRefresh(qryProcess, 'technological_process_id');
  updateMenu;
end;

procedure TfrmMain.DiscardOptimalTP;
begin
  qryProcess.CancelUpdates;
  if(dbConnection.InTransaction) then
    dbConnection.Rollback;

  DoRefresh(qryProcess, 'technological_process_id');
  updateMenu;
end;

procedure TfrmMain.Filter(Sender: TObject; var Key: Word; Shoft: TShiftState);
begin
  case Key of
    13: DoFilter;
    8: begin
      if(TEdit(Sender).Text = '') then
        DoFilter;
    end;
  end;
end;

procedure TfrmMain.DoFilter;
var
  fStr, vWhere: String;
  vWheres: TStringList;
  i: Integer;
begin
  vWheres := TStringList.Create;

  try
    fStr := '';
    vWhere := '';

    if trim(edtFilterCompany.Text) <> '' then
      vWheres.Add('company_name LIKE ' + QuotedStr('*'+edtFilterCompany.Text+'*'));

    if trim(edtFilterPart.Text) <> '' then
      vWheres.Add('part_name LIKE ' + QuotedStr('*'+edtFilterPart.Text+'*'));

    if trim(edtFilterDrawing.Text) <> '' then
      vWheres.Add('drawing_number LIKE ' + QuotedStr('*'+edtFilterDrawing.Text+'*'));

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
      qryProcess.Filter:=fStr;
      qryProcess.Filtered:=true;
    end else
      qryProcess.Filtered:=false;
  finally
  end;
end;

initialization
  {$I reports.lrs}

end.

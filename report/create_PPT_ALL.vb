'Option Explicit

Dim pptTemplate As PowerPoint.Presentation
'-----connect to the database
Dim sql As String
Dim conn As ADODB.Connection

Dim strType As String ' Local or Web

Dim strTemplatePath As String

Dim strCurrCode As String

Dim strOutput As String
Dim strOutputPath As String
Dim strImgPath As String
'''''datetime
Dim strCurrVSLast As String
Dim strDataMonth As String
Dim strCAGRMATDate As String
Dim strCAGRMATQuarterDate As String
Dim strCPAMATDate As String
Dim strCPAMATQuarterDate As String
Dim strCAGR3MthsDate As String
Dim strRxCompareTime As String
Dim strHKAPITime As String
Dim strCPATime As String

Dim GeoColors As New Collection
Dim currentGeo As New Collection

Dim currentFilter As String
Dim currentTimeframeFilter As String

' connect to DB33 BMSChina database
Const strConnectDB = "Provider=MSDASQL;Driver={SQL Server};Server=172.20.0.82;Database=BMSChina_ppt;Uid=sa;Pwd=love2you;"
Const strConnectDB2 = "Provider=MSDASQL;Driver={SQL Server};Server=172.20.0.82;Database=BMSChina_staging;Uid=sa;Pwd=love2you;"


' report datasource : output
' report template : template_all

' Change logs:
' 6/11/2012: set the chart title from db
' set the number format of Y Axis

Public Sub Script_main()
''''''initialize
    sbConnectDB
    sbDefineConstant
'   Step1:  Update the datasource of ppt templates
    'Update_Template_PPT_DataSource
'   Step2:  Create single ppts
    
    sbCreateOutputFolder
        'run reports for national
    sbCreatePPT
    
    
'   Step3:  Adjust the single ppt
    Patch_Hospital_Secondary_Y_Format strOutputPath, strOutputPath
'   Step4:  Create the images of single ppts
    Script_main_Generate_Image strOutputPath, strImgPath
    sbDisconnectDB
    'Correct_Left
End Sub

Private Sub sbDefineConstant()
    strOutputPath = "D:\CI&A\BMSChinaPPT\Output\temp\tempslide"
    strImgPath = "D:\CI&A\BMSChinaPPT\Output\temp\SlideImg"
    strTemplatePath = ActivePresentation.Path & "\template"
    'MsgBox strOutputPath
        
    
    'set current month date
    sql = " select * from [tblDates]where DateSource='MonthDate' "
    Dim rs As New ADODB.Recordset
    rs.Open sql, conn, 1, 3
    rs.MoveFirst
    strDataMonth = rs("DateValue")
    
    ' set current month and last year month
    sql = " select * from [tblDates]where DateSource='CurrVSLast' "
    Set rs = New ADODB.Recordset
    rs.Open sql, conn, 1, 3
    rs.MoveFirst
    strCurrVSLast = rs("DateValue")
    
    

    'set CAGR MAT Date time
    sql = " select * from [tblDates]where DateSource='CAGRMATDate' "
    Set rs = New ADODB.Recordset
    
    rs.Open sql, conn, 1, 3
    rs.MoveFirst
    strCAGRMATDate = rs("DateValue")
    
    'set CAGR MQT Date time
    sql = " select * from [tblDates] where DateSource='CAGR3MthsDate' "
    Set rs = New ADODB.Recordset
    
    rs.Open sql, conn, 1, 3
    rs.MoveFirst
    strCAGR3MthsDate = rs("DateValue")
    
    'set CAGR MAT Quarter Date time
    sql = " select * from [tblDates] where DateSource='CAGRMATQuarterDate' "
    Set rs = New ADODB.Recordset
    
    rs.Open sql, conn, 1, 3
    rs.MoveFirst
    strCAGRMATQuarterDate = rs("DateValue")
    
     'set CAGR MAT Date time of CPA
    sql = " select * from [tblDates] where DateSource = 'CPAMATDate' "
    Set rs = New ADODB.Recordset
    
    rs.Open sql, conn, 1, 3
    rs.MoveFirst
    strCPAMATDate = rs("DateValue")

    'set CAGR MAT Quarter Date time of CPA
    sql = " select * from [tblDates] where DateSource = 'CPAMATQuarterDate' "
    Set rs = New ADODB.Recordset
    
    rs.Open sql, conn, 1, 3
    rs.MoveFirst
    strCPAMATQuarterDate = rs("DateValue")
    
     'set RxCompareTime time
    sql = " select * from [tblDates] where DateSource = 'RxCompareTime' "
    Set rs = New ADODB.Recordset
    
    rs.Open sql, conn, 1, 3
    rs.MoveFirst
    strRxCompareTime = rs("DateValue")
    
         'set RxCompareTime time
    sql = " select * from [tblDates] where DateSource = 'HKAPITime' "
    Set rs = New ADODB.Recordset
    
    rs.Open sql, conn, 1, 3
    rs.MoveFirst
    strHKAPITime = rs("DateValue")
    'set RxCompareTime time
    sql = " select * from [tblDates] where DateSource = 'CPATime' "
    Set rs = New ADODB.Recordset
    
    rs.Open sql, conn, 1, 3
    rs.MoveFirst
    strCPATime = rs("DateValue")
    
    rs.Close
    Set rs = Nothing
    
End Sub
    
Private Sub sbConnectDB()
    Set conn = New ADODB.Connection
    conn.Open strConnectDB
End Sub

Private Sub sbDisconnectDB()
    conn.Close
    Set conn = Nothing
End Sub

Private Sub sbCreateOutputFolder()
    Dim fso
    Set fso = CreateObject("scripting.filesystemobject")

    If (fso.folderexists(strOutputPath)) Then
        fso.deletefolder (strOutputPath)
    End If
    fso.createfolder (strOutputPath)
    Set fso = Nothing
    'MsgBox conn
End Sub

Private Sub sbOpenTemplate(inCode As String, inGeo As String, inProd As String, inTimeFrame As String)
    Dim strTemplate As String
    Dim fso
    
    If (inCode = "D020" Or inCode = "D030" Or inCode = "D040") And fnIsHeat(inGeo, inProd) = True Then
        If (inProd = "Baraclude" And inCode = "D020" And inTimeFrame = "MTH") Then
            strTemplate = strTemplatePath & "\" & inCode & "_" & inProd & "_Heat_MTH.pptx"
        Else
            strTemplate = strTemplatePath & "\" & inCode & "_" & inProd & "_Heat.pptx"
        End If
    ElseIf (inCode = "D020" Or inCode = "D030" Or inCode = "D040") And fnIsHeat(inGeo, inProd) = False Then
        If (inProd = "Baraclude" And inCode = "D020" And inTimeFrame = "MTH") Then
            strTemplate = strTemplatePath & "\" & inCode & "_" & inProd & "_MTH.pptx"
        Else
            strTemplate = strTemplatePath & "\" & inCode & "_" & inProd & ".pptx"
        End If
    ElseIf inCode Like "R53*" Then
        strTemplate = strTemplatePath & "\R530_" & inProd & ".pptx"
    Else
        strTemplate = strTemplatePath & "\" & inCode & "_" & inProd & ".pptx"
    End If

    Set fso = CreateObject("scripting.filesystemobject")

    If inProd = "Onglyza" And Not fso.FileExists(strTemplate) Then
        strTemplate = Replace(strTemplate, "Onglyza", "Glucophage")
    End If
    
    If Not fso.FileExists(strTemplate) Then
        strTemplate = strTemplatePath & "\" & inCode & ".pptx"
    End If
    
    Application.Presentations.Open strTemplate
    
End Sub


Private Function fnIsHeat(inGeo As String, inProd As String) As Boolean
    Dim tmpRS As New Recordset
    sql = "select count(*) cnt from outputGeo"
    sql = sql + " where Product = '" + inProd + "' and parentgeo = '" + inGeo + "'"
    
    tmpRS.Open sql, conn, adOpenForwardOnly, adLockReadOnly
    If CInt(tmpRS("cnt").Value) >= 10 Then
        fnIsHeat = True
    Else
        fnIsHeat = False
    End If
End Function
Private Sub sbCreatePPT()
'MsgBox conn
    sql = " select distinct Product,Parentcode,parentgeo,Geo,"
    sql = sql + " Currency,TimeFrame,Category,outputname,Caption, case when Product='Baraclude' and ParentCode='D020' and TimeFrame='MTH' then replace( SlideTitle,'MQT/MTH','MTH' ) else SlideTitle end as SlideTitle ,case when parentcode='c160' then subCaption else '-' end as subCaption"
    sql = sql + " from tblChartTitle A "
    sql = sql + " where ( exists (select * from outputgeo B where a.geo=b.geo and ( a.product=b.product or left(a.product,7)=b.product)) "
    sql = sql + " or  a.linkchartcode  like'c%' or a.linkchartcode like 'r%' )"
    sql = sql + " and not (ParentCode in('R400','R410','R500') and Category in ( 'Dosing Units','Adjusted patient number') )" ' not unit output for these code
     'sql = sql + " and parentcode in ('D020') and product='Coniel' and geo in ('Other') and currency='rmb' and timeframe='MAT'"
     'sql = sql + " and parentcode like 'r640%' and product in ('Monopril','Coniel')"
     'sql = sql + " and ( (product='Coniel' and ParentCode in ('R610','D080')) or (product='coniel' and datasource='CPA'and parentcode like 'r%') or (product='Monopril' and ParentCode='R610'))"
     ' and TimeFrame='MQT' and Currency='UNIT' and Geo='Nantong'"
    'sql = sql + " and outputname = 'R670_Eliquis VTEP_China_China_RMB_MTH_Value.pptx'"
    'sql = sql + " and parentcode in ('R650','R670','R680')"
    'sql = sql + " and dataSource='Rx' "
    'sql = sql + " and (dataSource='IMS' or dataSource='CPA' or DataSource = 'HKAPI' )"
    'sql = sql + " and product like 'eliquis%'"
    'sql = sql + " and  dataSource='Rx' and Product is not null "
    'and Currency='UNIT'
      sql = sql + " and parentcode in ('r640')  "
    'sql = sql + " and parentcode in ('r040')  "
    ' hospital
    'sql = sql + " and ( parentcode in('D050','D060','D110','D130','D150','c200') or parentCode >='R150') "
    
    ' sql = sql + " and geo in ('s1','s2','Pearl River delta','China') "
    ' baraclude ims
    'sql = sql + " and not ( parentcode in('D050','D060','D110','D130','D150','c200') or parentCode >='R150') "
    'sql = sql + " and geo in ('s1') "
    
    'rerun hospital ppt
    ' sql = sql + " and (parentcode in('D050','D060','D110','D130','D150','c200') or parentCode >'R150')"
    
    ' Dashboard Portfolio
     'sql = sql + " and Product in ('glucophage','Onglyza','portfolio') "
    
    ' city level
    ' sql = sql + "  and lev in('city','Region')"
   
    ' region level
    ' sql = sql + " and lev = 'region' "
    
    ' Predefined reports
     'sql = sql + " and (parentCode like 'r%' or Product = 'Portfolio')"

    sql = sql + " order by ParentCode desc, product desc,parentgeo desc,geo desc,currency desc,timeframe desc,category desc "

    Dim rs As New ADODB.Recordset
    rs.Open sql, conn, 1, 3
    If rs.RecordCount > 0 Then
    rs.MoveFirst
    End If
    
    Dim sld As Slide
    While Not rs.EOF
        'open template
        sbOpenTemplate rs("ParentCode"), rs("Geo"), rs("Product"), rs("TimeFrame")
        
        Set pptTemplate = Application.Presentations.Item(Application.Presentations.Count)
        Set sld = pptTemplate.Slides.Item(1)
        'Set sld = pptTemplate.Slides(1)
        
        'fill data
        fillGraphData sld, CStr(rs("Parentcode")), CStr(rs("Product")), CStr(rs("ParentGeo")), CStr(rs("Geo")), CStr(rs("Currency")), CStr(rs("Timeframe")), CStr(rs("Category")), CStr(rs("Caption")), CStr(rs("SlideTitle")), CStr(rs("subCaption"))

        ' save the output
        strOutput = strOutputPath & "\" & rs("outputname")
        
        ActiveWindow.ViewType = ppViewSlide
        ActiveWindow.View.Zoom = 75
        ActiveWindow.ViewType = ppViewNormal
        pptTemplate.SaveAs strOutput
        
        'close the template
        pptTemplate.Close
        
        'to fetch the next record
        rs.MoveNext
    Wend
    
    rs.Close
    Set rs = Nothing
End Sub

Private Sub Correct_Left()
    Dim fso, fd, f
    Set fso = CreateObject("scripting.filesystemobject")
    'strOutputPath = "E:\Projects\BMSChina\Rpt\Output\20120131_200333"
    Set fd = fso.getfolder(strOutputPath)

    For Each f In fd.Files
        Dim inCode As String
        inCode = f.Name
        'incode = Mid(incode, InStr(incode, strOutputPath & "\") + 16, 4)
        inCode = Left(inCode, 4)
            If (inCode >= "R190" And inCode <= "R300") Or inCode = "R900" Or inCode = "R960" Or inCode = "D030" Or inCode = "D040" Then
                Application.Presentations.Open f
                Set ppt = Application.Presentations.Item(Application.Presentations.Count)
                If ppt.Slides.Count > 0 Then
                    Set sld = ppt.Slides(1)
                        Dim shp As PowerPoint.Shape
                        For Each shp In sld.Shapes
                            If shp.AlternativeText Like "sheet*" Then
                                shp.Left = 13
                                Exit For
                            End If
                            
                        Next
                      
                        
                    ppt.Save
                    ppt.Close
            End If

        End If
       
    Next

End Sub

Private Sub fillGraphData(inSlide As Slide, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCaption As String, inSubTitle As String, inSubCaption As String)
    Dim shp As Shape
    Dim trng As TextRange
    Dim Graphtype As String
    'set the color
    Dim i As Integer
    Dim ChartType As String
    Dim ChartSeries As Object
 
    Dim wb As Workbook
    Dim ct As Graph.Chart 'for 2003 versions
    Dim ds As Object
    
    
    Dim caption As String
    
    Dim subsql As String
    Dim subrs As New ADODB.Recordset
    
    subsql = " select * from tblPPTGraphDef where code='" & inCode & "' and product='" & inProduct & "'"
    subsql = subsql + "  order by id,Graphtype "
    subrs.Open subsql, conn, 1, 3
    If subrs.RecordCount > 0 Then
        subrs.MoveFirst
    End If
    
    Dim ShpLeft As Double, ShpWidth As Double
    Dim waitTime
    While Not subrs.EOF
            Graphtype = subrs("Graphtype")
            For Each shp In inSlide.Shapes
                caption = LCase(shp.AlternativeText)
                'to identify whether the graphtype exists in tblPPTGraphDef
                If InStr(1, caption, Graphtype, 1) > 0 Then
                        If InStr(1, Graphtype, "sheet", 1) > 0 Or (InStr(1, Graphtype, "ppttable", 1) > 0 And InStr(1, caption, "sheet", 1) > 0) Then
                            ' office 2003 sheet
                            ' the # of rows is fixed
                            ' Dynamic # of columns: the columns may < or > default columns 7
                            Set wb = shp.OLEFormat.Object
                            If (inCode >= "R190" And inCode <= "R300") Or inCode = "R900" Or inCode = "R960" Or inCode = "D020" Or inCode = "D030" Or inCode = "D040" Then
                                ShpLeft = shp.Left
                                ShpWidth = shp.Width
                                If (inCode = "D020" Or inCode = "D030" Or inCode = "D040") And InStr(1, caption, "sheet2", 1) > 0 Then
                                    'the first table must fill timeframe="YTD" data ;
                                    'other chart must change following the timeframe
                                    sbClearAndFillSheetData_U caption, wb, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, "YTD", inCategory, subrs("StartCols"), subrs("StartRows")
                                Else
                                    sbClearAndFillSheetData caption, wb, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                                End If
                                
                                wb.Save
                                wb.RefreshAll
                                sbSleep 1000
                                sbSetShapeWidth shp, ShpLeft, ShpWidth
                                'sbSleep 1000
                                
                            ElseIf (inCode = "R400" Or inCode = "R410") Then
                                If Graphtype = "Sheet2" Then
                                    sbClearAndFillSheetData_U caption, wb, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, "Unit", inTimeFrame, "Dosing Units", subrs("StartCols"), subrs("StartRows")
                                Else
                                    sbClearAndFillSheetData_U caption, wb, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                                End If
                            ElseIf inCode Like "R45*" Then
                                sbClearAndFillScatterTableData caption, wb, "Y", subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory
                            Else
                                sbClearAndFillSheetData caption, wb, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                            End If
                            wb.Save
                            wb.RefreshAll
                            
                            wb.Close
                            Set wb = Nothing
                            
                         'format the special table code in('c040','c050')
                        ElseIf InStr(1, Graphtype, "SpecialTable", 1) > 0 Then
                            ' Office 2003 Sheet
                            'fixed # of rows
                            'Dynamic # of columns: the columns may < default columns
                            'shp.Visible = msoCTrue
                            Set wb = shp.OLEFormat.Object
                            sbSpecialClearAndFillTableData wb, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                            wb.Close
                            Set wb = Nothing
                            
                        ElseIf InStr(1, Graphtype, "ppttable", 1) > 0 And InStr(1, Graphtype, "sheet", 1) <= 0 Then
                            ' PPT Table object
                            
                            ' dynamic # of rows
                            ' fixed # of columns
                            ' The Alternative text of D020,D030 and D040 may be "ppttable,sheet2".
                            ' It should be considered as a Excel sheet not PPT table.
                            'the first table must fill timeframe="YTD" data ;other chart must change following the timeframe
                            If inCode = "D020" Or inCode = "D030" Or inCode = "D040" Then
                                If fnIsHeat(inGeo, inProduct) Then
                                    ' This should never happed
                                    sbClearAndFillPPRTableData_U shp.Table, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, "YTD", inCategory, subrs("StartCols"), subrs("StartRows")
                                    shp.Table.Columns(shp.Table.Columns.Count).Delete
                                    'shp.Left = 7.659
                                    'shp.Top = 214.234
                                Else
                                    sbClearAndFillPPRTableData shp.Table, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, "YTD", inCategory, subrs("StartCols"), subrs("StartRows")
                                End If
                            ElseIf inCode = "R610" Or inCode = "R620" Or inCode = "R630" Or inCode = "R640" Or inCode = "R650" Or inCode = "R720" Or inCode = "R730" Then
                                sbClearAndFillPPRTableData_R shp.Table, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                            Else
                                sbClearAndFillPPRTableData shp.Table, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                            End If
                        ElseIf InStr(1, Graphtype, "chart", 1) > 0 Then
                            ' Office 2007 Chart object model
                            'the first chart must fill timeframe="MQT" data ;other chart must change following the timeframe
                            If inCode = "D020" Or inCode = "D030" Or inCode = "D040" Then
                                If Graphtype = "Chart1" And inTimeFrame = "MTH" And inProduct = "Baraclude" And inCode = "D020" Then
                                    sbClearAndFillChartData caption, shp.Chart, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, "MTH", inCategory, subrs("StartCols"), subrs("StartRows")
                                    sbSetSeriesColor shp.Chart, subrs("Active"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, "MTH", inCategory
                                ElseIf Graphtype = "Chart1" And (inCode = "D030" Or inCode = "D040" Or (inCode = "D020" And (inProduct <> "Braclude" Or (inProduct = "Braclude" And inTimeFrame <> "MTH")))) Then
                                    ' The Timeframe should always be MQT
                                    sbClearAndFillChartData caption, shp.Chart, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, "MQT", inCategory, subrs("StartCols"), subrs("StartRows")
                                    sbSetSeriesColor shp.Chart, subrs("Active"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, "MQT", inCategory
                                Else
                                    sbClearAndFillChartData caption, shp.Chart, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                                    sbSetSeriesColor shp.Chart, subrs("Active"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory
                                    If (inProduct = "Monopril" And inGeo = "East") _
                                        Or (inProduct = "Glucophage" And inGeo = "East 2") _
                                        Or (inProduct = "Onglyza" And inGeo = "East 2") _
                                        Or (inProduct = "Taxol" And inGeo = "East-2") _
                                    Then
                                        shp.Chart.Axes(xlCategory).TickLabels.Font.Size = 4.5
                                    End If
                                End If
                            ' todo
                            ElseIf (inCode >= "R190" And inCode <= "R300") Or inCode = "R900" Or inCode = "R960" Or inCode = "R910" Or inCode = "R920" Or inCode = "R220" Or inCode = "R930" Or inCode = "R970" Or inCode = "R980" Or inCode = "R280" Or inCode = "R990" Then
                              
                                If Graphtype = "Chart2" Then
                                    ' The Timeframe should always be MQT
                                    sbClearAndFillChartData caption, shp.Chart, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, "MQT", inCategory, subrs("StartCols"), subrs("StartRows")
                                    sbSetSeriesColor shp.Chart, subrs("Active"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, "MQT", inCategory
                                Else
                                    sbClearAndFillChartData caption, shp.Chart, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                                    sbSetSeriesColor shp.Chart, subrs("Active"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory
                                End If
                            ElseIf (inCode = "R400" Or inCode = "R410" Or inCode = "R500") Then
                                If Graphtype = "Chart2" Then
                                    ' The Currency should always be UNIT
                                    sbClearAndFillChartData caption, shp.Chart, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, "Unit", inTimeFrame, "Dosing Units", subrs("StartCols"), subrs("StartRows")
                                    sbSetSeriesColor shp.Chart, subrs("Active"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, "Unit", inTimeFrame, inCategory
                                Else
                                    sbClearAndFillChartData caption, shp.Chart, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                                    sbSetSeriesColor shp.Chart, subrs("Active"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory
                                End If
                            ElseIf (inCode = "R451" Or inCode = "R452") Then
                                ' It is different to fill the data to scatter chart
                                sbClearAndFillScatterChartData caption, shp.Chart, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                                sbSetSeriesColor shp.Chart, subrs("Active"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory
                            Else
                                sbClearAndFillChartData caption, shp.Chart, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                                sbSetSeriesColor shp.Chart, subrs("Active"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory
                            End If
                            If (inCode <> "R451" And inCode <> "R452" And inCode <> "R511" And inCode <> "R512" And inCode <> "R491" And inCode <> "R492") Then
                                sbSetAxisNumberFormat shp.Chart, subrs("LinkChartCode"), inProduct
                            End If
                        ElseIf InStr(1, Graphtype, "bubble", 1) > 0 Then
                            '如果是bubble图，数据填充比较特殊，使用新的函数
                            sbFillBubbleData caption, shp.Chart, subrs("Active"), subrs("Axis"), subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, subrs("StartCols"), subrs("StartRows")
                        End If
                End If
                
            'use function to fill data
            
               If InStr(1, caption, "labelcagr", 1) Then
                   Set trng = shp.TextFrame.TextRange
                   If inCode = "C200" Then
                     If InStr(1, caption, "c201", 1) Then
                        'IMS
                       If inTimeFrame = "MAT Month" Then
                           trng.Text = Replace(trng.Text, "#period", strCAGRMATDate)
                           sbFillTheLabelData caption, trng, subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, "N"
                       ElseIf inTimeFrame = "MAT Quarter" Then
                           trng.Text = Replace(trng.Text, "#period", strCAGRMATQuarterDate)
                           sbFillTheLabelData caption, trng, subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, "N"
                       End If
                       
                     ElseIf InStr(1, caption, "c202", 1) Then
                        'CPA
                       If inTimeFrame = "MAT Month" Then
                           trng.Text = Replace(trng.Text, "#period", strCPAMATDate)
                           sbFillTheLabelData caption, trng, subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, "N"
                       ElseIf inTimeFrame = "MAT Quarter" Then
                           trng.Text = Replace(trng.Text, "#period", strCPAMATQuarterDate)
                           sbFillTheLabelData caption, trng, subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, "N"
                       End If
       
                     End If
                   End If
                   If InStr(trng.Text, "#period") > 0 Then
                          If (inProduct = "Baraclude" And inTimeFrame = "YTD" And inCode = "R020") Then
                            trng.Text = Replace(trng.Text, "#period", Replace(strCAGRMATDate, "MAT", "YTD"))
                          Else
                            trng.Text = Replace(trng.Text, "#period", strCAGRMATDate)
                          End If
                   End If
                   If InStr(trng.Text, "#rolling3mths") > 0 Then
                          If (inProduct = "Baraclude" And inTimeFrame = "YTD" And (inCode = "R060" Or inCode = "R050" Or inCode = "D090")) Then
                            trng.Text = Replace(trng.Text, "#rolling3mths", Replace(strCAGRMATDate, "MAT", "YTD"))
                          Else
                            trng.Text = Replace(trng.Text, "#rolling3mths", strCAGR3MthsDate)
                          End If
                          ' trng.Text = Replace(trng.Text, "#rolling3mths", strCAGR3MthsDate)
                   End If
                   If InStr(trng.Text, "#Product") > 0 Then
                          trng.Text = Replace(trng.Text, "#Product", subrs("LinkChartProduct"))
                   End If
                   
                   If InStr(trng.Text, "#value") > 0 Then
                      sbFillTheLabelData caption, trng, subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, "N"
                    End If

                End If

            If InStr(1, caption, "labelcontribution", 1) Then
                Set trng = shp.TextFrame.TextRange
                If InStr(trng.Text, "#value") > 0 Then
                    sbFillTheLabelData caption, trng, subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, "N"
                End If
            ElseIf InStr(1, caption, "labelAvg", 1) Then
                Set trng = shp.TextFrame.TextRange
                If InStr(trng.Text, "#value") > 0 Then
                    sbFillTheLabelData caption, trng, subrs("LinkChartCode"), subrs("LinkChartProduct"), inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, "Y"
                End If
            ElseIf InStr(1, caption, "labelSubTitle", 1) Then
                Set trng = shp.TextFrame.TextRange
                trng.Text = inSubTitle
            ElseIf InStr(1, caption, "labelSubChartTitle", 1) Then
                Set trng = shp.TextFrame.TextRange
                trng.Text = inSubCaption
                ' sbUpdateSlideSubTitle trng, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeframe, inCategory
            ElseIf InStr(1, caption, "lableintroduction", 1) Then
                Set trng = shp.TextFrame.TextRange
                trng.Text = ""
                
                
                If InStr(inTimeFrame, "MQT") > 0 Or InStr(inTimeFrame, "Rolling 3 Months") > 0 Or InStr(inTimeFrame, "Rolling Quarter") > 0 Or InStr(inTimeFrame, "Current 3 Months") > 0 Then
                    trng.Text = "MQT: Moving Quarter Total."
                End If
                If InStr(inTimeFrame, "MAT") > 0 Then
                    trng.Text = "MAT: Moving Annual Total."
                End If
                If InStr(inTimeFrame, "YTD") > 0 Then
                    trng.Text = "YTD: Year to Date."
                End If
                If InStr(subrs("LinkChartCode"), "R420") > 0 And InStr(subrs("LinkChartProduct"), "Taxol") > 0 Then
                    trng.Text = "MAT: Moving Annual Total.  || MNC: Gemcitabine;Docetaxel; Paclitaxel"
                End If
                If InStr(subrs("LinkChartCode"), "R420") > 0 And InStr(subrs("LinkChartProduct"), "Paraplatin") > 0 Then
                    trng.Text = "MAT: Moving Annual Total.  || MNC: Carboplatin ;Cisplatin ; Nedaplatin"
                End If
                If InStr(subrs("LinkChartCode"), "R430") > 0 And InStr(subrs("LinkChartProduct"), "Taxol") > 0 Then
                    trng.Text = "MAT: Moving Annual Total.  || [Gemcitabine:Gemzar] [Docetaxel  :Taxotere] [Paclitaxel :Taxol,Abraxane,Anzatax]"
                End If
                If InStr(subrs("LinkChartCode"), "R430") > 0 And InStr(subrs("LinkChartProduct"), "Paraplatin") > 0 Then
                    trng.Text = "MAT: Moving Annual Total.  || [Carboplatin:Paraplatin,Loca] [Cisplatin  :Bo Long,Cisplatin,Fang Tan,Jin Shun,Nuo Xin] [Nedaplatin :Ao Xian Da,Jie Bai Shu,Lu Bei,Quan Bo]"
                End If
                
                
            ElseIf InStr(1, caption, "labelGeo", 1) Then
                Set trng = shp.TextFrame.TextRange
                If InStr(trng.Text, "#") > 0 Then
                    trng.Text = Replace(trng.Text, "#Geo", inGeo)
                End If
            ElseIf InStr(1, caption, "labelDataType", 1) Then
                Set trng = shp.TextFrame.TextRange
                If InStr(trng.Text, "#") > 0 Then
                    trng.Text = Replace(trng.Text, "#Category", inCategory)
                     trng.Text = Replace(trng.Text, "#TimeFrame", inTimeFrame)
                End If
            ElseIf InStr(1, caption, "labelproduct", 1) Then
                Set trng = shp.TextFrame.TextRange
                If InStr(trng.Text, "#") > 0 Then
                    trng.Text = Replace(trng.Text, "#Product", subrs("LinkChartProduct"))
                    trng.Text = Replace(trng.Text, "#Category", inCategory)
                End If
            ElseIf InStr(1, caption, "labelTitle", 1) Then
                Set trng = shp.TextFrame.TextRange
                trng.Text = inCaption
                
            ElseIf InStr(1, caption, "currVsLast", 1) Or InStr(1, caption, "footnote", 1) Or InStr(1, caption, "labelcompareTime", 1) Or InStr(1, caption, "labelcontribution", 1) Or InStr(1, caption, "labelTimeFrame", 1) Then
                Set trng = shp.TextFrame.TextRange
                If InStr(trng.Text, "#") > 0 Then
                    trng.Text = Replace(trng.Text, "#CurrentMonthlyTime", strDataMonth)
                    trng.Text = Replace(trng.Text, "#TimeFrame", inTimeFrame)
                    trng.Text = Replace(trng.Text, "#HKAPITime", strHKAPITime)
                    trng.Text = Replace(trng.Text, "#CPATime", strCPATime)
                    trng.Text = Replace(trng.Text, "#currVsLast", strCurrVSLast)
                    trng.Text = Replace(trng.Text, "#Currency", inCurrency)
                    trng.Text = Replace(trng.Text, "#Category", inCategory)
                End If
            End If
                    
            
        Next
        
        subrs.MoveNext
    Wend
        
    subrs.Close
    Set subrs = Nothing
    
End Sub

Private Sub sbSetShapeWidth(shp As Shape, ShpLeft As Double, ShpWidth As Double)
        shp.Left = ShpLeft
        If shp.Width / ShpWidth > 1 Then
            shp.ScaleWidth ShpWidth / shp.Width, msoFalse
        ElseIf shp.Width / ShpWidth < 1 Then
            shp.ScaleWidth shp.Width / ShpWidth, msoFalse
        End If
        shp.Left = ShpLeft
        shp.Width = ShpWidth
End Sub

Private Sub sbFillTheLabelData(inCaption As String, intrng As TextRange, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inActive As String)
  Dim subrs As New ADODB.Recordset

If InStr(1, inCaption, "labelAvg", 1) > 0 Then
    sql = "select distinct series,seriesidx,cast(round(cast(y as float)*100,0) as varchar(10)) as Yvalue from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "' and Currency='" & inCurrency & "'and Timeframe='" & inTimeFrame & "' "
    sql = sql + " and series='Avg. Growth' order by seriesidx"
Else
    sql = "select distinct series,seriesidx,cast(round(cast(y as float),3)*100 as varchar(10)) as Yvalue from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "' and Currency='" & inCurrency & "'and Timeframe='" & inTimeFrame & "' "
    sql = sql + "order by seriesidx"      'the number 4 above this line is changed to 3~
End If

    Dim rs As New ADODB.Recordset
    rs.Open sql, conn, 1, 3

    If (rs.RecordCount > 0) Then
        rs.MoveFirst
    End If
'to judge how many value need to update

    Dim icount As Integer
    Dim i As Integer
    i = 1
    icount = CLng(rs.RecordCount)
      If icount = 1 Then
        If inCode = "C201" Then
          intrng.Text = Replace(intrng.Text, "#value1", IIf(IsNull(rs("Yvalue")), "0", rs("Yvalue")))
        ElseIf inCode = "C202" Then
          intrng.Text = Replace(intrng.Text, "#value2", IIf(IsNull(rs("Yvalue")), "0", rs("Yvalue")))
        Else
        intrng.Text = Replace(intrng.Text, "#value1", IIf(IsNull(rs("Yvalue")), "0", rs("Yvalue")))
        End If
      End If
      If icount > 1 Then
        While Not rs.EOF
    
            intrng.Text = Replace(intrng.Text, "#value" & CStr(i), IIf(IsNull(rs("Yvalue")), "0", rs("Yvalue")))
            i = i + 1
            rs.MoveNext
        Wend
      End If
   
    
    rs.Close
    Set rs = Nothing
    
End Sub

'Fill office Table object
Private Sub sbClearAndFillPPRTableData_U(PT As PowerPoint.Table, inActive As String, inAxis As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer)
    Dim SeriesCnt As Integer
    Dim xCnt As Integer
'-----to fill X axis
    Dim inRs As New ADODB.Recordset
    sql = "select Distinct X,XIdx from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by Xidx"

    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    xCnt = inCols + 1
    While Not inRs.EOF
        
        PT.Cell(xCnt, 1).Shape.TextFrame.TextRange.Font.Size = 5
        PT.Cell(xCnt, 1).Shape.TextFrame.TextRange.Font.Bold = True
        PT.Cell(xCnt, 1).Shape.TextFrame.TextRange.Text = inRs("X")
        
        xCnt = xCnt + 1
        inRs.MoveNext
    Wend
    xCnt = xCnt - 2
    inRs.Close
    
 '-----to fill series axis
    Set inRs = New ADODB.Recordset
    sql = "select Distinct Series,SeriesIdx from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by Seriesidx"
    
    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    
    'to insert the rows
    Dim i As Integer
    Dim cnt As Integer
    cnt = CLng(inRs.RecordCount)
    i = 2
    While i <= cnt
        PT.Columns.Add (i)
        i = i + 1
    Wend
    
    'format the rows
    Dim j As Integer
    j = 1
         PT.Columns(j).Width = 50
         PT.Rows(1).Height = 15
         PT.Rows(2).Height = 15
         PT.Rows(3).Height = 15
    j = 2
    While j <= i
         PT.Columns(j).Width = (49 * 13) / cnt
         'PT.Rows(1).Height = 15
         'PT.Rows(2).Height = 15
         'PT.Rows(3).Height = 15
         
        j = j + 1
    Wend

    'to fill the series
    SeriesCnt = inRows + 1

    While Not inRs.EOF
        'PT.Cell(1, SeriesCnt).Shape.TextFrame.TextRange.Font.Size = 6
        'PT.Cell(1, SeriesCnt).Shape.TextFrame.TextRange.Font.Bold = True
        PT.Cell(1, SeriesCnt).Shape.TextFrame.TextRange.Text = inRs("Series")
        SeriesCnt = SeriesCnt + 1
        inRs.MoveNext
    Wend
    
    SeriesCnt = SeriesCnt - 1
'-----to fill Y axis
    Set inRs = New ADODB.Recordset
    sql = "select "
    sql = sql + " cast(round(cast(Y as float)*100,1) as varchar(10)) as Y  "
    sql = sql + " from output_ppt "
    sql = sql + " where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' "
    sql = sql + " and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' "
    sql = sql + " and geo='" & inGeo & "'  and Currency='" & inCurrency & "' "
    sql = sql + " and Timeframe='" & inTimeFrame & "' and Category='" & inCategory & "' "
    sql = sql + " order by seriesidx,xidx"

    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    
    Dim tempY As String
    Dim idx As Integer
    Dim curRows As Integer
    Dim curCols As Integer
    idx = 1
    curRows = inRows
    curCols = inCols
    
    While Not inRs.EOF
        tempY = IIf(IsNull(inRs("Y")), "", inRs("Y"))
        PT.Cell(curCols + 1, curRows + 1).Shape.TextFrame.TextRange.Text = IIf(tempY = "", "-", tempY + "%")

        'to judge how to fill the data to the next colume or the next row
        If idx Mod xCnt = 0 Then
            curRows = curRows + 1
            curCols = inCols
        Else
            curCols = curCols + 1
        End If
        idx = idx + 1
        inRs.MoveNext
    Wend
    
    
    inRs.Close
    Set inRs = Nothing
End Sub

Private Sub sbClearAndFillScatterTableData(inCaption As String, obj As Workbook, inActive As String, inAxis As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String)
    Dim ds As Worksheet
    Set ds = obj.Sheets(1)
    ds.Range("A1:AZ100").ClearContents
    sql = "select Distinct X,XIdx from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by Xidx"
    Dim inRs As New ADODB.Recordset
    inRs.Open sql, conn, 1, 3
    Dim idx As Integer
    idx = 1
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
        
        While Not inRs.EOF
            ds.Cells(idx, 1).Value = CStr(inRs("X"))
            idx = idx + 1
            inRs.MoveNext
        Wend
    End If
    inRs.Close
    Set inRs = Nothing
End Sub

' Fill Office 2003 Sheet object
Private Sub sbClearAndFillSheetData(inCaption As String, obj As Workbook, inActive As String, inAxis As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer)
    Dim ds As Worksheet
    Set ds = obj.Sheets(1)
    ds.Range("A" & inRows & ":AZ100").ClearContents
    
    Dim SeriesCnt As Integer
    Dim xCnt As Integer
    SeriesCnt = 1
    xCnt = 1
    
    Dim arr() As String
    arr = Split(inAxis, "||")
    
    Dim isFillSeries As Boolean
    Dim isFillX As Boolean
    
    isFillSeries = False
    isFillX = False
    
    Dim i As Integer
    For i = 0 To UBound(arr)
        If LCase(arr(i)) = "series" Then
            isFillSeries = True
        ElseIf LCase(arr(i)) = "x" Then
            isFillX = True
        End If
    Next
    If Not isFillX Then
        inRows = inRows - 1
    End If
    If Not isFillSeries Then
        inCols = inCols - 1
    End If
    
    If isFillSeries Then
        SeriesCnt = sbFillSeries(ds, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, inCols, inRows)
    Else
        SeriesCnt = fnGetCount("Series", inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory)
    End If
    
    If isFillX Then
        xCnt = sbFillX(ds, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, inCols, inRows)
    Else
        xCnt = fnGetCount("X", inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory)
    End If

    sbFillY ds, SeriesCnt, xCnt, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, inCols, inRows
     
    If InStr(1, inCaption, "TimeFrame", 1) > 0 Then
        ds.Cells(1, 1).Value = Replace(ds.Cells(1, 1).Value, "#TimeFrame", inTimeFrame)
    End If
    If InStr(1, inCaption, "rxCompareTime", 1) > 0 Then
        ds.Cells(1, 1).Value = Replace(ds.Cells(1, 1).Value, "#RxCompareTimee", strRxCompareTime)
    End If
    
    ' adjust the column to make the column of sheet can align the X of the chart
    sbCorrectColumnQuantity inCaption, ds, inCode, xCnt
    
    Set ds = Nothing
    
End Sub

' Correct the columns of the Sheet object
' to show or hide the columns and adjust the column width
Private Sub sbCorrectColumnQuantity(inCaption As String, inDs As Worksheet, inCode As String, ColumnCount As Integer)
    If (inCode >= "R190" And inCode <= "R300") Or (inCode >= "R900" And inCode <= "R999") Or inCode Like "D02*" Or inCode Like "D03*" Or inCode Like "D04*" Then
        If InStr(inCaption, "TimeFrame") = 0 Then
            Dim col_wid As Double
            'col_wid = 104 / cnt_flag 'in older ppt,the length of the "sheet" table is 600 including the tile column
            col_wid = inDs.Columns("B").ColumnWidth
            col_wid = col_wid * 7 / ColumnCount
            
            inDs.Columns("B:" & fnGetColumn(65 + ColumnCount)).EntireColumn.ColumnWidth = 1
            inDs.Columns(fnGetColumn(66 + ColumnCount) & ":AZ").EntireColumn.Hidden = True
            inDs.Columns("B:" & fnGetColumn(65 + ColumnCount)).EntireColumn.Hidden = False
            If (ColumnCount = 1) Then
               If (inCode = "D022") Then
               inDs.Columns("B:B").EntireColumn.ColumnWidth = 120
               Else
               inDs.Columns("B:B").EntireColumn.ColumnWidth = 150
               End If
            Else
                inDs.Columns("B:" & fnGetColumn(65 + ColumnCount)).EntireColumn.ColumnWidth = col_wid
            End If
        End If
    End If
End Sub

' Fill Office 2003 sheet object with switching Series & X
Private Sub sbClearAndFillSheetData_U(inCaption As String, obj As Workbook, inActive As String, inAxis As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer)

    Dim ds As Worksheet
    Set ds = obj.Sheets(1)
    ds.Range("A" & inRows & ":AZ100").ClearContents
    
    Dim SeriesCnt As Integer
    Dim xCnt As Integer
    SeriesCnt = 1
    xCnt = 1
'-----to fill X axis
    Dim inRs As New ADODB.Recordset
    
    sql = "select Distinct X,XIdx from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by Xidx"

    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    xCnt = inCols + 1
    While Not inRs.EOF
        
        ds.Cells(xCnt, 1).Value = inRs("X")
        
        xCnt = xCnt + 1
        inRs.MoveNext
    Wend
    xCnt = xCnt - 2
    inRs.Close
    
 '-----to fill series axis
    sql = "select Distinct Series,SeriesIdx from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by Seriesidx"
    
    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    
    'to fill the series
    SeriesCnt = inRows + 1

    While Not inRs.EOF
        ds.Cells(1, SeriesCnt).Value = inRs("Series")
        SeriesCnt = SeriesCnt + 1
        inRs.MoveNext
    Wend
    
    SeriesCnt = SeriesCnt - 1
'-----to fill Y axis
    Set inRs = New ADODB.Recordset
    sql = "select Y  from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by seriesidx,xidx"

    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    
    Dim tempY As String
    Dim idx As Integer
    Dim curRows As Integer
    Dim curCols As Integer
    idx = 1
    curRows = inRows
    curCols = inCols
    
    While Not inRs.EOF
        tempY = IIf(IsNull(inRs("Y")), "", inRs("Y"))
        ds.Cells(curCols + 1, curRows + 1).Value = tempY

        'to judge how to fill the data to the next colume or the next row
        If idx Mod xCnt = 0 Then
            curRows = curRows + 1
            curCols = inCols
        Else
            curCols = curCols + 1
        End If
        idx = idx + 1
        inRs.MoveNext
    Wend
    
    inRs.Close
    Set inRs = Nothing
    
    ' adjust the column to make the column of sheet can align the X of the chart
    sbCorrectColumnQuantity inCaption, ds, inCode, SeriesCnt - 1

End Sub

Private Sub sbSpecialClearAndFillTableData(obj As Workbook, inActive As String, inAxis As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer)
    Dim ds As Worksheet
    Set ds = obj.Sheets(1)
    ds.Range("A" & inRows & ":AZ100").ClearContents
    
    Dim SeriesCnt As Integer
    Dim xCnt As Integer
    SeriesCnt = 1
    xCnt = 1
    
    Dim arr() As String
    arr = Split(inAxis, "||")
    
    Dim isFillSeries As Boolean
    Dim isFillX As Boolean
    
    isFillSeries = False
    isFillX = False
    
    Dim i As Integer
    For i = 0 To UBound(arr)
        If LCase(arr(i)) = "series" Then
            isFillSeries = True
        ElseIf LCase(arr(i)) = "x" Then
            isFillX = True
        End If
    Next
    If Not isFillX Then
        inRows = inRows - 1
    End If
    If Not isFillSeries Then
        inCols = inCols - 1
    End If
    
    If isFillSeries Then
        SeriesCnt = sbFillSeries(ds, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, inCols, inRows)
    Else
        SeriesCnt = fnGetCount("Series", inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory)
    End If
    
    If isFillX Then
        xCnt = sbFillX(ds, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, inCols, inRows)
    Else
        xCnt = fnGetCount("X", inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory)
    End If

    sbFillY ds, SeriesCnt, xCnt, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, inCols, inRows
    
    'format the special table code in('c040','c050')
    'to judge how many column need to update
    Dim icount As Double

    If inCode = "C040" Or inCode = "C050" Or inCode = "C100" Or inCode = "C110" Then
        If xCnt = 10 Then
            ds.Columns("B:K").ColumnWidth = 9.45
            ds.Columns("L:L").EntireColumn.Hidden = True
        End If
    ElseIf inCode = "D050" Or inCode = "D110" Then
        icount = 100 / xCnt
        If xCnt <> 10 And xCnt > 1 Then
            ds.Columns("B:" & fnGetColumn(Asc("A") + xCnt)).ColumnWidth = icount
            ds.Columns(fnGetColumn(Asc("A") + xCnt + 1) & ":K").EntireColumn.Hidden = True
        End If
        If xCnt = 1 Then
            ds.Columns("C:K").EntireColumn.Hidden = True
        End If
    ElseIf inCode = "R471" Or inCode = "R472" Then
        'todo
        icount = ds.Columns("B:B").ColumnWidth
        icount = icount * 10 / xCnt
        
        ds.Columns(fnGetColumn(Asc("A") + xCnt + 1) & ":Z").EntireColumn.Hidden = True
        ds.Columns("B:" & fnGetColumn(Asc("A") + xCnt)).ColumnWidth = icount
    End If



    'obj.RefreshAll
'    If inRows > 1 Then
'        ' sbReplaceTableText ds, inCode, inCols, inRows
'        sbInsertCurrentMonth ds, inCode
'    End If
    Set ds = Nothing
End Sub

' todo
Private Sub sbSetAxisNumberFormat(cht As Chart, inCode As String, inProduct)
On Error GoTo errorhandler
    sql = ""
    Dim maxscale As Double, minscale As Double
    Dim fmt As String
    
    maxscale = cht.Axes(xlValue).MaximumScale
    minscale = cht.Axes(xlValue).MinimumScale
    maxscale = maxscale - minscale

    fmt = cht.Axes(xlValue).TickLabels.NumberFormat
    
    'MARKET SHARE
    If inCode = "D022" _
    Or inCode = "D032" _
    Or inCode = "D042" _
    Or inCode = "D082" _
    Or inCode = "D130" _
    Or inCode = "D150" _
    Or (inCode = "R120" And inProduct = "Onglyza") _
    Or inCode = "R901" _
    Or inCode = "R961" _
    Or (inCode >= "R191" And inCode <= "R301" And inCode Like "*1") _
    Or inCode = "R341" _
    Or inCode = "R351" _
    Or inCode = "R361" Then
        If maxscale > 1 Then
            cht.Axes(xlValue).MaximumScale = 1
        ElseIf maxscale <= 0.00005 Then
            cht.Axes(xlValue).TickLabels.NumberFormat = "0.0000%"
        ElseIf maxscale <= 0.0005 Then
            cht.Axes(xlValue).TickLabels.NumberFormat = "0.000%"
        ElseIf maxscale <= 0.005 Then
            cht.Axes(xlValue).TickLabels.NumberFormat = "0.00%"
        ElseIf maxscale <= 0.05 Then
            cht.Axes(xlValue).TickLabels.NumberFormat = "0.0%"
        End If
    ElseIf inCode = "D021" _
    Or inCode = "D031" _
    Or inCode = "D041" _
    Or inCode = "R902" _
    Or inCode = "R962" _
    Or (inCode >= "R192" And inCode <= "R302" And inCode Like "*2") _
    Or inCode = "R342" _
    Or inCode = "R352" _
    Or inCode = "R362" Then
        If maxscale <= 0.00005 Then
            cht.Axes(xlValue).TickLabels.NumberFormat = "0.0000%"
        ElseIf maxscale <= 0.0005 Then
            cht.Axes(xlValue).TickLabels.NumberFormat = "0.000%"
        ElseIf maxscale <= 0.005 Then
            cht.Axes(xlValue).TickLabels.NumberFormat = "0.00%"
        ElseIf maxscale <= 0.05 Then
            cht.Axes(xlValue).TickLabels.NumberFormat = "0.0%"
        End If
    ElseIf inCode = "D110" Then
        Dim d As Double
        d = cht.Axes(xlValue).MajorUnit
        If maxscale = 1 And d < 1 Then
            cht.Axes(xlValue).TickLabels.NumberFormat = "#,##0.0"
        End If
    End If
    
errorhandler:
    Exit Sub
End Sub

Private Sub sbClearAndFillScatterChartData(inCaption As String, obj As Chart, inActive As String, inAxis As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer)
    obj.ChartData.Activate

    Dim ds As Worksheet
    Dim wb As Workbook
    Set wb = obj.ChartData.Workbook
    Set ds = wb.Sheets(1)
    ds.Range(ds.Cells(1, 1), ds.Cells(1000, 1000)).ClearContents

    Dim inRs As New ADODB.Recordset
    Dim idx As Integer, SeriesIdx As String, col As Integer
    Dim SeriesCnt As Integer
    Dim tempY As String
    
        ' Fill Series
        sql = "select Distinct Series,SeriesIdx from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
        sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by seriesidx"
        inRs.Open sql, conn, 1, 3
        If (inRs.RecordCount > 0) Then
            inRs.MoveFirst
        End If
        
        idx = 1
        While Not inRs.EOF
            ds.Cells(1, idx + 1).Value = IIf(IsNull(inRs("Series")), "", inRs("Series"))
            idx = idx + 1
            inRs.MoveNext
        Wend
        SeriesCnt = idx - 1
        inRs.Close
        Set inRs = Nothing
        
        ' Fill Y
        sql = "select distinct SeriesIdx,X, Xidx, Y from Output_PPT where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
        sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by seriesidx,Xidx"
        inRs.Open sql, conn, 1, 3
        If (inRs.RecordCount > 0) Then
            inRs.MoveFirst
        End If
        idx = 2
        col = 2
        SeriesIdx = CStr(inRs("SeriesIdx"))
        While Not inRs.EOF
            If CStr(inRs("SeriesIdx")) <> SeriesIdx Then
                col = col + 1
                SeriesIdx = CStr(inRs("SeriesIdx"))
            End If
            tempY = IIf(IsNull(inRs("Y")), "", inRs("Y"))
            If (IsNumeric(tempY)) Then
                ds.Cells(idx, 1).Value = CDbl(tempY)
            Else
                ds.Cells(idx, 1).Value = tempY
            End If
        
            ds.Cells(idx, col).Value = CInt(inRs("XIdx"))
            idx = idx + 1
            inRs.MoveNext
        Wend
    
    obj.SetSourceData Source:="='Sheet1'!$A$1:" & getColumnName(idx - 1, SeriesCnt + 1, ds)
    
End Sub

'填充bubble图的数据
Private Sub sbFillBubbleData(inCaption As String, obj As Chart, inActive As String, inAxis As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer)
    obj.ChartData.Activate

    Dim ds As Worksheet
    Dim wb As Workbook
    Set wb = obj.ChartData.Workbook
    Set ds = wb.Sheets(1)
    
    sbFillXYZ ds, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, inCols, inRows
    
End Sub

'填充bubble图的数据:从数据中取出series,x,y,z填充到每一行上
Private Sub sbFillXYZ(inDs As Object, inActive As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer)

    Dim inRs As New ADODB.Recordset
    

        sql = "select Series,X,Y,Size "
        sql = sql & " from output_ppt "
        sql = sql & " where IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' "
        sql = sql & " and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' "
        sql = sql & " and geo='" & inGeo & "'  and Currency='" & inCurrency & "' "
        sql = sql & " and Timeframe='" & inTimeFrame & "' and Category='" & inCategory & "' "
        sql = sql & " order by seriesidx,xidx"
 
    inRs.Open sql, conn, 1, 3

    
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
        
        Dim idx As Integer
        idx = 2
        While Not inRs.EOF
            
            
            inDs.Cells(idx, 2) = inRs("Series")
            inDs.Cells(idx, 3) = CDbl(inRs("X"))
            inDs.Cells(idx, 4) = CDbl(inRs("Y"))
            inDs.Cells(idx, 5) = CDbl(inRs("Size"))
           
            idx = idx + 1
            inRs.MoveNext
        Wend
        
        inDs.Rows(CStr(inRs.RecordCount + 2) + ":55").Hidden = True
    End If
    
    
    inRs.Close
    Set inRs = Nothing
End Sub


Private Sub sbClearAndFillChartData(inCaption As String, obj As Chart, inActive As String, inAxis As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer)
    obj.ChartData.Activate

    Dim ds As Worksheet
    Dim wb As Workbook
    Set wb = obj.ChartData.Workbook
    Set ds = wb.Sheets(1)
    ds.Range(ds.Cells(1, 1), ds.Cells(1000, 1000)).ClearContents
    'return the chart rows number
    Dim SeriesCnt As Integer
    'return the chart colume number
    Dim xCnt As Integer
    Dim yCnt As Integer
    
    SeriesCnt = 1
    xCnt = 1
    
    Dim arr() As String
    arr = Split(inAxis, "||")
    
    Dim isFillSeries As Boolean
    Dim isFillX As Boolean
    
    isFillSeries = False
    isFillX = False
    
    Dim i As Integer
    For i = 0 To UBound(arr)
        If LCase(arr(i)) = "series" Then
            isFillSeries = True
        ElseIf LCase(arr(i)) = "x" Then
            isFillX = True
        End If
    Next
    If Not isFillX Then
        inRows = inRows - 1
    End If
    If isFillSeries Then
        SeriesCnt = sbFillSeries(ds, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, inCols, inRows)
    End If
    
    If isFillX Then
        xCnt = sbFillX(ds, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, inCols, inRows)
    Else
        xCnt = fnGetCount("X", inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory)
    End If
    
    yCnt = sbFillY(ds, SeriesCnt, xCnt, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory, inCols, inRows)

    'judge if need to update the axis title
    If InStr(1, inCaption, "No Primary Title,No Secondry Title", 1) > 0 Then
    ElseIf InStr(1, inCaption, "Primary Title,No Secondry Title", 1) > 0 Then
        sbUpdatePrimaryAxisName obj, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory
    ElseIf InStr(1, inCaption, "No Primary Title,Secondry Title", 1) > 0 Then
        sbUpdateSecondaryAxisName obj, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory
    Else
        sbUpdatePrimaryAxisName obj, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory
        sbUpdateSecondaryAxisName obj, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory
    End If
    'update the chart title
    If obj.HasTitle Then
        sbUpdateChartTitle obj, inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory
    End If
    
   ' LCase (shp.AlternativeText)
    If InStr(1, inCaption, "colums", 1) > 0 Then
        obj.SetSourceData Source:="='Sheet1'!$A$1:" & getColumnName(SeriesCnt + 1, xCnt + 1, ds), PlotBy:=2
    Else
        obj.SetSourceData Source:="='Sheet1'!$A$1:" & getColumnName(SeriesCnt + 1, xCnt + 1, ds), PlotBy:=1
    End If
    
    ' Set ds = Nothing
    ' wb.Close
End Sub

Private Function sbUpdatePrimaryAxisName(inobj As Chart, inActive As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String)
    'inobj.ChartData.Activate
    Dim inRs As New ADODB.Recordset
    sql = "select DISTINCT isnull(PYAxisName,'') as inPYAxisName,isnull(SYAxisName,'') as inSYAxisName from tblChartTitle where LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "'"
    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    
        If (IIf(IsNull(inRs("inPYAxisName")), "", inRs("inPYAxisName")) <> "") Then
            inobj.Axes(xlValue, xlPrimary).AxisTitle.Text = inRs("inPYAxisName")
        End If
    End If
End Function

Private Function sbUpdateSecondaryAxisName(inobj As Chart, inActive As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String)
    'inobj.ChartData.Activate
    Dim inRs As New ADODB.Recordset
    sql = "select DISTINCT isnull(PYAxisName,'') as inPYAxisName,isnull(SYAxisName,'') as inSYAxisName from tblChartTitle where LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "'"
    inRs.Open sql, conn, 1, 3
   
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
        If inRs("inSYAxisName") <> "" Then
            inobj.Axes(xlValue, xlSecondary).AxisTitle.Text = inRs("inSYAxisName")
        End If
    End If
End Function

Private Function sbUpdateChartTitle(inobj As Chart, inActive As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String)
    'inobj.ChartData.Activate
    Dim inRs As New ADODB.Recordset
    sql = "select DISTINCT isnull(Subcaption,'') as Subcaption from tblChartTitle where LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "'"
    inRs.Open sql, conn, 1, 3
   
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
     '   If inRs("Subcaption") <> "" Then
     '       inobj.ChartTitle.Characters.Text = inRs("Subcaption")
     '   End If
    End If
    If inRs("Subcaption") <> "" Then
      inobj.ChartTitle.Characters.Text = inRs("Subcaption")
    End If
    
End Function

Private Function sbUpdateSlideSubTitle(intrng As TextRange, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String)
    'inobj.ChartData.Activate
    Dim inRs As New ADODB.Recordset
    sql = "select DISTINCT isnull(case when Product='Baraclude' and ParentCode='D020' and TimeFrame='MTH' then replace( SlideTitle,'MQT/MTH','MTH' ) else SlideTitle end as SlideTitle,'') as SlideTitle from tblChartTitle where parentcode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "'"
    inRs.Open sql, conn, 1, 3
   
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
'    If inRs("SlideTitle") <> "" Then
'        intrng.Text = inRs("SlideTitle")
    intrng.Text = IIf(IsNull(inRs("SlideTitle")), "", inRs("SlideTitle"))

'    End If
End Function

Function getColumnName(Rn As Integer, Cn As Integer, ds As Worksheet) As String
    getColumnName = ds.Cells(Rn, Cn).Address
End Function


Private Function fnGetCount(inType As String, inActive As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String) As Integer
    Dim inRs As New ADODB.Recordset
    sql = "select "
    If LCase(inType) = "x" Then
        sql = sql & " count(Distinct " & inType & "+cast(XIdx as varchar)) as cnt"
    Else
        sql = sql & " count(Distinct " & inType & "Idx) as cnt"
    End If
    sql = sql & " from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "'"
    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    Dim rlt As Integer
    rlt = inRs("cnt")
    inRs.Close
    Set inRs = Nothing
    
    fnGetCount = rlt
    
End Function

Private Function sbFillSeries(inDs As Object, inActive As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer) As Integer
    Dim inRs As New ADODB.Recordset
    sql = "select Distinct Series,SeriesIdx from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by seriesidx"
    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    Dim idx As Integer
    idx = inRows
    While Not inRs.EOF
        If inCode Like "R53*" Then
            inDs.Cells(idx + 1, inCols - 1).Value = inRs("SeriesIdx")
            inDs.Cells(idx + 1, inCols).Value = IIf(IsNull(inRs("Series")), "-", inRs("Series")) 'mmmmmmmmmmmmmmtest
        Else
            inDs.Cells(idx + 1, inCols).Value = IIf(IsNull(inRs("Series")), "-", inRs("Series"))  'mmmmmmmmmmmmmmtest
        End If
        idx = idx + 1
        inRs.MoveNext
    Wend
    inRs.Close
    Set inRs = Nothing
    sbFillSeries = idx - 1
End Function
Private Function sbFillX(inDs As Object, inActive As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer) As Integer
    Dim inRs As New ADODB.Recordset
    sql = "select DISTINCT [X],XIdx from output_ppt where IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "'  order by xidx"
    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    Dim idx As Integer
    idx = inCols
    While Not inRs.EOF
        inDs.Cells(inRows, idx + 1).Value = IIf(IsNull(inRs("X")), "", inRs("X"))   'testmmmmmmmmmmmmmmmmmmm
        idx = idx + 1
        inRs.MoveNext
    Wend
    inRs.Close
    Set inRs = Nothing
    sbFillX = idx - 1
End Function


Private Function sbFillY(inDs As Object, inRowsCnt As Integer, inColsCnt As Integer, inActive As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer) As Integer

    Dim inRs As New ADODB.Recordset
    Dim rlt As Integer
    
    ' not 100% stacked bar any more
    'If inCode = "D022" Or inCode = "D032" Or inCode = "D042" Or inCode = "R901" Or inCode = "R961" Or (inCode >= "R191" And inCode <= "R301" And inCode Like "*1") Or inCode = "R341" Or inCode = "R351" Or inCode = "R361" Then
    '    sql = "select case seriesidx when 10000 then Y else cast(Y as float)*100 end as Y  "
    '    sql = sql & " from output_ppt "
    '    sql = sql & " where IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' "
    '    sql = sql & " and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' "
    '    sql = sql & " and geo='" & inGeo & "'  and Currency='" & inCurrency & "' "
    '    sql = sql & " and Timeframe='" & inTimeframe & "' and Category='" & inCategory & "' "
    '    sql = sql & " order by seriesidx,xidx"
    'Else
        sql = "select Y "
        sql = sql & " from output_ppt "
        sql = sql & " where IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' "
        sql = sql & " and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' "
        sql = sql & " and geo='" & inGeo & "'  and Currency='" & inCurrency & "' "
        sql = sql & " and Timeframe='" & inTimeFrame & "' and Category='" & inCategory & "' "
        sql = sql & " order by seriesidx,xidx"
    'End If
 
    inRs.Open sql, conn, 1, 3
    
    rlt = 0
    
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
        rlt = CLng(inRs.RecordCount)
    End If
    
    Dim tempY As String
    Dim idx As Integer
    Dim curRows As Integer
    Dim curCols As Integer
    idx = 1
    curRows = inRows
    curCols = inCols
    
    While Not inRs.EOF
        tempY = IIf(IsNull(inRs("Y")), "", inRs("Y"))          'mmmmmmmmmmmmmmmmmmmmmtest
        If (IsNumeric(tempY)) Then
            inDs.Cells(curRows + 1, curCols + 1).Value = CDbl(tempY)
        Else
            inDs.Cells(curRows + 1, curCols + 1).Value = tempY
        End If
        
        'to judge how to fill the data to the next colume or the next row
        If idx Mod inColsCnt = 0 Then
            curRows = curRows + 1
            curCols = inCols
        Else
            curCols = curCols + 1
        End If
        idx = idx + 1
        inRs.MoveNext
    Wend
    inRs.Close
    Set inRs = Nothing
    sbFillY = rlt
End Function

Private Sub sbSetSeriesColor(inchart As Chart, inActive As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String)
    inchart.ChartData.Activate

    Dim ds As Worksheet
    Dim wb As Workbook
    Set wb = inchart.ChartData.Workbook
    Set ds = wb.Sheets(1)
    
    Dim i As Integer
    Dim KR As Long
    Dim KG As Long
    Dim KB As Long
    Dim K As String
    Dim arr() As String
    
    Dim ChartType  As Integer
    Dim SeriesName As String
    Dim ColorList As New ADODB.Recordset
    Set ColorList = fnGetColorList(inActive, inCode, inProduct, inParentGeo, inGeo, inCurrency, inTimeFrame, inCategory)
    
        For i = 1 To inchart.SeriesCollection.Count
            ChartType = inchart.SeriesCollection(i).ChartType
           ' SeriesName = inchart.ChartData.DataSheet.Cells(i + 1, 1)  ''2003 version
           
            If (inCode = "R451" Or inCode = "R452") Then
                SeriesName = ds.Cells(1, i + 1)
            Else
                SeriesName = ds.Cells(i + 1, 1)
            End If
            'kR = fnGetColor(ColorList, SeriesName)
            'kG = fnGetColor(ColorList, SeriesName)
            K = fnGetColor(ColorList, SeriesName)

'

            'Set ChartSeries = inchart.SeriesCollection(i)
            'If kB + kG + kR <> 0 Then
            If K <> 0 Then
                KR = Left(K, InStr(1, K, ",", 1) - 1)
                arr = Split(Right(K, Len(K) - InStr(1, K, ",", 1) + 1), ",")
                KG = arr(1)
                KB = arr(2)
                sbSetNonPieSeriesColor inCode, SeriesName, ChartType, inchart.SeriesCollection(i), KR, KG, KB
            End If
        Next
    wb.Close
    
End Sub

Private Sub sbSetNonPieSeriesColor(inCode As String, inSeriesName As String, inChartType As Integer, inSeries As Object, KR As Long, KG As Long, KB As Long)
        If inChartType = 65 Then 'XuXian + lingxing
            inSeries.Border.Weight = 2
            inSeries.Format.Line.BackColor.RGB = RGB(KR, KG, KB)
            inSeries.Format.Line.ForeColor.RGB = RGB(KR, KG, KB)
            inSeries.MarkerStyle = 2
            inSeries.MarkerSize = 7
            inSeries.MarkerBackgroundColor = RGB(KR, KG, KB)
            inSeries.MarkerForegroundColor = RGB(KR, KG, KB)
            
        ElseIf inChartType = 74 Then 'ShiXian + Lingxing
            inSeries.Border.Weight = 2
            inSeries.Format.Line.BackColor.RGB = RGB(KR, KG, KB)
            inSeries.Format.Line.ForeColor.RGB = RGB(KR, KG, KB)
            inSeries.MarkerStyle = 2
            inSeries.MarkerSize = 7
            inSeries.MarkerBackgroundColor = RGB(KR, KG, KB)
            inSeries.MarkerForegroundColor = RGB(KR, KG, KB)
        ElseIf inChartType = -4169 Then
            inSeries.MarkerSize = 7
            inSeries.MarkerBackgroundColor = RGB(KR, KG, KB)
            inSeries.MarkerForegroundColor = RGB(KR, KG, KB)
        ElseIf inChartType = 4 Then 'xuxian
            inSeries.Border.Weight = 3
            inSeries.Format.Line.BackColor.RGB = RGB(KR, KG, KB)
            inSeries.Format.Line.ForeColor.RGB = RGB(KR, KG, KB)
           ' inSeries.Format.Fill.ForeColor.RGB = RGB(KR, KG, KB)
            inSeries.MarkerStyle = xlNone
        ElseIf inChartType = xlLineMarkers Then
            inSeries.Border.LineStyle = 1
            inSeries.Border.Weight = 2
            'inSeries.Border.colorIndex = k
            inSeries.Format.Line.BackColor.RGB = RGB(KR, KG, KB)
            inSeries.Format.Line.ForeColor.RGB = RGB(KR, KG, KB)
            'inSeries.MarkerStyle = xlSquare ' fang ge
            inSeries.MarkerStyle = 2 ' lingxing(xlDiamond)
            inSeries.MarkerSize = 7
            inSeries.MarkerBackgroundColor = RGB(KR, KG, KB)
            inSeries.MarkerForegroundColor = RGB(KR, KG, KB)
        ElseIf inChartType = xlColumnClustered Then
            inSeries.Format.Fill.ForeColor.RGB = RGB(KR, KG, KB)
        ElseIf inChartType = xlColumnStacked Or inChartType = xlColumnStacked100 Then
            inSeries.Format.Fill.ForeColor.RGB = RGB(KR, KG, KB)
            inSeries.Format.Line.ForeColor.RGB = RGB(KR, KG, KB)
        ElseIf inChartType = xl3DPie Then
            inSeries.Interior.Color = RGB(KR, KG, KB)
        ElseIf inChartType = xlLine Then
            inSeries.Border.Color = RGB(KR, KG, KB)
        Else
            ' do nothing
            Dim d As Integer
            d = 1
        End If

End Sub

Private Function fnGetColorList(inActive As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String) As ADODB.Recordset
    Dim inRs As New ADODB.Recordset
   ' sql = "select Distinct LinkChartCode,Series,SeriesIdx,isnull(coloridx,0) as coloridx from tblChartSeries where  LinkChartCode = '" & inCode & "' and geo='" & inGeo & "'"
    sql = "select Distinct LinkChartCode,Series,isnull(R,0) as Rcoloridx,isnull(G,0)as Gcoloridx,isnull(B,0)as Bcoloridx "
    sql = sql & " from output_ppt where  IsShow = 'Y' and LinkChartCode = '" & inCode & "' "
    sql = sql & " and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  "
    sql = sql & " and product='" & inProduct & "' "
    sql = sql & " and currency='" & inCurrency & "'"
    
    
    inRs.Open sql, conn, 1, 3
    Set fnGetColorList = inRs
End Function

Private Function fnGetColor(ByRef inRs As ADODB.Recordset, inName As String) As String
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If

    Dim isFound As Boolean
    isFound = False
    Do While Not inRs.EOF
        If inRs("Series") <> inName Then
            inRs.MoveNext
        Else
            fnGetColor = inRs("Rcoloridx") & "," & inRs("Gcoloridx") & "," & inRs("Bcoloridx")
            isFound = True
            Exit Do
        End If
    Loop
    
    If Not isFound Then
        fnGetColor = 0
    End If
End Function

Private Sub sbClearAndFillPPRTableData(PT As PowerPoint.Table, inActive As String, inAxis As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer)
    

    
    Dim SeriesCnt As Integer
    Dim xCnt As Integer
'-----to fill X axis
    Dim inRs As New ADODB.Recordset
    sql = "select Distinct X,XIdx from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by Xidx"
    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    xCnt = inCols + 1
    While Not inRs.EOF
        PT.Cell(1, xCnt).Shape.TextFrame.TextRange.Font.Size = 7
        PT.Cell(1, xCnt).Shape.TextFrame.TextRange.Font.Bold = True
        PT.Cell(1, xCnt).Shape.TextFrame.TextRange.Text = inRs("X")
        xCnt = xCnt + 1
        inRs.MoveNext
    Wend
    xCnt = xCnt - 2
 '-----to fill series axis
    Set inRs = New ADODB.Recordset
    sql = "select Distinct Series,SeriesIdx from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by Seriesidx"
    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    
    'to insert the rows
    Dim i As Integer
    i = 2
    While i <= inRs.RecordCount

        PT.Rows.Add (i)
        i = i + 1
    Wend
    'format the rows
    Dim j As Integer
    j = 1
    While j <= i
         PT.Rows(j).Height = 14
        j = j + 1
    Wend

    'to fill the series
    SeriesCnt = inRows + 1
    While Not inRs.EOF
        PT.Cell(SeriesCnt, 1).Shape.TextFrame.TextRange.Font.Size = 7
        PT.Cell(SeriesCnt, 1).Shape.TextFrame.TextRange.Font.Bold = True
        PT.Cell(SeriesCnt, 1).Shape.TextFrame.TextRange.Text = inRs("Series")
        SeriesCnt = SeriesCnt + 1
        inRs.MoveNext
    Wend
    
    SeriesCnt = SeriesCnt - 1
'-----to fill Y axis
    Set inRs = New ADODB.Recordset
    sql = "select "
    
    If inCode = "D021" Or inCode = "D031" Then
        sql = sql + " cast(round(cast(Y as float)*100,0) as varchar(10)) as Y  "
    Else
        sql = sql + " cast(round(cast(Y as float)*100,1) as varchar(10)) as Y  "
    End If
    
    sql = sql + " from output_ppt "
    sql = sql + " where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' "
    sql = sql + " and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' "
    sql = sql + " and geo='" & inGeo & "'  and Currency='" & inCurrency & "' "
    sql = sql + " and Timeframe='" & inTimeFrame & "' and Category='" & inCategory & "' "
    sql = sql + " order by seriesidx,xidx"
    
    inRs.Open sql, conn, 1, 3
    
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    
    Dim tempY As String
    Dim idx As Integer
    Dim curRows As Integer
    Dim curCols As Integer
    
    idx = 1
    curRows = inRows
    curCols = inCols
    
    While Not inRs.EOF
        tempY = IIf(IsNull(inRs("Y")), "", inRs("Y"))                        'mmmmmmmmmmmmmmmtest
        PT.Cell(curRows + 1, curCols + 1).Shape.TextFrame.TextRange.Font.Size = 7
        PT.Cell(curRows + 1, curCols + 1).Shape.TextFrame.TextRange.Font.Bold = True
        PT.Cell(curRows + 1, curCols + 1).Shape.TextFrame.TextRange.Text = IIf(tempY = "", "-", tempY + "%")

        'to judge how to fill the data to the next colume or the next row
        If idx Mod xCnt = 0 Then
            curRows = curRows + 1
            curCols = inCols
        Else
            curCols = curCols + 1
        End If
        idx = idx + 1
        inRs.MoveNext
    Wend
    
    inRs.Close
    Set inRs = Nothing
End Sub

Private Sub sbClearAndFillPPRTableData_R(PT As PowerPoint.Table, inActive As String, inAxis As String, inCode As String, inProduct As String, inParentGeo As String, inGeo As String, inCurrency As String, inTimeFrame As String, inCategory As String, inCols As Integer, inRows As Integer)
    

    
    Dim SeriesCnt As Integer
    Dim xCnt As Integer
'-----to fill X axis
    Dim inRs As New ADODB.Recordset
    sql = "select Distinct X,XIdx from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by Xidx"
    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    xCnt = inCols + 1
    While Not inRs.EOF
'        PT.Cell(1, xCnt).Shape.TextFrame.TextRange.Font.Size = 7
'        PT.Cell(1, xCnt).Shape.TextFrame.TextRange.Font.Bold = True
        PT.Cell(inRows, xCnt).Shape.TextFrame.TextRange.Text = inRs("X")
        xCnt = xCnt + 1
        inRs.MoveNext
    Wend
    xCnt = xCnt - inCols - 1
 '-----to fill series axis
    Set inRs = New ADODB.Recordset
    sql = "select Distinct Series,SeriesIdx from output_ppt where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and Currency='" & inCurrency & "'and Timeframe='"
    sql = sql & inTimeFrame & "' and Category='" & inCategory & "' order by Seriesidx"
    inRs.Open sql, conn, 1, 3
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    
    'to insert the rows
'    Dim i As Integer
'    i = 2
'    While i <= inRs.RecordCount
'
'        PT.Rows.Add (i)
'        i = i + 1
'    Wend
    'format the rows
'    Dim j As Integer
'    j = 1
'    While j <= i
'         PT.Rows(j).Height = 14
'        j = j + 1
'    Wend

    'to fill the series
    SeriesCnt = inRows + 1
    While Not inRs.EOF
'        PT.Cell(SeriesCnt, 1).Shape.TextFrame.TextRange.Font.Size = 7
'        PT.Cell(SeriesCnt, 1).Shape.TextFrame.TextRange.Font.Bold = True
        PT.Cell(SeriesCnt, inCols).Shape.TextFrame.TextRange.Text = inRs("Series")
        If InStr(1, inRs("Series"), "average", 1) > 0 And inCode = "R610" Then
            PT.Cell(SeriesCnt, inCols).Shape.TextFrame.TextRange.Characters(InStr(1, inRs("Series"), "average", 1), Len(inRs("Series")) - InStr(1, inRs("Series"), "average", 1) + 1).Font.Color.RGB = RGB(255, 0, 0)
        End If
        SeriesCnt = SeriesCnt + 1
        inRs.MoveNext
    Wend
    
    SeriesCnt = SeriesCnt - 1
'-----to fill Y axis
    Set inRs = New ADODB.Recordset
    sql = "select "
    
    If inCode = "R620" Or inCode = "R630" Or inCode = "R720" Or inCode = "R730" Then
        sql = sql + " case when X IN ('ACEI MS Size (K RMB)','CCB MS Size (K RMB)','VTEP MS Size (K RMB)') then  Y when X='Region' then Y else cast(round(cast(Y as float)*100,1) as varchar(10)) end as Y  "
    ElseIf inCode = "R640" Then
        sql = sql + " case when X ='Hosp. # matched with BMS hospital'  then  cast(round(cast(Y as float),0) as varchar(10)) else cast(round(cast(Y as float)*100,1) as varchar(10)) end as Y  "
    Else
        sql = sql + " cast(round(cast(Y as float)*100,1) as varchar(10)) as Y  "
    End If
    
    sql = sql + ", X,R,G,B from output_ppt "
    sql = sql + " where  IsShow = '" & inActive & "' and LinkChartCode = '" & inCode & "' "
    sql = sql + " and Product='" & inProduct & "' and parentgeo='" & inParentGeo & "' "
    sql = sql + " and geo='" & inGeo & "'  and Currency='" & inCurrency & "' "
    sql = sql + " and Timeframe='" & inTimeFrame & "' and Category='" & inCategory & "' "
    sql = sql + " order by seriesidx,xidx"
    
    inRs.Open sql, conn, 1, 3
    
    If (inRs.RecordCount > 0) Then
        inRs.MoveFirst
    End If
    
    Dim tempY As String
    Dim idx As Integer
    Dim curRows As Integer
    Dim curCols As Integer
    
    idx = 1
    curRows = inRows
    curCols = inCols
    
    While Not inRs.EOF
        If inRs("X") = "Hosp. # matched with BMS Hospital" Or inRs("X") = "ACEI MS Size (K RMB)" Or inRs("X") = "Hosp. # matched with BMS hospital" Or inRs("X") = "Region" Or inRs("X") = "CCB MS Size (K RMB)" Or inRs("X") = "VTEP MS Size (K RMB)" Then
          tempY = IIf(IsNull(inRs("Y")), "", inRs("Y"))
          PT.Cell(curRows + 1, curCols + 1).Shape.TextFrame.TextRange.Text = IIf(tempY = "", "-", tempY)
        Else
          tempY = IIf(IsNull(inRs("Y")), "", inRs("Y"))                        'mmmmmmmmmmmmmmmtest
'         PT.Cell(curRows + 1, curCols + 1).Shape.TextFrame.TextRange.Font.Size = 7
'         PT.Cell(curRows + 1, curCols + 1).Shape.TextFrame.TextRange.Font.Bold = True
          PT.Cell(curRows + 1, curCols + 1).Shape.TextFrame.TextRange.Text = IIf(tempY = "", "-", tempY + "%")
        End If
        If inCode = "R610" And inRs("R") <> "" Then
           PT.Cell(curRows + 1, curCols + 1).Shape.TextFrame.TextRange.Font.Color.RGB = RGB(inRs("R"), inRs("G"), inRs("B"))
        End If

        'to judge how to fill the data to the next colume or the next row
        If idx Mod xCnt = 0 Then
            curRows = curRows + 1
            curCols = inCols
        Else
            curCols = curCols + 1
        End If
        idx = idx + 1
        inRs.MoveNext
    Wend
    
    inRs.Close
    Set inRs = Nothing
End Sub

Private Function fnGetColumn(ColIndex As Integer) As String
    Dim Result As String
    Dim i As Integer, j As Integer
    If ColIndex >= 65 And ColIndex <= 90 Then
        Result = Chr(ColIndex)
    ElseIf (ColIndex > 90) Then
            j = (ColIndex - 90) Mod 26
            i = (ColIndex - 90 - j) / 26
            If (j = 0) Then
                i = i - 1
                j = 26
            End If
            Result = fnGetColumn(Asc("A") + i) & Chr(Asc("A") + j - 1)
    End If
    fnGetColumn = Result
End Function

Private Function GetColumn(ColIndex) As String
    
    Dim Result
    Dim i
    Dim j
    If (ColIndex < 1) Then
          Result = "A"
     Else
          If (ColIndex < 27) Then
              Result = Chr(Asc("A") + ColIndex - 1)
           Else
          
              j = ColIndex Mod 26
              i = (ColIndex - j) / 26
              If (j = 0) Then
              
                  i = i - 1
                  j = 26
              End If
              Result = GetColumn(i) + Chr(Asc("A") + j - 1)
           End If
      End If
    GetColumn = Result
End Function

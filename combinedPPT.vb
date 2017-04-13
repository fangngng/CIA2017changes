Option Explicit

Dim pptTemplate As PowerPoint.Presentation
'-----connect to the database
Dim sql As String
Dim conn As ADODB.Connection

Public strTemplatePath As String
Public strOutputPath As String
Dim strCurrCode As String
'''''datetime
Dim strDataMonth As String


Const strPPTPath = "D:\CI&A\BMSChinaPPT\Output\201701\Slide\"   'todo

' connect to DB102 BMSChina database
Const strConnectDB = "Provider=MSDASQL;Driver={SQL Server};Server=172.20.0.82;Database=BMSChina_ppt;Uid=sa;Pwd=love2you;"

' report datasource : output
' report template : template_all

Public Sub Script_main()
''''''initialize
    sbConnectDB
    sbDefineConstant
    sbCreateOutputFolder
        'run reports for national
    sbCombineSlides

    sbDisconnectDB
End Sub

Private Sub sbDefineConstant()
    strOutputPath = "D:\CI&A\BMSChinaPPT\Output\temp\SlideCombined"
    strTemplatePath = ActivePresentation.path & "\template"
    'MsgBox strOutputPath
    'ppt from where
    
    
    
    'set current month date
    sql = " select * from [tblDates]where DateSource='CurrentMonthlyDate' "
    Dim rs As New ADODB.Recordset
    rs.Open sql, conn, 1, 3
    rs.MoveFirst
    strDataMonth = rs("DateValue")
        
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
    MsgBox conn
End Sub

Private Sub sbCombineSlides()
    
   Dim sql As String
    sql = "       select distinct case left(OutputName,1) when 'R' then 'BrandReport' else 'Dashboard' end as Page,"
    sql = sql + " product,lev,parentgeo,geo "
    sql = sql + " from tblPPTOutputCombine "
    sql = sql + " where lev<>'' "
    
    

      ' sql = sql + " and Product like 'eliquis%'  "
    
    '  sql = sql + " and Product = 'Paraplatin' and lev = 'Predefined'"
    
    ' sql = sql + " and Product = 'Glucophage' and lev = 'city' and geo = 'hangzhou' "
    ' sql = sql + " and ((lev = 'City' and Product = 'Glucophage') or (lev = 'Region' and product = 'Taxol')) "
    
    ' sql = sql + " and Product = 'Glucophage' and lev = 'city' and geo = 'hangzhou' and lev = 'city' and Outputname like 'D130%' "
    'sql = sql + " and Product = 'Onglyza' and Geo ='East 2'  "
    
    'sql = sql + " and (OutputName like 'D020%' or OutputName like 'D030%') and ("
    'sql = sql + " (SlideCategory = 'Monopril_D' and Geo = 'East') or "
    'sql = sql + " (SlideCategory = 'Glucophage_D' and Geo = 'East 2') or"
    'sql = sql + " (SlideCategory = 'Onglyza_D' and Geo = 'East 2') or"
    'sql = sql + " (SlideCategory = 'Taxol_D' and Geo = 'East-2') "
    'sql = sql + ") "
    
    'sql = sql + " and ("
    'sql = sql + "(Lev = 'City' and geo in('Xian','Pearl Delta river')) "
    'sql = sql + "or (Lev ='Region' and geo in ('North','North west','West','East 1','HEAT-87','South')) "
    'sql = sql + ")"
    
    
    'sql = sql + " and product  in ('baraclude') and lev<>'Predefined' and geo in ('north','beijing')"
    'sql = sql + " and lev = 'Portfolio' "
    'sql = sql + " and lev ='City' and Product in ('Monopril') "
    
    'sql = sql + " and Geo = 'Ningbo' and Product in ('Glucophage','baraclude') "
    'sql = sql + " and  Product = 'Glucophage' and geo='HEAT-87'"
    'sql = sql + " and  Product in('monopril')  "
    'sql = sql + " and (Outputname like  'C100%' or Outputname like  'C110' or Outputname like  'C210' "
    'sql = sql + " or Outputname like  'C220' or Outputname like  'R320')"
    
    sql = sql + "order by product,lev,parentgeo,geo"
    'sql = sql + " order by idx "
    Dim rs As New ADODB.Recordset
    
    rs.Open sql, conn, 1, 3
    If rs.RecordCount > 0 Then
        rs.MoveFirst
    End If
    While Not rs.EOF
    
        sbCombineLevSlides rs("Page"), rs("Product"), rs("lev"), rs("parentgeo"), rs("geo")
        rs.MoveNext
        
    Wend
    
    rs.Close
    Set rs = Nothing
    
End Sub

Private Sub sbCombineLevSlides(inPage As String, inProd As String, inLev As String, inParentGeo As String, inGeo As String)
    Dim ppt As PowerPoint.Presentation
    sql = "       select a.Code, a.IsSection,a.IsCover,b.OutputName"
    sql = sql + " from ("
    sql = sql + "   select Code,IsSection, IsCover,id from tblPPTSection"
    sql = sql + "   where Page = '" + inPage + "' and Product = '" + inProd + "' and Lev = '" + inLev + "'"
    sql = sql + " ) a left join ("
    sql = sql + "     select OutputName,OutputName4Rank"
    sql = sql + "     From tblPPTOutputCombine"
    sql = sql + "     where Product = '" + inProd + "' and Lev = '" + inLev + "' and Parentgeo = '" + inParentGeo + "' and Geo = '" + inGeo + "'"
    sql = sql + "           and outputname not like '%NOAC%' "
    sql = sql + " ) b on a.code = left(b.OutputName,4)"
    sql = sql + " order by a.id,b.OutputName4Rank"
    Dim rs As New ADODB.Recordset
    rs.Open sql, conn, 1, 3
    If rs.RecordCount > 0 Then
        rs.MoveFirst
    End If
    
    Set ppt = Application.Presentations.Open(strTemplatePath & "\" & rs("code") & ".pptx")
    
    Dim sld As PowerPoint.Slide
    Dim shp As PowerPoint.Shape
    
    ' For City/Region Cover, set the Geo
    If inLev = "Region" Or inLev = "City" Or inLev = "Nation" Then
        Set sld = ppt.Slides(ppt.Slides.Count)
        For Each shp In sld.Shapes
            If shp.HasTextFrame And shp.AlternativeText = "Title" Then
                Dim strTitle As String
                strTitle = shp.TextFrame.TextRange
                If InStr(1, strTitle, "#") <> 0 Then
                    strTitle = Replace(strTitle, "#Geo#", inGeo)
                    strTitle = Replace(strTitle, "#Product", inProd)
                    shp.TextFrame.TextRange = strTitle
                    
                    If inGeo = "Pearl River Delta" Then
                        shp.TextFrame.TextRange.Font.Size = 28
                    End If
                    Exit For
                End If
            End If
        Next
    End If
    
    rs.MoveNext
    While Not rs.EOF
        If rs("IsSection") = "Y" Then
            ' Insert section page
            ' And set the name of section
            ppt.Slides.InsertFromFile strTemplatePath & "\Title.pptx", ppt.Slides.Count
            Set sld = ppt.Slides(ppt.Slides.Count)
            For Each shp In sld.Shapes
                If shp.HasTextFrame And shp.AlternativeText = "Title" Then
                    shp.TextFrame.TextRange = rs("Code")
                    Exit For
                End If
            Next
        Else
            If Not IsNull(rs("OutputName")) Then
                ppt.Slides.InsertFromFile strPPTPath & rs("OutputName"), ppt.Slides.Count
            End If
        End If
        rs.MoveNext
    Wend
    rs.Close
    Set rs = Nothing
    
    If inLev = "Portfolio" Then
        ppt.SaveAs strOutputPath & "\" & inLev & ".pptx"
    ElseIf inLev = "Predefined" Then
        ppt.SaveAs strOutputPath & "\" & inProd & "_" & strDataMonth & ".pptx"
    Else
        ppt.SaveAs strOutputPath & "\" & inProd & "_" & inParentGeo & "_" & inGeo & ".pptx"
    End If
    ppt.Close
    
End Sub

Private Sub ddd(InProduct As String, inLev As String, inParentGeo As String, inGeo As String)
    Dim ppt As Presentation
'    If InLev = "Portfolio" Then
'        Set ppt = Application.Presentations.Open("E:\BI_DB\BMSchina\Rpt\Template\C010.pptx")
'    ElseIf InLev = "Predefined" Then
'        Set ppt = Application.Presentations.Open("E:\Projects\BMSChina\Rpt\Template\R010.pptx")
'    ElseIf InLev = "Region" Then
'            Set ppt = Application.Presentations.Open("E:\BI_DB\BMSchina\Rpt\Template\D010.pptx")
'    Else:  Set ppt = Application.Presentations.Open("E:\BI_DB\BMSchina\Rpt\Template\D070.pptx")
'    End If

    sql = " select distinct [SlideRank],outputname from tblPPTOutputCombine "
    sql = sql + " where product ='" & InProduct & "' and parentgeo='" & inParentGeo & "' and geo='" & inGeo & "'  and lev='" & inLev & "'"
    sql = sql + "order by SlideRank"
    Dim Inrs As New ADODB.Recordset
    Set Inrs = New ADODB.Recordset
  
    
    Inrs.Open sql, conn, 1, 3
    If Inrs.RecordCount > 0 Then
        Inrs.MoveFirst
    End If
           
    If Inrs("outputname") = "R010.pptx" Or Inrs("outputname") = "C010.pptx" Or Inrs("outputname") = "D010.pptx" Or Inrs("outputname") = "D070.pptx" Then
           
            Set ppt = Application.Presentations.Open(strTemplatePath & "\" & Inrs("outputname"))
            'need to add the Geo information in the first page,so plus the following#
            If Inrs("outputname") = "D010.pptx" Or Inrs("outputname") = "D070.pptx" Then
                Dim shp As PowerPoint.Shape
                For Each shp In ppt.Slides(1).Shapes
                    If shp.HasTextFrame Then
                        Dim strTitle As String
                        strTitle = shp.TextFrame.TextRange
                        If InStr(1, strTitle, "#") <> 0 Then
                            shp.TextFrame.TextRange = Mid(strTitle, 1, InStr(1, strTitle, "#") - 1) & inGeo
                        End If
                        
                    End If
                Next
            End If
            '#
            Else:  Set ppt = Application.Presentations.Open(strPPTPath & Inrs("outputname"))
    End If
        
    Inrs.MoveNext
        
    Do While Not Inrs.EOF
               
        If Inrs("outputname") = "R140.pptx" Or Inrs("outputname") = "R310.pptx" Or Inrs("outputname") = "R330.pptx" Or Inrs("outputname") = "C090.pptx" Then
            ppt.Slides.InsertFromFile strTemplatePath & "\" & Inrs("outputname"), ppt.Slides.Count
            Else: ppt.Slides.InsertFromFile strPPTPath & Inrs("outputname"), ppt.Slides.Count
        End If
        
        Inrs.MoveNext
    Loop
  
  
    If inLev = "Portfolio" Then
        ppt.SaveAs strOutputPath & "\" & inLev & ".pptx"
    ElseIf inLev = "Predefined" Then
        ppt.SaveAs strOutputPath & "\" & InProduct & "_" & strDataMonth & ".pptx"
    Else: ppt.SaveAs strOutputPath & "\" & InProduct & "_" & inParentGeo & "_" & inGeo & ".pptx"
    End If
    ppt.Close
        
    Inrs.Close
    Set Inrs = Nothing
    
    Set ppt = Nothing

End Sub


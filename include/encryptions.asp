<% 
' http://www.devx.com/vb2themax/Tip/19404 pour VBSCRIPT
'http://stackoverflow.com/questions/240713/how-can-i-encrypt-a-querystring-in-asp-net pour ASP.NET
'http://www.devcity.net/Articles/47/1/encrypt_querystring.aspx

' These two VBScript routines can be use to encrypt data passed on the 
' querystring, so that users can't decode what is being passed between ASP pages.

' USE:  sField = Decode(request.querystring(encode("sParm")))
'       Link = encode("Cdc=" & Cdc & "&Choix_Enr=" & 1) 

Function Decode(sIn)
    dim x, y, abfrom, abto
    Decode="": ABFrom = ""

    For x = 0 To 25: ABFrom = ABFrom & Chr(65 + x): Next 
    For x = 0 To 25: ABFrom = ABFrom & Chr(97 + x): Next 
    For x = 0 To 9: ABFrom = ABFrom & CStr(x): Next 

    abto = Mid(abfrom, 14, Len(abfrom) - 13) & Left(abfrom, 13)
    For x=1 to Len(sin): y=InStr(abto, Mid(sin, x, 1))
        If y = 0 then
            Decode = Decode & Mid(sin, x, 1)
        Else
            Decode = Decode & Mid(abfrom, y, 1)
        End If
    Next
End Function

' USE: location.href="nextpage.asp?" & encode("sParm=" & sData)

Function Encode(sIn)
    dim x, y, abfrom, abto
    Encode="": ABFrom = ""

    For x = 0 To 25: ABFrom = ABFrom & Chr(65 + x): Next 
    For x = 0 To 25: ABFrom = ABFrom & Chr(97 + x): Next 
    For x = 0 To 9: ABFrom = ABFrom & CStr(x): Next 

    abto = Mid(abfrom, 14, Len(abfrom) - 13) & Left(abfrom, 13)
    For x=1 to Len(sin): y = InStr(abfrom, Mid(sin, x, 1))
        If y = 0 Then
             Encode = Encode & Mid(sin, x, 1)
        Else
             Encode = Encode & Mid(abto, y, 1)
        End If
    Next
End Function 
%> 



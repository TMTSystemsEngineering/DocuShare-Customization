<%@ include file="ds_login.jsp" %>
<%@ include file="/jsp/common/start.jsp" %>
<% int tmtCurrentPageHightlightIndex = 2;
String pageTitle = "Add Document";
%>
<%@ include file="docushare_header.jsp" %>

<%!
public String escapeSingleQuotes(String text)
{
    StringBuffer sb = null;
    try
    {
        int pos = 0;
        if(text != null)
        {
            sb = new StringBuffer(text);
            while(sb.indexOf("'", pos) != -1)
            {
                pos = sb.indexOf("'", pos);
                sb.replace(pos, (pos+1), "&#146;");
                if(pos+1 < sb.length())
                  ++pos;
                //System.out.println("Pos :"+pos+"  St :"+sb.toString());
            }

            pos = 0;

            while(sb.indexOf("\"", pos) != -1)
            {
                pos = sb.indexOf("\"", pos);
                sb.replace(pos, (pos+1), "&#147;");
                if(pos+1 < sb.length())
                  ++pos;
                //System.out.println("Pos :"+pos+"  St :"+sb.toString());
            }
        }
    }
    catch(Exception ex)
    {
        ex.printStackTrace();
    }
    return sb != null ? sb.toString() : "";
}
%>

<%
String dcn = null;
String dcni = null;
String documentTitle = "";

Vector errorVec = null;
boolean requestSubmitted = false;

String selected = "";

Connection con = null;
Statement stmt = null;
String query = null;
ResultSet rs = null;

Vector dcns = null;
Vector vec = null;

try
{
	dcni = request.getParameter("dcni");
	if (dcni != null && dcni.trim().length() == 0) dcni = null;
	
	String showAll = request.getParameter("show_all_dcns");
	
	if (dcni != null)
	{
		/*System.out.println("dcni=" + dcni);*/
		query = "select id, title, dcn, keywords from tmt_dcn_issued where id = " + Integer.parseInt(dcni); // use parseInt() to shield from SQL injection
	} else
	if (showAll != null && showAll.trim().equals("show_all_dcns"))
	{
		query = "select id, title, dcn, keywords from tmt_dcn_issued where ds_doc_handle is NULL";
	} else
	{
		query = "select id, title, dcn, keywords from tmt_dcn_issued where ds_user like '" + (user.getHandle().toExternalForm()).trim() + "' and ds_doc_handle is NULL";
	}

	/*System.out.println("Connecting to database...");*/
	con = com.waterware.db.DBServices.getConnection();
	stmt = con.createStatement();
	
	/*System.out.println("Executing query: " + query);*/
	rs = stmt.executeQuery(query);

	while(rs.next())
	{
		/*System.out.println("Got a result row for " + rs.getString("dcn"));*/
		if (dcns == null) dcns = new Vector();
		vec = new Vector();
		vec.addElement(new Integer(rs.getInt("id")));
		vec.addElement(escapeSingleQuotes(rs.getString("title")));
		vec.addElement(rs.getString("dcn"));
		vec.addElement(escapeSingleQuotes(rs.getString("keywords")));
		dcns.addElement(vec);
	}
	stmt.close();
	/*System.out.println("No more rows.");*/
}
catch(Exception ex)
{
	ex.printStackTrace();
}
finally
{
	try { if(con != null) com.waterware.db.DBServices.releaseConnection(con); } catch(Exception ex) {}
}
%>

<script type="text/javascript">

var dcns = [<%
		if(dcns != null && dcns.size() > 0)
		for(int i=0; i<dcns.size(); i++)
		{
			if(i>0) out.print(",");
			vec = (Vector)dcns.elementAt(i);
			out.print("["+((Integer)vec.elementAt(0)).intValue()+", '"+(String)vec.elementAt(1)+"', '"+(String)vec.elementAt(2)+"', '"+(String)vec.elementAt(3)+"']");
        }
%>];

function update() {
  	var val = <%= (dcni != null ? dcni : 0)%>;
	if (document.ApplyAddDocument.dcnSelect != null) val = document.ApplyAddDocument.dcnSelect.value;
	
  	if(val > 0)
  	{
		for (i=0; i<dcns.length; i++) {
			if(dcns[i][0] == val)
			{
				document.ApplyAddDocument.DCN.value = dcns[i][2];
				document.ApplyAddDocument.documentTitle.value = removeEscapeCharacters(dcns[i][1]);
				document.ApplyAddDocument.keywords.value = removeEscapeCharacters(dcns[i][3]);
				break;
			}
		}
	}
}

function removeEscapeCharacters(text)
{
    rExp = /&#146;/gi;
    text_new = text.replace(rExp, "'");

    rExp = /&#147;/gi;
    results = text_new.replace(rExp, "\"");

    return results;
}

function validateDocSection(frm)
{
  if (frm.dcnSelect != null && frm.dcnSelect.type == "select-one" &&  frm.dcnSelect.selectedIndex == 0) {
    alert ("Please select a document number for this Document.");
    frm.dcnSelect.focus();
    return false;
  }

  if (frm.DCN == null || frm.DCN.value.length == 0) {
    alert ("There is no document control number for this Document.");
    if (frm.DCN != null) frm.DCN.focus();
    return false;
  }

  if (frm.uploadedDocument == null || frm.uploadedDocument.value.length == 0) {
    alert ("Please provide a file for this Document Number.");
    frm.uploadedDocument.focus();
    return false;
  }

  val = frm.documentTitle.value;
  val = val.replace(/(^ +| +$)/, "");
  if (val.length == 0) {
    alert ("Please enter a title for this Document.");
	frm.documentTitle.focus();
    return false;
  }

  val = frm.max_versions.value;
  val = val.replace(/(^ +| +$)/, "");
  if (val.length == 0) {
    alert ("Please enter the maximum number of versions for this Document.");
    frm.max_versions.focus();
    return false;
  }

  if (frm.destinationCollection.value.length == 0) {
    alert ("Please select the destination collection where this document should be uploaded.");
    frm.destinationCollection.focus();
    return false;
  }
	
  // rename the uploadedDocument element to simply "document" (yes, this is a crazy thing to do. Blame Xerox...)
  frm.uploadedDocument.name = "document";
  // same thing for the "title" property (except this time blame WaterWare)
  frm.documentTitle.name = "title";
  
  frm.action = "/docushare/dsweb/ApplyAddDocument/" + frm.destinationCollection.value;
  frm.encoding='multipart/form-data';
  
  return true;
}

function showHide(id){
  if (document.getElementById){
	var obj = document.getElementById(id);
	if (obj.style.display == "none"){
    	obj.style.display = "";
	} else {
    	obj.style.display = "none";
	}
  }
}

function showSequenceSpan(pass) {
  var spans = document.getElementsByTagName('span');
  //alert("spans = " + spans.length);

  //for select list use this.
  //var val = document.ApplyAddDocument.doc_or_version.value;

  //for radio buttons use this.
  if(!document.ApplyAddDocument.doc_or_version)
	return;

  if(document.ApplyAddDocument.doc_or_version[0].checked == true)
    val = 1;
  else if(document.ApplyAddDocument.doc_or_version[1].checked == true)
    val = 2;
  //alert(val);

  for (i=0; i<spans.length; i++) {
    if (spans[i].id.indexOf(pass, 0) != -1) {
        if (document.getElementById) {
            if(val == 2){
            //if (spans[i].style.display == "none"){
                spans[i].style.display = "";
            } else {
                spans[i].style.display = "none";
            }
        }
    }
  }
}

</script>
<A name="header"/>
<blockquote>
<span class="tmttitle">Add Document</span>
    
	  <form name="ApplyAddDocument" method="POST" action="addDocument.jsp">
    <table class="dialogbody" border="0" cellpadding="3" cellspacing="0" width="100%">
	<tbody>

<%
	if (errorVec != null && errorVec.size() > 0) {
		out.println("<tr><td colspan=2>The following errors occured:</td></tr><tr><td colspan=2>");
		for (int x=0; x < errorVec.size(); x++) {
		  out.println("<ul><font color='red'>" + errorVec.elementAt(x) + "</font></ul>");
		}
		out.println("</td></tr>");
	}
%>
	<!-- Things needed by the DocuShare add mechanism -->
	<input style="display:none;" type="radio" name="source" value="localFile" checked="checked" />
	<input name="class" type="hidden" value="Document">
<%
if (dcni == null)
{
%>
	<tr>
		<td align="right" valign="top" width="25%">
		 	<span style="display: ;" id="pick_dcn">
				<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Pick a DCN&help=Select a DCN from the picklist. Once the document is uploaded the DCN will be set as the summary property.&locale=en')" class="fieldname" target="_parent">Pick a Document Number:</a></font>
			</span>
		</td>
		<td width="75%">
	 	<span style="display: ;" id="pick_dcn">
			<select name="dcnSelect" onChange="update();">
				<option value="0">-Select-</option>
				<%
				if(dcns != null && dcns.size() > 0)
				{
					for(int i=0; i<dcns.size(); i++)
					{
						vec = (Vector)dcns.elementAt(i);
						out.print("<option value=\""+((Integer)vec.elementAt(0)).intValue()+"\">"+(String)vec.elementAt(2)+" - "+(String)vec.elementAt(1)+"</option>");
					}
				}
				%>
			</select>

			<%
			if(principal.isAdmin(DSLoginPrincipal.ANY_ADMIN))
			{
			%>
			<br/>
			<input type="checkbox" name="show_all_dcns" value="show_all_dcns"
			<%=request.getParameter("show_all_dcns") != null && request.getParameter("show_all_dcns").trim().equalsIgnoreCase("show_all_dcns") ? "CHECKED" : ""%>
				onclick="this.form.action='addDocument.jsp'; this.form.encoding='application/x-www-form-urlencoded'; this.form.submit();">Show all DCNs<br/><br/>
			<%
			}
			%>
	 	</span>
		</td>
	</tr>
<%
}

%>

   	<tr>
	    <td align=right width="25%">
	        <a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Filename&help=The complete path and filename of the document you want to upload. You can click the Browse button to navigate to and select the document.&locale=en')" class="fieldname" target="_parent">Filename:</a><br/><small>(required)</small>
		</td>
		<td width="75%">
	        <input type="file" name="uploadedDocument" size="40">
		</td>
	</tr>

   	<tr>
	    <td align="right">
	        <a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Title&help=The title of the object. The title should be short, but descriptive, and can contain spaces and punctuation marks.')" class="fieldname" target="_parent">Title:</a><br/><small>(required)</small>
		</td>

		<td valign="top">
	        <input type="text" name="documentTitle" size="60" value="<%=(request.getParameter("documentTitle") != null ? request.getParameter("documentTitle") : "")%>">
		</td>
	</tr>

	<tr>
	    <td align="right">
	        <a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Document Control Number&help=The document control number (DCN) of the document. This is the Document Number you created earlier. The document control number appears below the document's title.')" class="fieldname" target="_parent">Document&nbsp;Control&nbsp;Number:</a><br/><small>(required)</small>
		</td>

		<td valign="top">
	        <input type="text" size=40 name="DCN" value="<%=dcn != null ? dcn : ""%>" />
		</td>
	</tr>
	
   	<tr>
	    <td align="right">
	        <a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Summary&help=The summary of the document. The summary appears below the document's control number and title.')" class="fieldname" target="_parent">Summary:</a>
		</td>

		<td>
	        <input type="text" size=40 name="summary" value=""/>
		</td>
	</tr>

    <tr>
		<td align="right">
	        <a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Description&help=A detailed description of the object. You can include HTML tags in the object\'s description. For container objects, the description appears below the title.')" class="fieldname" target="_parent">Description:</a>
		</td>
		<td>
	        <textarea name='description' wrap='soft' rows='4' cols='60'><%=(request.getParameter("description") != null ? request.getParameter("description") : "")%></textarea>
		</td>
	</tr>

    <tr>
		<td align="right">
	        <a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Keywords&help=One or more words to associate with the object. Keywords help to categorize objects and can be used to find objects in a search. Separate keywords with a comma.')" class="fieldname" target="_parent">Keywords:</a>
		</td>

		<td>
	        <input name='keywords' type='text' size=60 maxlength=1024 value='<%=(request.getParameter("keywords") != null ? request.getParameter("keywords") : "")%>'/>
		</td>
	</tr>

    <tr>
		<td align='right' valign='top'>
	        <a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Expiration Date&help=The date on which the object is no longer needed. You can search for expired objects and delete or archive them.')" class="fieldname" target="_parent">Expiration Date:</a>
		</td>
		<td>
	        <input name='expiration_date' type='text' value='' tabindex='1' /><a href="javascript:show_calendar('ApplyAddDocument.expiration_date','MM/dd/yyyy','/docushare/')"><img src="/docushare/images/calendar.gif" border="0" ALT="Calendar Chooser" TITLE="Calendar Chooser"/></a>
			<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Date Format&help=Enter the date using one of these formats:<UL><LI>mm/dd/yyyy (for example, 12/6/2002)<LI>mm/dd/yy (for example, 12/6/02)<LI>mm/dd/yyyy hh:mm:ss am/pm (for example, 12/6/2002 2:01:00 pm)<LI>mm/dd/yyyy HH:mm:ss (a 24 hour clock example, 12/6/2002 14:01:00)</LI></UL>')" class="fieldvalue" target="_parent">mm/dd/yyyy</a>
		</td>
	</tr>

    <tr>
		<td align='right' valign='top'>
	        <a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Max Versions&help=The maximum number of versions to save. When a new version of a document is added to DocuShare, the oldest version is deleted.')" class="fieldname" target="_parent">Max Versions:</a><br/><small>(required)</small>
		</td>
		<td valign="top">
			<input name='max_versions' type='text' size='10' value='100' tabindex='1' />
		</td>
	</tr>

    <tr>
		<td align='right' valign='top'>
			<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Author&help=The document\'s author or authors. An author can be someone other than the document\'s owner.')" class="fieldname" target="_parent">Author:</a>
		</td>
		<td>
			<input name='author' type='text' size=60 maxlength=128 value='' tabindex='1' />
		</td>
	</tr>

	<tr>
		<td align="right">
			<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Keywords&help=This is the collection where the document will be uploaded.')" class="fieldname" target="_parent">Destination Collection:</a><br/><small>(required)</small>
        </td>
		<td>
			<input type="text" size=20 name="destinationCollection" value="<%=(request.getParameter("destinationCollection") != null ? request.getParameter("destinationCollection") : "")%>" onfocus="blur();" />
			<input type="button" name=PickCollection value="Pick a Collection..." onclick='popup("pickDestinationCollection.jsp");'/>
		</td>
	</tr>

	<tr>
		<td align="right">
			<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Initial Permissions&help=The access permissions assigned to the new object: <UL><LI><b>Same as container</b> assigns the container\'s access permissions to the object. <LI><b>Same as container except write restricted to owner</b> assigns the users who have Reader access to the container with Reader access to the object. You are the only user with Writer access to the object. <LI><b>Restricted to owner</b> assigns full access permissions only to you, the object\'s owner.</LI></UL>&locale=en')" class="fieldname" target="_parent">Initial Permissions:</a>
		</td>
		<TD>
	    	<INPUT TYPE="radio" NAME="inherit" VALUE="yes" <%=(request.getParameter("inherit") != null && request.getParameter("inherit").trim().equalsIgnoreCase("yes") ? "CHECKED" : (request.getParameter("inherit") == null ? "CHECKED" : ""))%> tabindex="1"><font class="fieldvalue">Same as container</font></INPUT><br />
		    <INPUT TYPE="radio" NAME="inherit" VALUE="restrictWrite" <%=(request.getParameter("inherit") != null && request.getParameter("inherit").trim().equalsIgnoreCase("restrictWrite") ? "CHECKED" : "")%> tabindex="1"><font class="fieldvalue">Same as container except write restricted to owner</font></INPUT><br />
		    <INPUT TYPE="radio" NAME="inherit" VALUE="owner" <%=(request.getParameter("inherit") != null && request.getParameter("inherit").trim().equalsIgnoreCase("owner") ? "CHECKED" : "")%> tabindex="1"><font class="fieldvalue">Restricted to owner</font></INPUT>
		</TD>
	</tr>

	<tr><td width=15%><span style="display: none;" id="add_document">&nbsp;</span></td><td width=85%><span style="display: none;" id="add_document">&nbsp;</span></td></tr>

	<tr>
		<td colspan=2 align=center>
  			<input type="submit" name="submitbutton" value="Add Document" tabindex="1"
				onclick="return validateDocSection(this.form);">
				&nbsp;&nbsp;&nbsp;&nbsp;
			<input name="reset" value="Reset" tabindex="1" type="reset">
		</td>
	</tr>

	</tbody>
	</table>
<!-- BEGIN: Restrict uploading of .ZIP files -->
<script type="text/javascript">
(document.getElementsByName('uploadedDocument')[0]).onchange = function(e){
    var ext = this.value.match(/\.([^\.]+)$/)[1];
    switch(ext.toLowerCase())
    {
        case 'zip':
        case '7z':
        case 'tar':
        case 'arj':
        case 'gz':
        case 'rar':
        case 'tgz':
        case 'gzip':
        case 'sitz':
        case 'lhz':
            alert('Tar, ZIP, and other archive files are no longer allowed.');
            this.value='';
            break;

        case 'bat':
        case 'bin':
        case 'com':
        case 'exe':
            alert('Executable files are no longer allowed.');
            this.value='';
            break;

        default:
            break;
    }
};
</script>
<!-- END: Restrict uploading of .ZIP files -->
	</form>
	</blockquote>
</body>
</html>
<%@ include file="/jsp/common/end.jsp" %>

<script type="text/javascript">
	//showAddDocumentSpanNew('add_document');
	update();
    var new_win = null;
    function popup(url)
    {
		var top = window.screenTop + 100;
				
		var left = window.screenLeft + 100
        new_win = window.open(url, "New", "width=600,height=700,resizable,scrollbars=yes,status=yes,top=" + top + ",left=" + left);
		
		new_win.moveTo(left, top);
    }
</script>

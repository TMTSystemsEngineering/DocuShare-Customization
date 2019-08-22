<%
/**
 * <p>Title: IssueDCN.jsp</p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: WaterWare Internet Services</p>
 * @author Naveen G
 * @version 1.0
 */
%>

<%@ include file="ds_login.jsp" %>
<%@ include file="/jsp/common/start.jsp" %>
<%

  Hashtable telescopesLookup = DCNManagement.getTelescopesLookup();
  Hashtable documentTypesLookup = DCNManagement.getDocumentTypesLookup();
  Hashtable groupCategoriesLookup = DCNManagement.getGroupCategoriesLookup();
  Vector yearsLookup = DCNManagement.getYearsLookup();
  Hashtable documentVersionsLookup = DCNManagement.getDocumentVersionsLookup();

  Vector errorVec = null;
  boolean requestSubmitted = false;
  String createdAwardNo = "";
  String createdFundingNo = "";
  int id = 0;

  String telescope = (request.getParameter("telescope") != null ? request.getParameter("telescope") : "");
  String groupCategory = (request.getParameter("groupCategory") != null ? request.getParameter("groupCategory") : (String)user.get("Group"));
  String documentType = (request.getParameter("documentType") != null ? request.getParameter("documentType") : "");
  String year = (request.getParameter("year") != null ? request.getParameter("year") : "");
  String documentVersion = (request.getParameter("documentVersion") != null ? request.getParameter("documentVersion") : "");
  String title = (request.getParameter("title") != null ? request.getParameter("title") : "");
  String owner = (request.getParameter("owner") != null ? request.getParameter("owner") : user.getHandle().toExternalForm());
  String keywords = (request.getParameter("keywords") != null ? request.getParameter("keywords") : "");
  String docVerType = (request.getParameter("doc_or_version") != null ? request.getParameter("doc_or_version") : "");
  String versionSeq = (request.getParameter("version_sequence") != null ? request.getParameter("version_sequence") : "");
  boolean showAllUsers = (request.getParameter("showAllUsers") != null);

  if (request.getParameter("btnSubmit") != null) {
    // reserve the DCN in the db.
    boolean wasReserved = false;

    try {
      id = DCNManagement.reserveDocumentNumber(request, dssession);
      System.out.println("IssueDCN.jsp : ID :"+id+"  Author :"+owner);
          if(id > 0)
          {
                wasReserved = true;
                if(title != null && title.length() == 0)
                {

                }
          }
    }
    catch (Exception dse) {
    }


    if (!wasReserved) {
      HttpSession hs = request.getSession();
      errorVec = (Vector)hs.getAttribute("DCN_Errors");
          //errorVec.addElement("Reserve DCN Failed");
    }
    else {
      response.sendRedirect("DCNSuccess.jsp?dcni="+id);
      return;
    }
  }
%>

<% int tmtCurrentPageHightlightIndex = 1;
String pageTitle = "Issue Document Number";
%>
<%@ include file="docushare_header.jsp" %>

<script type="text/javascript">
function validateForm(frm) {

  if (frm.title.value.length == 0) {
    alert ("Please enter the title for this Document.");
    frm.title.focus();
    return false;
  }

  if (frm.owner.selectedIndex == 0) {
    alert ("Please select the owner of this Document.");
    frm.owner.focus();
    return false;
  }

  if (frm.doc_or_version.selectedIndex == 0) {
    alert ("Please select the type of this document.");
    frm.doc_or_version.focus();
    return false;
  }

  if (frm.doc_or_version.selectedIndex == 2) {
        if (frm.version_sequence.value.length == 0) {
      alert ("Please enter the sequence number for this version.");
      frm.version_sequence.focus();
      return false;
        }
  }

  if (frm.telescope.selectedIndex == 0) {
    alert ("Please select a telescope.");
    frm.telescope.focus();
    return false;
  }

  if (frm.groupCategory.selectedIndex == 0) {
    alert ("Please select the Group Category.");
    frm.groupCategory.focus();
    return false;
  }

  if (frm.documentType.selectedIndex == 0) {
    alert ("Please select the Document Type.");
    frm.documentType.focus();
    return false;
  }

  if (frm.year.selectedIndex == 0) {
    alert ("Please select the Year.");
    frm.year.focus();
    return false;
  }

  if (frm.documentVersion.selectedIndex == 0) {
    alert ("Please select the Document Version.");
    frm.documentVersion.focus();
    return false;
  }

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

function showSpan(pass) {
  var spans = document.getElementsByTagName('span');
  //alert("spans = " + spans.length);

  //for select list use this.
  //var val = document.issueDCN.doc_or_version.value;

  //for radio buttons use this.
  if(document.issueDCN.doc_or_version[0].checked == true)
        val = 1;
  else if(document.issueDCN.doc_or_version[1].checked == true)
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

<blockquote>
<p/>
<span class="tmttitle">Issue a Document Control Number</span>
<p/>
<%
  if (errorVec != null && errorVec.size() > 0) {
    out.println("The following errors occured:");
    for (int x=0; x < errorVec.size(); x++) {
      out.println("<ul><font color='red'>" + errorVec.elementAt(x) + "</font></ul>");
    }
  }
%>
<form name="issueDCN" method="POST" action="IssueDCN.jsp" onSubmit="return validateForm(this)">
<table cellpadding="3">
	<tr>
		<td align=right>
			<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Title&help=The title of the object. The title should be short, but descriptive, and can contain spaces and punctuation marks.')" class="fieldname" target="_parent">Title:</a>
		</td>
		<td>
			<input name="title" size="60" tabindex="1" />
		</td>
	</tr>

	<tr>
		<td align="right" valign="top">
			<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Owner&help=Pick the owner for this document.&locale=en')" class="fieldname" target="_parent">Owner:</a></font></td>
		</td>
		<td>
			<select name="owner">
				<option value="">-- Select --</option>
				<%
				try
				{
					DSObjectIterator iter = dssession.instances(DSUser.classname, DSSelectSet.ALL_PROPERTIES);
					ArrayList list = new ArrayList(iter.size());
					while(iter.hasNext())
					{
						DSUser user = (DSUser)iter.nextObject();
						String handle = user.getHandle().toExternalForm().trim();
						if (handle.equalsIgnoreCase("User-1")) continue;
						
						if (user.getIsActive() || showAllUsers)
						{
							list.add (user.getFirstName().trim() + " " + user.getLastName().trim() + "::" + handle);
						}
					}
					
					Collections.sort(list, new StringComparator());
					
					for (int i=0; i<list.size(); i++) {
						String item = (String) list.get(i);
						String usrHandle = item.substring(item.indexOf("::")+2).trim();
						String name = item.substring(0, item.indexOf("::")).trim();
						%>
						<option value="<%= usrHandle%>" <%= owner.equalsIgnoreCase(usrHandle) ? "SELECTED" : "" %>><%= name %></option>
						<%
					}
				}
				catch(Exception ex)
				{
					ex.printStackTrace();
				}
				%>
			</select><br/><input type="checkbox" name="showAllUsers" <%= (showAllUsers ? "CHECKED" : "") %> onclick="submit()" />Show all users
		</td>
	</tr>
	<tr>
		<td align=right>
			<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Keywords&help=One or more words to associate with the object. Keywords help to categorize objects and can be used to find objects in a search. Separate keywords with a comma.')" class="fieldname" target="_parent">Keywords:</a>
		</td>
		<td>
			<input type="text" name="keywords" size="60" value="<%= keywords %>" />
		</td>
	</tr>

	<!-- included for historical reasons (vestigial) -->
    <input style="display:none;" type=radio name="doc_or_version" value="1" onClick="showSpan('version_sequence');" <%= docVerType != null && docVerType.trim().length() == 0 ? "CHECKED" : (docVerType != null && docVerType.trim().equals("1") ? "CHECKED" : "") %> />
    <input style="display:none;" type=radio name="doc_or_version" value="2" onClick="showSpan('version_sequence');" <%= (docVerType != null && docVerType.trim().equals("2") ? "CHECKED" : "") %> />
    <input style="display:none;" name="version_sequence" value="<%=versionSeq%>" size="10" tabindex="1" />

	<!-- Telescopes -->
	<tr>
		<td align=right>
			<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Telescope&help=Pick the Telescope type.&locale=en')" class="fieldname" target="_parent">Telescope:</a></font>
		</td>
		<td>
			<select name="telescope">
			<option value="">-- Select --</option>
			<%
			Object[] types = telescopesLookup.keySet().toArray();
			if (types.length == 1) 
			{
				String keyname = (String) types[0];
				String keyvalue = (String) telescopesLookup.get(keyname); 
				%>
				<option value="<%= keyname %>" SELECTED><%= keyvalue != null && keyvalue.trim().length() > 0 ? keyvalue : keyname %></option>
				<%
			} else
			{
				Arrays.sort(types);
				for (int x=0; x < types.length; x++) {
					String keyname = (String) types[x];
					String keyvalue = (String) telescopesLookup.get(keyname);
					%>
					<option value="<%= keyname %>" <%= telescope.equals(keyname) ? "SELECTED" : "" %>><%= keyvalue != null && keyvalue.trim().length() > 0 ? keyvalue : keyname %></option>
					<%
				}
				
			}
			%>
			</select>
		</td>
	</tr>

	<!-- Group Categories -->
	<tr>
		<td align="right">
			<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Group Category&help=Pick the Group Category.&locale=en')" class="fieldname" target="_parent">Group Category:</a></font>
		</td>
		<td>
			<select name="groupCategory">
			<option value="">-- Select --</option>
			<%

			types = groupCategoriesLookup.keySet().toArray();
			Arrays.sort(types);
			for (int x=0; x < types.length; x++) {
				String keyname = (String) types[x];
				String keyvalue = (String) groupCategoriesLookup.get(keyname);
				%>
				<option value="<%= keyname %>" <%= groupCategory != null && groupCategory.equals(keyname) ? "SELECTED" : "" %>><%= keyvalue != null && keyvalue.trim().length() > 0 ? keyvalue : keyname %></option>
				<%
			}

			%>
			</select>
		</td>
	</tr>

	<!-- Document Type -->
	<tr>
		<td align="right">
			<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Document Type&help=Pick the Document Type.&locale=en')" class="fieldname" target="_parent">Document Type:</a></font>
		</td>
		<td>
			<select name="documentType">
				<option value="">-- Select --</option>
				<%

				types = documentTypesLookup.keySet().toArray();
				Arrays.sort(types);
				for (int x=0; x < types.length; x++) {
					String keyname = (String) types[x];
					String keyvalue = (String) documentTypesLookup.get(keyname);
					%>
					<option value="<%= keyname %>" <%= documentType.equals(keyname) ? "SELECTED" : "" %>><%= keyvalue != null && keyvalue.trim().length() > 0 ? keyvalue : keyname %></option>
					<%
				}

				%>
			</select>
		</td>
	</tr>

	<!-- Year -->
	<tr>
	<td align="right">
		<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Originating Year&help=Pick the Originating Year.&locale=en')" class="fieldname" target="_parent">Originating Year:</a></font>
	</td>
	<td>
		<select name="year">
			<option value="">-- Select --</option>
			<%
			Calendar cal = Calendar.getInstance();
			String currentYear = String.valueOf(cal.get(Calendar.YEAR));
			for (int x=0; x < yearsLookup.size(); x++) {
				String keyname = (String) yearsLookup.elementAt(x);
				%>
				<option value="<%= keyname %>" <%= year != null && year.trim().length() == 0 && keyname.equals(currentYear) ? "SELECTED" : (year != null && year.trim().length() > 0 && year.equals(keyname) ? "SELECTED" : "") %>><%= keyname %></option>
				<%
			}

			%>
		</select>
	</td>
	</tr>

	<!-- Document Versions -->
	<tr>
		<td>
			<a href="javascript:openHelpTextWindow('/docushare/jsp/common/PropHelp.jsp?label=Document Version&help=Pick Draft or Release depending on the type of document.&locale=en')" class="fieldname" target="_parent">Document Version:</a></font>
		</td>
		<td>
			<%
			
			types = documentVersionsLookup.keySet().toArray();
			Arrays.sort(types);
			for (int x=0; x < types.length; x++) {
				String keyname = (String) types[x];
				String keyvalue = (String) documentVersionsLookup.get(keyname);
				%>
				<input type=radio name="documentVersion" value="<%=keyname%>" 
				<%= documentVersion != null && documentVersion.trim().length() == 0 && keyname.trim().equals("DRF") ? "CHECKED" : (documentVersion != null && documentVersion.trim().length() > 0 && documentVersion.equals(keyname) ? "CHECKED" : "") %> /><%= keyvalue != null && keyvalue.trim().length() > 0 ? keyvalue : keyname %>
				<br/>
				<%
			}

			%>
		</td>
	</tr>

  <tr><td>&nbsp;</td></tr>
  <tr>
    <td colspan=2 align=center>
      <input type="submit" name="btnSubmit" value="Submit">&nbsp;&nbsp;&nbsp;<input type="reset" name="reset" value="Reset">
    </td>
  </tr>
</table>
</form>

</blockquote>
<br/>

<!-- footer -->
</td></tr></table>

</center>


</body>
</html>
<%@ include file="/jsp/common/end.jsp" %>

<script type="text/javascript">
        showSpan('version_sequence');
</script>

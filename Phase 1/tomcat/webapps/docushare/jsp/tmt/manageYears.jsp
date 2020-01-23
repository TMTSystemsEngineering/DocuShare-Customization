<%
/**
 * <p>Title: manageYears.jsp</p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: WaterWare Internet Services</p>
 * @author Naveen G
 * @version 1.0
 */
%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="com.xerox.docushare.*"%>
<%@ page import="com.xerox.docushare.object.*"%>
<%@ page import="com.xerox.docushare.property.*"%>
<%@ page import="edu.caltech.docushare.*"%>
<%
java.sql.Connection con = null;
java.sql.Statement stmt = null;
ResultSet rs = null;
String sql = null;
Vector years = new Vector();

boolean success = true;
String msgString = "";

String btnSubmit = request.getParameter("btnSubmit");
String year = "";

if (btnSubmit != null && "Add".equals(btnSubmit)) {
  success = PicklistManager.addYear(request);
  if (success) {
    msgString = "Year <b>" + request.getParameter("year") + "</b> added successfully";
  }
  else {
    msgString = (String) request.getAttribute("ADMIN_YEAR_ERROR");
  }
}

if (btnSubmit != null && "Delete".equals(btnSubmit)) {
  success = PicklistManager.deleteYear(request);
  if (success) {
    msgString = request.getParameter("year") + " deleted";
  }
  else {
    msgString = (String) request.getAttribute("ADMIN_YEAR_ERROR");
  }
}

if (!success) {
 year = request.getParameter("year");
}

try {
  con = com.waterware.db.DBServices.getConnection();
  stmt = con.createStatement();
  sql = "select * from tmt_year order by year";
  rs = stmt.executeQuery(sql);

  while (rs.next()) {
    Hashtable hash = new Hashtable(10);
    String n = rs.getString("year").trim();
    hash.put("year", n);

    years.addElement(hash);
  }
  rs.close();
  stmt.close();
}
catch (Exception ex) {
  System.out.println("Exception ex in manageYears.jsp: " + ex);
  ex.printStackTrace(new PrintWriter(out));
  return;
}
finally {
  if (con != null)
    com.waterware.db.DBServices.releaseConnection(con);
}
%>

<%@ include file="ds_login.jsp" %>
<%@ include file="/jsp/common/start.jsp" %>
<%
int tmtCurrentPageHightlightIndex = 8;
String pageTitle = "Years Picklist Management";
%>
<%@ include file="docushare_header.jsp" %>
<%
	if(!principal.isAdmin(DSLoginPrincipal.ANY_ADMIN))
	{
      response.sendRedirect("index.jsp");
      return;
	}
%>


<link rel="stylesheet" href="/docushare/docushare.css" type="text/css">
<link rel="stylesheet" href="/docushare/jsp/tmt/tmt.css" type="text/css">

<script language="Javascript">
function addOption(oEditable, oCombo) {
  if (oEditable.value != "") {
    //First search for duplicates
    for (var i = 0; i < oCombo.options.length ; i++){
      if (oCombo.options[i].text == oEditable.value)
        return;
    }
    // Add new one
    oCombo.options[oCombo.options.length] = new Option (oEditable.value, oEditable.value);
  }
}

function populateForm(vIndex) {
  acctx = types[vIndex];
  document.manager.year.value = acctx.year;
}

function setUpdate() {
  document.manager.year.readOnly = true;
  document.manager.btnSubmit.value="Update";
  document.manager.btnClear.value="Cancel";
  document.getElementById("msgtxt").innerHTML = "<font color=green>Make your changes and click on \"Update\"</font>";
  document.getElementById("msgtxt1").innerHTML = "";
}

function setDelete() {
  document.manager.year.readOnly = true;
  document.manager.btnSubmit.value="Delete";
  document.manager.btnClear.value="Cancel";
  document.getElementById("msgtxt").innerHTML = "<font color=red>Are you sure you want to delete this record?</font>";
  document.getElementById("msgtxt1").innerHTML = "";
}

function clearForm(frm) {
  frm.year.readOnly = false;
  frm.description.readOnly = false;

  frm.year.value = "";

  frm.btnClear.value="Clear";
  frm.btnSubmit.value="Add";
  document.getElementById("msgtxt").innerHTML = "";
  document.getElementById("msgtxt1").innerHTML = "";

}


function validateForm(frm) {
  if (frm.year.value == "") {
    alert("Please enter a three letter abbreviation of the Telescope.");
    frm.year.focus();
    return false;
  }

  return true;
}

var types = new Array();
<%
  int size = years.size();
  for (int x=0; x < size; x++) {
    Hashtable hash = (Hashtable) years.elementAt(x);
    String t1 = (String) hash.get("year");

      out.println("types["+x+"] = new Array();");
      out.println("types["+x+"].year = '" + t1 + "';");
  }
%>
</script>

<h1>TMT Project Picklist Management</h1>
<p>
<span id="msgtxt1">
<%
  if (!success && msgString != null && !"".equals(msgString)) {
%>
    <b>An error occured.</b><br>
    <font color="red"><%= msgString %></font>
<%
  }
  else if (msgString != null && !"".equals(msgString)) {
%>
    <font color="green"><%= msgString %></font>
<%
  }
%>
</span>
<p>
<form name="manager" method="post" >
<table cellpadding="3">
<tr><td>Enter a new year to add. </td></tr>
</table>
<table cellpadding="3">
<tr>
  <td align="right"><b>Year (YYYY):</b></td>
  <td><input type="text" name="year" size="40" value="<%= year %>"></td>
</tr>
<tr><td colspan=2>&nbsp;<span id="msgtxt"></span></td></tr>
<tr><td colspan=2 align="center">
  <input type="submit" name="btnSubmit" value="Add" onClick="return validateForm(this.form)">&nbsp;
  <input type="button" name="btnClear" value="Clear" onClick="return clearForm(this.form)">&nbsp;
</td></tr>
</table>
<hr/>
<h1>Current Years</h1>
<table border="1" cellpadding="3" cellspacing="0">
<%
  if (size > 0) {
%>
  <tr>
    <th>links</th>
    <th>Year</th>
  </tr>
<%
  }
  else {
%>
  <tr>
    <th>No Years found in database</th>
  </tr>
<%
  }

  for (int x=0; x < size; x++) {
    Hashtable hash = (Hashtable) years.elementAt(x);
    String t1 = (String) hash.get("year");
%>
    <tr>
      <td><font size="-1">
          <a href="#" onclick="populateForm(<%= x %>); setDelete();">delete</a>
          </font>
      </td>
      <td nowrap><%=(t1 == null || t1.trim().length() == 0 ? "&nbsp;" : t1)%></td>
    </tr>
<%
  }
%>
</table>
</form>
<p>
</blockquote>

<!-- footer -->
</td></tr></table>
</center>
</body>
</html>
<%@ include file="/jsp/common/end.jsp" %>

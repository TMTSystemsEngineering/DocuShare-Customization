<%
/**
 * <p>Title: manageTelescopes.jsp</p>
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
Vector telescopeTypes = new Vector();

boolean success = true;
String msgString = "";

String btnSubmit = request.getParameter("btnSubmit");
String name = "";
String desc = "";

if (btnSubmit != null && "Add".equals(btnSubmit)) {
  success = PicklistManager.addTelescope(request);
  if (success) {
    msgString = "Telescope <b>" + request.getParameter("name") + "</b> added successfully";
  }
  else {
    msgString = (String) request.getAttribute("ADMIN_TELESCOPE_ERROR");
  }
}

if (btnSubmit != null && "Delete".equals(btnSubmit)) {
  success = PicklistManager.deleteTelescope(request);
  if (success) {
    msgString = request.getParameter("name") + " deleted";
  }
  else {
    msgString = (String) request.getAttribute("ADMIN_TELESCOPE_ERROR");
  }
}

if (btnSubmit != null && "Update".equals(btnSubmit)) {
  success = PicklistManager.updateTelescope(request);
  if (success) {
    msgString = request.getParameter("name") + " updated";
  }
  else {
    msgString = (String) request.getAttribute("ADMIN_TELESCOPE_ERROR");
  }
}

if (!success) {
 name = request.getParameter("name");
 desc = request.getParameter("description");
}

try {
  con = com.waterware.db.DBServices.getConnection();
  stmt = con.createStatement();
  sql = "select * from tmt_telescopes order by sequence";
  rs = stmt.executeQuery(sql);

  while (rs.next()) {
    Hashtable hash = new Hashtable(10);
    String n = rs.getString("name").trim();
    String d = rs.getString("description") != null ? rs.getString("description").trim() : "";
    String sequence = ""+rs.getInt("sequence");

    hash.put("name", n);
    hash.put("description", d);
    hash.put("sequence", sequence);

    telescopeTypes.addElement(hash);
  }
  rs.close();
  stmt.close();
}
catch (Exception ex) {
  System.out.println("Exception ex in manageTelescopes.jsp: " + ex);
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
int tmtCurrentPageHightlightIndex = 5;
String pageTitle = "Telescopes Picklist Management";
%>
<%@ include file="docushare_header.jsp" %>

<%
	if(!principal.isAdmin(DSLoginPrincipal.ANY_ADMIN))
	{
      response.sendRedirect("index.jsp");
      return;
	}
%>

<link rel="stylesheet" href="http://www.caltech.edu/aux/main.css" type="text/css">

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
  document.manager.name.value = acctx.name;
  document.manager.description.value = acctx.description;
}

function setUpdate() {
  document.manager.name.readOnly = true;
  document.manager.btnSubmit.value="Update";
  document.manager.btnClear.value="Cancel";
  document.getElementById("msgtxt").innerHTML = "<font color=green>Make your changes and click on \"Update\"</font>";
  document.getElementById("msgtxt1").innerHTML = "";
}

function setDelete() {
  document.manager.name.readOnly = true;
  document.manager.description.readOnly = true;
  document.manager.btnSubmit.value="Delete";
  document.manager.btnClear.value="Cancel";
  document.getElementById("msgtxt").innerHTML = "<font color=red>Are you sure you want to delete this record?</font>";
  document.getElementById("msgtxt1").innerHTML = "";
}

function clearForm(frm) {
  frm.name.readOnly = false;
  frm.description.readOnly = false;

  frm.name.value = "";
  frm.description.value = "";

  frm.btnClear.value="Clear";
  frm.btnSubmit.value="Add";
  document.getElementById("msgtxt").innerHTML = "";
  document.getElementById("msgtxt1").innerHTML = "";

}

function validateForm(frm) {
  if (frm.name.value == "") {
    alert("Please enter a three letter abbreviation of the Telescope.");
    frm.name.focus();
    return false;
  }

  if (frm.description.value == "") {
    alert("Please enter a Description for the Telescope.");
    frm.description.focus();
    return false;
  }

  return true;
}

var types = new Array();
<%
  int size = telescopeTypes.size();
  for (int x=0; x < size; x++) {
    Hashtable hash = (Hashtable) telescopeTypes.elementAt(x);
    String t1 = (String) hash.get("name");
    String t2 = (String) hash.get("description");

      out.println("types["+x+"] = new Array();");
      out.println("types["+x+"].name = '" + t1 + "';");
      out.println("types["+x+"].description = '" + t2 + "';");
  }
%>
</script>


<P>
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
<tr><td>Enter the information for a new Telescope to add. </td></tr>
</table>
<table cellpadding="3">
<tr>
  <td align="right"><b>Telescope Designation(3 letter):</b></td>
  <td><input type="text" name="name" size="40" value="<%= name %>"></td>
</tr>
<tr>
  <td align="right"><b>Telescope Description:</b></td>
  <td>
    <input type="text" name="description" size="40" value="<%= desc %>">
  </td>
</tr>
<tr><td colspan=2>&nbsp;<span id="msgtxt"></span></td></tr>
<tr><td colspan=2 align="center">
  <input type="submit" name="btnSubmit" value="Add" onClick="return validateForm(this.form)">&nbsp;
  <input type="button" name="btnClear" value="Clear" onClick="return clearForm(this.form)">&nbsp;
</td></tr>
</table>
<hr/>
<h1>Current Telescope Types</h1>
<table border="1" cellpadding="3" cellspacing="0">
<%
  if (size > 0) {
%>
  <tr>
    <th>links</th>
    <th>Designation</th>
    <th>Telescope Description</th>
  </tr>
<%
  }
  else {
%>
  <tr>
    <th>No Telescopes found in database</th>
  </tr>
<%
  }

  for (int x=0; x < size; x++) {
    Hashtable hash = (Hashtable) telescopeTypes.elementAt(x);
    String t1 = (String) hash.get("name");
    String t2 = (String) hash.get("description");
%>
    <tr>
      <td><font size="-1">
          <a href="#" onclick="populateForm(<%= x %>); setUpdate();">edit</a><br>
          <a href="#" onclick="populateForm(<%= x %>); setDelete();">delete</a>
          </font>
      </td>
      <td nowrap><%=(t1 == null || t1.trim().length() == 0 ? "&nbsp;" : t1)%></td>
      <td><%=(t2 == null || t2.trim().length() == 0 ? "&nbsp;" : t2)%></td>
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


<%
/**
 * <p>Title: index.jsp</p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: WaterWare Internet Services</p>
 * @author Naveen G
 * @version 1.0
 */
%>

<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="com.xerox.docushare.amber.util.MessageDB" %>
<%@ page import="com.xerox.docushare.*"%>
<%@ page import="com.xerox.docushare.amber.util.XSLTMessage" %>
<%@ page import="com.xerox.docushare.amber.error.RedirectionException" %>
<%@ page import="com.xerox.docushare.object.*"%>
<%@ page import="com.xerox.docushare.query.*"%>
<%@ page import="com.xerox.docushare.property.*"%>
<%@ page import="edu.caltech.docushare.*"%>

<%@ include file="ds_login.jsp" %>
<%@ include file="/jsp/common/start.jsp" %>
<% int tmtCurrentPageHightlightIndex = 4;
String pageTitle = "Administrator Home";
String jspFile = "index_admin.jsp";
%>
<%@ include file="docushare_header.jsp" %>

<%
    Connection con = null;
    Statement pstmt = null;
    ResultSet rs = null;

    String dcni = request.getParameter("dcni");
    if (dcni != null && dcni.trim().length() > 0)
    {
        dcni = "" + (Integer.parseInt(dcni)); // use parseInt() to shield from SQL injection
    }
    String sort = "";
    if(request.getParameter("sort") != null && request.getParameter("sort").trim().length() > 0)
	sort = request.getParameter("sort").trim();
    if(request.getParameter("action") != null && request.getParameter("action").trim().equals("purge"))
    {
	if(dcni != null)
	    com.waterware.db.DBServices.executeUpdate("delete from tmt_dcn_issued where id = "+dcni);
    }

    if(request.getParameter("action") != null && request.getParameter("action").trim().equals("DeleteDocument"))
    {
	if(dcni != null)
	    {
		String docHandle = com.waterware.db.DBServices.getString("select ds_doc_handle from tmt_dcn_issued where id = "+dcni);
		if(docHandle != null && docHandle.trim().length() > 0)
		{
		    try
		    {
			DSObject docObject = dssession.getObject(new DSHandle(docHandle));
			if(docObject != null)
			    dssession.deleteObject(new DSHandle(docHandle), DSSelectSet.ALL_PROPERTIES);
		    }
		    catch(Exception ex) {ex.getMessage();}
		}
		com.waterware.db.DBServices.executeUpdate("delete from tmt_dcn_issued where id = "+dcni);
        }
    }
%>

<style>
	A.section:active {font:  bold 8pt  Verdana, Arial, Helvetica, sans-serif; color: black; text-decoration : none}
	A.section:link {font: bold 8pt  Verdana, Arial, Helvetica, sans-serif; color: black; text-decoration : none;}
	A.section:visited {font:  bold 8pt  Verdana, Arial, Helvetica, sans-serif; color: black; text-decoration : none;}
	A.section:hover {font: bold 8pt  Verdana, Arial, Helvetica, sans-serif; color: black; text-decoration : none;}
</style>

 <script language="javascript">
      function showSpan(pass) {
          var spans = document.getElementsByTagName('span');
          //alert("spans = " + spans.length);
          for (i=0; i<spans.length; i++) {
            if (spans[i].id.indexOf(pass, 0) != -1) {
               if (document.getElementById) {
                  if (spans[i].style.display == "none"){
                     spans[i].style.display = "";
                  } else {
                     spans[i].style.display = "none";
                  }
               }
            }
          }
      }
</script>

<%
	if(!principal.isAdmin(DSLoginPrincipal.ANY_ADMIN))
	{
      response.sendRedirect("index.jsp");
      return;
	}

	if(request.getParameter("ReIndex") != null && request.getParameter("ReIndex").trim().equalsIgnoreCase("Re Index Document Numbers"))
	{
		//UpdateDocumentProperties udp = new UpdateDocumentProperties();
		UpdateDocumentProperties.updateDocumentProperties(dssession);
	}
%>

<p>
<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
<TBODY>
<!--<TR><TD><BR/></TD></TR>-->
<!--<TR><TD>Click the following button to reindex and update the properties of documents in the database.</TD></TR>-->
<!--<TR><TD><BR/></TD></TR>-->
<!--<TR>-->
<!--	<TD>-->
<!--		<form name="IndexForm" method="POST" action="index_admin.jsp" onSubmit="showSpan('index_admin'); return(true);">-->
		<!--<span style="display: ;" id="index_admin">-->
		<!--<input type=submit name=ReIndex value="Re Index Document Numbers">-->
		<!-- onclick='javascript:popup("/docushare/jsp/tmt/pickDestinationCollection.jsp"); return false;'-->
		<!--</span>-->
<!--		<br>-->
<!--	    <span style="display: none;" id="index_admin">-->
<!--		<font class="VariableWidth9"><i>Processing Request...</i></font>-->
<!--	    </span>-->
<!--		</form>-->
<!--	</TD>-->
<!--</TR>-->
<!--<TR><TD><BR/></TD></TR>-->
<!--<TR><TD><BR/></TD></TR>-->
<TR>
<TD vAlign="bottom">
  <TABLE cellSpacing="0" cellPadding="0">
    <TBODY>
    <TR>
      <TD vAlign="bottom">
        <TABLE cellSpacing="0" cellPadding="0" class="dialogborder" border="0">
          <TBODY>
          <TR>
			<% if(request.getParameter("pageId") != null && request.getParameter("pageId").trim().equalsIgnoreCase("1")) { %>
	            <TD width="8" bgcolor="#999999" background="/docushare/images/pop_tab_gray_left.gif"><IMG height="1" src="/docushare/images/spacer.gif" width="8" /></TD>
    	        <TD>
        	      <TABLE cellSpacing="0" cellPadding="3" border="0">
            	    <TBODY>
                	<TR>
	                  <TD vAlign="top" class="selected" bgcolor="#999999"><a href="index_admin.jsp" class=section>Reserved Document Numbers</A></TD></TR>
    	            </TBODY>
        	      </TABLE>
            	</TD>
	            <TD width="8" bgcolor="#999999" background="/docushare/images/pop_tab_gray_right.gif"><IMG height="1" src="/docushare/images/spacer.gif" width="8" /></TD>

    	        <TD width="8"  background="/docushare/images/pop_tab_ltgray_left.gif"><IMG height="1" src="/docushare/images/spacer.gif" width="8" /></TD>
        	    <TD>
            	  <TABLE cellSpacing="0" cellPadding="3" border="0">
	                <TBODY>
    	            <TR>
        	          <TD vAlign="top" class="selected"><a href="index_admin.jsp?pageId=1" class=section>Uploaded Documents</A></TD></TR>
            	    </TBODY>
	              </TABLE>
    	        </TD>
        	    <TD width="8" background="/docushare/images/pop_tab_ltgray_right.gif"><IMG height="1" src="/docushare/images/spacer.gif" width="8" /></TD>
			<% } else { %>
	            <TD width="8" background="/docushare/images/pop_tab_ltgray_left.gif"><IMG height="1" src="/docushare/images/spacer.gif" width="8" /></TD>
    	        <TD>
        	      <TABLE cellSpacing="0" cellPadding="3" border="0">
            	    <TBODY>
                	<TR>
	                  <TD vAlign="top" class="selected"><a href="index_admin.jsp" class=section>Reserved Document Numbers</A></TD></TR>
    	            </TBODY>
        	      </TABLE>
            	</TD>
	            <TD width="8" background="/docushare/images/pop_tab_ltgray_right.gif"><IMG height="1" src="/docushare/images/spacer.gif" width="8" /></TD>

    	        <TD width="8"  bgcolor="#999999" background="/docushare/images/pop_tab_gray_left.gif"><IMG height="1" src="/docushare/images/spacer.gif" width="8" /></TD>
        	    <TD>
            	  <TABLE cellSpacing="0" cellPadding="3" border="0">
                	<TBODY>
	                <TR>
    	              <TD vAlign="top" class="selected"  bgcolor="#999999"><a href="index_admin.jsp?pageId=1" class=section>Uploaded Documents</A></TD></TR>
        	        </TBODY>
            	  </TABLE>
	            </TD>
    	        <TD width="8" bgcolor="#999999" background="/docushare/images/pop_tab_gray_right.gif"><IMG height="1" src="/docushare/images/spacer.gif" width="8" /></TD>
			<% } %>
          </TR>
          </TBODY>
        </TABLE>
       </TD>
    </TR>
    </TBODY>
  </TABLE>
</TD>
</TR>

<TR>
<TD class="dialogborder"><IMG height="8" src="/docushare/images/spacer.gif" width="1" /></TD></TR>
</TBODY>
</TABLE>

<%
int count = 0;
try
{
   String query = "select * from tmt_dcn_issued";
   if(sort != null && sort.equalsIgnoreCase("title"))
     query += " order by title";
   else if(sort != null && sort.equalsIgnoreCase("author"))
     query += " order by author";
   else if(sort != null && sort.equalsIgnoreCase("dcn"))
     query += " order by dcn";
   else if(sort != null && sort.equalsIgnoreCase("date"))
     query += " order by date_uploaded";
   else
     query += " order by id";

   //System.out.println("Query :"+query);

   con = com.waterware.db.DBServices.getConnection();
   pstmt = con.createStatement();
   rs = pstmt.executeQuery(query);

   if(request.getParameter("pageId") != null && request.getParameter("pageId").trim().equalsIgnoreCase("1"))
   {
    %>
        <%@ include file="index_docs.jsp" %>
    <%
   }
   else
   {
    %>
        <%@ include file="index_dcns.jsp" %>
    <%
   }

   pstmt.close();
}
catch(Exception ex)
{
    ex.printStackTrace();
}
finally
{
    if(con != null) com.waterware.db.DBServices.releaseConnection(con);
}
%>

</blockquote>
<br>
</center>
</body>
</html>
<%@ include file="/jsp/common/end.jsp" %>

<script>
    <!--
    var new_win = null;
    function popup(url)
    {
        new_win = window.open(url, "New", "width=480,height=500,resizable,scrollbars=yes,status=yes");
    }
    // -->
</script>

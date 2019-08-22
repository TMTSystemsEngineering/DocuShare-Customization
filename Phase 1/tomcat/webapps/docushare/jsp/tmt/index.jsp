<%
/**
 * <p>Title: index.jsp</p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: WaterWare Internet Services</p>
 * @author Naveen G
 * @version 1.0
 */
%>

<%@ include file="ds_login.jsp" %>
<%@ include file="/jsp/common/start.jsp" %>

<% int tmtCurrentPageHightlightIndex = 0;
String pageTitle = "View Document Numbers";
String jspFile = "index.jsp";
%>
<%@ include file="docushare_header.jsp" %>

<style>
	A.section:active {font:  bold 8pt  Verdana, Arial, Helvetica, sans-serif; color: black; text-decoration : none}
	A.section:link {font: bold 8pt  Verdana, Arial, Helvetica, sans-serif; color: black; text-decoration : none;}
	A.section:visited {font:  bold 8pt  Verdana, Arial, Helvetica, sans-serif; color: black; text-decoration : none;}
	A.section:hover {font: bold 8pt  Verdana, Arial, Helvetica, sans-serif; color: black; text-decoration : none;}
</style>

<%
    Connection con = null;
    Statement pstmt = null;
    ResultSet rs = null;

	String sort = "";
	if(request.getParameter("sort") != null && request.getParameter("sort").trim().length() > 0)
		sort = request.getParameter("sort").trim();

	if(request.getParameter("action") != null && request.getParameter("action").trim().equals("purge"))
	{
		if(request.getParameter("dcn") != null)
			com.waterware.db.DBServices.executeUpdate("delete from tmt_dcn_issued where id = "+request.getParameter("dcn"));
    }
%>

<p>
<TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
<TBODY>
<TR><TD><BR /></TD></TR>

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
	            <TD width="8" bgcolor="#999999"></TD>
    	        <TD>
        	      <TABLE cellSpacing="0" cellPadding="3" border="0">
            	    <TBODY>
                	<TR>
	                  <TD vAlign="top" class="selected" bgcolor="#999999"><a href="index.jsp" class=section>Reserved Document Numbers</A></TD></TR>
    	            </TBODY>
        	      </TABLE>
            	</TD>
	            <TD width="8" bgcolor="#999999" ></TD>

    	        <TD width="8"></TD>
        	    <TD>
            	  <TABLE cellSpacing="0" cellPadding="3" border="0">
	                <TBODY>
    	            <TR>
        	          <TD vAlign="top" class="selected"><a href="index.jsp?pageId=1" class=section>Uploaded Documents</A></TD></TR>
            	    </TBODY>
	              </TABLE>
    	        </TD>
        	    <TD width="8"></TD>
			<% } else { %>
	            <TD width="8"></TD>
    	        <TD>
        	      <TABLE cellSpacing="0" cellPadding="3" border="0">
            	    <TBODY>
                	<TR>
	                  <TD vAlign="top" class="selected"><a href="index.jsp" class=section>Reserved Document Numbers</A></TD></TR>
    	            </TBODY>
        	      </TABLE>
            	</TD>
	            <TD width="8"></TD>

    	        <TD width="8"  bgcolor="#999999"></TD>
        	    <TD>
            	  <TABLE cellSpacing="0" cellPadding="3" border="0">
                	<TBODY>
	                <TR>
    	              <TD vAlign="top" class="selected"  bgcolor="#999999"><a href="index.jsp?pageId=1" class=section>Uploaded Documents</A></TD></TR>
        	        </TBODY>
            	  </TABLE>
	            </TD>
    	        <TD width="8" bgcolor="#999999" ></TD>
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
   String query = "select * from tmt_dcn_issued where ds_user like '"+(user.getHandle().toExternalForm()).trim()+"'";
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
   System.out.println("Query :"+query);

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

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

<%
	String title = null;
	String owner = null;
	String keywords = null;

  	String telescope = null;
  	String groupCategory = null;
  	String documentType = null;
  	String year = null;
  	String documentVersion = null;
	String sequenceNumber = null;
	String dcn = null;

    Connection con = null;
    Statement pstmt = null;
    ResultSet rs = null;

	String dcni = request.getParameter("dcni");

	if(dcni != null && Integer.parseInt(dcni) > 0)
	{
	    try
    	{
	       String query = "select * from tmt_dcn_issued where id = " + Integer.parseInt(dcni); // use parseInt() to shield from SQL injection;
    	   con = com.waterware.db.DBServices.getConnection();
	       pstmt = con.createStatement();
    	   rs = pstmt.executeQuery(query);

			if(rs.next())
			{
				title = rs.getString("title");
				owner = rs.getString("author");
				keywords = rs.getString("keywords");
				telescope = rs.getString("telescope");
				groupCategory = rs.getString("group_category");
				documentType = rs.getString("document_type");
				year = rs.getString("year");
				documentVersion = rs.getString("document_version");
				sequenceNumber = rs.getString("sequence_number");
				dcn = rs.getString("dcn");
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
	}
%>
<% int tmtCurrentPageHightlightIndex = 1; String pageTitle = "Document Number Created";%>
<%@ include file="docushare_header.jsp" %>

<!--p align=center>
<a href="/docushare/dsweb/HomePage" alt="Docushare Home">Docushare Home</a>&nbsp;|
<a href="index.jsp" alt="TMT Home">TMT Home</a-->

<br clear=all>
<blockquote>
<p class="tmttitle">TMT - Issuing a Document Number - Success</p>
<table cellpadding="3">

  <tr>
    <td align="right"><b>Document Title:</b></td>
    <td><%= title %></td>
  </tr>
  <tr>
    <td align="right"><b>Owner:</b></td>
    <td><%= owner%></td>
  </tr>
  <tr>
    <td align="right"><b>Keywords:</b></td>
    <td><%= keywords %></td>
  </tr>

  <tr>
    <td align="right"><b>Telescope:</b></td>
    <td><%= telescope%></td>
  </tr>

  <!-- Group Categories -->
  <tr>
    <td align="right"><b>Group Category:</b></td>
    <td><%= groupCategory%></td>
  </tr>

  <!-- Document Type -->
  <tr>
    <td align="right"><b>Document Type:</b></td>
    <td><%= documentType%></td>
  </tr>

  <!-- Year -->
  <tr>
    <td align="right"><b>Originating Year:</b></td>
    <td><%=year%></td>
  </tr>

  <!-- Document Versions -->
  <tr>
    <td align="right"><b>Document Version:</b></td>
    <td><%= documentVersion%></td>
  </tr>

  <!-- Sequence NUmber -->
  <tr>
    <td align="right"><b>Sequence Number:</b></td>
    <td><%= sequenceNumber%></td>
  </tr>

  <!-- Document Control Number -->
  <tr>
    <td align="right" valign="top"><b>Document Number :</b></td>
    <td><%= dcn%><br/><a href="addDocument.jsp?dcni=<%=dcni%>"><i>Click here to add this document now</i></a></td>
  </tr>

</table>

</blockquote>
<br>

<!-- footer -->
</td></tr></table>

</center>
</body>
</html>
<%@ include file="/jsp/common/end.jsp" %>

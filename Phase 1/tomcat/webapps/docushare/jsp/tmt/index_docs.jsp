<%
/**
 * <p>Title: index.jsp</p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: WaterWare Internet Services</p>
 * @author Naveen G
 * @version 1.0
 */
%>

<table cellpadding="3" width=95% border=0 bgcolor="#FFFFFF">
<%
	DSObject docObject = null;
	DSVersion verObject = null;
	boolean flag = true;
	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, MMMM d, yyyy KK:mm:ss aaa z");

	try
	{
		while(rs.next())
		{
			String dsDocHandle = rs.getString("ds_doc_handle");
			if(dsDocHandle == null || dsDocHandle.trim().length() == 0)
				continue;

			++count;
			String title = rs.getString("title");
			String author = rs.getString("author");
			String dcn = rs.getString("dcn");
			java.sql.Timestamp createdDate = rs.getTimestamp("date_uploaded");

			if(flag) {
			%>
			  <tr>
				<td align="center"><a href="<%=jspFile%>?sort=title&pageId=1"><b>Document<br>Title</b></a></td>
				<td align="center"><a href="<%=jspFile%>?sort=author&pageId=1"><b>Author</b></a></td>
				<td align="center"><a href="<%=jspFile%>?sort=dcn&pageId=1"><b>Document<br>Number</b></a></td>
				<td align="center"><a href="<%=jspFile%>?sort=date&pageId=1"><b>Date<br>Uploaded</b></a></td>
				<td align="center"><b>Manage</b></td>
				<%if(principal.isAdmin(DSLoginPrincipal.ANY_ADMIN) && jspFile.indexOf("index_admin") != -1) { %>
					<td align="center"><b>Delete<br>Documents</b></td>
				<% } %>
			  </tr>
			<%
				flag = false;
			}
			%>
			  <tr>
				<td align="center"><%= title %></td>
				<td align="center"><%= author%></td>
				<td align="center"><%= dcn%></td>
				<td align="center"><%=(createdDate != null ? sdf.format(new java.util.Date(createdDate.getTime())) : "Property does not exist.")%></td>
				<td align="center" bgcolor="#ffffff">
					<A HREF="/docushare/dsweb/Services/<%=dsDocHandle%>"><img src="griffin_service.gif" border="0" width="18" height="18" alt="Properties" title="Properties" class="midalign" bgcolor=white></img></A>
					<% //if(docObject.isLocked()) { %>
					<!-- <A HREF="/docushare/dsweb/Services/<%=dsDocHandle%>"><img src="/docushare/NewImage/griffin_lock.png" border="0" width="18" height="18" alt="lock: admin" title="lock: admin" class="midalign"></img></A> -->
					<% //} else { %>
					<A HREF="/docushare/dsweb/CheckOut/<%=dsDocHandle%>/"><img src="griffin_CHECKOUT.gif" border="0" width="18" height="18" alt="Checkout" title="Checkout" class="midalign"></img></A>
					<A HREF="javascript:openRoutingSlip('/docushare/', '<%=dsDocHandle%>')"><img src="griffin_routing.gif" border="0" width="18" height="18" alt="Route" title="Route" class="midalign"></img></A>
					<A HREF="/docushare/dsweb/Get/<%=dsDocHandle%>/"><img src="griffin_HTML.gif" border="0" width="18" height="18" alt="View" title="View" class="midalign"></img></A>
				</td>
					<% //} %>
					<%if(principal.isAdmin(DSLoginPrincipal.ANY_ADMIN) && jspFile.indexOf("index_admin") != -1) { %>
						<td align="center"><a href="/docushare/jsp/tmt/index_admin.jsp?action=DeleteDocument&pageId=1&dcni=<%=rs.getInt("id")%>"
							onclick="return confirm('Are you sure you want to delete this document number and the document from Docushare?\n Once you delete this document you may not be able to retrieve it later.');">Delete</a></td>
					<% } %>
			  </tr>
			<%
		}

		if(count == 0)
		{
			%><tr><td>&nbsp;</td></tr><tr><td>Currently you do not own any documents in this system.</td></tr><%
		}
		else
		{
			%><tr><td>&nbsp;</td></tr><tr><td><b>Total : <%=count%> Documents</b></td></tr><%
		}
	}
	catch(Exception ex)
	{
		ex.printStackTrace();
	}
%>

</table>

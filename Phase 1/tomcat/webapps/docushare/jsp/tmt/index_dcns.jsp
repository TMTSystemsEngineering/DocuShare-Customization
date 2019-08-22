<%
/**
 * <p>Title: index.jsp</p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: WaterWare Internet Services</p>
 * @author Naveen G
 * @version 1.0
 */
%>

<table cellpadding="3" width=95%>

<%
	boolean flag = true;
    while(rs.next())
    {
        String dsDocHandle = rs.getString("ds_doc_handle");
        if(dsDocHandle != null && dsDocHandle.trim().length() > 0)
            continue;

        ++count;
        String title = rs.getString("title");
        String author = rs.getString("author");
        String dcn = rs.getString("dcn");

        if(flag) {
        %>
      <tr>
        <td align="center"><a href="<%=jspFile%>?sort=title"><b>Document Title</b></a></td>
        <td align="center"><a href="<%=jspFile%>?sort=dcn"><b>Document Number</b></a></td>
        <!--<td align="center"><a href="<%=jspFile%>?sort=author"><b>Author</b></a></td>-->
        <td align="center"><b>Upload Documents</b></td>
        <td align="center"><b>Release Documents</b></td>
      </tr>
        <%
            flag = false;
        }
        %>
          <tr>
            <td align="center"><%= title %></td>
            <td align="center"><%= dcn%></td>
            <!--<td align="center"><%= author%></td>-->
            <td align="center"><a href="/docushare/jsp/tmt/addDocument.jsp?dcni=<%=rs.getInt("id")%>&action=Upload">Add</a></td>
            <td align="center"><a href="/docushare/jsp/tmt/<%=jspFile%>?action=purge&dcni=<%=rs.getInt("id")%>"
                onclick="return confirm('Are you sure you want to delete this document number?');">Delete</a>
            </td>
          </tr>
        <%
    }

    if(count == 0)
    {
        %><tr><td>&nbsp;</td></tr><tr><td> None. To reserve a document number please click the "Reserve & Add Document" link.</td></tr><%
    }
    else
    {
        %><tr><td>&nbsp;</td></tr><tr><td><b>Total : <%=count%> Document Numbers</b></td></tr><%
    }
%>

</table>

<%
/**
 * <p>Title: picDestinationCollection.jsp</p>
 * <p>Copyright: Copyright (c) 2005</p>
 * <p>Company: WaterWare Internet Services</p>
 * @author Naveen G
 * @version 1.0
 */
%>

<%@ include file="ds_login.jsp" %>
<%@ include file="/jsp/common/start.jsp" %>

<%
%>
<% String pageTitle = "Select Destination Collection"; %>
<HTML>
    <HEAD>
	<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE" />
	<META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE" />
	<META HTTP-EQUIV="EXPIRES" CONTENT="0" />
	<link rel="SHORTCUT ICON" href="/docushare/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="/docushare/docushare.css" />
	<link rel="alternate" type="application/rss+xml" title="RSS" href="/docushare/dsweb/ApplyListNew/<%=(request.getParameter("destCollection") != null && request.getParameter("destCollection").trim().length() > 0 ? request.getParameter("destCollection").trim() : "Site")%>?vdf_results=RSS10&days=7&sort_key0=date" />
	<TITLE><%=pageTitle%></TITLE>

    <style>
    .tmt {
         background-color:#429c6;
         color: white;
    }
    .tmtred {
         color: red;
    }
    .tmttitle {
         font-weight: bold;
         font-size: 16px;
    }
    </style>

    </HEAD>

    <BODY style="min-width: 400px;" background="" bgcolor="#FFFFFF">
	
	<A name="header" />

<SCRIPT LANGUAGE="JavaScript1.2">
  function setDestinationCollection()
  {
	var found = false;

    if(document.CollectionsForm.destCollection.length > 1)
	{
		for(i=0; i<document.CollectionsForm.destCollection.length; i++)
		{
			if(document.CollectionsForm.destCollection[i].checked == true)
			{
				var handle = document.CollectionsForm.destCollection[i].value;
				self.opener.document.ApplyAddDocument.destinationCollection.value = handle;
				found = true;
				break;
			}
		}
	}
	else
	{
        if(document.CollectionsForm.destCollection.checked == true)
        {
            var handle = document.CollectionsForm.destCollection.value;
            self.opener.document.ApplyAddDocument.destinationCollection.value = handle;
			found = true;
        }
	}

	if(found == true)
	    window.close();
	else
	{
		alert("Please select a collection or drill down into a collection.");
		return false;
	}
  }

  function startOver()
  {
    parentId = 0;
    setSelectOptions(parentId);
  }

</SCRIPT>
<br>&nbsp;<a href="/docushare/jsp/tmt/pickDestinationCollection.jsp">Root Collections</a>
<%
    HttpSession hs = request.getSession();
    Stack st = null;

    if(request.getParameter("collectionHandle") != null && request.getParameter("bc") != null)
    {
	String handle = request.getParameter("collectionHandle").trim();
	if(hs.getAttribute("BCStack") != null)
	{
	    st = (Stack) hs.getAttribute("BCStack");
	    if(st.size() > 0)
	    {
		while(st.size() > 0)
		{
		    String top = (String)st.pop();
		    if( top.trim().equalsIgnoreCase(handle.trim()) )
		    break;
		}
	    }
	}
	//System.out.println("Size :"+st.size());
	for(int i=0; i<st.size(); i++)
	{
	    String hdl = (String)st.elementAt(i);
	    out.println(" >> <a href=\"/docushare/jsp/tmt/pickDestinationCollection.jsp?collectionHandle="+hdl+"&bc=true\">"+dssession.getObject(new DSHandle(hdl)).getTitle()+"</a>");
	}
	DSObject currObject = dssession.getObject(new DSHandle(request.getParameter("collectionHandle")));
	//System.out.println("Curr: >> "+currObject.getTitle()+"  Listing");
	out.println(" >> "+currObject.getTitle()+"  Listing");
	st.push(request.getParameter("collectionHandle"));
	hs.setAttribute("BCStack", st);
    }
    else if(request.getParameter("collectionHandle") != null && request.getParameter("bc") == null)
    {
	String handle = request.getParameter("collectionHandle").trim();
	if(hs.getAttribute("BCStack") != null)
	{
	    st = (Stack) hs.getAttribute("BCStack");
	    if(st != null && st.size() > 0)
	    for(int i=0; i<st.size(); i++)
	    {
		String hdl = (String)st.elementAt(i);
		out.println(" >> <a href=\"/docushare/jsp/tmt/pickDestinationCollection.jsp?collectionHandle="+hdl+"&bc=true\">"+dssession.getObject(new DSHandle(hdl)).getTitle()+"</a>");
	    }

	    st.push(handle);
	    hs.setAttribute("BCStack", st);
	}
	else
	{
	    st = new Stack();
	    st.push(handle);
	    hs.setAttribute("BCStack", st);
	}
	DSObject currObject = dssession.getObject(new DSHandle(request.getParameter("collectionHandle")));
	//System.out.println("Curr: >> "+currObject.getTitle()+"  Listing");
	out.println(" >> "+currObject.getTitle()+"  Listing");
    }
    else if(request.getParameter("collectionHandle") == null)
    hs.removeAttribute("BCStack");
%>
<br/>
<blockquote>
<p class="tmttitle">Pick a destination collection for your document.</p>

<form method="POST" action="pickDestinationCollection.jsp" name="CollectionsForm">
<table cellpadding="3">
<%
ArrayList list = null;

String item = null;
String handle = null;
String title = null;

try
{
    if(request.getParameter("collectionHandle") == null)
    {

	    DSObjectIterator rootIter = dssession.rootObjects(new DSSelectSet("Object.title"));
    	%>
	      <tr>
    	    <td align="left"><b>Root Collections :</b></td>
	      </tr>
    	<%
	    list = new ArrayList(rootIter.size());
    	while(rootIter.hasNext())
	    {
    	    DSObject tmpObject = rootIter.nextObject();
			handle = tmpObject.getHandle().toExternalForm();
			if (handle.startsWith("Collection-"))
			{
				list.add(tmpObject.getTitle()+"::"+handle);
			}
    	}
    }
    else
    {
	    String collectionHandle = request.getParameter("collectionHandle");

    	DSObject tmpObject = dssession.getObject(new DSHandle(collectionHandle));
	    DSHandle [] destRootHandles = new DSHandle[1];
    	if(tmpObject.canWriteLinked()) {
	        destRootHandles[0] = tmpObject.getHandle();
    	}

	    String[] targetClass = new String[] {"Collection"};
    	DSLinkIterator iterator = dssession.getDestinationsLinkPairs( destRootHandles,
        	new String[] {DSLinkDesc.containment}, 1, targetClass, new DSSelectSet(new String[] {"title","handle"}));

	    list = new ArrayList(iterator.size());
    	while(iterator.hasNext())
	    {
    	    DSLinkItem linkItem = iterator.nextObject();
			handle = linkItem.getLinkedObjectHandle().toExternalForm();
			if (handle.startsWith("Collection-"))
			{
				list.add(linkItem.getLinkedObject().getTitle()+"::"+handle);
			}
	    }
    }

    Collections.sort(list, new StringComparator());
    for(int i=0; i<list.size(); i++) {
        item = (String) list.get(i);
        title = item.substring(0, item.indexOf("::")).trim();
        handle = item.substring(item.indexOf("::")+2).trim();

        if ((dssession.getObject(new DSHandle(handle))).canWriteLinked()) {
            DSLinkIterator childIter = dssession.getDestinationsLinkPairs( new DSHandle[] {new DSHandle(handle)},
                new String[] {DSLinkDesc.containment}, 1, new String[] {"Collection"}, new DSSelectSet("Object.title"));
            if(childIter.size() > 0)
            {
            %>
              <tr>
                <td align="left"><input type=radio name="destCollection" value="<%=handle%>"><a href="/docushare/jsp/tmt/pickDestinationCollection.jsp?collectionHandle=<%=handle%>"><%=title%>&nbsp;(<%=handle%>)</td>
              </tr>
            <%
            }
            else
            {
            %>
              <tr>
                <td align="left"><input type=radio name="destCollection" value="<%=handle%>"><%=title%>&nbsp;(<%=handle%>)</td>
              </tr>
            <%
            }
        }
    }
}
catch(Exception ex)
{
    ex.printStackTrace();
}

%>

<tr><td>&nbsp;</td></tr>
<tr>
	<td><input type=submit name=Submit Value="Submit" onclick="return setDestinationCollection();">&nbsp;&nbsp;
		<input type=submit name=Cancel Value="Close" onClick="window.close()"></td>
</tr>
</table>
</form>

</blockquote>
<br>

<!-- footer -->
</td></tr></table>
</center>
</body>
</html>
<%@ include file="/jsp/common/end.jsp" %>

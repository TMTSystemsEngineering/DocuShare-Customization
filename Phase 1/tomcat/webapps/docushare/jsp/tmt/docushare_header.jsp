<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      	<TITLE><%=pageTitle%></TITLE>

		<link rel="stylesheet" type="text/css" href="/docushare/docushare.css" />
		<link rel="stylesheet" type="text/css" href="/docushare/jsp/tmt/tmt.css" />
		<link rel="alternate" type="application/rss+xml" title="RSS" href="/docushare/dsweb/ApplyListNew/Site?vdf_results=RSS10&amp;days=7&amp;sort_key0=date" />

		<style type="text/css">
		  body {
			background-color: #FFFFFF;
		  }
		</style>
		
	</head>
  <body>
	<a href="#contents" title="Skip to Contents" class="skipnav_header">Skip to Contents</a>

    <div id="header">
      <div id="header_inner">
	  <h1><a href="/docushare/dsweb/Home" title="Home"></a></h1>
      <ul id="header_linksection">
        <li class="first"><a href="/docushare/dsweb/Home">Home</a></li>
        <li><a href="/docushare/dsweb/Index/<%=(request.getParameter("destCollection") != null && request.getParameter("destCollection").trim().length() > 0 ? request.getParameter("destCollection").trim() : "Site")%>?init=true">Content Map</a></li>
        <li><a href="/docushare/dsweb/ApplyListNew/<%=(request.getParameter("destCollection") != null && request.getParameter("destCollection").trim().length() > 0 ? request.getParameter("destCollection").trim() : "Site")%>?nresults=100">What's New</a></li>
        <li><a href="/docushare/dsweb/Registry">Users &amp; Groups</a></li>
        <li><a href="/docushare/dsweb/helpdesk">Help</a></li>
      </ul>
      </div>
    </div>

<%

 // TMT DCN Navigation strip drawing
 // set tmtCurrentPageHighlightIndex on page to indicate which is current page
 boolean first = true;
 String tmtNav [] = { "View Reserved DCNs", "Issue DCN", "Add Document", "Manage Picklists" };
 String tmtNavUrl [] = { "index.jsp", "IssueDCN.jsp", "addDocument.jsp", "index_admin.jsp"};
 
 String tmtNav2 [] = { "Back", "Manage", "Telescopes", "Group Categories", "Document Types", "Years", "Document Versions"};
 String tmtNavUrl2 [] = { "index.jsp", "index_admin.jsp", "manageTelescopes.jsp", "manageGroupCategories.jsp", "manageDocumentTypes.jsp", "manageYears.jsp", "manageDocumentVersions.jsp"};
 String navStrip = "<table cellspacing=\"0\" cellpadding=\"0\"  width=\"100%\" border=\"0\" bgcolor=\"#4279c6\">\n";
 navStrip += "<tr>\n";
 navStrip += "<td align=\"left\" height=\29\" class=\"tmt\"><nobr>&nbsp;&nbsp;<b>TMT Document Management</b>&nbsp;</nobr></td>\n";
 navStrip += "<td width=\"100%\" class=\"tmt\" height=\"29\">&nbsp;</td>";

 if(tmtCurrentPageHightlightIndex < 3)
 {
	 for(int i = 0; i < tmtNav.length; i++){
		//do not show the manage link if the current user is not an admin.
		if(tmtNav[i] == "Manage" && !principal.isAdmin(DSLoginPrincipal.ANY_ADMIN))
			continue;
		
	    if (!first){
    	   navStrip += "<td class=\"tmt\">|</td>";
	    }
		
		navStrip += "<td align=\"center\" class=\"tmt\" height=\"29\">";
		
    	navStrip += "&nbsp;<a href=\"" + tmtNavUrl[i] + "\"  title=\"" + tmtNav[i] + "\" class=\"headerlinks\">";
	    if (i == tmtCurrentPageHightlightIndex){
    	    navStrip += "<span class=\"tmtred\"><nobr><b>" + tmtNav[i] + "</b></nobr></span></a>&nbsp; ";
	    }
    	else {
        	 navStrip += "<nobr><b>" + tmtNav[i] + "</b></nobr></a>&nbsp; ";
	    }
    	navStrip += "</td>\n";
		first = false;
	  }
 }
 else
 {
	tmtCurrentPageHightlightIndex = tmtCurrentPageHightlightIndex - 3;
	for(int i = 0; i < tmtNav2.length; i++){
	    if (!first){
    	   navStrip += " | ";
	    }

    	navStrip += "<a href=\"" + tmtNavUrl2[i] + "\"  title=\"" + tmtNav2[i] + "\" class=\"headerlinks\">";
	    if (i == tmtCurrentPageHightlightIndex){
    	    navStrip += "<span class=\"tmtred\"><b>" + tmtNav2[i] + "</span></b></a> ";
	    }
    	else {
        	 navStrip += "<b>" + tmtNav2[i] + "</b></a> ";
	    }
    	navStrip += "\n";
		first = false;
	}
 }

 navStrip += "</tr></table>\n";
%>
<%=navStrip%>
	<A name="header" />





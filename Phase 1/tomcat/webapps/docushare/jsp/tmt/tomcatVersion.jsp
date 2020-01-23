Tomcat Version : <%= application.getServerInfo() %><br>
    Servlet Specification Version :
<%= application.getMajorVersion() %>.<%= application.getMinorVersion() %> <br>  
    JSP version :
<%=JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion() %><br>


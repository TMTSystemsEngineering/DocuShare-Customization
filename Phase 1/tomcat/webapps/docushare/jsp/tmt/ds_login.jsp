<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.xerox.docushare.amber.util.MessageDB" %>
<%@ page import="com.xerox.docushare.*"%>
<%@ page import="com.xerox.docushare.amber.util.XSLTMessage" %>
<%@ page import="com.xerox.docushare.amber.error.RedirectionException" %>
<%@ page import="com.xerox.docushare.object.*"%>
<%@ page import="com.xerox.docushare.query.*"%>
<%@ page import="com.xerox.docushare.property.*"%>

<%@ page import="edu.caltech.docushare.*"%>

<%@ page extends="com.xerox.docushare.amber.pages.common.SessionPage" %>

<%!
protected DSLoginPrincipal principal;
protected DSUser user;
DSCredential credential = null;
DSServer server = null;
DSSession dssession = null;

// need to implement this abstract method from SessionPage.
protected boolean hasURLCheck()
{
  return false;
}

// need to implement this abstract method from SessionPage.
public void process(HttpServletRequest aRequest, HttpServletResponse aResponse)
        throws ServletException
{
  return;
}

protected boolean preprocess(HttpServletRequest aRequest, HttpServletResponse aResponse)
        throws ServletException, DSException, RedirectionException
{
    if(!super.preprocess(aRequest, aResponse))
    {
        return false;
    } else
    {
        mDSSession = getDSSessionFromCookies();
        if(mDSSession == null)
            throw redirect(mLoginPage, new Exception(getMessage("InvalidSessionError")));

		dssession = mDSSession;
        principal = mDSSession.getLoginPrincipal();
		user = (DSUser)mDSSession.getObject(principal.getHandle());

        if (principal == null)
            throw redirect(mLoginPage, new Exception(getMessage("InvalidSessionError")));

        if (principal.isGuestUser()) {
            //throw redirect(mLoginPage, new DSException(16, getMessage("AuthorizationExceptionBodyGuest1")));
            throw redirect(mLoginPage, new DSException(DSException.ACCESS_DENIED, getMessage("scanservlet_not_authorised")));
        }

		credential = mDSSession.getCredential();
		server = mDSSession.getServer();
        HttpSession hs = aRequest.getSession();
        hs.setAttribute("dsCredential", credential);
        hs.setAttribute("dsServer", server);

        return true;
    }
}

%>



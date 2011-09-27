<%@ page import="java.security.CodeSource" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<!DOCTYPE html>
<html>
<head>
    <title>clx - <%= request.getServletContext().getContextPath() %></title>
</head>
<body style="font-family: Georgia, sans-serif">
<div style="background-image: -webkit-linear-gradient(top, #dcdcdc, #fff); background-image: -moz-linear-gradient(top, #dcdcdc, #fff); overflow: auto; width: 100%; border-radius: 10px">
<h1 style="font-size: 5em; float: left; margin: 10px 40px 0 20px;">clx</h1>

<%
  Map<String,Map<String,String>> strings = new HashMap<String,Map<String,String>>();
  strings.put("en",new HashMap<String,String>(){{
  		       put("systemclass"," is a system class.");
		       put("hierarchy","Classloader hierarchy");
		       put("bootstrap","Bootstrap class loader");
		       put("location","Location");
		       put("classnotfound","Class not found");
		       put("search","Search");
  }});
  strings.put("no",new HashMap<String,String>(){{
  		       put("systemclass"," er en systemklasse.");
		       put("hierarchy","Klasseinnlasterhierarki");
		       put("bootstrap","Prim&aelig;rklasseinnlaster");
		       put("location","Plassering");
		       put("classnotfound","Finner ikke klassen");
		       put("search","S&oslash;k");
  }});
    String lang = request.getParameter("lang");
    if (lang == null) {
       Cookie [] cookies = request.getCookies();
       for (int i =0 ;i < cookies.length; i ++) {
       	   if (cookies[i].getName().equals("lang")) {
	      lang = cookies[i].getValue();
	      break;
	   }
       }
       if (lang == null) lang = "en";

    }
    Cookie cookie = new Cookie("lang",lang);
    response.addCookie(cookie);
%>

<style>
	a {text-decoration: none; color: black; }
</style>

<% String searchString = request.getParameter("c") ; %>
<% String param = searchString==null?"":"c="+searchString+"&"; %>

<div>
<a href="clx.jsp?<%= param %>lang=en">English</a>
<a href="clx.jsp?<%= param %>lang=no">Norsk</a>
</div>

<div style="float: left; margin: 3em 0;">
<form method="get">
    <input name="c" value="${param.c}" size="60" style="border: solid 1px #bababa; font-size: 12pt;">
    <input type="submit" value="<%= strings.get(lang).get("search") %>" style="font-size: 14pt; vertical-align: baseline; -webkit-appearance: button;">
</form>
</div>
</div>


<div style="margin-left: 10px">
<%
    String className = request.getParameter("c");
    if (className != null && className.length() > 0) {
        try {
	    className = className.replace('/','.');
            Class<?> c = Class.forName(className.trim());
            CodeSource codeSource = c.getProtectionDomain().getCodeSource();
            if (codeSource == null) {
                out.println(className);
                out.println(strings.get(lang).get("systemclass"));
            } else {
                %><b><%= strings.get(lang).get("location") %>:</b> <%= codeSource.getLocation().getFile() %><%
            }

    %><p><b><%= strings.get(lang).get("hierarchy")%>:</b></p><ul><%
    ClassLoader cl = c.getClassLoader();
    while (cl != null) {
        out.println("<li>");
        out.println(cl);
        URL classUrl = cl.getResource(className.replace('.', '/') + ".class");
        if (classUrl != null) {
            out.print("<b>" + strings.get(lang).get("location") +": " + classUrl + "</b>");
        }
        out.println("</li>");
        cl = cl.getParent();
    }
    %><li>(<%= strings.get(lang).get("bootstrap") %>)</ul><%
} catch (ClassNotFoundException e) {
            %><i><%= strings.get(lang).get("classnotfound") %>: <%= className %></i><%
        }
    }


%>
</div>

</body>
</html>

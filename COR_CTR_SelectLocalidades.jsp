<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"               
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld" 
%><%@ taglib prefix="mail" uri="futuretense_cs/mail.tld"
%><%@ page import="COM.FutureTense.Interfaces.Utilities,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors,
				   org.apache.commons.lang.StringUtils,
				   java.util.HashMap,java.util.Map,java.util.List,
				   java.util.ArrayList,
				   java.util.Arrays,
				   java.lang.String,
				   java.io.*,
				   java.net.HttpURLConnection,
				   java.net.URL,
				   org.apache.commons.io.IOUtils,
				   es.correos.webpublica.web.fatwire.app.*,
                   java.io.Serializable"%>
<cs:ftcs><%-- COR_Aplicaciones/Migracion/COR_CTR_SelectLocalidades



INPUT



OUTPUT



--%>

<%-- Record dependencies for the SiteEntry and the CSElement --%>

<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>

<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<%
// Variables de control
//========================================================
boolean debug = false;

// Variables entrada formulario
//========================================================
String strCodProvincia = ics.GetVar("ctr_provincia");
String strTabla="Localidades";

//Variables de salida
//========================================================
ArrayList <String> listaLocalidades =  new ArrayList<String>();

//Variables Internas
//========================================================
String strQuery = null;
String strCodigo =null;

%><ics:logmsg msg="INICIO SelectLocalidades " severity="info" /><%

	try {
		//strQuery = "SELECT Id_provincia, nom_localidad FROM "+strTabla+" WHERE CODIGO_PAIS="+strPais+" ORDER BY CODIGO";
		//strQuery = "SELECT Id_provincia, nom_localidad FROM "+strTabla+" WHERE CODIGO_PROV="+strCodProvincia+" ORDER BY NOMBRE";
		strQuery = "SELECT CODIGO, NOMBRE FROM "+strTabla+" WHERE CODIGO_PROV="+strCodProvincia+" ORDER BY NOMBRE";
		
		if (debug){	
			out.println("Tabla: \n  " +strTabla+"\n");
			out.println("Query: \n  " +strQuery+"\n");
			out.println("CodProvincia: \n  " +strCodProvincia+"\n");
		}
		%><ics:sql sql="<%=strQuery%>" listname="lista" table="<%=strTabla%>" /><%

		if(ics.GetErrno()!=0){
				System.out.println("Errno "+ics.GetErrno());
		}

		%><ics:listloop listname="lista"><%	
			%><ics:listget listname="lista" fieldname="codigo" output="CODIGO"/>
			<ics:listget listname="lista" fieldname="nombre" output="NOMBRE"/>
			<%
			
			strCodigo=ics.GetVar("CODIGO")+";"+ics.GetVar("NOMBRE");
			//if (debug) out.println(ics.GetVar("CODIGO")+" \n "+ics.GetVar("NOMBRE"));

			listaLocalidades.add(strCodigo);
			//if (debug) out.println("\nCARGA LISTA LOCALIDADES");
			
		%></ics:listloop><%
		ics.SetObj("listaLocalidades",listaLocalidades);

		
	} catch (Exception ex){
		%>
			<ics:logmsg msg="ERROR SelectLocalidades " severity="error" />
			<ics:callelement element='COR_Aplicaciones/PaginaError' />
			<ics:logmsg msg='<%=ex.toString()%>' severity="error"/>
		<%
	} %>
	<ics:logmsg msg="FIN SelectLocalidades " severity="info" />
</cs:ftcs>
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
				   java.lang.System.*,		
				   java.lang.String,
				   java.io.*,
				   java.net.HttpURLConnection,
				   java.net.URL,
				   org.apache.commons.io.IOUtils,
				   es.correos.webpublica.web.fatwire.app.*,
				   java.util.Calendar,
                   java.io.Serializable"%>
<cs:ftcs><%-- COR_Aplicaciones/Migracion/COR_CTR_SelectUnidades


INPUT



OUTPUT



--%>

<%-- Record dependencies for the SiteEntry and the CSElement --%>

<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>

<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<%
// Variables de control
//========================================================
boolean debug = true;
		if (debug){	
			System.out.println("***_*** ENTRA EN COR_CTR_SelectUnidades");
		}
// Variables entrada formulario
//========================================================
String strCodProvincia = ics.GetVar("ctr_provincia");
String strCodLocalidad = ics.GetVar("ctr_localidad");
String strTabla="CTR_Concurso_Traslados_Ofertas";

//Variables de salida
//========================================================
ArrayList <String> listaUnidades =  new ArrayList<String>();

//Variables Internas
//========================================================
String strQuery = null;
String strCodigo =null;

%><ics:logmsg msg="INICIO SelectUnidades " severity="info" /><%

	try {
		strQuery = "SELECT DISTINCT unidad, descripcion_unidad FROM "+strTabla+" WHERE provincia='"+strCodProvincia+"' AND localidad_ine='"+strCodLocalidad+"' ORDER BY descripcion_unidad";
		
		if (debug){	
			System.out.println("***_*** Tabla: \n  " +strTabla+"\n");
			System.out.println("***_*** Query: \n  " +strQuery+"\n");
			System.out.println("***_*** CodProvincia: \n  " +strCodProvincia+"\n");
			System.out.println("***_*** CodLocalidad: \n  " +strCodLocalidad+"\n");			
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
			if (debug) System.out.println(ics.GetVar("CODIGO")+" \n "+ics.GetVar("NOMBRE"));

			listaUnidades.add(strCodigo);
			//if (debug) System.out.println("\nCARGA LISTA UNIDADES");
			
		%></ics:listloop><%
		ics.SetObj("listaUnidades",listaUnidades);

		
	} catch (Exception ex){
		%>
			<ics:logmsg msg="ERROR SelectUnidades " severity="error" />
			<ics:callelement element='COR_Aplicaciones/PaginaError' />
			<ics:logmsg msg='<%=ex.toString()%>' severity="error"/>
		<%
	} %>
	<ics:logmsg msg="FIN SelectUnidades " severity="info" />
</cs:ftcs>
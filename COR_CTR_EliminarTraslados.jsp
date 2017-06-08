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
<cs:ftcs><%-- Page/COR_Aplicaciones/COR_CTR_EliminarTraslados

INPUT

OUTPUT

--%>

<%-- Record dependencies for the SiteEntry and the CSElement --%>

<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>

<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<%
//========================================================
// Variables de control
//=====================
boolean debug = true;
		if (debug){	
			System.out.println("***_*** ENTRA EN COR_CTR_EliminarTraslados");
		}
//========================================================
//Variables de salida
//===================

//========================================================
//Variables Internas
//==================
String strQuery = null;
String strCodigo =null;
String strResultado = null;


String strTabla="";
String wTmp = "";
String wSiNo = "";

String CTR_Solicitantes_DNI = ics.GetVar("DNI");

%><ics:logmsg msg="***_*** - INICIO del LOG de - COR_CTR_EliminarTraslados - ***_***" severity="info" /><%

	try {
	//-------------------------------------------------------------------------------------------------------------------------------------------------		
	// GRABACION de Tabla "CTR_Solicitantes"	
	//-------------------------------------------------------------------------------------------------------------------------------------------------		
		//-------------------------------------------------------------------------------------------------	
		//Coger ultimo Nº secuencial de id_solicitude para incrementar en 1 y asignar nº a la nueva Solicitud.
		//-------------------------------------------------------------------------------------------------	

		strTabla = "CTR_Solicitantes";
		strQuery = "SELECT dni AS num FROM "+strTabla+" WHERE dni ='"+CTR_Solicitantes_DNI+"'";  //Leo el registro del solicitante

		if (debug){	
			System.out.println("***_*** Query CTR_Solicitantes: \n  " +strQuery+"\n");
		}

		
		%><render:callelement elementname="correos/webpublica/logica/COR_obtenerSQLNum" scoped="local"><%
			%><render:argument name="strQuery" value='<%=strQuery%>'/><%
			%><render:argument name="strTabla" value='<%=strTabla%>'/><%
		%></render:callelement><%
		strResultado = ics.GetSSVar("strQueryResult");

		//-------------------------------------------------------------------------------------------------	
		// UPDATE sobre la tabla para grabar la fecha de anulacion de las solicitudes
		//-------------------------------------------------------------------------------------------------

		//Fecha del sistema
		Calendar wFecha = Calendar.getInstance();
		String wFechaActual = wFecha.get(Calendar.DAY_OF_MONTH) + "/" + (wFecha.get(Calendar.MONTH) + 1) + "/" + wFecha.get(Calendar.YEAR);		
		
		strTabla = "CTR_Solicitantes";		
		strQuery = "UPDATE "+strTabla+ " SET fechabaja='" + wFechaActual + "',activo='0' WHERE dni ='" + CTR_Solicitantes_DNI+"'";

		if (debug){	
			System.out.println("***_*** Query UPDATE: \n  " +strQuery+"\n");
		}

		
		%><render:callelement elementname="correos/webpublica/logica/COR_obtenerSQLNum" scoped="local"><%
			%><render:argument name="strQuery" value='<%=strQuery%>'/><%
			%><render:argument name="strTabla" value='<%=strTabla%>'/><%
		%></render:callelement><%

		if (debug){	
			System.out.println("***_*** Despues del UPDATE: \n  " +strQuery+"\n");
		}


	} catch (Exception ex){
		%>
			<ics:logmsg msg="ERROR wArray " severity="error" />
			<ics:callelement element='COR_Aplicaciones/PaginaError' />
			<ics:logmsg msg='<%=ex.toString()%>' severity="error"/>
		<%
	} 
	%>
	<ics:logmsg msg="FIN del LOG de - COR_CTR_EliminarTraslados -" severity="info" />
</cs:ftcs>
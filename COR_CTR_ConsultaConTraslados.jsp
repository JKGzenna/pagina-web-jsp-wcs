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
                   java.io.Serializable"%>
<cs:ftcs><%-- COR_Aplicaciones/Migracion/COR_CTR_ConsultaConTraslados


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
			System.out.println("***_*** ENTRA EN COR_CTR_ConsultaConTraslados");
		}

//========================================================
// Variables entrada formulario
//=============================
String strDni = ics.GetVar("DNI");
String strNip = ics.GetVar("NIP");
String strTabla="CTR_Solicitantes";
String strTabla2="CTR_Solicitudes";
String strTabla3="CTR_Concurso_Traslados_Puestos";
String strTabla4="CTR_Concurso_Traslados_Ofertas";
String wTmp = "";
String wProvincia = "";
String wLocalidad = "";
String wPuesto = "";
String wDesc_Unidad = "";
String wSiNo = "";
//========================================================
//Variables de salida
//===================
ArrayList <String> wArray =  new ArrayList<String>();


//========================================================
//Variables Internas
//==================
String strQuery = null;
String strCodigo =null;
String strResultado = null;
String strStringArray =null;

%><ics:logmsg msg="INICIO del LOG de - COR_CTR_ConsultaConTraslados -" severity="info" /><%

	try {
		// Busco el código de solicitud "id_solicitud" en la tabla "Concurso_Traslados_Solicitantes" para buscar con ese código en la tabla
		// "Concurso_Taslados_Silicitudes" que es la lista de solicitudes de traslado realizadas por el usuario.

		strQuery = "SELECT id_solicitud AS num FROM "+strTabla+" WHERE dni="+strDni;

		if (debug){	
			System.out.println("Query: \n  " +strQuery+"\n");
		}
//----------------------------		
		%><render:callelement elementname="correos/webpublica/logica/COR_obtenerSQLNum" scoped="local"><%
			%><render:argument name="strQuery" value='<%=strQuery%>'/><%
			%><render:argument name="strTabla" value='<%=strTabla%>'/><%
		%></render:callelement><%

		strResultado = ics.GetSSVar("strQueryResult");

		if (debug) {
			System.out.println("VALOR DE LA CONSULTA: "+strResultado);
		}
		
		if (strResultado == null || strResultado == "NOROWS")
		{
			if (debug) {
				System.out.println("NO ENCUENTRA EL DNI: "+strResultado);
			}
			System.exit(0);
		}
//-----------------------------
		
		// Busco lista de solicitudes de traslado por codigo de solicitud "id_solicitud" en la tabla "CTR_Solicitudes" que generará un ArrayList
		// con los destinos solicitados

		strQuery = "SELECT orden, cod_unidad, id_puesto, aportacion_local FROM "+strTabla2+" WHERE id_solicitud="+strResultado+" ORDER BY orden";

		if (debug){	
			System.out.println("Query: \n  " +strQuery+"\n");
		}
				
		%><ics:sql sql="<%=strQuery%>" listname="wRecordset" table="<%=strTabla2%>" /><%

		if(ics.GetErrno()!=0){
				System.out.println("Error BBDD Num: "+ics.GetErrno());
				System.exit(0);
		}
//-------------------------------------------------------------------------------------------------------------------------------------------------		
// LOOP de montaje de la lista de solicitudes de traslado del solicitante		
//-------------------------------------------------------------------------------------------------------------------------------------------------
			strStringArray = "";
			%><ics:listloop listname="wRecordset">
			<ics:listget listname="wRecordset" fieldname="orden" output="ORDEN"/>
			<ics:listget listname="wRecordset" fieldname="cod_unidad" output="UNIDAD"/>
			<ics:listget listname="wRecordset" fieldname="id_puesto" output="PUESTO"/>	
			<ics:listget listname="wRecordset" fieldname="aportaLocal" output="APORTA_LOCAL"/><%
				
				
				//Extraer PUESTO -----------------------		
				wTmp = ics.GetVar("PUESTO");
				strQuery = "SELECT desc_puesto AS num FROM "+strTabla3+" WHERE id_puesto="+wTmp; //Descripcion del puesto
				%><render:callelement elementname="correos/webpublica/logica/COR_obtenerSQLNum" scoped="local"><%
					%><render:argument name="strQuery" value='<%=strQuery%>'/><%
					%><render:argument name="strTabla" value='<%=strTabla3%>'/><%
				%></render:callelement><%
				wPuesto = ics.GetSSVar("strQueryResult");
				if (debug){	
					System.out.println("Query: \n  " +strQuery+"\n");
					System.out.println("wPuesto: \n  " +wPuesto+"\n");
				}				
				//-----------------------------
				
				//Extraer PROVINCIA -----------------------		
				wTmp = ics.GetVar("UNIDAD");
				strQuery = "SELECT descripcion AS num FROM "+strTabla4+" WHERE unidad="+wTmp; //Nombre de la provincia
				%><render:callelement elementname="correos/webpublica/logica/COR_obtenerSQLNum" scoped="local"><%
					%><render:argument name="strQuery" value='<%=strQuery%>'/><%
					%><render:argument name="strTabla" value='<%=strTabla4%>'/><%
				%></render:callelement><%
				wProvincia = ics.GetSSVar("strQueryResult");
				if (debug){	
					System.out.println("Query: \n  " +strQuery+"\n");
					System.out.println("wProvincia: \n  " +wProvincia+"\n");
				}				
				//-----------------------------

				//Extraer LOCALIDAD -----------------------		
				wTmp = ics.GetVar("UNIDAD");
				strQuery = "SELECT localidad_ine AS num FROM "+strTabla4+" WHERE unidad="+wTmp; //Nombre de la Localidad
				%><render:callelement elementname="correos/webpublica/logica/COR_obtenerSQLNum" scoped="local"><%
					%><render:argument name="strQuery" value='<%=strQuery%>'/><%
					%><render:argument name="strTabla" value='<%=strTabla4%>'/><%
				%></render:callelement><%
				wLocalidad = ics.GetSSVar("strQueryResult");
				if (debug){	
					System.out.println("Query: \n  " +strQuery+"\n");
					System.out.println("wLocalidad: \n  " +wLocalidad+"\n");
				}
				//-----------------------------

				//Extraer UNIDAD -----------------------		
				wTmp = ics.GetVar("UNIDAD");
				strQuery = "SELECT descripcion_unidad AS num FROM "+strTabla4+" WHERE unidad="+wTmp; //Descripcion de la UNIDAD
				%><render:callelement elementname="correos/webpublica/logica/COR_obtenerSQLNum" scoped="local"><%
					%><render:argument name="strQuery" value='<%=strQuery%>'/><%
					%><render:argument name="strTabla" value='<%=strTabla4%>'/><%
				%></render:callelement><%
				wDesc_Unidad = ics.GetSSVar("strQueryResult");
				if (debug){	
					System.out.println("Query: \n  " +strQuery+"\n");
					System.out.println("wDesc_Unidad: \n  " +wDesc_Unidad+"\n");
				}
				//-----------------------------
				 
				//Compongo texto de Aportación Local -----------------------	
				 if (Boolean.parseBoolean(ics.GetVar("APORTA_LOCAL")))
				 {
					 wSiNo = "Si";
				 }
				 else
				 {
					 wSiNo = "No";
				 }
				 
				strStringArray = strStringArray + (ics.GetVar("ORDEN") + ";" + wProvincia + ";" + wLocalidad + ";" + wDesc_Unidad + ";" + wPuesto + ";" + wSiNo + "|");
				if (debug){	
					System.out.println("strStringArray: \n  " +strStringArray+"\n");
				}
			//wArray.add(strCodigo);
			%></ics:listloop><%

		//ics.SetObj("ARRAY",wArray);
		
		
		if (debug){	
			System.out.println("ANTES DE SALIR DE ConsultaConTraslados \n");
			System.out.println("Contenido del String de salida strStringArray:  \n" +strStringArray);
		}
		ics.SetVar("STR_ARRAY", strStringArray); 
		if (debug){	
			System.out.println("DESPUES del SetVar   ***** \n");
		}	
		
		ics.RemoveVar("strQuery");
		ics.RemoveVar("strTabla");
		ics.RemoveVar("strTabla2");
		
	} catch (Exception ex){
		%>
			<ics:logmsg msg="ERROR wArray " severity="error" />
			<ics:callelement element='COR_Aplicaciones/PaginaError' />
			<ics:logmsg msg='<%=ex.toString()%>' severity="error"/>
		<%
	} 
		
		/*
		strQuery = "SELECT distinct (CTR_Concurso_Traslados_Puestos.desc_puesto), CTR_Concurso_Traslados_Mapeos.codigo_puesto FROM CTR_Concurso_Traslados_Ofertas INNER JOIN CTR_Concurso_Traslados_Puestos ON CTR_Concurso_Traslados_Ofertas.TIPO_UNIDAD = CTR_Concurso_Traslados_Puestos.tipoUnidad INNER JOIN CTR_Concurso_Traslados_Mapeos ON CTR_Concurso_Traslados_Puestos.id_puesto = CTR_Concurso_Traslados_Mapeos.id_puesto WHERE (Provincia = "+strCodProvincia+") AND (Localidad_INE = "+strCodLocalidad+") AND (Unidad = "+strCodUnidad+") ORDER BY desc_puesto";
		*/
	%>
	<ics:logmsg msg="FIN del LOG de - COR_CTR_ConsultaConTraslados -" severity="info" />
</cs:ftcs>
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
<cs:ftcs><%-- COR_Aplicaciones/Migracion/COR_CTR_SelectPuestos


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
			System.out.println("***_*** ENTRA EN COR_CTR_SelectPuestos");
		}
// Variables entrada formulario
//========================================================
String strCodProvincia = ics.GetVar("ctr_provincia");
String strCodLocalidad = ics.GetVar("ctr_localidad");
String strCodUnidad = ics.GetVar("ctr_unidad");
String strTabla="CTR_Concurso_Traslados_Puestos";

//Variables de salida
//========================================================
ArrayList <String> listaPuestos =  new ArrayList<String>();

//Variables Internas
//========================================================
String strQuery = null;
String strCodigo =null;

%><ics:logmsg msg="INICIO SelectUnidades " severity="info" /><%

	try {

/*	
SELECT distinct(CTR_Concurso_Traslados_Puestos.desc_puesto), CTR_Concurso_Traslados_Mapeos.codigo_puesto FROM CTR_Concurso_Traslados_Ofertas INNER JOIN  CTR_Concurso_Traslados_Puestos ON CTR_Concurso_Traslados_Ofertas.TIPO_UNIDAD = CTR_Concurso_Traslados_Puestos.tipoUnidad INNER JOIN CTR_Concurso_Traslados_Mapeos ON CTR_Concurso_Traslados_Puestos.id_puesto = CTR_Concurso_Traslados_Mapeos.id_puesto WHERE (Provincia = @Provincia) AND (Localidad_INE = @Localidad) AND (Unidad = @unidad) AND (CTR_Concurso_Traslados_Mapeos.visible_todos <> @FiltroPuestos) ORDER BY desc_puesto
*/

	
		strQuery = "SELECT distinct (CTR_Concurso_Traslados_Puestos.desc_puesto), CTR_Concurso_Traslados_Mapeos.codigo_puesto FROM CTR_Concurso_Traslados_Ofertas INNER JOIN CTR_Concurso_Traslados_Puestos ON CTR_Concurso_Traslados_Ofertas.tipo_unidad = CTR_Concurso_Traslados_Puestos.tipounidad INNER JOIN CTR_Concurso_Traslados_Mapeos ON CTR_Concurso_Traslados_Puestos.id_puesto = CTR_Concurso_Traslados_Mapeos.id_puesto WHERE (provincia = "+strCodProvincia+") AND (localidad_ine ='"+strCodLocalidad+"') AND (unidad ='"+strCodUnidad+"') AND (CTR_Concurso_Traslados_Mapeos.visible_todos <> 'EX') ORDER BY desc_puesto";
		
		// Este filtro del WHERE no sabemos a que se refiere:
		// "AND (CTR_Concurso_Traslados_Mapeos.visible_todos <> @FiltroPuestos)"
		// Ponemos "EX" para pruebas
	
		
		if (debug){	
			System.out.println("***_*** Query: \n  " +strQuery+"\n");
			System.out.println("***_*** CodProvincia: \n  " +strCodProvincia+"\n");
			System.out.println("***_*** CodLocalidad: \n  " +strCodLocalidad+"\n");
			System.out.println("***_*** CodUnidad: \n  " +strCodUnidad+"\n");					
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

			listaPuestos.add(strCodigo);
			//if (debug) System.out.println("\nCARGA LISTA PUESTOS");
			
		%></ics:listloop><%
		ics.SetObj("listaPuestos",listaPuestos);

		
	} catch (Exception ex){
		%>
			<ics:logmsg msg="ERROR SelectPuestos " severity="error" />
			<ics:callelement element='COR_Aplicaciones/PaginaError' />
			<ics:logmsg msg='<%=ex.toString()%>' severity="error"/>
		<%
	} %>
	<ics:logmsg msg="FIN SelectPuestos " severity="info" />
</cs:ftcs>
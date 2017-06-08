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
<cs:ftcs><%-- Page/COR_Aplicaciones/COR_CTR_PageLogin

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
			System.out.println("***_*** ENTRA EN COR_CTR_InsertarTraslados");
		}
//========================================================
//Variables de salida
//===================
//ArrayList <String> wArray =  new ArrayList<String>();


//========================================================
//Variables Internas
//==================
String strQuery = null;
String strCodigo =null;
String strResultado = null;


String strTabla="";
String wTmp = "";
String wSiNo = "";
Integer wContador = 0;
String wJuegoCaracteres="TRWAGMYFPDXBNJZSQVHLCKE";
int wModulo = 0;
int wNif = 0;
char wLetra = 'A';

// Esto no se puede utilizar porque pertecene a la versión 7 de JAVA y se está en un entorno de JAVA 6
//SimpleDateFormat wFormato = new SimpleDateFormat("dd/MM/yyyy");

//========================================================
//BUFFER DE  CTR_Solicitudes (para el INSERT)
//========================================================
Integer CTR_Solicitantes_ID_SOLICITUD = 0;
String CTR_Solicitantes_DNI = ics.GetVar("DNI");
String CTR_Solicitantes_LETRA_DNI = ics.GetVar("LETRA_DNI");
String CTR_Solicitantes_APELLIDO_1 = ics.GetVar("APELLIDO_1");
String CTR_Solicitantes_APELLIDO_2 = ics.GetVar("APELLIDO_2");
String CTR_Solicitantes_NOMBRE = ics.GetVar("NOMBRE");
String CTR_Solicitantes_TELEFONO = ics.GetVar("TELEFONO");
String CTR_Solicitantes_EMAIL = ics.GetVar("EMAIL");
String CTR_Solicitantes_FUNCIONARIO = ics.GetVar("FUNCIONARIO"); 
String CTR_Solicitantes_TIPO_FUNCIONARIO = "";
String CTR_Solicitantes_JORNADAINCOMPLETA = ics.GetVar("JORNADAINCOMPLETA");
String CTR_Solicitantes_CONDICIONADO = ics.GetVar("CONDICIONADO");
String CTR_Solicitantes_DNI_CONDICIONADO = ics.GetVar("DNI_CONDICIONADO");
String CTR_Solicitantes_CONDICIONADO_PADRES = ics.GetVar("CONDICIONADO_PADRES");
String CTR_Solicitantes_CONDICIONADO_HIJOS = ics.GetVar("CONDICIONADO_HIJOS");
Integer CTR_Solicitantes_PROVINCIA_GRABACION = Integer.valueOf(ics.GetVar("PROVINCIA_GRABACION"));
String CTR_Solicitantes_FECHA_REGISTRO = ics.GetVar("FECHA_REGISTRO");
String CTR_Solicitantes_COLECTIVO = "";
String CTR_Solicitantes_ACTIVO = "1";
String CTR_Solicitantes_FECHABAJA = null;
String CTR_Solicitudes_ARRAY = ics.GetVar("ARRAY");


%><ics:logmsg msg="***/*** - INICIO del LOG de - COR_CTR_InsertarConTraslados - ***\/***" severity="info" /><%

	try {
//-------------------------------------------------------------------------------------------------------------------------------------------------		
// GRABACION de Tabla "CTR_Solicitantes"	
//-------------------------------------------------------------------------------------------------------------------------------------------------		
		//-------------------------------------------------------------------------------------------------	
		//Coger ultimo Nº secuencial de id_solicitude para incrementar en 1 y asignar nº a la nueva Solicitud.
		//-------------------------------------------------------------------------------------------------	

		strTabla = "CTR_Solicitantes";
		strQuery = "SELECT MAX(id_solicitud) AS num FROM "+strTabla;  //Leo el valor maximo para añadir 1 y generar nuevo nº 

		if (debug){	
			System.out.println("***_*** Query CTR_Solicitantes: \n  " +strQuery+"\n");
		}
		strResultado = null;
		
		%><render:callelement elementname="correos/webpublica/logica/COR_obtenerSQLNum" scoped="local"><%
			%><render:argument name="strQuery" value='<%=strQuery%>'/><%
			%><render:argument name="strTabla" value='<%=strTabla%>'/><%
		%></render:callelement><%
		strResultado = ics.GetSSVar("strQueryResult");
		if (debug) {
			System.out.println("VALOR DE CONT - antes: "+strResultado);
		}
		
		/*---- Incrementar 1 al contador ---------------------------------------------------------------------------------------------*/

		if (strResultado.equals(null))
		{
			strResultado = "0";
		}

		if (strResultado.equals("NOROWS"))
		{
			wContador = 0;
		}
		else
		{
			wContador = Integer.valueOf(strResultado);
			wContador = wContador + 1;
		}

/**/	CTR_Solicitantes_ID_SOLICITUD = wContador;
		if (debug) {
			System.out.println("VALOR DE CONT - despues: "+CTR_Solicitantes_ID_SOLICITUD);
		}	
		//-------------------------------------------------------------------------------------------------	
		// Calcular letra del DNI
		//-------------------------------------------------------------------------------------------------
		if (debug) {
			System.out.println("VALOR DE DNI: "+CTR_Solicitantes_DNI);
		}
		//---- wNif = Integer.parseInt(CTR_Solicitantes_DNI);
		//---- //wNif = Integer.valueOf(CTR_Solicitantes_DNI);
		//---- if (debug) {
		//---- 	System.out.println("wNif: "+wNif);
		//---- }	
		//---- wModulo= wNif % 23;
		//---- if (debug) {
		//---- 	System.out.println("wModulo: "+wModulo);
		//---- }
		//---- wLetra = wJuegoCaracteres.charAt(wModulo);
/**/	//---- CTR_Solicitantes_LETRA_DNI = Character.toString(wLetra); 
		//---- if (debug) {
		//---- 	System.out.println("CTR_Solicitantes_LETRA_DNI: "+CTR_Solicitantes_LETRA_DNI);
		//---- }

		//-------------------------------------------------------------------------------------------------	
		// Cargar nombre y Apellidos en las variables
		//-------------------------------------------------------------------------------------------------
		// VIENEN YA CARGADOS
/**/	//CTR_Solicitantes_APELLIDO_1 = "Apellido 1";				//Datos fijos para pruebas
/**/	//CTR_Solicitantes_APELLIDO_2 = "Apellido 2";				//Datos fijos para pruebas
/**/	//CTR_Solicitantes_NOMBRE = "Nombre";						//Datos fijos para pruebas

		//-------------------------------------------------------------------------------------------------	
		// Carga Funcionario true/false. Tabla "CTR_Empleados"
		//-------------------------------------------------------------------------------------------------
		strTabla = "CTR_Empleados";
		
		if (debug) {
			System.out.println("strTabla: "+strTabla);
		}

		strQuery = "SELECT colectivo AS num FROM "+strTabla+ " WHERE nif='"+CTR_Solicitantes_DNI + CTR_Solicitantes_LETRA_DNI+"'";
		if (debug){	
			System.out.println("***_*** Query CTR_Empleados: \n  " +strQuery+"\n");
		}
		%><render:callelement elementname="correos/webpublica/logica/COR_obtenerSQLNum" scoped="local"><%
			%><render:argument name="strQuery" value='<%=strQuery%>'/><%
			%><render:argument name="strTabla" value='<%=strTabla%>'/><%
		%></render:callelement><%
		if (debug){	
			System.out.println("***_*** strQueryResult:  " +ics.GetSSVar("strQueryResult"));
		}
		if (ics.GetSSVar("strQueryResult") == "F")
		{
/**/		CTR_Solicitantes_FUNCIONARIO = "1";
		}
		else
		{
/**/		CTR_Solicitantes_FUNCIONARIO = "0";			
		}
/**/	CTR_Solicitantes_COLECTIVO = ics.GetSSVar("strQueryResult");
		if (debug) {
			System.out.println("CTR_Solicitantes_COLECTIVO: "+CTR_Solicitantes_COLECTIVO);
		}

		//-------------------------------------------------------------------------------------------------	
		// Carga Tipo Funcionario. Tabla "CTR_Empleados"
		//-------------------------------------------------------------------------------------------------
		strTabla = "CTR_Empleados";
		strQuery = "SELECT cuerpo AS num FROM "+strTabla+ " WHERE nif='"+CTR_Solicitantes_DNI + CTR_Solicitantes_LETRA_DNI+"'";
		if (debug){	
			System.out.println("***_*** Query CTR_Empleados: \n  " +strQuery+"\n");
		}
		%><render:callelement elementname="correos/webpublica/logica/COR_obtenerSQLNum" scoped="local"><%
			%><render:argument name="strQuery" value='<%=strQuery%>'/><%
			%><render:argument name="strTabla" value='<%=strTabla%>'/><%
		%></render:callelement><%
/**/	CTR_Solicitantes_TIPO_FUNCIONARIO = ics.GetSSVar("strQueryResult");

		//Fecha del sistema
		Calendar wFecha = Calendar.getInstance();
		String wFechaActual = wFecha.get(Calendar.DAY_OF_MONTH) + "/" + (wFecha.get(Calendar.MONTH) + 1) + "/" + wFecha.get(Calendar.YEAR);

		//-------------------------------------------------------------------------------------------------	
		// INSERT. Tabla "CTR_Solicitantes"
		//-------------------------------------------------------------------------------------------------
		strTabla = "CTR_Solicitantes";
		strQuery = "INSERT INTO "+strTabla+" (id_solicitud,dni,letra_dni,apellido_1,apellido_2,nombre,telefono,email,funcionario,tipo_funcionario,jornadaincompleta,condicionado,dni_condicionado,condicionadopadres,condicionadohijos,provincia_grabacion,fecha_registro,colectivo,activo,fechabaja) ";
		strQuery = strQuery + " values ("+CTR_Solicitantes_ID_SOLICITUD +",\'"+ CTR_Solicitantes_DNI  +"\',\'"+ CTR_Solicitantes_LETRA_DNI  +"\',\'"+ CTR_Solicitantes_APELLIDO_1  +"\',\'"+ CTR_Solicitantes_APELLIDO_2  +"\',\'"+ CTR_Solicitantes_NOMBRE +"\',\'"+ CTR_Solicitantes_TELEFONO  +"\',\'"+ CTR_Solicitantes_EMAIL  +"\',\'"+ CTR_Solicitantes_FUNCIONARIO +"\',\'"+ CTR_Solicitantes_TIPO_FUNCIONARIO  +"\',\'"+ CTR_Solicitantes_JORNADAINCOMPLETA+"\',\'"+ CTR_Solicitantes_CONDICIONADO  +"\',\'"+ CTR_Solicitantes_DNI_CONDICIONADO  +"\',\'"+ CTR_Solicitantes_CONDICIONADO_PADRES  +"\',\'"+ CTR_Solicitantes_CONDICIONADO_HIJOS  +"\',"+ CTR_Solicitantes_PROVINCIA_GRABACION  +",\'"+ CTR_Solicitantes_FECHA_REGISTRO  +"\',\'"+ CTR_Solicitantes_COLECTIVO  +"\',\'"+ CTR_Solicitantes_ACTIVO +"\',\'" + CTR_Solicitantes_FECHABAJA +"\')";	
		
		if (debug)	System.out.println("Sentencia SQL del INSERT de CTR_Solicitantes: "+ strQuery );
		
		%><ics:sql sql='<%=strQuery%>' listname="sqlresult" table='<%=strTabla%>' /><%
		
		// Revisar esto
		//ics.SetSSVar("OK_KO","true");
		//if (debug){	
		//	System.out.println("***_*** Respuesta OK/KO: \n  " +ics.GetVar("OK_KO")+"\n");
		//}
		
		
//-------------------------------------------------------------------------------------------------------------------------------------------------		
// LOOP de lectura del ARRAY de solicitudes de destino (TRASLADOS) para grabar en tabla "CTR_Solicitudes"	
//-------------------------------------------------------------------------------------------------------------------------------------------------
		if (debug) {
			System.out.println("String/Array: "+CTR_Solicitudes_ARRAY);
		}
		
		Integer i = 0;
		Integer j = 0;

		//-----------------------------
		//Conversion de String a Array 
		//-----------------------------
		String [] wArrayFilas = CTR_Solicitudes_ARRAY.split("#");	
		Integer wFilas = wArrayFilas.length;
		Integer wCol = 8;
		String [][] matrix = new String[wFilas][wCol];
		if (debug){	
			System.out.println("***_*** wFilas :" + wFilas);
			System.out.println("***_*** wCol :" + wCol);			
		}		
		for (j = 0; j < wFilas; j++) 
		{
			System.out.println("valor del array: " + wArrayFilas[j]);
			if (debug){	
				System.out.println("***_*** recorre j :" + j);
			}		
			matrix[j] = wArrayFilas[j].split(";");
		}
		if (debug){	
			System.out.println("***_*** Sale del LOOP Array \n");
		}
		//-----------------------------
		//BUCLE for para recorrer el string/array y grabar registros. Bucle de Grabacion.
		//-----------------------------
		for (j = 0; j < wFilas; j++) 
		{
		if (debug){	
			System.out.println("***_*** Inicio LOOP Grabacion \n");
		}
			//-------------------------------------------------------------------------------------------------	
			// INSERT. Tabla "CTR_Solicitudes"
			//-------------------------------------------------------------------------------------------------
			strTabla = "CTR_Solicitudes";
			strQuery = "INSERT INTO "+strTabla+" (id_solicitud,orden,cod_unidad,id_puesto,aportacion_local)";
			strQuery = strQuery +" values ("+CTR_Solicitantes_ID_SOLICITUD +","+ Integer.valueOf(matrix[j][0]) +","+ Integer.valueOf(matrix[j][6]) +",\'"+ matrix[j][7] +"\',\'"+ matrix[j][5]+"\')";	
			
			if (debug)	System.out.println("Sentencia SQL del INSERT de CTR_Solicitudes: "+ strQuery );
			
			%><ics:sql sql='<%=strQuery%>' listname="sqlresult" table='<%=strTabla%>' /><%
			ics.SetSSVar("OK_KO","true");
		}
		if (debug){	
			System.out.println("***_*** Fin LOOP Grabacion \n");
		}		
		
	
		
//- FIN LOOP ---------------------------------------------------------------------------------------------------------------------------------------		


	} catch (Exception ex){
		%>
			<ics:logmsg msg="ERROR wArray " severity="error" />
			<ics:callelement element='COR_Aplicaciones/PaginaError' />
			<ics:logmsg msg='<%=ex.toString()%>' severity="error"/>
		<%
	} 
	%>
	<ics:logmsg msg="FIN del LOG de - COR_CTR_InsertarTraslados -" severity="info" />
</cs:ftcs>
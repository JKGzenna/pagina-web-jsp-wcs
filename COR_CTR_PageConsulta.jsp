<!------------------------------------------------------------------------------------------------------------------------------------------------------ -->
<!-- BLOQUE WEBCENTER SITES ---------------------------------------------------------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------------------------------------------------------------------------------- -->
								
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="javax.servlet.http.HttpServletRequest"
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
				   java.lang.System.*,				   
				   java.util.Arrays,
				   java.lang.String,
				   java.io.*,
				   java.net.HttpURLConnection,
				   java.net.URL,
				   org.apache.commons.io.IOUtils,
				   es.correos.webpublica.web.fatwire.app.*,
				   java.util.Calendar,
                   java.io.Serializable"%>
<cs:ftcs>
<%-- Aplicacion_C/COR_CTR_PageConsulta

INPUT

OUTPUT

--%>

<%
//=====================
// Variables de control
//=====================
boolean debug = false;
		if (debug){	
			System.out.println("***_*** ENTRA EN COR_CTR_PageConsulta");
		}
//
String ctr_dni = ics.GetVar("ctr_dni");
String ctr_nip = ics.GetVar("ctr_nip");
String ctr_boton = ics.GetVar("ctr_boton");
String enviadoFormulario = ics.GetVar("enviadoFormulario");


if (debug){	
	System.out.println("ctr_dni: " +ctr_dni+"\n");
	System.out.println("ctr_nip: " +ctr_nip+"\n");			
}
%>
	<!-- <P>ENTRA EN LA LLAMADA A  COR_CTR_ConsultaConTraslado s</P> -->
	<render:callelement elementname="COR_Aplicaciones/Migracion/COR_CTR_ConsultaConTraslados" scoped="global">
		<render:argument name="DNI" value='<%=ics.GetVar("ctr_dni")%>' />
		<render:argument name="NIP" value='<%=ics.GetVar("ctr_nip")%>' />
	</render:callelement>

	<!-- <P>SALE DE COR_CTR_ConsultaConTraslados</P> -->
<%
String wStrArray = ics.GetVar("STR_ARRAY");
if (debug){	
	System.out.println("wStrArray: \n  " +wStrArray+"\n");
}


if (Utilities.goodString(enviadoFormulario) && "yes".equals(enviadoFormulario) ) 
{
	if ( ctr_boton.equals("Eliminar") ) 
	{
		enviadoFormulario = "";
		%>
		<render:callelement elementname="COR_Aplicaciones/Migracion/COR_CTR_EliminarTraslados" scoped="global">
			<render:argument name="DNI" value='<%=ctr_dni%>' />
		</render:callelement>		
		<%
	}

	if ( ctr_boton.equals("Imprimir") ) 		
	{
		enviadoFormulario = "";
		// ¡¡¡¡¡¡ PENDIENTE DE CREAR EL CSELEMENT
	}
}
%>			
		
<!-- INICIO -------------------------------------------------------------------------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------------------------------------------------------------------------------- -->
<!-- INSERTAR CODIGO JSP AQUI------------------------------------------------------------------------------------------------------------------------------- -->


<!-- <body text="#000000" bgcolor="#abffed" link="#0000ff" vlink="#ff0000" alink="#000088" onload="regenerateTable();"> -->

<body class="bgFondo" onload="CargadorTabla('<%=wStrArray%>');">
<satellite:form name="frm" method="POST" action="#">

     <img src="/COREstaticos/img/Cabecera.jpg" align="bottom" style="padding:0px;margin:0px;vertical-align:bottom;"/>
     <img src="/COREstaticos/img/Pestania.jpg" align="top" style="padding:0px;margin:0px;vertical-align:top;" />
     <div style="position:static; display:inline-block;">
  
      
                <table border="0" cellspacing="0" cellpadding="0" width="985px" align="left" class="estiloTabla">
                    <tr>
                       <td colspan="3" class="filaCabecera" style="height: 30px">&nbsp;</td>
                    </tr>
      <div id="divDatosPersonales" visible="false" runat="server">
        <table width="304" height="33" border ="0"  cellpadding="1" cellspacing="1" class="estiloTabla" style="width: 93%; height: 34px">
                          <tr>
                            <td width="1300" height="31" colspan="2" bgcolor="#CECFCE" class="txtDest" style="width: 70px;"><span class="titulos"><strong>Datos profesionales</strong></span></tr>
                          <br />
                          <br />
        </table>
        
		
		
		
		
		<div id="divDatosPersonales2" visible="false">
		            <table width="1300" height="33" border ="1"  cellpadding="1" cellspacing="1" class="estiloTabla" style="width: 93%; height: 34px">
              <tr>
                <td width="1300" height="31" colspan="2" bgcolor="#D6EBFF" class="txtDest" style="width: 70px;"><span class="txtNegrita" style="width: 150px; display: inline-block"><strong>Peticiones de destino</strong></span>                
              </tr>
              <br />
              <br />
            </table>
            <table width="1300">
              <tr bgcolor="#D6EBFF">
                <td colspan="8" bgcolor="#F7F7F7">&nbsp;</td>
              </tr>
				<table id="objTable" width="87%" border="1">
				  <tr align="center" bgcolor="#F7F7F7">
					<td width="85" color="#ff9933">Orden</td>
					<td width="250">Provincia</td>
					<td width="300">Localidad</td>
					<td width="200">Unidad</td>
					<td width="200">Puesto</td>
					<td width="60">Aportación Local</td>
					<td width="100">&nbsp;</td>
				  </tr>
				</table>  
            </table>
		</div>

		
		
<table style="display:none">
<tr><td><b>Fields</b></td><td><input type="text" name="field"><br></td><td>   <!--   <input type="button" value="Negrita" onclick="cambiotexto()"></td></tr> -->
<tr><td><b>Type</b></td><td><input type="text" name="type"><br></td></tr>
<tr><td><b>Utility</b></td><td><input type="text" name="utility"><br></td></tr>
<tr><td><b>Values</b></td><td><textarea name="values" onKeyPress="checkEnterKey();"></textarea><br></td></tr>
<tr><td><b>Puesto</b></td><td><input type="text" name="Puesto"><br></td></tr>
<tr><td><b>Aportacion Local</b></td><td><input type="text" name="AportacionLocal"><br></td></tr>
</table>

<input type="hidden" name="rowIndex"><br>

         
				  
<!-- Botón Salir -->	

	<table width="1300">
		<tr bgcolor="#D6EBFF">
			<td colspan="8" bgcolor="#F7F7F7">
				<input type="submit" name="btnSalir" id="btnSalir" value="Salir" onClick="">
				<input type="submit" name="ctr_boton"   id="ctr_boton"   value="Imprimir" onClick="ImprimirSolicitud(this.value)">
				<input type="submit" name="ctr_boton"   id="ctr_boton"   value="Eliminar" onClick="EliminarSolicitud(this.value)">
			</td>
		</tr>
		<tr>
		<div id="pnlClausuraProteccionDatos2"> <span id="lblClausuraProteccionDatos2">
			El   peticionario autoriza expresamente a Correos y Telégrafos S.A. para que   los datos recogidos en este formulario de grabación de peticiones, así   como los que sean proporcionados en el futuro, queden incorporados a la   base de datos de Recursos Humanos, cuyo titular responsable es la   Sociedad Estatal Correos y Telégrafos, S.A. para la gestión de los   procesos de selección y promoción. El peticionario de acuerdo con la   normativa vigente en materia de protección de datos, tiene la   posibilidad de ejercitar los derechos de acceso, rectificación,   oposición y cancelación sobre sus datos personales, dirigiendo   comunicación escrita a la Dirección de Recursos Humanos en la dirección   que se expresa a continuación: Vía Dublín, 7, 28070 Madrid.
		</div>			
		</tr>  
	</table>

	
	<input type="hidden" name="enviadoFormulario" id="enviadoFormulario" value="yes" />	
	
</satellite:form>

</body>


<link rel="stylesheet" type="text/css" href="ConcursoTraslados.css" />
<script type="text/javascript" src="http://www.correos.es/COREstaticos/js/stats.min.js"></script>
<script type="text/javascript" language="javascript1.2">
/* -------------------------------------------------------- 
   VARIABLES GLOBALES 
-----------------------------------------------------------*/
var matrizLineas = [];

//for (i = 0; i < 5; i++)
//{
//	arraySolicitudes[i]=new Array(6);
//}

/*----------------------------------------------------------*/
/*FUNCION PARA CARGAR FILAS EN TABLA "PETICIONES DE DESTINO       */
/*----------------------------------------------------------*/
  
function CargadorTabla(wStringArray) 
{
	var i = 0;
	var wFilas = [];
	wFilas = wStringArray.split('|');
	for (i = 0; i < wFilas.length; i++) 
	{
		matrizLineas[i] = wFilas[i].split(';');
	}	
	regenerarTabla();
}

/*----------------------------------------------------------*/
/*FUNCION PARA AÑADIR FILAS EN "PETICIONES DE DESTINO       */
/*----------------------------------------------------------*/

function add() 
{

alert("Metodo add");
	// Con esto se captura el VALUE de las "Select"

	var wPosicion=null;
	var wProvincia="";
	var wLocalidad="";
	var wUnidad="";
	var wPuesto="";
	wPosicion=document.getElementById("ctr_provincia").options.selectedIndex; //posicion
	wProvincia = document.getElementById("ctr_provincia").options[wPosicion].text;

	wPosicion=document.getElementById("ctr_localidad").options.selectedIndex; //posicion
	wLocalidad = document.getElementById("ctr_localidad").options[wPosicion].text;

	wPosicion=document.getElementById("ctr_unidad").options.selectedIndex; //posicion
	wUnidad = document.getElementById("ctr_unidad").options[wPosicion].text;

	wPosicion=document.getElementById("ctr_puesto").options.selectedIndex; //posicion
	wPuesto = document.getElementById("ctr_puesto").options[wPosicion].text;

	matrizLineas.push(new Array("Nº Orden", wProvincia,wLocalidad,wUnidad,wPuesto,"Aport.Local"));
	regenerarTabla();
	
}	

/*----------------------------------------------------------*/
/*FUNCION PARA REGENERAR TABLA DE "PETICIONES DE DESTINO"   */
/*----------------------------------------------------------*/  

function regenerarTabla() 
{
	var row = 0;
	var col = 0;

	while (objTable.rows.length>1)
		objTable.deleteRow(1);

	for (row=0;row<matrizLineas.length;row++) 
	{
		var objRow = objTable.insertRow();
		var objCell;
		for (col=0; col<6; col++) 
		{
				objCell = objRow.insertCell();
				objCell.innerText = matrizLineas [row][col];
				}
		objCell = objRow.insertCell();
		//objCell.innerHTML = '<center><img src="edit.gif" onClick="edit('+row+');" alt="modificar fila">';
	}
	
}

/*----------------------------------------------------------*/
/*FUNCION PREGUNTA ANTES DE IMPRIMIR                    */
/*----------------------------------------------------------*/
  
function ImprimirSolicitud(wBoton) 
{
	var trueFalse = confirm('Va a Imprimir su solicitud. ¿Está usted seguro?.');
	if (!trueFalse)
	{
		alert(trueFalse);
		return false;
	}
}

/*----------------------------------------------------------*/
/*FUNCION PREGUNTA ANTES DE ELIMINAR                     */
/*----------------------------------------------------------*/
  
function EliminarSolicitud(wBoton) 
{
	var trueFalse = confirm('Va a Eliminar su solicitud. ¿Está usted seguro?.');
	if (!trueFalse)
	{
		alert(trueFalse);
		return false;
	}
}
</script>
<!-- FIN ----------------------------------------------------------------------------------------------------------------------------------------------- -->
<!-- BLOQUE PARA PRUEBAS HTML -------------------------------------------------------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------------------------------------------------------------------------------- -->


<!------------------------------------------------------------------------------------------------------------------------------------------------------ -->
<!-- BLOQUE WEBCENTER SITES ---------------------------------------------------------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------------------------------------------------------------------------------- -->
</cs:ftcs>
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
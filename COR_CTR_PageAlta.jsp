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
<%-- Aplicacion_C/COR_CTR_PageAlta

INPUT

OUTPUT

--%>
<!-- --------------------------------------------------------------------------------------------------------------------------------------------------- -->

<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'>
	<ics:then>
		<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
	</ics:then>
</ics:if>
<asset:load name="currentPage" type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>' />

<!-- //RECUPERO PARÁMETROS DE CONFIGURACIÓN -->
<asset:load name="urldelsitio" type="Configuracion" field="name" value="URL_ServerName" />
<asset:get name="urldelsitio" field="valor" output="rutainicial"/>

<!-- INICIO -------------------------------------------------------------------------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------------------------------------------------------------------------------- -->
<%
//=====================
// Variables de control
//=====================
	boolean debug = true;
		if (debug){	
			System.out.println("***_*** ENTRA EN COR_CTR_PageAlta");
		}
//========================================================
//Parametros del Formulario
//========================================================
String sidioma = ics.GetVar("sidioma");
String site = ics.GetVar("site");
String p = ics.GetVar("p");
String c = ics.GetVar("c");
String cid = ics.GetVar("cid");
String sPathStatic = ics.GetVar("sPathStatic");

String wctr_provincia = (ics.GetVar("ctr_provincia") != null) ? ics.GetVar("ctr_provincia") : "";
String wctr_localidad = (ics.GetVar("ctr_localidad") != null) ? ics.GetVar("ctr_localidad") : "";
String wctr_unidad = (ics.GetVar("ctr_unidad") != null) ? ics.GetVar("ctr_unidad") : "";
String wctr_puesto = (ics.GetVar("ctr_puesto") != null) ? ics.GetVar("ctr_puesto") : "";

//--------------------------------------------------------
// 	esto es para hacer pruebas, antes de preparar la 
//	recarga automática de de cada combo en funcion de
//  la anterior.

wctr_provincia="7"; 
wctr_localidad="E.R. DE VITORIA-GASTEIZ"; 
wctr_unidad="1";
wctr_puesto="1"; 	
//--------------------------------------------------------


//========================================================
//BUFFER DE  CTR_Solicitantes (para el INSERT)
//========================================================
String CTR_Solicitantes_NIP = (ics.GetVar("ctr_nip") != null) ? ics.GetVar("ctr_nip") : "";
String CTR_Solicitantes_DNI = (ics.GetVar("ctr_dni") != null) ? ics.GetVar("ctr_dni") : "";
String CTR_Solicitantes_LETRA_DNI = (ics.GetVar("ctr_letra_dni") != null) ? ics.GetVar("ctr_letra_dni") : "";
String CTR_Solicitantes_NOMBRE = (ics.GetVar("ctr_nombre") != null) ? ics.GetVar("ctr_nombre") : "";
String CTR_Solicitantes_APELLIDO_1 = (ics.GetVar("ctr_apellido_1") != null) ? ics.GetVar("ctr_apellido_1") : "";
String CTR_Solicitantes_APELLIDO_2 = (ics.GetVar("ctr_apellido_2") != null) ? ics.GetVar("ctr_apellido_2") : "";
String CTR_Solicitantes_FUNCIONARIO = (ics.GetVar("ctr_funcionario") != null) ? ics.GetVar("ctr_funcionario") : "";
String CTR_Solicitantes_TELEFONO = (ics.GetVar("ctr_movil") != null) ? ics.GetVar("ctr_movil") : "";
String CTR_Solicitantes_EMAIL = (ics.GetVar("ctr_email") != null) ? ics.GetVar("ctr_email") : "";
String CTR_Solicitantes_JORNADAINCOMPLETA = (ics.GetVar("ctr_jornadaincompleta") != null) ? ics.GetVar("ctr_jornadaincompleta") : "";
String CTR_Solicitantes_CONDICIONADO = (ics.GetVar("ctr_condicionado") != null) ? ics.GetVar("ctr_condicionado") : "";
String CTR_Solicitantes_DNI_CONDICIONADO = (ics.GetVar("ctr_dni_condicionado") != null) ? ics.GetVar("ctr_dni_condicionado") : "";
String CTR_Solicitantes_CONDICIONADO_PADRES = (ics.GetVar("ctr_condicionado_padres") != null) ? ics.GetVar("ctr_condicionado_padres") : "";
String CTR_Solicitantes_CONDICIONADO_HIJOS = (ics.GetVar("ctr_condicionado_hijos") != null) ? ics.GetVar("ctr_condicionado_hijos") : "";
String CTR_Solicitantes_PROVINCIA_GRABACION = (ics.GetVar("ctr_provincia_grabacion") != null) ? ics.GetVar("ctr_provincia_grabacion") : "";
String CTR_Solicitantes_FECHA_REGISTRO = (ics.GetVar("ctr_fecha_registro") != null) ? ics.GetVar("ctr_fecha_registro") : "";
String CTR_Solicitudes_ARRAY = (ics.GetVar("ctr_array") != null) ? ics.GetVar("ctr_array") : "";
//========================================================	
//Arrays de COMBOS	
//========================================================
ArrayList<String> listaProvincias = null;				
ArrayList<String> listaLocalidades = null;	
ArrayList<String> listaUnidades = null;	
ArrayList<String> listaPuestos = null;	

String wArraySubStrings[] = null; 	 
//	

String urlformulario =  ics.GetVar("rutainicial");

Boolean noErrorValidacion = true; // Variable para especificar si se validan las entradas.
Boolean fLoad = true;

//Parámetros del login

String enviadoFormulario = ics.GetVar("enviadoFormulario");
String ctr_boton = ics.GetVar("ctr_boton");




// Logica Validacion Formulario por Servidor

if (Utilities.goodString(enviadoFormulario) && "yes".equals(enviadoFormulario) ) 
{
	// VALIDACIÓN JAVA
	
	if ( ctr_boton.equals("Guardar") ) 
	{
		if (debug){	
			System.out.println("***_*** ANTES DE ENTRAR A LLAMADA A - COR_CTR_InsertarTraslados");
		}
		
		
		//////////      ¡¡¡ojo!!!  QUITAR ----------------------------
		
		// CTR_Solicitantes_DNI = "22222222";
		// CTR_Solicitantes_NIP = "'222222";
		
		///////// ----------------------------------------------------
		
		
		
		%>
		<render:callelement elementname="COR_Aplicaciones/Migracion/COR_CTR_InsertarTraslados" scoped="global">
			<render:argument name="DNI" value='<%=CTR_Solicitantes_DNI%>' />
			<render:argument name="LETRA_DNI" value='<%=CTR_Solicitantes_LETRA_DNI%>' />
			<render:argument name="NOMBRE" value='<%=CTR_Solicitantes_NOMBRE%>' />
			<render:argument name="APELLIDO_1" value='<%=CTR_Solicitantes_APELLIDO_1%>' />				
			<render:argument name="APELLIDO_2" value='<%=CTR_Solicitantes_APELLIDO_2%>' />				
			<render:argument name="FUNCIONARIO" value='<%=CTR_Solicitantes_FUNCIONARIO%>' />										
			<render:argument name="TELEFONO" value='<%=CTR_Solicitantes_TELEFONO%>' />
			<render:argument name="EMAIL" value='<%=CTR_Solicitantes_EMAIL%>' />
			<render:argument name="JORNADAINCOMPLETA" value='<%=CTR_Solicitantes_JORNADAINCOMPLETA%>' />
			<render:argument name="CONDICIONADO" value='<%=CTR_Solicitantes_CONDICIONADO%>' />
			<render:argument name="DNI_CONDICIONADO" value='<%=CTR_Solicitantes_DNI_CONDICIONADO%>' />			
			<render:argument name="CONDICIONADO_PADRES" value='<%=CTR_Solicitantes_CONDICIONADO_PADRES%>' />			
			<render:argument name="CONDICIONADO_HIJOS" value='<%=CTR_Solicitantes_CONDICIONADO_HIJOS%>' />	
			<render:argument name="PROVINCIA_GRABACION" value='<%=CTR_Solicitantes_PROVINCIA_GRABACION%>' />				
			<render:argument name="FECHA_REGISTRO" value='<%=CTR_Solicitantes_FECHA_REGISTRO%>' />				
			<render:argument name="ARRAY" value='<%=CTR_Solicitudes_ARRAY%>' />
		</render:callelement>		
		<%
	}
}
		
%>		


<!-----------------------------------------------------------------------------------------
LLAMADA A CSELEMENT PARA CALCULAR LA URL
------------------------------------------------------------------------------------------->
		<render:callelement elementname="correos/webpublica/logica/COR_calcularUrl" scoped="global">
			<render:argument name="sTemplateName" value='/COR_Layout' />
			<render:argument name="sWrapperName" value="COR_Wrapper" />
			<render:argument name="sidioma" value='<%=sidioma%>' />
			<render:argument name="c" value='<%=c%>' />
			<render:argument name="cid" value='<%=cid%>' />
			<render:argument name="site" value='<%=site%>' />
			<render:argument name="p" value='<%=p%>' />
			<render:argument name="sVarUrl" value='laUrl' />
		</render:callelement>
<!-- --------------------------------------------------------------------------------------->		
<%	
	urlformulario = urlformulario + ics.GetVar("laUrl");
%><body class="bgFondo" onload="EnableDisableCampos('<%=CTR_Solicitantes_NIP%>');">
<satellite:form id="FormularioAlta" action='<%=urlformulario%>' method="POST">
   
	<!--
	<P>URL: <%=urlformulario%></P>
    -->
   
     <img src="/COREstaticos/img/Cabecera.jpg" align="bottom" style="padding:0px;margin:0px;vertical-align:bottom;"/>
     <img src="/COREstaticos/img/Pestania.jpg" align="top" style="padding:0px;margin:0px;vertical-align:top;" />
     <div style="position:static; display:inline-block;">

            <ContentTemplate>
		<table border="0" cellspacing="0" cellpadding="0" width="985px" align="left" class="estiloTabla">
			<tr>
			   <td colspan="3" class="filaCabecera" style="height: 30px">&nbsp;</td>
			</tr>
			<div id="divDatosPersonales" visible="false" runat="server">
				<table width="304" height="33" border ="0"  cellpadding="1" cellspacing="1" class="estiloTabla" style="width: 93%; height: 34px">
				  <tr>
					<td width="1300" height="31" colspan="2" bgcolor="#CECFCE" class="txtDest" style="width: 70px;"><span class="titulos"><strong>Rellene los siguientes datos:</strong></span></tr>
				  <br />
				  <br />
		</table>
   		<div id="divDatosPersonales2" visible="false" runat="server">
          <table width="304" height="33" border ="1"  cellpadding="1" cellspacing="1" class="estiloTabla" style="width: 93%; height: 34px">
            <tr>
              <td width="1300" height="31" colspan="2" bgcolor="#D6EBFF" class="txtDest" style="width: 70px;">
				<span class="txtDest" style="width: 70px;">
					<label for="divDatosPersonales7" id="lblDatosPersonales" class="txtNegrita" style="width: 150px; display: inline-block">
						<strong>Datos personales </strong>
					</label>
				</span>              
            </tr>
            <br />
            <br />
          </table>
        </div>     
	<%if (CTR_Solicitantes_NIP.equals("666666") && CTR_Solicitantes_DNI.equals("12345678")) 
	{%>
		<!------------------------------------------->
		<!-- Campos ocultos solo para NIP = 666666 -->
		<!------------------------------------------->

		<div name="Div_Nombre_Apellidos" id="Div_Nombre_Apellidos" >  <!-- style="display:none;" -->
		<table width="1300">
           <tr> 
            <td bgcolor="#F7F7F7">&nbsp;</td> 
            <td width="153" bgcolor="#F7F7F7">Nombre *:</td>
            <td width="400" bgcolor="#F7F7F7"> <input type="text" id="ctr_nombre" name="ctr_nombre" value="<%=CTR_Solicitantes_NOMBRE%>" required /></td>
            <td width="153" bgcolor="#F7F7F7">Primer apellido *:</td>
            <td width="400" bgcolor="#F7F7F7"> <input type="text" id="ctr_apellido_1" name="ctr_apellido_1" value="<%=CTR_Solicitantes_APELLIDO_1%>" required /></td>
            <td width="153" bgcolor="#F7F7F7">Segundo apellido:</td>
            <td width="400" bgcolor="#F7F7F7"> <input type="text" id="ctr_apellido_2" name="ctr_apellido_2" value="<%=CTR_Solicitantes_APELLIDO_2%>"/></td>
          </tr>
           <tr> 
            <td bgcolor="#F7F7F7">&nbsp;</td> 
            <td width="153" bgcolor="#F7F7F7">Nif/Nie *:</td>
            <td width="400" bgcolor="#F7F7F7"> <input type="text" id="ctr_dni" name="ctr_dni" value="<%=CTR_Solicitantes_DNI%>" required /></td>
			<td width="20" bgcolor="#F7F7F7"> <input type="text" id="ctr_letra_dni" name="ctr_letra_dni" value="<%=CTR_Solicitantes_LETRA_DNI%>" required />
            <td width="153" bgcolor="#F7F7F7">Teléfono Móvil *:</td>
            <td width="400" bgcolor="#F7F7F7"> <input type="text" id="ctr_movil" name="ctr_movil" value="<%=CTR_Solicitantes_TELEFONO%>"/></td>
            <td width="153" bgcolor="#F7F7F7">Email:</td>
            <td width="400" bgcolor="#F7F7F7"> <input type="text" id="ctr_email" name="ctr_email" value="<%=CTR_Solicitantes_EMAIL%>" required /></td>
          </tr>
          <tr> 
            <td bgcolor="#F7F7F7">&nbsp;</td> 
            <td width="153" bgcolor="#F7F7F7">Empleado:</td>
            
			<td width="784" bgcolor="#F7F7F7"> <!-- Pendiente de introducir codigo JAVA para seleccionar correctamente el RadioBoton -->
			
				<input type="radio" name="group" id="ctr_funcionario" value="Funcionario"
				<%if (CTR_Solicitantes_FUNCIONARIO.equals("1")) 
				{%> checked="checked"> Funcionario</br>
				<%}else {%>
				> Funcionario</br>
				<input type="radio" name="group" id="ctr_laboral" value="Laboral"
				<%}if (CTR_Solicitantes_FUNCIONARIO.equals("0")) 
				{%> checked="checked"> Laboral</br>
				<%}else {%>
				 > Laboral</br>
				<%}%>

			</td>
			
		  </tr>
          <tr> 			
            <td width="153" bgcolor="#F7F7F7">* Campos Obligatorios.</td>
          </tr>
		</div>
		<!------------------------------------------->
	<%}
	else
	{%>
        <table width="1300">
          <tr bgcolor="#D6EBFF">
            <td colspan="3" bgcolor="#F7F7F7">&nbsp;</td>
          </tr>
          <tr>
            <td width="20" bgcolor="#F7F7F7">&nbsp;</td>
            <td colspan="2" bgcolor="#F7F7F7"><span class="txtNegrita" style="width: 350px; display: inline-block"> Para posibles comunicaciones aporte los siguientes datos:</span></td>
          </tr>
          <tr> 
            <td bgcolor="#F7F7F7">&nbsp;</td> 
            <td width="153" bgcolor="#F7F7F7">Teléfono Móvil:</td>
            <td width="784" bgcolor="#F7F7F7">
			  <!-- Telefono MOVIL -->
			  <input type="text" id="ctr_movil" name="ctr_movil" maxlength="60" onBlur="Validar_Movil(this.value)" required/></td>
          </tr>
          <tr> 
            <td bgcolor="#F7F7F7">&nbsp;</td>
            <td bgcolor="#F7F7F7"><span class="txtDest" style="width: 119px;">
              <label for="Email6" id="lblEmail" class="txtNegrita" style="width: 150px; display: inline-block">Email:</label>
            </span></td>
            <td bgcolor="#F7F7F7"><span class="txtDest" style="width: 119px;">
			  <!-- EMAIL -->
              <input type="text" id="ctr_email" name="ctr_email" onBlur="Validar_Email(this.value)" required/>
            </span></td>
          </tr>
          <tr>
            <td bgcolor="#F7F7F7">&nbsp;</td>
            <td bgcolor="#F7F7F7">&nbsp;</td>
            <td bgcolor="#F7F7F7">&nbsp;</td>
          </tr>
          <tr>
            <td bgcolor="#F7F7F7">&nbsp;</td>
            <td bgcolor="#F7F7F7">Colectivo Laboral</td>
            <td bgcolor="#F7F7F7">&nbsp;</td>
          </tr>
        </table>
      </div>
	<%}%>
	  <!--
	        <div id="divDatosPersonales3" visible="false" runat="server">
        <table width="304" height="33" border ="1"  cellpadding="1" cellspacing="1" class="estiloTabla" style="width: 93%; height: 34px">
          <tr>
            <td width="1300" height="31" colspan="2" bgcolor="#D6EBFF" class="txtDest" style="width: 70px;"><span class="txtDest" style="width: 70px;">
            <label for="divDatosPersonales8" id="lblDatosPersonales" class="txtNegrita" style="width: 150px; display: inline-block"><strong>Servicios Rurales</strong></label></span>
          </tr>
          <br />
          <br />
        </table>
		-->
		
		<div id="divServiciosRurales" >
          <table width="96%" height="33" border ="1"  cellpadding="1" cellspacing="1" class="estiloTabla" style="width: 93%; height: 34px">
            <tr>
              <td width="1220" height="31" colspan="2" bgcolor="#D6EBFF" class="txtDest" style="width: 70px;">
				<span class="txtDest" style="width: 100px;">
					<label for="divDatosPersonales7" id="lblDatosPersonales" class="txtNegrita" style="width: 150px; display: inline-block">
						<strong>Servicios Rurales </strong>
					</label>
				</span>              
            </tr>
            <br />
            <br />
          </table>
        </div>
		
		
        <table width="1300">
          <tr bgcolor="#D6EBFF">
            <td colspan="3" bgcolor="#F7F7F7">&nbsp;</td>
          </tr>
          <tr>
            <td width="20" bgcolor="#F7F7F7">&nbsp;</td>
            <td colspan="2" bgcolor="#F7F7F7"><span class="txtNegrita">Si quiere optar a jornada incompleta en SERVICIOS RURALES, active la casilla. </span></td>
          </tr>
          <tr>
            <td bgcolor="#F7F7F7">&nbsp;</td>
            <td width="153" bgcolor="#F7F7F7"><span class="txtNegrita">
              <label for="JornadaIncompleta2" id="lblJornadaIncompleta" class="txtNegrita" style="width: 150px; display: inline-block">Jornada Incompleta </label>
            </span></td>
            <td width="784" bgcolor="#F7F7F7"><span class="txtNegrita">
			  <!-- Jornada Incompleta -->	  
              <input type = "checkbox" id = "ctr_jornadaincompleta" name = "ctr_jornadaincompleta" value="<%=CTR_Solicitantes_JORNADAINCOMPLETA%>"/>
            </span></td>
          </tr>
        </table>
        <div id="divDatosPersonales4" visible="false" runat="server">
          <table height="33" border ="1"  cellpadding="1" cellspacing="1" class="estiloTabla" style="width: 93%; height: 34px">
            <tr>
              <td width="1300" height="31" colspan="2" bgcolor="#D6EBFF" class="txtDest" style="width: 70px;"><span class="txtDest" style="width: 70px;">
              <label for="divDatosPersonales9" id="lblDatosPersonales" class="txtNegrita" style="width: 300px; display: inline-block"><strong>Solicitud Condicionada</strong></label></span>
            </tr>
            <br />
            <br />
          </table>
          <table width="1300">
            <tr bgcolor="#D6EBFF">
              <td colspan="3" bgcolor="#F7F7F7">&nbsp;</td>
            </tr>
            <tr>
              <td width="20" bgcolor="#F7F7F7">&nbsp;</td>
              <td colspan="2" bgcolor="#F7F7F7"><span class="txtNegrita">Complete si condiciona su destino con otro participante de este proceso</span></td>
            </tr>
            <tr>
              <td bgcolor="#F7F7F7">&nbsp;</td>
              <td width="153" bgcolor="#F7F7F7"><span class="txtNegrita" style="width: 150px; display: inline-block">Selección condicionada</span></td>
              <td width="314" bgcolor="#F7F7F7"><span class="txtDest" style="width: 157px">
			    <!-- Seleccion condicionada --> 
              <input type = "checkbox" id = "ctr_condicionado" name = "ctr_condicionado" value="<%=CTR_Solicitantes_CONDICIONADO%>"
				onClick="EnableDisableDniCondicionado();" />
              </span></td>
			  
			  <!-- Seleccion Condicionada -->	  
              <td width="797" bgcolor="#F7F7F7" style="visibility:hidden">Dni/Nie condicionado 
                <label>
                  <input type="text" name="ctr_dni_condicionado" id="ctr_dni_condicionado">
              </label>
              </td>
			  
			  
            </tr>
          </table>
        </div>	  
        <div id="divDatosPersonales5" visible="false" runat="server">
          <table width="304" height="33" border ="1"  cellpadding="1" cellspacing="1" class="estiloTabla" style="width: 93%; height: 34px">
            <tr>
              <td width="1300" height="31" colspan="2" bgcolor="#D6EBFF" class="txtDest" style="width: 400px;"><span class="txtNegrita" style="width: 400px; display: inline-block"><strong>Méritos vida personal, familiar y laboral</strong></span>              
            </tr>
            <br />
            <br />
          </table>
          <table width="1300">
            <tr bgcolor="#D6EBFF">
              <td colspan="3" bgcolor="#F7F7F7">&nbsp;</td>
            </tr>
            <tr>
              <td width="20" bgcolor="#F7F7F7">&nbsp;</td>
              <td colspan="2" bgcolor="#F7F7F7"><span class="txtNegrita">Indique en su caso el que corresponda </span></td>
            </tr>
            <tr>
              <td bgcolor="#F7F7F7">&nbsp;</td>
              <td width="153" bgcolor="#F7F7F7"><span class="txtNegrita">
                <label for="Meritos2" id="lblCuidadoFamiliar" class="txtNegrita" style="width: 150px; display: inline-block">Cuidado de un familiar<br>
				(madre o padre) </label>
              </span></td>
              <td width="784" bgcolor="#F7F7F7"><span class="txtNegrita">
			    <!-- Cuidado familiar --> 
                <input type = "checkbox" id = "ctr_condicionado_padres" name = "ctr_condicionado_padres" value="<%=CTR_Solicitantes_CONDICIONADO_PADRES%>" />
              </span></td>
            </tr>
            <tr>
              <td bgcolor="#F7F7F7">&nbsp;</td>
              <td bgcolor="#F7F7F7"><span class="txtNegrita">
                <label for="Meritos3" id="lblCuidadoHijos" class="txtNegrita" style="width: 150px; display: inline-block">Cuidado de hijos </label>
              </span></td>
              <td bgcolor="#F7F7F7"><span class="txtNegrita">
			    <!-- Cuidado hijos -->
                <input type = "checkbox" id = "ctr_condicionado_hijos" name = "ctr_condicionado_hijos" value="<%=CTR_Solicitantes_CONDICIONADO_HIJOS%>"/>
              </span></td>
            </tr>
          </table>
        </div>
        <div id="divDatosPersonales6" visible="false">
          
		  <table height="33" border ="1"  cellpadding="1" cellspacing="1" class="estiloTabla" style="width: 93%; height: 34px">
            <tr>
              <td width="1300" height="31" colspan="2" bgcolor="#D6EBFF" class="txtDest" style="width: 70px;"><span class="txtNegrita" style="width: 300px; display: inline-block"><strong>Localidades y peticiones</strong></span> 
			  </td>
            </tr>
            <br />
            <br />
          </table>
		</div>
		  
		  <table width="1197">
            <tr bgcolor="#D6EBFF">
              <td colspan="5" bgcolor="#F7F7F7">&nbsp;</td>
            </tr>
            <tr bgcolor="#F7F7F7">
              <td width="7">&nbsp;</td>
              <td width="328"><span class="txtCabeceraTablaMain" style="height: 20px; width: 250px;"><strong>Provincia</strong></span></td>
              <td width="348"><span class="txtCabeceraTablaMain" style="height: 20px; width: 250px;"><strong>Localidad</strong></span></td>
              <td width="339"><strong>Unidad</strong></td>
              <td width="145">&nbsp;</td>
            </tr>
            <tr>
            <td bgcolor="#F7F7F7">&nbsp;</td>
            <td bgcolor="#F7F7F7"><label for="idProvincia"></label>
<!------------------------
	COMBO PROVINCIA 
------------------------->	
<!-- Llamada a WCS para recuperar un "Array de Provincias" -->
<!-- Objeto esperado "Array de Provincias" -->
<!-- WCS -->
				<%String num = "1";
				String tabla="Provincias";%>
				<render:callelement elementname="COR_Aplicaciones/Migracion/SelectProvincias" scoped="global">
								<render:argument name="Pais" value='<%=num%>' />
								<render:argument name="Tabla" value='<%=tabla%>' />
				</render:callelement>
				<%listaProvincias = (ArrayList)ics.GetObj("listaProvincias");%>			
<!--------->
			   <div class="Div_Combo_Provincias" style='display:inline;'>   
					<select id="ctr_provincia" onchange="document.getElementById('FormularioAlta').submit();" name="ctr_provincia">
	
						<option value=""  selected > ----- Provincia: -----</option>       
						<% String provincia = "1"; 
						for(int i=0; i<listaProvincias.size(); i++)
						{%>
							<%if(provincia!=null)
							{%>
								<%if(provincia.equals(listaProvincias.get(i).substring(0,2))){%>
									 <option value="<%=listaProvincias.get(i).substring(0,2)%>" selected><%=listaProvincias.get(i).substring(2,listaProvincias.get(i).length())%></option>
								<%} else {%>
									 <option value="<%=listaProvincias.get(i).substring(0,2)%>"> <%=listaProvincias.get(i).substring(2,listaProvincias.get(i).length())%>
									 </option>
								<%}%>
							<%}
							 else 
							{%>
								<option value="<%=listaProvincias.get(i).substring(0,2)%>"> <%=listaProvincias.get(i).substring(2,listaProvincias.get(i).length())%>
								</option>
							<%}%>
						<%}%>
					</select>
			   </div>
	         </td>

<!-------------------
	COMBO LOCALIDAD  
--------------------->	
			<!-- SQL: "SELECT distinct(Localidad_INE), Localidad_INE FROM dbo.CPT11_Ofertas WHERE ([Provincia] = @PROVINCIA) order by Localidad_INE" -->
			<!-- Objeto esperado "Array de Localidades" -->
<!-- WCS -->
			<render:callelement elementname="COR_Aplicaciones/Migracion/COR_CTR_SelectLocalidades" scoped="global">
				<render:argument name="ctr_provincia" value='<%=wctr_provincia%>' />
			</render:callelement>
			
			<% listaLocalidades = (ArrayList)ics.GetObj("listaLocalidades");%>			
<!--------->
			<td bgcolor="#F7F7F7">	  
			   <div class="Div_Combo_Localidades" style='display:inline;'>
					<select id="ctr_localidad" type="submit" onchange="" name="ctr_localidad">
	
						<option value=""  selected > ----- Localidad: -----</option>       
						<% wArraySubStrings = null; 
						wctr_localidad = "1"; 				
						for(int i=0; i<listaLocalidades.size(); i++)
						{%> 
							<%if(wctr_localidad!=null)
							{%>
								<%
								wArraySubStrings = listaLocalidades.get(i).split(";");
								//Excepción para buscar en tabla de Ofertas por LOCALIDAD_INE pues no hay código en la tabla.
								if(wctr_localidad.equals(wArraySubStrings[1])){%>
								
								<option value="<%=wArraySubStrings[1]%>" selected>
											 <%=wArraySubStrings[1]%>
								</option>								
								<%} else {%>
									 <option value="<%=wArraySubStrings[1]%>"><%=wArraySubStrings[1]%></option>
								<%}%>
							<%}
							else 
							{%>
								<option value="<%=wArraySubStrings[1]%>"> <%=wArraySubStrings[1]%></option>
							<%}%>
						<%}%>
					</select>
			   </div>
	        </td>
              

<!-------------------
	COMBO UNIDAD  
--------------------->	
<!-- SQL: "SELECT DISTINCT unidad as CodUnidad, descripcion_unidad as DescUnidad FROM dbo.CPT11_Ofertas  WHERE (localidad_INE = @id_localidad and Provincia = @PROVINCIA ) order by DescUnidad" -->
<!-- Objeto esperado "Array de Unidades" -->
<!-- WCS -->
			<render:callelement elementname="COR_Aplicaciones/Migracion/COR_CTR_SelectUnidades" scoped="global">
				<render:argument name="ctr_provincia" value='<%=wctr_provincia%>' />
				<render:argument name="ctr_localidad" value='<%=wctr_localidad%>' />
			</render:callelement>
			
			<% listaUnidades = (ArrayList)ics.GetObj("listaUnidades");%>			
<!--------->
			<td bgcolor="#F7F7F7">	  
			   <div class="Div_Combo_Unidades" style='display:inline;'>
					<select id="ctr_unidad" type="submit" onchange="" name="ctr_unidad">
						
						<option value=""  selected > ----- Unidad: -----</option>       
						<% wArraySubStrings = null;
						wctr_unidad = "1"; 				
						for(int i=0; i<listaUnidades.size(); i++)
						{%> 
							<%if(wctr_unidad!=null)
							{%>
								<%
								wArraySubStrings = listaUnidades.get(i).split(";");
								if(wctr_unidad.equals(wArraySubStrings[0])){%>
									 <option value="<%=wArraySubStrings[0]%>" selected>
									 <%=wArraySubStrings[1]%>
									 </option>
								<%} else {%>
									 <option value="<%=wArraySubStrings[0]%>">
									 <%=wArraySubStrings[1]%>
									 </option>
								<%}%>
							<%}
							else 
							{%>
								<option value="<%=wArraySubStrings[0]%>"> 
								<%=wArraySubStrings[1]%>
								</option>
							<%}%>
						<%}%>						
					</select>
			   </div>
	        </td>

			 <td bgcolor="#F7F7F7">&nbsp;</td>
            </tr>
            <tr>
              <td bgcolor="#F7F7F7">&nbsp;</td>
              <td bgcolor="#F7F7F7"><strong>Puesto</strong></td>
              <td bgcolor="#F7F7F7">&nbsp;</td>
              <td bgcolor="#F7F7F7">&nbsp;</td>
              <td bgcolor="#F7F7F7">&nbsp;</td>
            </tr>
            <tr>
              <td bgcolor="#F7F7F7">&nbsp;</td>

<!-------------------
	COMBO PUESTO  
--------------------->	
<!-- SQL: "SELECT    distinct(dbo.CPT11_Puestos.desc_puesto), dbo.CPT11_Mapeos.codigo_puesto FROM dbo.CPT11_Ofertas INNER JOIN dbo.CPT11_Puestos ON dbo.CPT11_Ofertas.TIPO_UNIDAD = dbo.CPT11_Puestos.tipoUnidad INNER JOIN dbo.CPT11_Mapeos ON dbo.CPT11_Puestos.id_puesto = dbo.CPT11_Mapeos.id_puesto WHERE
(Provincia = @Provincia) AND (Localidad_INE = @Localidad) AND (Unidad = @unidad) AND (dbo.CPT11_Mapeos.visible_todos <> @FiltroPuestos) ORDER BY desc_puesto" -->
<!-- Objeto esperado "Array de Puestos" -->

<!-- WCS -->
			<render:callelement elementname="COR_Aplicaciones/Migracion/COR_CTR_SelectPuestos" scoped="global">
				<render:argument name="ctr_provincia" value='<%=wctr_provincia%>' />
				<render:argument name="ctr_localidad" value='<%=wctr_localidad%>' />
				<render:argument name="ctr_unidad" value='<%=wctr_unidad%>' />
			</render:callelement>
			
			<% listaPuestos = (ArrayList)ics.GetObj("listaPuestos");%>			
<!--------->
			<td bgcolor="#F7F7F7">	  
			   <div class="Div_Combo_Puestos" style='display:inline;'>
					<select id="ctr_puesto" onchange="" name="ctr_puesto">
						
						<option value=""  selected > ----- Puesto: -----</option>       
						<% wArraySubStrings = null;
						wctr_puesto = "1"; 				
						for(int i=0; i<listaPuestos.size(); i++)
						{%> 
							<%if(wctr_puesto!=null)
							{%>
								<%
								wArraySubStrings = listaPuestos.get(i).split(";");
								if(wctr_puesto.equals(wArraySubStrings[0])){%>
									 <option value="<%=wArraySubStrings[0]%>" selected>
									 <%=wArraySubStrings[1]%>
									 </option>
								<%} else {%>
									 <option value="<%=wArraySubStrings[0]%>">
									 <%=wArraySubStrings[1]%>
									 </option>
								<%}%>
							<%}
							else 
							{%>
								<option value="<%=wArraySubStrings[0]%>"> 
								<%=wArraySubStrings[1]%>
								</option>
							<%}%>
						<%}%>										
					</select>
			   </div>
	        </td>
			  
              <td bgcolor="#F7F7F7"><strong>Aportación Local<span class="txtNegrita">
                <input type = "checkbox" name = "ctr_aport_local" id="ctr_aport_local">
				
			<!-- ¿? no se que hace -->
				
				
              </span></strong></td>
              <td bgcolor="#F7F7F7">&nbsp;</td>
              <td bgcolor="#F7F7F7">
<!-----------------------------------
	BOTON AÑADIR a lista de Destinos
------------------------------------>
<input type="button" name="btnAnadir" value="Añadir" onClick="AnadirDestino();" id="btnAnadir" class="btnAnadir" style="width:145px;" /></td>				  
			  <td width="0"></td>
            </tr>
          </table>
          <div id="divPeticionesDeDestino"">
            <!--<table width="1300" height="33" border ="1"  cellpadding="1" cellspacing="1" class="estiloTabla" style="width: 93%; height: 34px">
              <tr>
                <td width="1300" height="31" colspan="2" bgcolor="#D6EBFF" class="txtDest" style="width: 300px;"><span class="txtNegrita" style="width: 150px; display: inline-block"><strong>Peticiones de destino</strong></span>                
              </tr>
              <br />
              <br />
            </table> -->
		  <table height="33" border ="1"  cellpadding="1" cellspacing="1" class="estiloTabla" style="width: 93%; height: 34px">
            <tr>
              <td width="1300" height="31" colspan="2" bgcolor="#D6EBFF" class="txtDest" style="width: 70px;"><span class="txtNegrita" style="width: 300px; display: inline-block"><strong>Peticiones de destino</strong></span> 
			  </td>
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
            <table width="1300">
              <tr bgcolor="#D6EBFF">
                <td colspan="3" bgcolor="#F7F7F7">&nbsp;</td>
              </tr>
              <tr>
 <!-- Combo PROVINCIA Pie --> 

				<!-- El valor param1='1' indica la clase del CSElement que carga en un SELECT todas las Provicnias -->
				<!-- DataSourceID="provinciaRegistroDts" DataTextField="Descripcion" DataValueField="PROVINCIA" -->
				<!-- SQL: "SELECT DISTINCT provincia AS PROVINCIA, descripcion AS Descripcion FROM dbo.CPT11_Ofertas order by descripcion" -->
				<!-- Objeto esperado "Array de Provincias" -->
				<!--

<!-- -->
               <td width="282">En </td>
               <td width="722"><td> 			   
				   <td width="135"><div class="Div_Combo_Provincias_Pie">
				   
				   <td width="0"><label for="provincia">
						<select name="ctr_provincia_grabacion" id="ctr_provincia_grabacion" class="corto-doble">
							<option value=""  selected > ----- Provincia: -----</option>       
							<% 
							for(int i=0; i<listaProvincias.size(); i++)
							{%>
								<%if(provincia!=null)
								{%>
									<%if(provincia.equals(listaProvincias.get(i).substring(0,2))){%>
										 <option value="<%=listaProvincias.get(i).substring(0,2)%>" selected><%=listaProvincias.get(i).substring(2,listaProvincias.get(i).length())%>
										 </option>
									<%} else {%>
										 <option value="<%=listaProvincias.get(i).substring(0,2)%>"> <%=listaProvincias.get(i).substring(2,listaProvincias.get(i).length())%>
										 </option>
									<%}%>
								<%}
								else 
								{%>
										<option value="<%=listaProvincias.get(i).substring(0,2)%>"> <%=listaProvincias.get(i).substring(2,listaProvincias.get(i).length())%>
										</option>
								<%}%>
							<%}%>
						</select>
						<!-- Fecha del sistema -->					
						a 
						<%Calendar fecha = Calendar.getInstance();%>
						<%String wFechaActual = fecha.get(Calendar.DAY_OF_MONTH) + "/" + (fecha.get(Calendar.MONTH) + 1) + "/" + fecha.get(Calendar.YEAR);%>
						<input type="hidden" id="ctr_fecha_registro"  name="ctr_fecha_registro" disabled><%=wFechaActual%><td width="0"></input>							
				   <td width="1">
<!-- --> 				
				<td width="3">

<!-------------------
	Botón Guardar  
--------------------->					
                <td width="121" colspan="2" bgcolor="#F7F7F7">
					<input type="submit" name="ctr_boton" id="ctr_boton" value="Guardar" onclick="guardarFormulario();">
				</td>
<!-------------------
	Botón Salir 
--------------------->	
               <td width="121" colspan="2" bgcolor="#F7F7F7">
					<input type="submit" name="ctr_boton2" id="ctr_boton2" value="Salir" onClick="return confirm('¿Está seguro de que quiere salir de esta página? Compruebe que haya guardado sus peticiones antes de salir. Pulse Aceptar para continuar, o Cancelar para permanecer en la página actual.');">
				</td>
<!-------------------
	Pie de Pagina 
--------------------->	
			 
			</tr>
              <tr bgcolor="#848284">
                <td colspan="3"><div>
                  <div id="pnlClausuraProteccionDatos2"> <span id="lblClausuraProteccionDatos2">El   peticionario autoriza expresamente a Correos y Telégrafos S.A. para que   los datos recogidos en este formulario de grabación de peticiones, así   como los que sean proporcionados en el futuro, queden incorporados a la   base de datos de Recursos Humanos, cuyo titular responsable es la   Sociedad Estatal Correos y Telégrafos, S.A. para la gestión de los   procesos de selección y promoción. El peticionario de acuerdo con la   normativa vigente en materia de protección de datos, tiene la   posibilidad de ejercitar los derechos de acceso, rectificación,   oposición y cancelación sobre sus datos personales, dirigiendo   comunicación escrita a la Dirección de Recursos Humanos en la dirección   que se expresa a continuación: Vía Dublín, 7, 28070 Madrid.</span></div>
                </div></td>
              </tr>
            </table>
          </div>
        </div>
        <div></div>
        <p>&nbsp;</p>
      </div>			 

<!------------------------------------------------------------------------------------------------------------------------------------------------------------->	  
	<input type="hidden" name="enviadoFormulario" id="enviadoFormulario" value="yes" />	
	<input type="hidden" name="sidioma" value="<%=sidioma%>" /> 
	<input type="hidden" value="<%=site%>" name="site"/> 
	<input type="hidden" name="p" value="<%=p%>" /> 
	<input type="hidden" name="c" value="<%=c%>" /> 
	<input type="hidden" name="cid" value="<%=cid%>" />
	<input type="hidden" name="tid" value="<%=ics.GetVar("tid")%>" />
	<input type="hidden" name="sPathStatic" value="<%=sPathStatic%>" /> 
	<input type="hidden" name="pagename" value="COR_Wrapper"  />	
	<input type="hidden" name="packedargs" value='<%=ics.GetVar("myPackedArgs")%>' />
	<input type="hidden" name="ctr_array" id="ctr_array" value='<%=ics.GetVar("ctr_array")%>' />	

    </satellite:form>
</body>


<script type="text/javascript" src="http://www.correos.es/COREstaticos/js/stats.min.js"></script>
<script language="javascript" type="text/javascript">

/*  
   VARIABLES GLOBALES 
*/

var matrizLineas = [];
var wNOrden = 0;
var strStringArray = "";

/*-----------------------------------------------------------------------------*/
/*Función Enable/Disable Campos de Nombre, Apellidos, etc, en funcion de 666666*/
/*-----------------------------------------------------------------------------*/
function EnableDisableCampos(Nip)
{
		if (Nip == '666666')
		{
			//alert('Es un funcionario en Excedencia. Poner Enable los campos');
			//document.getElementById("Div_Nombre_Apellidos").style.display="inline";
		}
}

/*-----------------------------------------------------------------------------*/
/*Función Enable/Disable ctr_dni_condicionado*/
/*-----------------------------------------------------------------------------*/
function EnableDisableDniCondicionado()
{
		if (document.getElementById("ctr_condicionado").checked = true )
		{
			document.getElementById("ctr_dni_condicionado").style.display="inline";
		}
		else
		{
			document.getElementById("ctr_dni_condicionado").style.display = "none";		
		}
}
/*-----------------------------------------------------------*/
/*Función para capturar la Provincia seleccionada en el COMBO*/
/*-----------------------------------------------------------*/
function CapturaProvincia()
{
	//var codCombo = document.getElementById("provinciaName").value;
	//document.getElementById("ctr_provincia").value= codCombo;
	//alert(document.getElementById("ctr_provincia").value);
	
	/*alert(codCombo);*/
	
	/*var combo = document.getElementById("provinciaName");
	alert(Combo);*/
	
	/*var selected = combo.options[combo.selectedIndex].text;

	document.getElementById("DivComboLocalidadesIni").style.display= "none";
	document.getElementById("DivComboLocalidadesFin").style.display= "inline";*/
}
/*-----------------------------------------------------------*/
/*Función para capturar la Localidad seleccionada en el COMBO*/
/*-----------------------------------------------------------*/

function CapturaLocalidad()
{
	//var codCombo = document.getElementById("localidadName").value;
	 
	//var combo = document.getElementById("localidadName");
	//var selected = combo.options[combo.selectedIndex].text;

	/*
	document.getElementById("DivComboLocalidadesIni").style.display= "none";
	document.getElementById("DivComboLocalidadesFin").style.display= "inline";
	*/
}

/*----------------------------------------------------------*/
/*FUNCION PARA VALIDAR MOVIL*/
/*----------------------------------------------------------*/
function Validar_Movil(Parametro) {
	/*Parametro = document.getElementById("Movil").value; */
	ExpresionRegular = /^(7|8|9|6)\d{8}$/;
	if (!ExpresionRegular.test(Parametro))
		{
		alert('El Teléfono ' + Parametro + ' es incorrecto.'); 
		document.Movil.focus();
		}
}
/*----------------------------------------------------------*/
/*FUNCION PARA VALIDAR EMAIL*/
/*----------------------------------------------------------*/
function Validar_Email(Parametro) {
	/*Parametro = document.getElementById("Email").value; */
	ExpresionRegular = /^[-\w.%+]{1,64}@(?:[A-Z0-9-]{1,63}\.){1,125}[A-Z]{2,63}$/i;
	if (!ExpresionRegular.test(Parametro))
		{
		alert("La dirección de email " + Parametro + " es incorrecta.");
		document.FormularioAlta.Email.focus();	
		}	
}	
/*----------------------------------------------------------*/
/*FUNCION PARA AÑADIR FILAS EN "PETICIONES DE DESTINO       */
/*----------------------------------------------------------*/

function AnadirDestino() 
{
	// Con esto se captura el VALUE de las "Select"

	var wPosicion=null;
	var wProvincia="";
	var wLocalidad="";
	var wUnidad="";
	var wCodUnidad="";	
	var wPuesto="";
	var wCodPuesto="";
	var wSiNo = "";

	wNOrden = wNOrden + 1;
	wPosicion=document.getElementById("ctr_provincia").options.selectedIndex; //posicion
	wProvincia = document.getElementById("ctr_provincia").options[wPosicion].text;

	wPosicion=document.getElementById("ctr_localidad").options.selectedIndex; //posicion
	wLocalidad = document.getElementById("ctr_localidad").options[wPosicion].text;

	//Texto
	wPosicion=document.getElementById("ctr_unidad").options.selectedIndex; //posicion
	wUnidad = document.getElementById("ctr_unidad").options[wPosicion].text;
	//Codigo
	wPosicion=document.getElementById("ctr_unidad").options.selectedIndex; //posicion
	wCodUnidad = document.getElementById("ctr_unidad").options[wPosicion].value;

	//Texto	
	wPosicion=document.getElementById("ctr_puesto").options.selectedIndex; //posicion
	wPuesto = document.getElementById("ctr_puesto").options[wPosicion].text;
	//Codigo	
	wPosicion=document.getElementById("ctr_puesto").options.selectedIndex; //posicion
	wCodPuesto = document.getElementById("ctr_puesto").options[wPosicion].value;
	
	//Falta estudiar como se comporta "Aportación_Local". De momento ponemos "No" en la columna.


	matrizLineas.push(new Array(wNOrden,wProvincia,wLocalidad,wUnidad,wPuesto,"No",wCodUnidad,wCodPuesto));

	wSiNo = document.getElementById("ctr_aport_local").value;
	//cargo String/Array para que viaje a la clase COR_CTR_InsertarTraslados	
	strStringArray = strStringArray + wNOrden + ";" + wProvincia + ";" + wLocalidad + ";" + wUnidad + ";" + wPuesto + ";" + wSiNo + "#";

	document.getElementById("ctr_array").value = strStringArray;
	
	regenerarTabla();
}	

/*----------------------------------------------------------*/
/*FUNCION PARA REGENERAR TABLA DE "PETICIONES DE DESTINO"   */
/*----------------------------------------------------------*/  

function regenerarTabla() 
{
	var row = 0;
	var col = 0;
	//alert("Entra en -- regenerarTabla() --"); 
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
			//alert("ROW--: " + row + "COL--: " + col + " LEN--: " + matrizLineas.length); 
			//alert("objCell--: " + matrizLineas [row][col]); 
		}
		objCell = objRow.insertCell();
		//objCell.innerHTML = '<center><img src="edit.gif" onClick="edit('+row+');" alt="modificar fila">';
	}
	
}
/*----------------------------------------------------------*/
/*FUNCION GUARDAR FORMULARIO"   */
/*----------------------------------------------------------*/  

function guardarFormulario() 
{
	var trueFalse = confirm('Va a guardar su solicitud. ¿Está usted seguro?.');
	if (!trueFalse)
	{
		alert(trueFalse);
		return false;
	}
	
	// otro string to array
	//var fruits = ["Banana", "Orange", "Apple", "Mango"];
	//var energy = fruits.join();

	
	//string a array
	//var str = "1,2,3|4,5,6|7,8,9|11,21,31";
	//var tempArray = str.split('|');
	//var finalArray = [];
	//for (var i = 0; i < tempArray.length; i++) {
	//	finalArray[i][ = tempArray[i].split(',');
	//}
}
//function submitir(){
//	document.getElementById('FormularioAlta').submit();
//}
</script>



<style type="text/css">
        .validation-summary {
            font-color: red;
            border: 1px solid red;
            padding: 5px;
            margin-top: 10px;
            margin-bottom: 10px;
        }
</style>
<!--	Link a fichero de Estilo
<link href="Css/ConcursoTraslados.css" rel="stylesheet" type="text/css" />
-->	
<!-- </body> -->

<!-- FIN ----------------------------------------------------------------------------------------------------------------------------------------------- -->
<!-- BLOQUE PARA PRUEBAS HTML -------------------------------------------------------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------------------------------------------------------------------------------- -->


<!------------------------------------------------------------------------------------------------------------------------------------------------------ -->
<!-- BLOQUE WEBCENTER SITES ---------------------------------------------------------------------------------------------------------------------------- -->
<!-- --------------------------------------------------------------------------------------------------------------------------------------------------- -->
</cs:ftcs>
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
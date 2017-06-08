<!---------------------------------------------------------------------------------------------------------------------
		WEBCENTER SITES/JAVA
---------------------------------------------------------------------------------------------------------------------->
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
<cs:ftcs><%-- Page/COR_Aplicaciones/COR_CTR_PageLogin

INPUT

OUTPUT

--%>

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

<%
//=====================
// Variables de control
//=====================
	boolean debug = false;


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
String CTR_Solicitantes_TELEFONO = "666777888";
String CTR_Solicitantes_EMAIL = "email@correo.es";
String CTR_Solicitantes_JORNADAINCOMPLETA = "0";
String CTR_Solicitantes_CONDICIONADO = "0";	
String CTR_Solicitantes_DNI_CONDICIONADO = (ics.GetVar("ctr_dni_condicionado") != null) ? ics.GetVar("ctr_dni_condicionado") : "";
String CTR_Solicitantes_CONDICIONADO_PADRES = "0";
String CTR_Solicitantes_CONDICIONADO_HIJOS = "0";
String CTR_Solicitantes_PROVINCIA_GRABACION = "28";
String CTR_Solicitantes_FECHA_REGISTRO = "07/04/2017";
String CTR_Solicitudes_ARRAY = "1;Madrid;QUIJORNA;2869302;Servicio Rural. Pie;1;10000;campo7-1#2;Madrid;SAN MARTIN DE VALDEIGLESIAS;2868002;Atencion al Cliente;0;20000;campo7-2#3;Malaga;RINCON DE LA VICTORIA;2973012;Reparto1.Moto;0;30000;campo7-3";														

//=========================	
//Parametros del Formulario
//=========================
	String sidioma = ics.GetVar("sidioma");
	String site = ics.GetVar("site");
	String p = ics.GetVar("p");
	String c = ics.GetVar("c");
	String cid = ics.GetVar("cid");
	String sPathStatic = ics.GetVar("sPathStatic");
	
	String urlformulario = ics.GetVar("rutainicial");

	Boolean noErrorValidacion = true; // Variable para especificar si se validan las entradas.
	Boolean fLoad = true;
	String wTmp = "";
	Boolean strResult = true;	
	
	//Parámetros del login

	String enviadoFormulario = ics.GetVar("enviadoFormulario");
	String ctr_nip = ics.GetVar("ctr_nip");
	String ctr_dni = ics.GetVar("ctr_dni");
	String ctr_fnac = ics.GetVar("ctr_fnac");
	String ctr_captcha = ics.GetVar("ctr_captcha");
	String ctr_boton = ics.GetVar("ctr_boton");


		
	//Inicializacion de VARIABLES
	//	RECUPEARAR DE CONFIGURACION: URL_ServerName
	
	boolean [] opcion_error = new boolean[6];
	String [] opcion = new String[6];
	for(int x=0; x<opcion_error.length; x++)
	{
		opcion_error[x] = false;
	}
	if (debug) {
%>			
		<P> c: <%=c%></P>	
		<P> p: <%=p%></P>					
		<P> cid: <%=cid%></P>	
		<P> sidioma: <%=sidioma%></P>	
		<P> site: <%=site%></P>						
		<P> fLoad: <%=fLoad%></P>	
		<P> sPathStatic: <%=sPathStatic%></P>
		<P> urlformulario: <%=urlformulario%></P>
		<P> enviadoFormulario: <%=enviadoFormulario%></P>	
		<P> ctr_dni: <%=ctr_dni%></P>
		<P> ctr_nip: <%=ctr_nip%></P>	
		<P> ctr_fnac: <%=ctr_fnac%></P>
		<P> ctr_boton: <%=ctr_boton%></P>			
<%	
	}
	// Logica Validacion Formulario por Servidor
	
	if (Utilities.goodString(enviadoFormulario) && "yes".equals(enviadoFormulario) ) 
	{
		if (debug) {%> <P>PASA 1</P><%}
		

		//-----------------------------
		//  SI "BOTON LANZADERA - INSERTAR"
		//-----------------------------		
		
		if ( ctr_boton.equals("LANZADERA-INSERTAR") ) 
		{	
		if (debug) {%> <P>PASA 2</P><%}
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
			if (debug) {%> <P>PASA 3</P><%}
		}
			
		//-----------------------------
		//  SI "BOTON LANZADERA-ELIMINAR"
		//-----------------------------		
		
		if ( ctr_boton.equals("LANZADERA-ELIMINAR") ) 
		{	
		if (debug) {%> <P>PASA 2 bis</P><%}
			%>
			<render:callelement elementname="COR_Aplicaciones/Migracion/COR_CTR_EliminarTraslados" scoped="global">
				<render:argument name="DNI" value='<%=CTR_Solicitantes_DNI%>' />
			</render:callelement>		
			<%
			if (debug) {%> <P>PASA 3 bis</P><%}
		}			
	}
	else 
	{
		if (debug) {%> <P>PASA 4</P><%}
%>			
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
<%	
		urlformulario = urlformulario + ics.GetVar("laUrl");
%>
<!-- --------------------------------------------------------------------------------------------------------------------------------------------------------------->	
<!-- FORMULARIO -->
<!-- --------------------------------------------------------------------------------------------------------------------------------------------------------------->		

	<satellite:form name="FormularioLogin" action='<%=urlformulario%>' method="POST" id="FormularioLogin" acceptcharset="utf-8">
	
    <img src="img/Cabecera.jpg" align="bottom" style="padding:0px;margin:0px;vertical-align:bottom;"/>
	<img src="img/Pestania.jpg" align="top" style="padding:0px;margin:0px;vertical-align:top;" />
            
	<br /><br />
	
	<div>
        <table cellspacing="0px" cellpadding="5px" border="0" width="983" class="estiloTabla" align="left" id="Table1">
            <tr>
				<td class="filaCabecera" style="height: 30px" colspan="3">
                &nbsp;<span class="titulos">Rellene los siguientes datos:</span></td>
            </tr>
						
            <tr class="">
                <td align="right"> 
					<label for="nip" id="lblNip" class="txtNegrita" style="width: 150px; display: inline-block">
						NIP:
					</label>
				</td>
                <td>
					<input type="text" id="ctr_nip" name="ctr_nip" maxlength="6" onBlur="ValidarNIP(this.value)" required/>
				</td>
				<td>
					<img src="icono2.jpg alt="Imagen" style="width:30px;height:22px;">
						<a href="#" data-toggle="tooltip" title="NIP: si no recuerda su Número de Identificación Profesional puede encontrarlo en su recibo de haberes">#</a>
				</td>
                <td width="30%">
					&nbsp;
				</td>                        
            </tr>
            <tr>
                <td align="right" style="height: 30px">
					<label for="nif" id="lblNif" class="txtNegrita" style="width: 150px; display: inline-block">
                        DNI:
					</label>
                </td>
				<td style="height: 30px">
					<input type="text" id="ctr_dni" name="ctr_dni" maxlength="8" onBlur="ValidarDNI(this.value)" required/>	
                </td>
                <td width="30%" style="height: 30px">
					&nbsp;
				</td>
			</tr>
            <tr>
				<td align="right" style="height: 30px">
					<label for="dia" id="lblFecha" class="txtNegrita" style="width: 150px; display: inline-block">
                        Fecha de Nacimiento:<br /> (dd/mm/aaaa)&nbsp;&nbsp;
					</label>
                </td>
				<td style="height: 30px">
					<input type="text" id="ctr_fnac" name="ctr_fnac" maxlength="10" onBlur="Validar_F_Nacimiento(this.value)" required/>	
                </td>
                <td width="30%" style="height: 30px">
					&nbsp;
				</td>
					
            </tr>
            <tr>
                <td align="right" style="height: 30px">
					<label for="captcha" id="lblCaptcha" class="txtNegrita" style="width: 170px; display: inline-block">
                        Código de seguridad:
					</label>					
                </td>		
                <td style="height: 30px">
					<input type="text" id="ctr_captcha" name="ctr_captcha" maxlength="8" onBlur="ValidarCaptcha(this.value)"/>&nbsp;
				</td>
				<td style="height: 30px">	
					<img id="imgCaptcha" onclick="this.src=this.src+'#'" style="width:30px;height:22px;" align="top"/>&nbsp;<br>
				</td>
					
				<td>&nbsp;
				</td>
            </tr>
			<!-- BOTONES Pie de página -->
            <tr>
				<td>&nbsp;</td>
                <td>
					<div style="text-align: left">
						&nbsp;
						 <!-- LLAMADA A FORMULARIO DE ALTA -->
						<input type="submit" name="ctr_boton" value="ALTA" id="ctr_boton" class="btnEnviar" style="width:230px;"/>
					</div>
				</td>
				<td>
					<div style="text-align: left">
						&nbsp;
						 <!-- LLAMADA A LANZADERA (INSERTAR TRASLADOS) -->
						<input type="submit" name="ctr_boton" value="LANZADERA-INSERTAR" id="ctr_boton" class="LANZADERA-INSERTAR" style="width:230px;" />
						 <!-- LLAMADA A LANZADERA 2 (ELIMINAR TRASLADOS) -->
						<input type="submit" name="ctr_boton" value="LANZADERA-ELIMINAR" id="ctr_boton" class="LANZADERA-ELIMINAR" style="width:230px;" />						
					</div>
				</td>
			</tr>
        </table>
		 
		<br></br>

    </div>
	
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
	<input type="hidden" name="paramBoton" value="<%=ctr_boton%>" />

	</satellite:form>
<%
}
%><%!

// -----------------------------------------------------------------------------------
// FUNCIONES JAVA
// ----------------------------------------------------------------------------------- 
// -----------------------------------------------------------------------------------
// FUNCION Comprobar DNI
// ----------------------------------------------------------------------------------- 

    //Boolean validarDNI_Java(String dni)    
    String validarDNI_Java(String dni) 
	{
		int i, j, k = 0;
		String numero = ""; 
		String numRevisado = "";
		String[] unoNueve = {"0","1","2","3","4","5","6","7","8","9"};
		String[] xyz = {"X","Y","X"};
	
		for(i = 0; i < dni.length() - 1; i++) 
		{
			numero = dni.substring(i, i+1);

			for(j = 0; j < unoNueve.length; j++) 
			{
				if(numero.equals(unoNueve[j])) 
				{
					numRevisado += unoNueve[j];
				}
				else
				{
					if(j == 0) 
					{
						if(numero.equals(xyz[0]) && numero.equals(xyz[1]) && numero.equals(xyz[2])) 
						{
							numRevisado += numero;
						}
						else
						{
							return numRevisado;
							//return false;
						}
					}
				}				
			}
		}
		if(numRevisado.length() != 8) 
		{
			return numRevisado;
			//return false;
		}
		else 
		{
			return numRevisado;
			//return true;
		}
	}
	
// -----------------------------------------------------------------------------------
// FUNCION Comprobar NIP
// ----------------------------------------------------------------------------------- 
    //Boolean validarNIP_Java(String nip)  
    String validarNIP_Java(String nip) 
	{
		int i, j = 0;
		String numero = ""; 
		String numRevisado = "";
		String[] unoNueve = {"0","1","2","3","4","5","6","7","8","9"};

		for(i = 0; i < nip.length() - 1; i++) {
			numero = nip.substring(i, i+1);

			for(j = 0; j < unoNueve.length; j++) {
				if(numero.equals(unoNueve[j])) {
					numRevisado += unoNueve[j];
				}
			}
		}

		if(numRevisado.length() != 6) {
			return numRevisado;
			//return false;
		}
		else {
			return numRevisado;
			//return true;
		}
	}

// -----------------------------------------------------------------------------------
// FUNCION Comprobar DNI
// -----------------------------------------------------------------------------------
//    private boolean validarDNI_Java(){
//		dniAComprobar = ctr_dni;
//        // Array con las letras posibles del dni en su posición
//        char[] letraDni = {
//            'T', 'R', 'W', 'A', 'G', 'M', 'Y', 'F', 'P', 'D',  'X',  'B', 'N', 'J', 'Z', 'S', 'Q', 'V', 'H', 'L', 'C', 'K', 'E'
//        };  
//  
//        String num= "";
//        int ind = 0;  
//  
//        // boolean que nos indicara si es un dni correcto o no
//        boolean valido;
//  
//        // existen dnis con 7 digitos numericos, si fuese el caso
//        // le añado un cero al principio
//        if(dniAComprobar.length() == 8) {
//             dniAComprobar = "0" + dniAComprobar;
//        }
//  
//        // compruebo que el 9º digito es una letra
//        if (!Character.isLetter(dniAComprobar.charAt(8))) {
//             return false;  
//        }
//  
//        // compruebo su longitud que sea 9
//        if (dniAComprobar.length() != 9){   
//             return false;
//        }  
// 
//        // Compruebo que lo 8 primeros digitos sean numeros
//        for (int i=0; i<8; i++) {
//   
//             if(!Character.isDigit(dniAComprobar.charAt(i))){
//                   return false;    
//             }
//             // si es numero, lo recojo en un String
//             num += dniAComprobar.charAt(i);     
//        }
//  
//        // paso a int el string donde tengo el numero del dni
//        ind = Integer.parseInt(num);
//  
//        // calculo la posición de la letra en el array que corresponde a este dni
//        ind %= 23;
//  
//        // verifico que la letra del dni corresponde con la del array
//        if ((Character.toUpperCase(dniAComprobar.charAt(8))) != letraDni[ind]){
//             return false;
//       }  
//       // si el flujo de la funcion llega aquí, es que el dni es correcto
//       return true;
//   }
%>	

<!---------------------------------------------------------------------------------------------------------------------
		ESCRIPT
---------------------------------------------------------------------------------------------------------------------->
<script language="javascript" type="text/javascript">

/*----------------------------------------------------------*/
/*FUNCION PARA VALIDAR DNI NIE*/
/*----------------------------------------------------------*/

var VariableBoton;

function ValidarDNI(dni) 
{
	var numero, numero2;
 
    dni = dni.toUpperCase();
	numero = dni;
	
	numero = dni.substr(1,dni.length);
	numero2 = dni.substr(0,1);
    numero2 = numero2.replace('X', 0);
    numero2 = numero2.replace('Y', 1);
    numero2 = numero2.replace('Z', 2);
	numero = numero2 + numero;
	
	if (!/[0-9]/.test(numero2)){ 
		alert("NIE incorrecto"); 
		return false; 
	} 
	
	if (numero > 0)
	{
		if ((numero.length) < 8)
		{
			alert('DNI incorrecto. El formato de Dni es de 8 caracteres numéricos y el de Nie de 8 caracteres alfanuméricos');
			return false;
		}
		return true;
	}
}
/*----------------------------------------------------------*/
/*FUNCION PARA VALIDAR NIP*/
/*----------------------------------------------------------*/
function ValidarNIP(nip)
{
	//nip = document.getElementById("nip").value;
	if (!/^([0-9])*$/.test(nip))
	{
		alert('El formato del Nip es incorrecto. Introduzca un código numérico.');
		return false;
	}
	return true;
}
/*----------------------------------------------------------*/
/*FUNCION PARA VALIDAR FECHA NACIMIENTO*/
/*----------------------------------------------------------*/
function Validar_F_Nacimiento(args)
{
	var validformat = /^(0[1-9]|[1,2][0-9]|3[0,1])\/(0[1-9]|1[0,1,2])\/(19[4,5,6,7,8,9][0-9])$/;
	if (!validformat.test(args))
	{
	   alert('Fecha Nacimiento incorrecta ó incompleta.');
	   return false;
	} 
	args.IsValid = true;
	return;
}
/*----------------------------------------------------------*/
/*FUNCION PARA LLAMAR A OTROS FORMULARIOS*/
/*----------------------------------------------------------*/
function LlamarPagina(pagina)
{
	//document.FormularioLogin.action = pagina;
	//document.FormularioLogin.submit();
	
}

/*----------------------------------------------------------*/
/*FUNCION PARA VALIDAR CAPTCHA*/
/*----------------------------------------------------------*/
function ValidarCaptcha(codigo)
{
	/* falta validar Captcha */
	if ((codigo.length) > 0)
        {
 	/*   alert('Captcha introducido. Ahora habría que validarlo'); */
        } 
    return;
}
/*----------------------------------------------------------*/
/*FUNCION PARA CARGAR EN VARIABLE EL BOTON PULSADO*/
/*----------------------------------------------------------*/
/*function CargarBoton(boton)
{
	VariableBoton = boton;
	document.getElementById("paramBoton2").value = boton;
	return;
}*/
</script>
<!---------------------------------------------------------------------------------------------------------------------
		ESTILOS
---------------------------------------------------------------------------------------------------------------------->
<style>

</style>
</cs:ftcs>
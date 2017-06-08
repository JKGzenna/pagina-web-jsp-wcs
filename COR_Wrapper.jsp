<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
				   COM.FutureTense.Util.ftMessage,
				   COM.FutureTense.Util.ftErrors,
				   es.correos.webpublica.web.fatwire.ov2.beans.CookieOv2BeanInfo,
				   es.correos.webpublica.web.fatwire.ov2.utilidades.UtilidadesCliente,
				   org.apache.commons.codec.binary.Base64,
				   java.util.*,
				   java.net.URLDecoder,
				   java.net.URLEncoder,
					com.fatwire.assetapi.data.*,
				   com.fatwire.assetapi.*,
				   com.fatwire.system.Session,
				   com.fatwire.system.SessionFactory,
				   com.openmarket.xcelerate.asset.AssetIdImpl"%>
<cs:ftcs><%

//MODO DEBUG
Boolean debug = true;
String temp = "";

%><ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" /></ics:then></ics:if><%
%><ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" /></ics:then></ics:if><%
%><%!
	private static final String CASTELLANO = "es_ES";
		
	// valores para los idiomas validos
	String [] idiomas = {"es_ES", "ca_ES", "gl_ES", "eu_ES", "en_GB", "fr_FR", "de_DE"};
%><%
// ARRAY XSS
List<String> array_xss = new ArrayList<String>();

// Parametros de entrada por defecto
String sidioma = ics.GetVar("sidioma"); // Recepcion de sidioma de la SiteEntry de COR_Wrapper
String sNombreCookie = ics.GetVar("nombreCookie");
String sValorCookie = ics.getCookie(sNombreCookie);
String site = ics.GetVar("site");
String p = ics.GetVar("p");
String c = ics.GetVar("c");
String cid = ics.GetVar("cid");
String packedargs = ics.GetVar("packedargs");
String pagename = ics.GetVar("pagename"); // Necesarias para validacion XSS
String childpagename = ics.GetVar("childpagename"); // Necesarias para validacion XSS

if (Utilities.goodString(sidioma)) { array_xss.add(sidioma); }
if (Utilities.goodString(sNombreCookie)) { array_xss.add(sNombreCookie); }
if (Utilities.goodString(sValorCookie)) { array_xss.add(sValorCookie); }
if (Utilities.goodString(site)) { array_xss.add(site); }
if (Utilities.goodString(p)) { array_xss.add(p); }
if (Utilities.goodString(c)) { array_xss.add(c); }
if (Utilities.goodString(cid)) { array_xss.add(cid); }
if (Utilities.goodString(packedargs)) { array_xss.add(packedargs); }
if (Utilities.goodString(pagename)) { array_xss.add(pagename); }
if (Utilities.goodString(childpagename)) { array_xss.add(childpagename); }

if (!Utilities.goodString(sidioma)) {
	sidioma = CASTELLANO;
}

//Extraccion y eliminacion de la variable sidioma del packedargs
String sidiomaPackedargs = null;
String packedargsAux = packedargs;
if (Utilities.goodString(packedargsAux)) {
	packedargsAux = URLDecoder.decode(packedargsAux,"UTF-8");
	%><render:unpackarg unpack="sidioma" remove="true" packed='<%=packedargsAux%>' outvar="packedargsAux" /><%
	sidiomaPackedargs = ics.GetVar("sidioma"); // Se almacena el valor de sidioma en sidiomaPackedargs por si es necesario recuperarlo
	packedargsAux = ics.GetVar("packedargsAux"); // Se actualiza la variable packedargsAux, ya que no es necesario pasar sidioma con la variable packedargsAux
	if (Utilities.goodString(packedargsAux)) {
	   packedargs = URLEncoder.encode(packedargsAux,"UTF-8"); // Si despues de eliminar el idioma hay algo mas, se hace encode de lo que ha quedado
	} else {
	   packedargs = null;
	}
}

// IF -> Se asigna como sidioma el idioma extraido del packedargs
// ELSE IF -> Si hay cookie que tiene valor distinto al sidioma y no hay idioma en el packedargs, se asigna el valor de la cookie al sidioma
if (Utilities.goodString(sidiomaPackedargs)) {
	// Si estaba informada en el packedargs, se comprueba si es diferente al valor acutal
	if (!sidioma.equals(sidiomaPackedargs)) {
		sidioma = sidiomaPackedargs; // Se actualiza con el valor que estaba informado en el packedargs
	}
}else if (Utilities.goodString(sNombreCookie) && Utilities.goodString(sValorCookie)) {
	if (!sidioma.equals(sValorCookie)) {
		// Si la cookie tiene un valor diferente, se establece como sidioma el valor de la cookie
		sidioma = sValorCookie;	
	}
}

// Despues de tener un idioma unico, comprobamos que esta declarado dentro de nuestros lenguajes validos para eso nos valemos del array declarado mas arriba.
boolean encontrado = false;
String idiomaelegido = null;
for (String elemento:idiomas) {
	if (sidioma.equals(elemento)) {
		// Si el idioma es igual a uno de los elementos es que es valido.
		encontrado = true;
		idiomaelegido = elemento;
	}
}
if (encontrado) {
	sidioma = idiomaelegido;
} else {
	//Si no lo ha encontrado, le doy el idioma mestro
	sidioma = CASTELLANO;
}

// inicializamos la variable bCookie para saber si necesitamos fijar cookie o modificar el idioma de la cookie existente
boolean bCookie = false;
if (Utilities.goodString(sidioma)) {
	// Verificamos que tenemos el nombre de la cookie
	if (Utilities.goodString(sNombreCookie)) {
		// Si no tenemos cookie o si su valor no coincide con el recibido,
		// intentamos fijarla con el valor de sidioma
		if (!Utilities.goodString(sValorCookie) || !sidioma.equals(sValorCookie)) {
			bCookie = true;
		}
	}
}
	
// Parametros Buscador Nueva Home
String tipo_buscador = ics.GetVar("tipo_buscador");
String busqueda = ics.GetVar("busqueda");
if (Utilities.goodString(tipo_buscador)) { array_xss.add(tipo_buscador); }
if (Utilities.goodString(busqueda)) { array_xss.add(busqueda); }

// Parametro del numero de factura para confirmacion
String f = ics.GetVar("f");
String numero = ics.GetVar("numero");
String Codigoexp = ics.GetVar("Codigoexp");
String Referencia = ics.GetVar("Referencia");
String codired = ics.GetVar("codired");
if (Utilities.goodString(f)) { array_xss.add(f); }
if (Utilities.goodString(numero)) { array_xss.add(numero); }
if (Utilities.goodString(Codigoexp)) { array_xss.add(Codigoexp); }
if (Utilities.goodString(Referencia)) { array_xss.add(Referencia); }
if (Utilities.goodString(codired)) { array_xss.add(codired); }

// Parametros del buscador, COR_Buscador
String q = ics.GetVar("q");
String Seccion = ics.GetVar("Seccion");
String Filatelia = ics.GetVar("Filatelia");
String fecha_filatelia = ics.GetVar("fecha_filatelia");
String Portal_Correos = ics.GetVar("Portal_Correos");
String Portal_Paqueteria = ics.GetVar("Portal_Paqueteria");
String Portal_Otros = ics.GetVar("Portal_Otros");
String ultimo_dia = ics.GetVar("ultimo_dia");
String ultimo_mes = ics.GetVar("ultimo_mes");
String ultimo_anio = ics.GetVar("ultimo_anio");
String fecha_todas = ics.GetVar("fecha_todas");
if (Utilities.goodString(q)) { array_xss.add(q); }
if (Utilities.goodString(Seccion)) { array_xss.add(Seccion); }
if (Utilities.goodString(Filatelia)) { array_xss.add(Filatelia); }
if (Utilities.goodString(fecha_filatelia)) { array_xss.add(fecha_filatelia); }
if (Utilities.goodString(Portal_Correos)) { array_xss.add(Portal_Correos); }
if (Utilities.goodString(Portal_Paqueteria)) { array_xss.add(Portal_Paqueteria); }
if (Utilities.goodString(Portal_Otros)) { array_xss.add(Portal_Otros); }
if (Utilities.goodString(ultimo_dia)) { array_xss.add(ultimo_dia); }
if (Utilities.goodString(ultimo_mes)) { array_xss.add(ultimo_mes); }
if (Utilities.goodString(ultimo_anio)) { array_xss.add(ultimo_anio); }
if (Utilities.goodString(fecha_todas)) { array_xss.add(fecha_todas); }

// Parametros formulario transparencia, FormularioTransparencia
String nom_y_ape = ics.GetVar("nom_y_ape");
String documentoId = ics.GetVar("documentoId");
String email = ics.GetVar("email");
String telefono = ics.GetVar("telefono");
String inf_solicitada = ics.GetVar("inf_solicitada");
String rec_info = ics.GetVar("rec_info");
String email_envio = ics.GetVar("email_envio");
String postal_calle = ics.GetVar("postal_calle");
String postal_num = ics.GetVar("postal_num");
String postal_piso = ics.GetVar("postal_piso");
String postal_loc = ics.GetVar("postal_loc");
String postal_pro = ics.GetVar("postal_pro");
String postal_cp = ics.GetVar("postal_cp");
String postal_pais = ics.GetVar("postal_pais");
String acepto = ics.GetVar("acepto");
String sendFormTrans = ics.GetVar("sendFormTrans");
String telecom = ics.GetVar("telecom"); // Identificacion si el formulario viene de Correos Telecom
if (Utilities.goodString(nom_y_ape)) { array_xss.add(nom_y_ape); }
if (Utilities.goodString(documentoId)) { array_xss.add(documentoId); }
if (Utilities.goodString(email)) { array_xss.add(email); }
if (Utilities.goodString(telefono)) { array_xss.add(telefono); }
if (Utilities.goodString(inf_solicitada)) { array_xss.add(inf_solicitada); }
if (Utilities.goodString(rec_info)) { array_xss.add(rec_info); }
if (Utilities.goodString(email_envio)) { array_xss.add(email_envio); }
if (Utilities.goodString(postal_calle)) { array_xss.add(postal_calle); }
if (Utilities.goodString(postal_num)) { array_xss.add(postal_num); }
if (Utilities.goodString(postal_piso)) { array_xss.add(postal_piso); }
if (Utilities.goodString(postal_loc)) { array_xss.add(postal_loc); }
if (Utilities.goodString(postal_pro)) { array_xss.add(postal_pro); }
if (Utilities.goodString(postal_cp)) { array_xss.add(postal_cp); }
if (Utilities.goodString(postal_pais)) { array_xss.add(postal_pais); }
if (Utilities.goodString(acepto)) { array_xss.add(acepto); }
if (Utilities.goodString(sendFormTrans)) { array_xss.add(sendFormTrans); }
if (Utilities.goodString(telecom)) { array_xss.add(telecom); }

// Parametros formulario Solicitud de Informacion
String fsi_nom = ics.GetVar("fsi_nom");
String fsi_ape = ics.GetVar("fsi_ape");
String fsi_cal = ics.GetVar("fsi_cal");
String fsi_num = ics.GetVar("fsi_num");
String fsi_pis = ics.GetVar("fsi_pis");
String fsi_pob = ics.GetVar("fsi_pob");
String fsi_pro = ics.GetVar("fsi_pro");
String fsi_cod = ics.GetVar("fsi_cod");
String fsi_tel = ics.GetVar("fsi_tel");
String fsi_ema = ics.GetVar("fsi_ema");
String fsi_inf = ics.GetVar("fsi_inf");
String fsi_sen = ics.GetVar("fsi_sen");
String fsi_cod_env = ics.GetVar("fsi_cod_env");
if (Utilities.goodString(fsi_nom)) { array_xss.add(fsi_nom); }
if (Utilities.goodString(fsi_ape)) { array_xss.add(fsi_ape); }
if (Utilities.goodString(fsi_cal)) { array_xss.add(fsi_cal); }
if (Utilities.goodString(fsi_num)) { array_xss.add(fsi_num); }
if (Utilities.goodString(fsi_pis)) { array_xss.add(fsi_pis); }
if (Utilities.goodString(fsi_pob)) { array_xss.add(fsi_pob); }
if (Utilities.goodString(fsi_pro)) { array_xss.add(fsi_pro); }
if (Utilities.goodString(fsi_cod)) { array_xss.add(fsi_cod); }
if (Utilities.goodString(fsi_tel)) { array_xss.add(fsi_tel); }
if (Utilities.goodString(fsi_ema)) { array_xss.add(fsi_ema); }
if (Utilities.goodString(fsi_inf)) { array_xss.add(fsi_inf); }
if (Utilities.goodString(fsi_sen)) { array_xss.add(fsi_sen); }
if (Utilities.goodString(fsi_cod_env)) { array_xss.add(fsi_cod_env); }

// Parametros Formularios DUA
String dua_sel_exp = ics.GetVar("dua_sel_exp");
String dua_ted_exp = ics.GetVar("dua_ted_exp");
String dua_nom_exp = ics.GetVar("dua_nom_exp");
String dua_cif_exp = ics.GetVar("dua_cif_exp");
String dua_dom_exp = ics.GetVar("dua_dom_exp");
String dua_pro_exp = ics.GetVar("dua_pro_exp");
String dua_pob_exp = ics.GetVar("dua_pob_exp");
String dua_cp_exp = ics.GetVar("dua_cp_exp");
String dua_nom_rep = ics.GetVar("dua_nom_rep");
String dua_nif_rep = ics.GetVar("dua_nif_rep");
String dua_nom_imp = ics.GetVar("dua_nom_imp");
String dua_cif_imp = ics.GetVar("dua_cif_imp");
String dua_pai_imp = ics.GetVar("dua_pai_imp");
String dua_num_env = ics.GetVar("dua_num_env");
String dua_send = ics.GetVar("dua_send");
if (Utilities.goodString(dua_sel_exp)) { array_xss.add(dua_sel_exp); }
if (Utilities.goodString(dua_ted_exp)) { array_xss.add(dua_ted_exp); }
if (Utilities.goodString(dua_nom_exp)) { array_xss.add(dua_nom_exp); }
if (Utilities.goodString(dua_cif_exp)) { array_xss.add(dua_cif_exp); }
if (Utilities.goodString(dua_dom_exp)) { array_xss.add(dua_dom_exp); }
if (Utilities.goodString(dua_pro_exp)) { array_xss.add(dua_pro_exp); }
if (Utilities.goodString(dua_pob_exp)) { array_xss.add(dua_pob_exp); }
if (Utilities.goodString(dua_cp_exp)) { array_xss.add(dua_cp_exp); }
if (Utilities.goodString(dua_nom_rep)) { array_xss.add(dua_nom_rep); }
if (Utilities.goodString(dua_nif_rep)) { array_xss.add(dua_nif_rep); }
if (Utilities.goodString(dua_nom_imp)) { array_xss.add(dua_nom_imp); }
if (Utilities.goodString(dua_cif_imp)) { array_xss.add(dua_cif_imp); }
if (Utilities.goodString(dua_pai_imp)) { array_xss.add(dua_pai_imp); }
if (Utilities.goodString(dua_num_env)) { array_xss.add(dua_num_env); }
if (Utilities.goodString(dua_send)) { array_xss.add(dua_send); }

// Parametros formulario Visita Museo
String strNumGrupos = ics.GetVar("strNumGrupos");
String strVisitantesGrupo = ics.GetVar("strVisitantesGrupo");
String strCentroAsoc = ics.GetVar("strCentroAsoc");
String strHorario = ics.GetVar("strHorario");
String strObservaciones = ics.GetVar("strObservaciones");
String strNombreCon = ics.GetVar("strNombreCon");
String strTelefonoCon = ics.GetVar("strTelefonoCon");
String strEmailCon = ics.GetVar("strEmailCon");
String strClave = ics.GetVar("strClave");
String strCaptcha = ics.GetVar("strCaptcha");
String enviadoFormulario = ics.GetVar("enviadoFormulario");
String newClaveCaptcha = ics.GetVar("newClaveCaptcha");
String confirmar = ics.GetVar("confirmar");
if (Utilities.goodString(strNumGrupos)) { array_xss.add(strNumGrupos); }
if (Utilities.goodString(strVisitantesGrupo)) { array_xss.add(strVisitantesGrupo); }
if (Utilities.goodString(strCentroAsoc)) { array_xss.add(strCentroAsoc); }
if (Utilities.goodString(strHorario)) { array_xss.add(strHorario); }
if (Utilities.goodString(strObservaciones)) { array_xss.add(strObservaciones); }
if (Utilities.goodString(strNombreCon)) { array_xss.add(strNombreCon); }
if (Utilities.goodString(strTelefonoCon)) { array_xss.add(strTelefonoCon); }
if (Utilities.goodString(strEmailCon)) { array_xss.add(strEmailCon); }
if (Utilities.goodString(strClave)) { array_xss.add(strClave); }
if (Utilities.goodString(strCaptcha)) { array_xss.add(strCaptcha); }
if (Utilities.goodString(enviadoFormulario)) { array_xss.add(enviadoFormulario); }
if (Utilities.goodString(newClaveCaptcha)) { array_xss.add(newClaveCaptcha); }
if (Utilities.goodString(confirmar)) { array_xss.add(confirmar); }

// Formulario buscador codigos postales
String pais = ics.GetVar("pais");
String provincia = ics.GetVar("provincia");
String localidad = ics.GetVar("localidad");
String fbcp_provincia = ics.GetVar("fbcp_provincia");
String fbcp_localidad = ics.GetVar("fbcp_localidad");
String direccion = ics.GetVar("direccion");
String fbcp_direccion = ics.GetVar("fbcp_direccion");
String fbcp_numero= ics.GetVar("fbcp_numero");
String fbcp_buscar= ics.GetVar("fbcp_buscar");
String formulario= ics.GetVar("formulario");
String fbcp_strLocalidadNombre = ics.GetVar("fbcp_strLocalidadNombre");
String fbcp_strCodPostal = ics.GetVar("fbcp_strCodPostal");
String strLocalidadNombre = ics.GetVar("strLocalidadNombre");
String strCodPostal = ics.GetVar("strCodPostal");
if (Utilities.goodString(pais)) { array_xss.add(pais); }
if (Utilities.goodString(provincia)) { array_xss.add(provincia); }
if (Utilities.goodString(localidad)) { array_xss.add(localidad); }
if (Utilities.goodString(fbcp_provincia)) { array_xss.add(fbcp_provincia); }
if (Utilities.goodString(fbcp_localidad)) { array_xss.add(fbcp_localidad); }
if (Utilities.goodString(fbcp_direccion)) { array_xss.add(fbcp_direccion); }
if (Utilities.goodString(direccion)) { array_xss.add(direccion); }
if (Utilities.goodString(fbcp_numero)) { array_xss.add(fbcp_numero); }
if (Utilities.goodString(numero)) { array_xss.add(numero); }
if (Utilities.goodString(fbcp_buscar)) { array_xss.add(fbcp_buscar); }
if (Utilities.goodString(formulario)) { array_xss.add(formulario); }
if (Utilities.goodString(fbcp_strLocalidadNombre)) { array_xss.add(fbcp_strLocalidadNombre); }
if (Utilities.goodString(fbcp_strCodPostal)) { array_xss.add(fbcp_strCodPostal); }
if (Utilities.goodString(strLocalidadNombre)) { array_xss.add(strLocalidadNombre); }
if (Utilities.goodString(strCodPostal)) { array_xss.add(strCodPostal); }

// Parametros formulario Mas Cerca
String nombre = ics.GetVar("nombre");
String apellidos = ics.GetVar("apellidos");
String empresa = ics.GetVar("empresa");
if (Utilities.goodString(nombre)) { array_xss.add(nombre); }
if (Utilities.goodString(apellidos)) { array_xss.add(apellidos); }
if (Utilities.goodString(empresa)) { array_xss.add(empresa); }

// Parametros aplicacion Calculador de Tarifas
String tarificador_idp = ics.GetVar("tarificador_idp");
String tarificador_idc = ics.GetVar("tarificador_idc");
if (Utilities.goodString(tarificador_idp)) { array_xss.add(tarificador_idp); }
if (Utilities.goodString(tarificador_idc)) { array_xss.add(tarificador_idc); }

//Parametros aplicacion Bolsa de Empleo
String bem_idAlta = ics.GetVar("bem_idAlta");
String bem_innif = ics.GetVar("bem_innif");
String bem_fechaNac = ics.GetVar("bem_fechaNac");
if (Utilities.goodString(bem_idAlta)) { array_xss.add(bem_idAlta); }
if (Utilities.goodString(bem_innif)) { array_xss.add(bem_innif); }
if (Utilities.goodString(bem_fechaNac)) { array_xss.add(bem_fechaNac); }

//Parametros aplicacion Concurso de Traslados 
String ctr_nip = ics.GetVar("ctr_nip");
String ctr_dni = ics.GetVar("ctr_dni");
String ctr_fnac = ics.GetVar("ctr_fnac");
String ctr_captcha = ics.GetVar("ctr_captcha");
String ctr_boton = ics.GetVar("ctr_boton");
String ctr_movil = ics.GetVar("ctr_movil");
String ctr_email = ics.GetVar("ctr_email");
String ctr_jornadaincompleta = ics.GetVar("ctr_jornadaincompleta");   	
String ctr_condicionado = ics.GetVar("ctr_condicionado");				
String ctr_dni_condicionado = ics.GetVar("ctr_dni_condicionado");		
String ctr_condicionado_padres = ics.GetVar("ctr_condicionado_padres");	
String ctr_condicionado_hijos = ics.GetVar("ctr_condicionado_hijos");	
String ctr_provincia = ics.GetVar("ctr_provincia"); 
String ctr_localidad = ics.GetVar("ctr_localidad");
String ctr_unidad = ics.GetVar("ctr_unidad");
String ctr_puesto = ics.GetVar("ctr_puesto");
String ctr_aport_local = ics.GetVar("ctr_aport_local");
String ctr_provincia_grabacion = ics.GetVar("ctr_provincia_grabacion"); 
String ctr_fecha_registro = ics.GetVar("ctr_fecha_registro");
String ctr_array = ics.GetVar("ctr_array");		
String ctr_letra_dni = ics.GetVar("ctr_letra_dni");	
String ctr_nombre = ics.GetVar("ctr_nombre");		
String ctr_apellido_1 = ics.GetVar("ctr_apellido_1");		
String ctr_apellido_2 = ics.GetVar("ctr_apellido_2");
String ctr_funcionario = ics.GetVar("ctr_funcionario");


if (Utilities.goodString(ctr_nip)) { array_xss.add(ctr_nip); }
if (Utilities.goodString(ctr_dni)) { array_xss.add(ctr_dni); }
if (Utilities.goodString(ctr_fnac)) { array_xss.add(ctr_fnac); }
if (Utilities.goodString(ctr_captcha)) { array_xss.add(ctr_captcha); }
if (Utilities.goodString(ctr_boton)) { array_xss.add(ctr_boton); }
if (Utilities.goodString(ctr_movil)) { array_xss.add(ctr_movil); }
if (Utilities.goodString(ctr_email)) { array_xss.add(ctr_email); }
if (Utilities.goodString(ctr_jornadaincompleta)) { array_xss.add(ctr_jornadaincompleta); }
if (Utilities.goodString(ctr_condicionado)) { array_xss.add(ctr_condicionado); }
if (Utilities.goodString(ctr_dni_condicionado)) { array_xss.add(ctr_dni_condicionado); }
if (Utilities.goodString(ctr_condicionado_padres)) { array_xss.add(ctr_condicionado_padres); }
if (Utilities.goodString(ctr_condicionado_hijos)) { array_xss.add(ctr_condicionado_hijos); }
if (Utilities.goodString(ctr_provincia)) { array_xss.add(ctr_provincia); }
if (Utilities.goodString(ctr_localidad)) { array_xss.add(ctr_localidad); }
if (Utilities.goodString(ctr_unidad)) { array_xss.add(ctr_unidad); }
if (Utilities.goodString(ctr_puesto)) { array_xss.add(ctr_puesto); }
if (Utilities.goodString(ctr_aport_local)) { array_xss.add(ctr_aport_local); }
if (Utilities.goodString(ctr_provincia_grabacion)) { array_xss.add(ctr_provincia_grabacion); }
if (Utilities.goodString(ctr_fecha_registro)) { array_xss.add(ctr_fecha_registro); }
if (Utilities.goodString(ctr_array)) { array_xss.add(ctr_array); }
if (Utilities.goodString(ctr_letra_dni)) { array_xss.add(ctr_letra_dni); }
if (Utilities.goodString(ctr_nombre)) { array_xss.add(ctr_nombre); }
if (Utilities.goodString(ctr_apellido_1)) { array_xss.add(ctr_apellido_1); }
if (Utilities.goodString(ctr_apellido_2)) { array_xss.add(ctr_apellido_2); }
if (Utilities.goodString(ctr_funcionario)) { array_xss.add(ctr_funcionario); }


//Variables Bolsa de Empleo
String BEM_id_provincia = ics.GetVar("BEM_id_provincia");
String BEM_provincia = ics.GetVar("BEM_provincia");
String BEM_boton = ics.GetVar("BEM_boton");

if (Utilities.goodString(BEM_id_provincia)) { array_xss.add(BEM_id_provincia); }
if (Utilities.goodString(BEM_provincia)) { array_xss.add(BEM_provincia); }
if (Utilities.goodString(BEM_boton)) { array_xss.add(BEM_boton); }

// Parametros formulario Encuesta
String opcion1 = ics.GetVar("opcion1");
String opcion2 = ics.GetVar("opcion2");
String opcion3 = ics.GetVar("opcion3");
String opcion4 = ics.GetVar("opcion4");
String opcion5 = ics.GetVar("opcion5");
String opcion6 = ics.GetVar("opcion6");
if (Utilities.goodString(opcion1)) { array_xss.add(opcion1); }
if (Utilities.goodString(opcion2)) { array_xss.add(opcion2); }
if (Utilities.goodString(opcion3)) { array_xss.add(opcion3); }
if (Utilities.goodString(opcion4)) { array_xss.add(opcion4); }
if (Utilities.goodString(opcion5)) { array_xss.add(opcion5); }
if (Utilities.goodString(opcion6)) { array_xss.add(opcion6); }

// Parametros formulario Traduccion
String tra_strTipo = ics.GetVar("tra_strTipo");
String tra_strTipoDescripcion = ics.GetVar("tra_strTipoDescripcion");
String tra_strSubtipo = ics.GetVar("tra_strSubtipo");
String tra_strSubtipoDescripcion = ics.GetVar("tra_strSubtipoDescripcion");
String tra_strXmlfile = ics.GetVar("tra_strXmlfile");
if (Utilities.goodString(tra_strTipo)) { array_xss.add(tra_strTipo); }
if (Utilities.goodString(tra_strTipoDescripcion)) { array_xss.add(tra_strTipoDescripcion); }
if (Utilities.goodString(tra_strSubtipo)) { array_xss.add(tra_strSubtipo); }
if (Utilities.goodString(tra_strSubtipoDescripcion)) { array_xss.add(tra_strSubtipoDescripcion); }
if (Utilities.goodString(tra_strXmlfile)) { array_xss.add(tra_strXmlfile); }

// Parametros Formulario Camino de Santiago
String assetid = ics.GetVar("assetid");
String assettype = ics.GetVar("assettype");
String opcion = ics.GetVar("opcion");
if (Utilities.goodString(assetid)) { array_xss.add(assetid); }
if (Utilities.goodString(assettype)) { array_xss.add(assettype); }
if (Utilities.goodString(opcion)) { array_xss.add(opcion); }

// Parametros filtrado Productos y Servicios de la A-Z
String az_emp = ics.GetVar("az_emp");
String az_par = ics.GetVar("az_par");
String az_mov = ics.GetVar("az_mov");
String az_ofi = ics.GetVar("az_ofi");
String az_onl = ics.GetVar("az_onl");
String az_ini = ics.GetVar("az_ini");
if (Utilities.goodString(az_emp)) { array_xss.add(az_emp); }
if (Utilities.goodString(az_par)) { array_xss.add(az_par); }
if (Utilities.goodString(az_mov)) { array_xss.add(az_mov); }
if (Utilities.goodString(az_ofi)) { array_xss.add(az_ofi); }
if (Utilities.goodString(az_onl)) { array_xss.add(az_onl); }
if (Utilities.goodString(az_ini)) { array_xss.add(az_ini); }

// Parametros Buscador Hemeroteca (GSA) - Sala de Prensa
String SPH_Ordn = ics.GetVar("SPH_Ordn");
String SPH_Catg = ics.GetVar("SPH_Catg");
String SPH_Anio = ics.GetVar("SPH_Anio");
String SPH_Etiq = ics.GetVar("SPH_Etiq");
if (Utilities.goodString(SPH_Ordn)) { array_xss.add(SPH_Ordn); }
if (Utilities.goodString(SPH_Catg)) { array_xss.add(SPH_Catg); }
if (Utilities.goodString(SPH_Anio)) { array_xss.add(SPH_Anio); }
if (Utilities.goodString(SPH_Etiq)) { array_xss.add(SPH_Etiq); }

// Parametro Portal Devoluciones
String identificacion = ics.GetVar("identificacion");
if (Utilities.goodString(identificacion)) { array_xss.add(identificacion); }

// Variables para obtener la template de las page subtipo Redireccion
String subtipo = null;
Long assetidAsset = 0L;
Session sess;
AssetDataManager adm;
AssetId aid;
AssetData ad;
String auxTemplate = null;
List attrNames = new ArrayList();
attrNames.add("template");

// Parametros Formulario Nivelacion Contenidos
String man_dest = ics.GetVar("man_dest");
String man_type = ics.GetVar("man_type");
String man_stpe = ics.GetVar("man_stpe");
String man_fdsd = ics.GetVar("man_fdsd");
String man_fhst = ics.GetVar("man_fhst");
String aprovedList = ics.GetVar("aprovedList");


// Parametros Formulario Localizador Equipajes
String idEnvio = ics.GetVar("idEnvio");

// Parametros Formulario Localizador Envios
String locEnvioAction = ics.GetVar("locEnvioAction");
String cod_env_ind = ics.GetVar("cod_env_ind");
String cod_exp = ics.GetVar("cod_exp");
String cods_env_mas = ics.GetVar("cods_env_mas");
String email_loc_mas = ics.GetVar("email_loc_mas");

%><asset:load name="idPageH" type="Configuracion" field="name" value="idPageHome" /><%
%><asset:get name="idPageH" field="valor" output="inicioSiteH" /><%
String inicioSite = ics.GetVar("inicioSiteH");

// Recogidas todas las variables de entrada, se procede a la validacion XSS
String validaXSS = null;
if (array_xss.size() > 0) {
	ics.SetObj("listXSS", array_xss);
	%><render:callelement elementname="correos/webpublica/logica/COR_ValidarXSS" scoped="global"></render:callelement><%
	validaXSS = ics.GetVar("validaXSS");
	if (Utilities.goodString(validaXSS) && "false".equals(validaXSS)) {
		%><render:callelement elementname="correos/webpublica/logica/COR_calcularUrl" scoped="global"><%
			%><render:argument name="sidioma" value='<%=sidioma%>' /><%
			%><render:argument name="site" value='<%=site%>' /><%
			%><render:argument name="p" value='<%=inicioSite%>' /><%
			%><render:argument name="c" value="Page" /><%
			%><render:argument name="cid" value='<%=inicioSite%>' /><%
			%><render:argument name="sVarUrl" value="urlHome" /><%
		%></render:callelement><%
		
		%><html>
			<head>
				<meta http-equiv="refresh" content='0; url=<%=ics.GetVar("urlHome")%>'>
			</head>
			<body></body>
		</html><%
	}
}

if ("true".equals(validaXSS)) {
	// SOLO si la validacion ha ido bien, se hace la llamada a LAYOUT
	
	// A partir de aqui, NO SE DEBE coger ninguna variable de entrada, ya que todas tienen que ser VALIDADAS

	%><render:callelement elementname="correos/webpublica/logica/COR_comprobarcontenido" scoped="global"><%
		%><render:argument name="c" value='<%=c%>' /><%
		%><render:argument name="cid" value='<%=cid%>' /><%
		%><render:argument name="p" value='<%=p%>' /><%
	%></render:callelement><%

	String existe = ics.GetVar("existe");
	if (existe==null || "false".equals(existe)) {
		// todo recoger de siteplan o fichero o mapeo
		if (Utilities.goodString(inicioSite)) {
			p = cid = inicioSite;
		}
		c = "Page";
	}


	// Variable que se envia a COR_Wrapper para especificar si hay que pintar el nuevo layout
	String pintaNewLayout = null;

	if (Utilities.goodString(c) && "Page".equals(c)) {
		// Si la pagina es la de error utilizamos su Layout
		%><assetset:setasset name="currentpage" type="Page" id='<%=cid%>' /><%
		%><asset:getsubtype type="Page" objectid='<%=cid%>' output="currentpagesubtipo" /><%
		subtipo = ics.GetVar("currentpagesubtipo");
/* Se comenta para poder definir la página de error a través del gestor de contenidos.
		if ("Error".equals(subtipo)) {
			ics.SetVar("childpagename","CorreosSite/COR_Layout_Error");
		}
*/
		if ("Comandia_A".equals(subtipo)) {
			ics.SetVar("childpagename","CorreosSite/Page/COM_Layout_A");
		}
		if ("Comandia_B".equals(subtipo)) {
			ics.SetVar("childpagename","CorreosSite/Page/COM_Layout_B");
		}
		if ("Redireccion".equals(subtipo)) {
			// Recuperacion del template al que hay que redireccionar, especificado en la Page
			assetidAsset = Long.parseLong(cid);
			sess = SessionFactory.getSession();
			adm = (AssetDataManager) sess.getManager(AssetDataManager.class.getName());
			aid = new AssetIdImpl("Page", assetidAsset);
			ad = adm.readAttributes(aid, attrNames);
			auxTemplate = (String) ad.getAttributeData("template").getData();
			ics.SetVar("childpagename", auxTemplate);
		}
		if ("NuevaHome".equals(subtipo)) {
			pintaNewLayout = "pinta";
		}
		if ("NuevaSubHomeInfCorp".equals(subtipo)) {
			pintaNewLayout = "pinta";
		}
		ics.RemoveVar("currentpagesubtipo");
	}
	
	if (Utilities.goodString(c) && "Oficina_P".equals(c)) {
		// Los detalles de las oficinas tienen que pintarse con el nuevo layout
		pintaNewLayout = "pinta";
	}

	String template = ics.GetVar("childpagename").replaceAll(site,"");
	ics.RemoveVar("childpagename");

	// recuperamos cookie y sesion de usuario.
	%><ics:getcookie name='<%=UtilidadesCliente.COOKIE_OV2_GCA%>' output="ov2a" /><%
	%><ics:getcookie name='<%=UtilidadesCliente.COOKIE_OV2_GCB%>' output="ov2b" /><%

	// Parametro para el usuario de sesion
	String usuariosesion = ics.GetSSVar("idUsuarioSesion");
	UtilidadesCliente util = new UtilidadesCliente();
	String param_1 = ics.GetVar("ov2a");
	String param_2 = ics.GetVar("ov2b");
	String tokenXml  = "";
	if (param_1!=null && param_2!=null) {
		tokenXml = util.generarToken(param_1,param_2);
	}

	CookieOv2BeanInfo cookieInfo = null;
	String idUsuarioCookie = null;

	// validamos el tokenXml y recuperamos la informacion
	if (Utilities.goodString(tokenXml) && util.comprobarFirma(tokenXml)) {
		cookieInfo = util.recuperaCookieInfo(tokenXml);
		if (cookieInfo != null) {
			if (Utilities.goodString(cookieInfo.nombreCliente)) {
				idUsuarioCookie = new String(Base64.decodeBase64(cookieInfo.nombreCliente.getBytes("UTF-8")));
			} else if (Utilities.goodString(cookieInfo.empresaCliente)) {
				idUsuarioCookie = new String(Base64.decodeBase64(cookieInfo.empresaCliente.getBytes("UTF-8")));
			}
			if (Utilities.goodString(idUsuarioCookie)) {
				ics.SetSSVar("idUsuarioSesion",idUsuarioCookie);
			}
		} else if (Utilities.goodString(usuariosesion)) {
			%><ics:removessvar name="idUsuarioSesion" /><%
		}
	} else if (Utilities.goodString(usuariosesion)) {
		%><ics:removessvar name="idUsuarioSesion" /><%
	}

	// finalmente llamamos al Layout
	%><render:calltemplate site='<%=site%>'
							slotname="slotPrincipal"
							tid='<%=ics.GetVar("eid")%>'
							ttype="CSElement"
							c='<%=c%>'
							cid='<%=cid%>'
							tname='<%=template%>'
							context=""><%
		%><render:argument name="sidioma" value='<%=sidioma%>' /><%
		%><render:argument name="p" value='<%=p%>' /><%
		if (Utilities.goodString(validaXSS)) {
			%><render:argument name="validaXSS" value='<%=validaXSS%>' /><%
		}
		if (Utilities.goodString(packedargs)) {
			%><render:argument name="packedargs" value='<%=packedargs%>' /><%
		}
		if (Utilities.goodString(pintaNewLayout)) {
			%><render:argument name="pintaNewLayout" value='<%=pintaNewLayout%>' /><%
		}
		if (Utilities.goodString(f)) {
			%><render:argument name="f" value='<%=f%>' /><%
		}
		if (Utilities.goodString(numero)) {
			%><render:argument name="numero" value='<%=numero%>' /><%
		}
		if (Utilities.goodString(Codigoexp)) {
			%><render:argument name="Codigoexp" value='<%=Codigoexp%>' /><%
		}
		if (Utilities.goodString(Referencia)) {
			%><render:argument name="Referencia" value='<%=Referencia%>' /><%
		}
		if (Utilities.goodString(codired)) {
			%><render:argument name="codired" value='<%=codired%>' /><%
		}
		if (Utilities.goodString(tipo_buscador)) {
			%><render:argument name="tipo_buscador" value='<%=tipo_buscador%>' /><%
		}
		if (Utilities.goodString(busqueda)) {
			%><render:argument name="busqueda" value='<%=busqueda%>' /><%
		}
		if (Utilities.goodString(q)) {
			%><render:argument name="q" value='<%=q%>' /><%
		}
		if (Utilities.goodString(Seccion)) {
			%><render:argument name="Seccion" value='<%=Seccion%>' /><%
		}
		if (Utilities.goodString(Filatelia)) {
			%><render:argument name="Filatelia" value='<%=Filatelia%>' /><%
		}
		if (Utilities.goodString(fecha_filatelia)) {
			%><render:argument name="fecha_filatelia" value='<%=fecha_filatelia%>' /><%
		}
		if (Utilities.goodString(Portal_Correos)) {
			%><render:argument name="Portal_Correos" value='<%=Portal_Correos%>' /><%
		}
		if (Utilities.goodString(Portal_Paqueteria)) {
			%><render:argument name="Portal_Paqueteria" value='<%=Portal_Paqueteria%>' /><%
		}
		if (Utilities.goodString(Portal_Otros)) {
			%><render:argument name="Portal_Otros" value='<%=Portal_Otros%>' /><%
		}
		if (Utilities.goodString(ultimo_dia)) {
			%><render:argument name="ultimo_dia" value='<%=ultimo_dia%>' /><%
		}
		if (Utilities.goodString(ultimo_mes)) {
			%><render:argument name="ultimo_mes" value='<%=ultimo_mes%>' /><%
		}
		if (Utilities.goodString(ultimo_anio)) {
			%><render:argument name="ultimo_anio" value='<%=ultimo_anio%>' /><%
		}
		if (Utilities.goodString(fecha_todas)) {
			%><render:argument name="fecha_todas" value='<%=fecha_todas%>' /><%
		}
		if (Utilities.goodString(nom_y_ape)) {
			%><render:argument name="nom_y_ape" value='<%=nom_y_ape%>' /><%
		}
		if (Utilities.goodString(documentoId)) {
			%><render:argument name="documentoId" value='<%=documentoId%>' /><%
		}
		if (Utilities.goodString(email)) {
			%><render:argument name="email" value='<%=email%>' /><%
		}
		if (Utilities.goodString(telefono)) {
			%><render:argument name="telefono" value='<%=telefono%>' /><%
		}
		if (Utilities.goodString(inf_solicitada)) {
			%><render:argument name="inf_solicitada" value='<%=inf_solicitada%>' /><%
		}
		if (Utilities.goodString(rec_info)) {
			%><render:argument name="rec_info" value='<%=rec_info%>' /><%
		}
		if (Utilities.goodString(email_envio)) {
			%><render:argument name="email_envio" value='<%=email_envio%>' /><%
		}
		if (Utilities.goodString(postal_calle)) {
			%><render:argument name="postal_calle" value='<%=postal_calle%>' /><%
		}
		if (Utilities.goodString(postal_num)) {
			%><render:argument name="postal_num" value='<%=postal_num%>' /><%
		}
		if (Utilities.goodString(postal_piso)) {
			%><render:argument name="postal_piso" value='<%=postal_piso%>' /><%
		}
		if (Utilities.goodString(postal_loc)) {
			%><render:argument name="postal_loc" value='<%=postal_loc%>' /><%
		}
		if (Utilities.goodString(postal_pro)) {
			%><render:argument name="postal_pro" value='<%=postal_pro%>' /><%
		}
		if (Utilities.goodString(postal_cp)) {
			%><render:argument name="postal_cp" value='<%=postal_cp%>' /><%
		}
		if (Utilities.goodString(postal_pais)) {
			%><render:argument name="postal_pais" value='<%=postal_pais%>' /><%
		}
		if (Utilities.goodString(acepto)) {
			%><render:argument name="acepto" value='<%=acepto%>' /><%
		}
		if (Utilities.goodString(sendFormTrans)) {
			%><render:argument name="sendFormTrans" value='<%=sendFormTrans%>' /><%
		}
		if (Utilities.goodString(telecom)) {
			%><render:argument name="telecom" value='<%=telecom%>' /><%
		}
		if (Utilities.goodString(fsi_nom)) {
			%><render:argument name="fsi_nom" value='<%=fsi_nom%>' /><%
		}
		if (Utilities.goodString(fsi_ape)) {
			%><render:argument name="fsi_ape" value='<%=fsi_ape%>' /><%
		}
		if (Utilities.goodString(fsi_cal)) {
			%><render:argument name="fsi_cal" value='<%=fsi_cal%>' /><%
		}
		if (Utilities.goodString(fsi_num)) {
			%><render:argument name="fsi_num" value='<%=fsi_num%>' /><%
		}
		if (Utilities.goodString(fsi_pis)) {
			%><render:argument name="fsi_pis" value='<%=fsi_pis%>' /><%
		}
		if (Utilities.goodString(fsi_pob)) {
			%><render:argument name="fsi_pob" value='<%=fsi_pob%>' /><%
		}
		if (Utilities.goodString(fsi_pro)) {
			%><render:argument name="fsi_pro" value='<%=fsi_pro%>' /><%
		}
		if (Utilities.goodString(fsi_cod)) {
			%><render:argument name="fsi_cod" value='<%=fsi_cod%>' /><%
		}
		if (Utilities.goodString(fsi_tel)) {
			%><render:argument name="fsi_tel" value='<%=fsi_tel%>' /><%
		}
		if (Utilities.goodString(fsi_ema)) {
			%><render:argument name="fsi_ema" value='<%=fsi_ema%>' /><%
		}
		if (Utilities.goodString(fsi_inf)) {
			%><render:argument name="fsi_inf" value='<%=fsi_inf%>' /><%
		}
		if (Utilities.goodString(fsi_sen)) {
			%><render:argument name="fsi_sen" value='<%=fsi_sen%>' /><%
		}
		if (Utilities.goodString(fsi_cod_env)) {
			%><render:argument name="fsi_cod_env" value='<%=fsi_cod_env%>' /><%
		}
		if (Utilities.goodString(dua_sel_exp)) {
			%><render:argument name="dua_sel_exp" value='<%=dua_sel_exp%>' /><%
		}
		if (Utilities.goodString(dua_ted_exp)) {
			%><render:argument name="dua_ted_exp" value='<%=dua_ted_exp%>' /><%
		}
		if (Utilities.goodString(dua_nom_exp)) {
			%><render:argument name="dua_nom_exp" value='<%=dua_nom_exp%>' /><%
		}
		if (Utilities.goodString(dua_cif_exp)) {
			%><render:argument name="dua_cif_exp" value='<%=dua_cif_exp%>' /><%
		}
		if (Utilities.goodString(dua_dom_exp)) {
			%><render:argument name="dua_dom_exp" value='<%=dua_dom_exp%>' /><%
		}
		if (Utilities.goodString(dua_pro_exp)) {
			%><render:argument name="dua_pro_exp" value='<%=dua_pro_exp%>' /><%
		}
		if (Utilities.goodString(dua_pob_exp)) {
			%><render:argument name="dua_pob_exp" value='<%=dua_pob_exp%>' /><%
		}
		if (Utilities.goodString(dua_cp_exp)) {
			%><render:argument name="dua_cp_exp" value='<%=dua_cp_exp%>' /><%
		}
		if (Utilities.goodString(dua_nom_rep)) {
			%><render:argument name="dua_nom_rep" value='<%=dua_nom_rep%>' /><%
		}
		if (Utilities.goodString(dua_nif_rep)) {
			%><render:argument name="dua_nif_rep" value='<%=dua_nif_rep%>' /><%
		}
		if (Utilities.goodString(dua_nom_imp)) {
			%><render:argument name="dua_nom_imp" value='<%=dua_nom_imp%>' /><%
		}
		if (Utilities.goodString(dua_cif_imp)) {
			%><render:argument name="dua_cif_imp" value='<%=dua_cif_imp%>' /><%
		}
		if (Utilities.goodString(dua_pai_imp)) {
			%><render:argument name="dua_pai_imp" value='<%=dua_pai_imp%>' /><%
		}
		if (Utilities.goodString(dua_num_env)) {
			%><render:argument name="dua_num_env" value='<%=dua_num_env%>' /><%
		}
		if (Utilities.goodString(dua_send)) {
			%><render:argument name="dua_send" value='<%=dua_send%>' /><%
		}
		if (Utilities.goodString(assetid)) {
			%><render:argument name="assetid" value='<%=assetid%>' /><%
		}
		if (Utilities.goodString(assettype)) {
			%><render:argument name="assettype" value='<%=assettype%>' /><%
		}
		if (Utilities.goodString(opcion)) {
			%><render:argument name="opcion" value='<%=opcion%>' /><%
		}
		// Visita Museo
		if (Utilities.goodString(strNumGrupos)) {
			%><render:argument name="strNumGrupos" value='<%=strNumGrupos%>' /><%
		}
		if (Utilities.goodString(strVisitantesGrupo)) {
			%><render:argument name="strVisitantesGrupo" value='<%=strVisitantesGrupo%>' /><%
		}
		if (Utilities.goodString(strCentroAsoc)) {
			%><render:argument name="strCentroAsoc" value='<%=strCentroAsoc%>' /><%
		}
		if (Utilities.goodString(strHorario)) {
			%><render:argument name="strHorario" value='<%=strHorario%>' /><%
		}
		if (Utilities.goodString(strObservaciones)) {
			%><render:argument name="strObservaciones" value='<%=strObservaciones%>' /><%
		}
		if (Utilities.goodString(strNombreCon)) {
			%><render:argument name="strNombreCon" value='<%=strNombreCon%>' /><%
		}
		if (Utilities.goodString(strTelefonoCon)) {
			%><render:argument name="strTelefonoCon" value='<%=strTelefonoCon%>' /><%
		}
		if (Utilities.goodString(strEmailCon)) {
			%><render:argument name="strEmailCon" value='<%=strEmailCon%>' /><%
		}
		// Formulario buscador codigos postales
		if (Utilities.goodString(pais)) {
			%><render:argument name="pais" value='<%=pais%>' /><%
		}
		if (Utilities.goodString(provincia)) {
			%><render:argument name="provincia" value='<%=provincia%>' /><%
		}
		if (Utilities.goodString(localidad)) {
			%><render:argument name="localidad" value='<%=localidad%>' /><%
		}
		if (Utilities.goodString(fbcp_provincia)) {
			%><render:argument name="fbcp_provincia" value='<%=fbcp_provincia%>' /><%
		}
		if (Utilities.goodString(fbcp_localidad)) {
			%><render:argument name="fbcp_localidad" value='<%=fbcp_localidad%>' /><%
		}
		if (Utilities.goodString(fbcp_direccion)) {
			%><render:argument name="fbcp_direccion" value='<%=fbcp_direccion%>' /><%
		}
		if (Utilities.goodString(fbcp_numero)) {
			%><render:argument name="fbcp_numero" value='<%=fbcp_numero%>' /><%
		}
		if (Utilities.goodString(direccion)) {
			%><render:argument name="direccion" value='<%=direccion%>' /><%
		}
		if (Utilities.goodString(numero)) {
			%><render:argument name="numero" value='<%=numero%>' /><%
		}
		if (Utilities.goodString(fbcp_buscar)) {
			%><render:argument name="fbcp_buscar" value='<%=fbcp_buscar%>' /><%
		}
		if (Utilities.goodString(formulario)) {
			%><render:argument name="formulario" value='<%=formulario%>' /><%
		}		
		if (Utilities.goodString(fbcp_strLocalidadNombre)) {
			%><render:argument name="fbcp_strLocalidadNombre" value='<%=fbcp_strLocalidadNombre%>' /><%
		}
		if (Utilities.goodString(fbcp_strCodPostal)) {
			%><render:argument name="fbcp_strCodPostal" value='<%=fbcp_strCodPostal%>' /><%
		}
		if (Utilities.goodString(strLocalidadNombre)) {
			%><render:argument name="strLocalidadNombre" value='<%=strLocalidadNombre%>' /><%
		}
		if (Utilities.goodString(strCodPostal)) {
			%><render:argument name="strCodPostal" value='<%=strCodPostal%>' /><%
		}	
		if (Utilities.goodString(newClaveCaptcha)) {
			%><render:argument name="newClaveCaptcha" value='<%=newClaveCaptcha%>' /><%
		}
		if (Utilities.goodString(confirmar)) {
			%><render:argument name="confirmar" value='<%=confirmar%>' /><%
		}
		
		// Parametros formulario Mas Cerca
		if (Utilities.goodString(nombre)) {
			%><render:argument name="nombre" value='<%=nombre%>' /><%
		}
		if (Utilities.goodString(apellidos)) {
			%><render:argument name="apellidos" value='<%=apellidos%>' /><%
		}
		if (Utilities.goodString(empresa)) {
			%><render:argument name="empresa" value='<%=empresa%>' /><%
		}

		//Parametros aplicacion Calculador de Tarifas
		if (Utilities.goodString(tarificador_idp)) {
			%><render:argument name="tarificador_idp" value='<%=tarificador_idp%>' /><%
		}
		if (Utilities.goodString(tarificador_idc)) {
			%><render:argument name="tarificador_idc" value='<%=tarificador_idc%>' /><%
		}
		
		//Parametros aplicacion Bolsa de Empleo 
		if (Utilities.goodString(bem_idAlta)) {
			%><render:argument name="bem_idAlta" value='<%=bem_idAlta%>' /><%
		}
		if (Utilities.goodString(bem_innif)) {
			%><render:argument name="bem_innif" value='<%=bem_innif%>' /><%
		}
		if (Utilities.goodString(bem_fechaNac)) {
			%><render:argument name="bem_fechaNac" value='<%=bem_fechaNac%>' /><%
		}

		//Parametros aplicacion Concurso de Traslados 
		if (Utilities.goodString(ctr_nip)) {
			%><render:argument name="ctr_nip" value='<%=ctr_nip%>' /><%
		}
		if (Utilities.goodString(ctr_dni)) {
			%><render:argument name="ctr_dni" value='<%=ctr_dni%>' /><%
		}
		if (Utilities.goodString(ctr_fnac)) {
			%><render:argument name="ctr_fnac" value='<%=ctr_fnac%>' /><%
		}
		if (Utilities.goodString(ctr_captcha)) {
			%><render:argument name="ctr_captcha" value='<%=ctr_captcha%>' /><%
		}
		if (Utilities.goodString(ctr_boton)) {
			%><render:argument name="ctr_boton" value='<%=ctr_boton%>' /><%
		}
		if (Utilities.goodString(ctr_movil)) {
			%><render:argument name="ctr_movil" value='<%=ctr_movil%>' /><%
		}		
		if (Utilities.goodString(ctr_email)) {
			%><render:argument name="ctr_email" value='<%=ctr_email%>' /><%
		}		
		if (Utilities.goodString(ctr_jornadaincompleta)) {
			%><render:argument name="ctr_jornadaincompleta" value='<%=ctr_jornadaincompleta%>' /><%
		}		
		if (Utilities.goodString(ctr_condicionado)) {
			%><render:argument name="ctr_condicionado" value='<%=ctr_condicionado%>' /><%
		}
		if (Utilities.goodString(ctr_dni_condicionado)) {
			%><render:argument name="ctr_dni_condicionado" value='<%=ctr_dni_condicionado%>' /><%
		}					
		if (Utilities.goodString(ctr_condicionado_padres)) {
			%><render:argument name="ctr_condicionado_padres" value='<%=ctr_condicionado_padres%>' /><%
		}		
		if (Utilities.goodString(ctr_condicionado_hijos)) {
			%><render:argument name="ctr_condicionado_hijos" value='<%=ctr_condicionado_hijos%>' /><%
		}			
		if (Utilities.goodString(ctr_provincia)) {
			%><render:argument name="ctr_provincia" value='<%=ctr_provincia%>' /><%
		}
		if (Utilities.goodString(ctr_localidad)) {
			%><render:argument name="ctr_localidad" value='<%=ctr_localidad%>' /><%
		}
		if (Utilities.goodString(ctr_unidad)) {
			%><render:argument name="ctr_unidad" value='<%=ctr_unidad%>' /><%
		}
		if (Utilities.goodString(ctr_puesto)) {
			%><render:argument name="ctr_puesto" value='<%=ctr_puesto%>' /><%
		}		
		if (Utilities.goodString(ctr_aport_local)) {
			%><render:argument name="ctr_aport_local" value='<%=ctr_aport_local%>' /><%
		}
		if (Utilities.goodString(ctr_provincia_grabacion)) {
			%><render:argument name="ctr_provincia_grabacion" value='<%=ctr_provincia_grabacion%>' /><%
		}
		if (Utilities.goodString(ctr_fecha_registro)) {
			%><render:argument name="ctr_fecha_registro" value='<%=ctr_fecha_registro%>' /><%
		}		
		if (Utilities.goodString(ctr_array)) {
			%><render:argument name="ctr_array" value='<%=ctr_array%>' /><%
		}	
		if (Utilities.goodString(ctr_letra_dni)) {
			%><render:argument name="ctr_letra_dni" value='<%=ctr_letra_dni%>' /><%
		}				
		if (Utilities.goodString(ctr_nombre)) {
			%><render:argument name="ctr_nombre" value='<%=ctr_nombre%>' /><%
		}				
		if (Utilities.goodString(ctr_apellido_1)) {
			%><render:argument name="ctr_apellido_1" value='<%=ctr_apellido_1%>' /><%
		}				
		if (Utilities.goodString(ctr_apellido_2)) {
			%><render:argument name="ctr_apellido_2" value='<%=ctr_apellido_2%>' /><%
		}				
		if (Utilities.goodString(ctr_funcionario)) {
			%><render:argument name="ctr_funcionario" value='<%=ctr_funcionario%>' /><%
		}	

		
		//Parametros Bolsa de Empleo
		if (Utilities.goodString(BEM_id_provincia)) {
			%><render:argument name="BEM_id_provincia" value='<%=BEM_id_provincia%>' /><%
		}	
		if (Utilities.goodString(BEM_provincia)) {
			%><render:argument name="BEM_provincia" value='<%=BEM_provincia%>' /><%
		}
		if (Utilities.goodString(BEM_boton)) {
			%><render:argument name="BEM_boton" value='<%=BEM_boton%>' /><%
		}
		
		// Parametros formulario encuesta
		if (Utilities.goodString(opcion1)) {
			%><render:argument name="opcion1" value='<%=opcion1%>' /><%
		}
		if (Utilities.goodString(opcion2)) {
			%><render:argument name="opcion2" value='<%=opcion2%>' /><%
		}
		if (Utilities.goodString(opcion3)) {
			%><render:argument name="opcion3" value='<%=opcion3%>' /><%
		}
		if (Utilities.goodString(opcion4)) {
			%><render:argument name="opcion4" value='<%=opcion4%>' /><%
		}
		if (Utilities.goodString(opcion5)) {
			%><render:argument name="opcion5" value='<%=opcion5%>' /><%
		}
		if (Utilities.goodString(opcion6)) {
			%><render:argument name="opcion6" value='<%=opcion6%>' /><%
		}
		

		// Si hay que fijar la cookie o modificar su idioma, se lo decimos al layout para que lo haga el
		if (bCookie && Utilities.goodString(sNombreCookie)) {
			%><render:argument name="setCookie" value="<%=sNombreCookie%>" /><%
		}
		// Parametros formulario Traduccion
		if (Utilities.goodString(tra_strTipo)) {
			%><render:argument name="tra_strTipo" value='<%=tra_strTipo%>' /><%
		}
		if (Utilities.goodString(tra_strTipoDescripcion)) {
			%><render:argument name="tra_strTipoDescripcion" value='<%=tra_strTipoDescripcion%>' /><%
		}
		if (Utilities.goodString(tra_strSubtipo)) {
			%><render:argument name="tra_strSubtipo" value='<%=tra_strSubtipo%>' /><%
		}
		if (Utilities.goodString(tra_strSubtipoDescripcion)) {
			%><render:argument name="tra_strSubtipoDescripcion" value='<%=tra_strSubtipoDescripcion%>' /><%
		}
		if (Utilities.goodString(tra_strXmlfile)) {
			%><render:argument name="tra_strXmlfile" value='<%=tra_strXmlfile%>' /><%
		}
		if (Utilities.goodString(strClave)) {
			%><render:argument name="strClave" value='<%=strClave%>' /><%
		}
		if (Utilities.goodString(strCaptcha)) {
			%><render:argument name="strCaptcha" value='<%=strCaptcha%>' /><%
		}
		if (Utilities.goodString(enviadoFormulario)) {
			%><render:argument name="enviadoFormulario" value='<%=enviadoFormulario%>' /><%
		}
		// Parametros filtrado Productos/Servicios A-Z
		if (Utilities.goodString(az_emp)) {
			%><render:argument name="az_emp" value='<%=az_emp%>' /><%
		}
		if (Utilities.goodString(az_par)) {
			%><render:argument name="az_par" value='<%=az_par%>' /><%
		}
		if (Utilities.goodString(az_mov)) {
			%><render:argument name="az_mov" value='<%=az_mov%>' /><%
		}
		if (Utilities.goodString(az_ofi)) {
			%><render:argument name="az_ofi" value='<%=az_ofi%>' /><%
		}
		if (Utilities.goodString(az_onl)) {
			%><render:argument name="az_onl" value='<%=az_onl%>' /><%
		}
		if (Utilities.goodString(az_ini)) {
			%><render:argument name="az_ini" value='<%=az_ini%>' /><%
		}
		// Parametros Buscador Hemeroteca (GSA) - Sala de Prensa
		if (Utilities.goodString(SPH_Ordn)) {
			%><render:argument name="SPH_Ordn" value='<%=SPH_Ordn%>' /><%
		}
		if (Utilities.goodString(SPH_Catg)) {
			%><render:argument name="SPH_Catg" value='<%=SPH_Catg%>' /><%
		}
		if (Utilities.goodString(SPH_Anio)) {
			%><render:argument name="SPH_Anio" value='<%=SPH_Anio%>' /><%
		}
		if (Utilities.goodString(SPH_Etiq)) {
			%><render:argument name="SPH_Etiq" value='<%=SPH_Etiq%>' /><%
		}
		// Parametro Portal Devoluciones
		if (Utilities.goodString(identificacion)) {
			%><render:argument name="identificacion" value='<%=identificacion%>' /><%
		}

		// Parametros Formulario Nivelacion Contenidos entre entornos
		if (Utilities.goodString(man_dest)) {
			%><render:argument name="man_dest" value='<%=man_dest%>' /><%
		}
		if (Utilities.goodString(man_type)) {
			%><render:argument name="man_type" value='<%=man_type%>' /><%
		}
		if (Utilities.goodString(man_stpe)) {
			%><render:argument name="man_stpe" value='<%=man_stpe%>' /><%
		}
		if (Utilities.goodString(man_fdsd)) {
			%><render:argument name="man_fdsd" value='<%=man_fdsd%>' /><%
		}
		if (Utilities.goodString(man_fhst)) {
			%><render:argument name="man_fhst" value='<%=man_fhst%>' /><%
		}
		if (Utilities.goodString(aprovedList)) {
			%><render:argument name="aprovedList" value='<%=aprovedList%>' /><%
		}
		
		// Parametros Formulario Localizador Equipajes
		if (Utilities.goodString(idEnvio)) {
			%><render:argument name="idEnvio" value='<%=idEnvio%>' /><%
		}
		
		// Parametros Formulario Localizador Envios
		if (Utilities.goodString(locEnvioAction)) {
			%><render:argument name="locEnvioAction" value='<%=locEnvioAction%>' /><%
		}
		if (Utilities.goodString(cod_env_ind)) {
			%><render:argument name="cod_env_ind" value='<%=cod_env_ind%>' /><%
		}
		if (Utilities.goodString(cod_exp)) {
			%><render:argument name="cod_exp" value='<%=cod_exp%>' /><%
		}
		if (Utilities.goodString(cods_env_mas)) {
			%><render:argument name="cods_env_mas" value='<%=cods_env_mas%>' /><%
		}
		if (Utilities.goodString(email_loc_mas)) {
			%><render:argument name="email_loc_mas" value='<%=email_loc_mas%>' /><%
		}

	%></render:calltemplate><%
}
%></cs:ftcs>
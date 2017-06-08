<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
					COM.FutureTense.Util.ftMessage,
					COM.FutureTense.Util.ftErrors,
					java.net.URLDecoder,
					org.apache.commons.lang.StringUtils,
					javax.servlet.http.Cookie"
%>

<cs:ftcs><%-- /COR_Layout

Plantilla General para todos los assets de la web de correos.
Dibuja los elementos comunes a todas las paginas (head, cabecera, , pie...)
y para la parte central invoca al template adecuado en funcion del assettype

INPUT
sidioma* 	-> (String) 	Parametro recibido con el idioma de navegacion
pathStatic*	-> (String)		Variable con la ruta a los ficheros estaticos. Viene definida en el template
setCookie	-> (String)		Si  tiene valor, se hace un setCookie con el idioma de navegacion

OUTPUT
Pagina HTML completa con la informacion del asset que se est dibujando
--%>

<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" /></ics:then></ics:if><%
//MODO DEBUG
Boolean debug = true;
String temp = "";
// Parametros de entrada por defecto
String c = ics.GetVar("c");
String cid = ics.GetVar("cid");
String p = ics.GetVar("p");
String site = ics.GetVar("site");
String packedargs = ics.GetVar("packedargs");
String packedargsDecode = null;

String pintaNewLayout = ics.GetVar("pintaNewLayout"); // Variable que informa COR_Wrapper y especifica si hay que pintar el nuevo Layout

// Recogemos la variable con el idioma de navegacion
String sidioma = ics.GetVar("sidioma");
if (StringUtils.isEmpty(sidioma)) sidioma="es_ES";

%><asset:load name="configestaticos" type="Configuracion" field="name" value="pathStatic" /><%
%><asset:get name="configestaticos" field="valor" output="sPathStatic" /><%
// Obtenemos la ruta de los ficheros estaticos y nos aseguramos que acaba en /
String sPathStatic = StringUtils.isNotEmpty(ics.GetVar("sPathStatic")) ? ics.GetVar("sPathStatic") : "";
sPathStatic = sPathStatic.endsWith("/") ? sPathStatic : sPathStatic;

// Si no hay validacion de URL y parametros (se esta atacando directamente a Layout), se redirige a la Home
String validaXSS = ics.GetVar("validaXSS");
if (!Utilities.goodString(validaXSS) || "false".equals(validaXSS)) {

	%><asset:load name="idHome" type="Configuracion" field="name" value="idPageHome" /><%
	%><asset:get name="idHome" field="valor" output="valIdPageHome" /><%
	%><render:callelement elementname="correos/webpublica/logica/COR_calcularUrl" scoped="global"><%
		%><render:argument name="sidioma" value='<%=sidioma%>' /><%
		%><render:argument name="site" value='<%=site%>' /><%
		%><render:argument name="p" value='<%=ics.GetVar("valIdPageHome")%>' /><%
		%><render:argument name="c" value="Page" /><%
		%><render:argument name="cid" value='<%=ics.GetVar("valIdPageHome")%>' /><%
		%><render:argument name="sVarUrl" value="urlHome" /><%
	%></render:callelement><%
	
	%><html>
		<head>
			<meta http-equiv="refresh" content='0; url=<%=ics.GetVar("urlHome")%>'>
		</head>
		<body></body>
	</html><%

} else if ("true".equals(validaXSS)) {

	// Si hay validacion de URL y parametros, se pinta lo solicitado y no se redirige a la Home

	// CUIDADO!! Todas las variables declaradas aqui solo son validas dentro del bloque else. No se deberian utilizar fuera de este ambito,
	// ya que supondria estar fuera de la validacion XSS. Esto se ha tenido que hacer asi para los ataques directos a Layout con
	// pagename=CorreosSite/COR_Layout

	// Parametros Buscador Nueva Home
	String tipo_buscador = ics.GetVar("tipo_buscador");
	String busqueda = ics.GetVar("busqueda");

	// Parametro del numero de factura para confirmacion
	String f = ics.GetVar("f");
	String numero = ics.GetVar("numero");
	String Codigoexp = ics.GetVar("Codigoexp");
	String Referencia = ics.GetVar("Referencia");
	String codired = ics.GetVar("codired");

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

	// Parametros formulario Visita Museo
	String strNumGrupos = ics.GetVar("strNumGrupos");
	String strVisitantesGrupo = ics.GetVar("strVisitantesGrupo");
	String strCentroAsoc = ics.GetVar("strCentroAsoc");
	String strHorario = ics.GetVar("strHorario");
	String strObservaciones = ics.GetVar("strObservaciones");
	String strNombreCon = ics.GetVar("strNombreCon");
	String strTelefonoCon = ics.GetVar("strTelefonoCon");
	String strEmailCon = ics.GetVar("strEmailCon");
	String strClave= ics.GetVar("strClave");
	String strCaptcha= ics.GetVar("strCaptcha");
	String enviadoFormulario = ics.GetVar("enviadoFormulario");
	String newClaveCaptcha= ics.GetVar("newClaveCaptcha");
	String confirmar= ics.GetVar("confirmar");
	
	// Parametros formulario Mas Cerca
	String nombre = ics.GetVar("nombre");
	String apellidos = ics.GetVar("apellidos");
	String empresa = ics.GetVar("empresa");

	// Parametros aplicacion Calculador de Tarifas
	String tarificador_idp = ics.GetVar("tarificador_idp");
	String tarificador_idc = ics.GetVar("tarificador_idc");

	//Parametros aplicacion Bolsa de Empleo
	String bem_idAlta = ics.GetVar("bem_idAlta");
	String bem_innif = ics.GetVar("bem_innif");
	String bem_fechaNac = ics.GetVar("bem_fechaNac");

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

	
	//Parametros aplicacion Bolsa de Empleo
	String BEM_id_provincia = ics.GetVar("BEM_id_provincia");
	String BEM_provincia = ics.GetVar("BEM_provincia");
	String BEM_boton = ics.GetVar("BEM_boton");
	
	// Parametros formulario encuesta
	String opcion1 = ics.GetVar("opcion1");
	String opcion2 = ics.GetVar("opcion2");
	String opcion3 = ics.GetVar("opcion3");
	String opcion4 = ics.GetVar("opcion4");
	String opcion5 = ics.GetVar("opcion5");
	String opcion6 = ics.GetVar("opcion6");
	
	// Parametros formulario consulta codigos postales
	String pais = ics.GetVar("pais");
	String provincia = ics.GetVar("provincia");
	String localidad = ics.GetVar("localidad");
	String fbcp_provincia = ics.GetVar("fbcp_provincia");
	String fbcp_localidad = ics.GetVar("fbcp_localidad");
	String fbcp_direccion = ics.GetVar("fbcp_direccion");
	String direccion = ics.GetVar("direccion");
	String fbcp_numero= ics.GetVar("fbcp_numero");
	String fbcp_buscar= ics.GetVar("fbcp_buscar");
	String formulario= ics.GetVar("formulario");
	String fbcp_strLocalidadNombre = ics.GetVar("fbcp_strLocalidadNombre");
	String fbcp_strCodPostal = ics.GetVar("fbcp_strCodPostal");
	String strLocalidadNombre = ics.GetVar("strLocalidadNombre");
	String strCodPostal = ics.GetVar("strCodPostal");

	// Parametros formulario Traduccion
	String tra_strTipo = ics.GetVar("tra_strTipo");
	String tra_strTipoDescripcion = ics.GetVar("tra_strTipoDescripcion");
	String tra_strSubtipo = ics.GetVar("tra_strSubtipo");
	String tra_strSubtipoDescripcion = ics.GetVar("tra_strSubtipoDescripcion");
	String tra_strXmlfile = ics.GetVar("tra_strXmlfile");
	
	// Parametros Formulario Camino de Santiago
	String assetid = ics.GetVar("assetid");
	String assettype = ics.GetVar("assettype");
	String opcion = ics.GetVar("opcion");

	// Parametros filtrado Productos y Servicios de la A-Z
	String az_emp = ics.GetVar("az_emp");
	String az_par = ics.GetVar("az_par");
	String az_mov = ics.GetVar("az_mov");
	String az_ofi = ics.GetVar("az_ofi");
	String az_onl = ics.GetVar("az_onl");
	String az_ini = ics.GetVar("az_ini");
	
	// Parametros Buscador Hemeroteca (GSA) - Sala de Prensa
	String SPH_Ordn = ics.GetVar("SPH_Ordn");
	String SPH_Catg = ics.GetVar("SPH_Catg");
	String SPH_Anio = ics.GetVar("SPH_Anio");
	String SPH_Etiq = ics.GetVar("SPH_Etiq");
	
	// Parametro Portal Devoluciones
	String identificacion = ics.GetVar("identificacion");
	
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

	%><!DOCTYPE html>
	<!--[if lt IE 8 ]> <html lang="<%=sidioma.substring(0,2)%>" class="ie7 no-js">    <![endif]-->
	<!--[if IE 8 ]>    <html lang="<%=sidioma.substring(0,2)%>" class="ie8 no-js">    <![endif]-->
	<!--[if IE 9 ]>    <html lang="<%=sidioma.substring(0,2)%>" class="ie9 no-js">    <![endif]-->
	<!--[if (gt IE 9)|!(IE)]><!--><html lang="<%=sidioma.substring(0,2)%>" class="no-js"><!--<![endif]--><%

	// Inicializamos el nombre de la template a la template por defecto
	String sNombreTemplate = null;
	String sNombreTemplateAux = null;

	// Tratamiento inicial del parametro p
	// Si estamos en el detalle de una pagina, buscamos la template asignada al asset
	if ("Page".equals(c)) {

		%><asset:load name="currentPage" type="Page" objectid='<%=cid%>' /><%
		%><asset:get name="currentPage" field="template" output="templateName" /><%
		sNombreTemplate = ics.GetVar("templateName");
		p = cid; // si se hace este cakmbio, el menu superior no lo monta bien....
	} else if (Utilities.goodString(packedargs)) {

		packedargsDecode = URLDecoder.decode(packedargs,"UTF-8");
		%><render:unpackarg unpack="includeTemplate" remove="false" packed='<%=packedargsDecode%>' outvar="packedargsDecode" /><%
		if (Utilities.goodString(ics.GetVar("includeTemplate"))) {
			sNombreTemplate = ics.GetVar("includeTemplate");
			sNombreTemplateAux = sNombreTemplate;
		}
	}

	%><render:callelement elementname="correos/webpublica/logica/COR_ObetenerTituloPage" scoped="global"><%
		%><render:argument name="sidioma" value='<%=sidioma%>' /><%
		%><render:argument name="cid" value='<%=p%>' /><%
	%></render:callelement><%
	String tituloPage = ics.GetVar("tituloPagina");

	// Agrego el tiempo de expiracion de la cache. Habria que darle un tiempo mas corto
	response.setDateHeader("Expires",Long.MAX_VALUE);

	if (Utilities.goodString(sNombreTemplateAux)) {
		while (sNombreTemplateAux.contains("%")) {
			sNombreTemplateAux = URLDecoder.decode(sNombreTemplateAux,"UTF-8");
		}
	}
	%><render:satellitepage pagename="correos/webpublica/layout/COR_head"><%
		%><render:argument name="c" value='<%=c%>' /><%
		%><render:argument name="cid" value='<%=cid%>' /><%
		%><render:argument name="sidioma" value='<%=sidioma%>' /><%
		%><render:argument name="sPathStatic" value='<%=sPathStatic%>' /><%
		if (Utilities.goodString(sNombreTemplateAux)) {
			%><render:argument name="sNombreTemplateAux" value='<%=sNombreTemplateAux%>' /><%
		}
	%></render:satellitepage><%

	%><body><%

		%><render:callelement elementname="correos/webpublica/layout/COR_politicaCookies" scoped="global"><%
			%><render:argument name="sidioma" value='<%=sidioma%>' /><%
			%><render:argument name="c" value='<%=c%>' /><%
			%><render:argument name="cid" value='<%=cid%>' /><%
		%></render:callelement><%
		
		%><div itemscope itemtype="http://schema.org/Organization"><%
		
			// COR_NuevaCabecera no puede llevar cache porque dentro se encuentra el formulario para el buscador
			// Dentro de COR_NuevaCabecera se aplican las caches correspondientes
			%><render:callelement elementname="correos/webpublica/bloques/cabecera/COR_NuevaCabecera"><%
				%><render:argument name="p" value='<%=p%>' /><%
				%><render:argument name="c" value='<%=c%>' /><%
				%><render:argument name="cid" value='<%=cid%>' /><%
				%><render:argument name="site" value='<%=site%>' /><%
				%><render:argument name="sidioma" value='<%=sidioma%>' /><%
				%><render:argument name="sPathStatic" value='<%=sPathStatic%>' /><%
				if (Utilities.goodString(packedargs)) {
					%><render:argument name="packedargs" value='<%=packedargs%>' /><%
				}
			%></render:callelement><%
			
			// Si no hay que pintar el nuevo Layout, se mantiene el antiguo layout
			if (!Utilities.goodString(pintaNewLayout) || !"pinta".equals(pintaNewLayout)) {
				%><div class="section_superior"><%
					%><div class="section"><%
			}


		
			
			%><render:calltemplate site='<%=site%>'
						slotname="slotCentral"
						tid='<%=ics.GetVar("tid")%>'
						c='<%=c%>'
						cid='<%=cid%>'
						tname='<%=sNombreTemplate%>'
						context=""><%
				%><render:argument name="sidioma" value='<%=sidioma%>' /><%
				%><render:argument name="p" value='<%=p%>' /><%
				%><render:argument name="sPathStatic" value='<%=sPathStatic%>' /><%
				if (Utilities.goodString(packedargs)) {
					%><render:argument name="packedargs" value='<%=packedargs%>' /><%
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
				if (Utilities.goodString(fsi_cod_env)) {
					%><render:argument name="fsi_cod_env" value='<%=fsi_cod_env%>' /><%
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
				if (Utilities.goodString(strClave)) {
					%><render:argument name="strClave" value='<%=strClave%>' /><%
				}
				if (Utilities.goodString(strCaptcha)) {
					%><render:argument name="strCaptcha" value='<%=strCaptcha%>' /><%
				}
				if (Utilities.goodString(enviadoFormulario)) {
					%><render:argument name="enviadoFormulario" value='<%=enviadoFormulario%>' /><%
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
				
				//Parametros aplicacion	de Empleo 
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
								
				// Parametros formulario codigos postales
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
				if (Utilities.goodString(direccion)) {
					%><render:argument name="direccion" value='<%=direccion%>' /><%
				}
				if (Utilities.goodString(fbcp_numero)) {
					%><render:argument name="fbcp_numero" value='<%=fbcp_numero%>' /><%
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
			
			// Si no hay que pintar el nuevo Layout, se mantiene el antiguo layout
			if (!Utilities.goodString(pintaNewLayout) || !"pinta".equals(pintaNewLayout)) {
					%></div><%
					%></div><%
					%><div class="limpieza-footer"></div><%
			}
			
			%><render:satellitepage pagename="correos/webpublica/bloques/pie/COR_NuevoPie"><%
				%><render:argument name="site" value='<%=site%>' /><%
				%><render:argument name="sidioma" value='<%=sidioma%>' /><%
				%><render:argument name="sPathStatic" value='<%=sPathStatic%>' /><%
			%></render:satellitepage><%
			
		%></div><%
		
		// Llamada para la funcion GoogleAnalytics
		%><render:satellitepage pagename="COR_GoogleAnalytics"><%
			%><render:argument name="site" value='<%=site%>' /><%
			%><render:argument name="p" value='<%=p%>' /><%
			if( Utilities.goodString(cid) ){
				%><render:argument name="cid" value='<%=cid%>' /><%
			}
			if( Utilities.goodString(c) ){
				%><render:argument name="c" value='<%=c%>' /><%
			}
			if( Utilities.goodString(packedargs) ){
				%><render:argument name="packedargs" value='<%=packedargs%>' /><%
			}
		%></render:satellitepage><%
		
		// Si tenemos que poner la cookie hacemos el satellite:cookie
		// Lo hacemos aqui porque la etiqueta renderiza un img tag y puede descuadrar la web
		if (ics.GetVar("setCookie") != null && !"".equals(ics.GetVar("setCookie"))) {
			// Creamos la cookie
			%><satellite:cookie name='<%=ics.GetVar("setCookie")%>' value='<%=sidioma%>' timeout="31536000" domain="correos.es"  secure="false" url="/" /><%
		}

	%></body><%
	%></html><%
}
%></cs:ftcs>
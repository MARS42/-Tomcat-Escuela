function validar(formu){

  // Array con todos los elementos del formulario

formulario = document.querySelector(`form[name=${formu}]`);
camposTexto = formulario.elements;

  for (x=0; x < camposTexto.length; x++)
  {
    //validar que los campos obligatorios se hayan llenado, con los demas campos, no hacer nada
    if( camposTexto[x].type=="text" && ( camposTexto[x].id=="novalid" ) ){}//no hacer nada en este caso
    
    else if ( camposTexto[x].value == "" && ( camposTexto[x].type== "text" ) ) {
      alert("El campo " + camposTexto[x].id + " es obligatorio !");
      formulario.elements[x].focus();
      return false;
    }

    if(camposTexto[x].type == "text" && camposTexto[x].id == "Edad"){
      if(!verificar_entero(camposTexto[x]))
        return false;
    }

    if( camposTexto[x].type == "text" && camposTexto[x].id == "Peso"){
      if(!verificar_decimal(camposTexto[x]))
        return false;
    }

    if( camposTexto[x].type == "text" && camposTexto[x].id == "Telefono"){
      if(!verificar_telefono(camposTexto[x]))
        return false;
    }

    if( camposTexto[x].type == "text" && camposTexto[x].id == "Email"){
      if(!verificar_email(camposTexto[x]))
        return false;
    }

    if( camposTexto[x].name=="semestre" && camposTexto[x].selectedIndex== 0 ){
      alert("El campo " + camposTexto[x].id + " es obligatorio !");
      formulario.elements[x].focus();
      return false;
    }

    if( camposTexto[x].type=="text" && camposTexto[x].id=="Fecha" ){
      if (checkDate(formulario.elements[x], formulario.elements[x].value)== false)
      {
        //formulario.elements[x].value="";
        formulario.elements[x].focus();
        formulario.elements[x].select();
        return false;
      }
    }
  }
}

function verificar_entero(campo){
  var checanum =/(^([0-9]){1,20}|^)$/
  if (!checanum.test (campo.value)) {
    alert("El contenido del campo " + campo.id +  " debe ser numérico entero !");
    campo.value="";
    campo.focus();
    return false;
  }
  return true;
}

function verificar_decimal(campo){
  var checanum = /(^([0-9,.]){1,20}|^)$/
  if (!checanum.test (campo.value)) {
    alert("El contenido del campo " + campo.id +  " debe ser numérico !");
    campo.value="";
    campo.focus();
    return false;
  }
  var campo_importe=campo.value;
  var k=0;
  for (i=0; i < campo_importe.length; i++) {
    if (campo_importe.charAt(i)=='.'){
      k++;
    }
  }
  if (k > 1) {
    alert("El contenido del campoo "+ campo.id + " es inválido !");
    campo.value="";
    campo.focus();
    return false;
  }		

  k=0;
  for (i=0; i < campo_importe.length; i++) {
    if (campo_importe.charAt(i)==','){
      k++;
    }
  }
  if (k > 0) {
    alert("El contenido del campo "+ campo.id + " es inválido !");
    campo.value="";
    campo.focus();
    return false;
  }
  return true;
}

function verificar_telefono(campo){
  var checatel =/^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/im
  if (!checatel.test (campo.value)) {
    alert("El contenido del campo " + campo.id +  " debe ser un número telefónico !");
    campo.value="";
    campo.focus();
    return false;
  }
  return true;
}

function verificar_email(campo){
  var checaema =/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
  if (!checaema.test (campo.value)) {
    alert("El contenido del campo " + campo.id +  " debe ser un email !");
    campo.value="";
    campo.focus();
    return false;
  }
  return true;
}
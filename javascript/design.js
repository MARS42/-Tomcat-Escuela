const tabs = document.getElementsByClassName('tab');
const tabs_content = {};
const alumnos = [];
const profesores = [];

for (let i = 0; i < tabs.length; i++)
{
  const tab = tabs[i];
  tab.addEventListener('click', ClickTab);

  const key = tab.getAttribute('data-tab-content');
  const value = document.getElementById(key);
  tabs_content[key] = value;
}

function ClickTab()
{
  for (let i = 0; i < tabs.length; i++)
  {
    const tab = tabs[i];
    const key = tab.getAttribute('data-tab-content');

    if (this === tab)
    {
      tab.classList.add('tab-active');
      tabs_content[key].classList.add('tab-content-active');
    }
    else
    {
      tab.classList.remove('tab-active');
      tabs_content[key].classList.remove('tab-content-active');
    }
  }
}

function TogglePersona(id){
  /*if(personas.includes(id))
    personas = personas.filter((i, p) => p == id);
  else
    personas.push(id);
  console.log('Personas a eliminar:', personas);*/
  if(document.getElementById('id-'+id).checked)
    alumnos.push(id);
  else
    alumnos.splice(alumnos.indexOf(id), 1);

  document.querySelector(`form[name=eliminacion]`)["ids"].setAttribute('value', alumnos.join(','));
  console.log(document.querySelector(`form[name=eliminacion]`)["ids"]);
}

function ConfirmarEliminacionAlumnos(){
  if(alumnos.length == 0) return false;

  return confirm(`¿Eliminar a los alumnos seleccionados (id= ${alumnos.join(', id= ')})?`);
}

function ToggleProfe(id){
  /*if(personas.includes(id))
    personas = personas.filter((i, p) => p == id);
  else
    personas.push(id);
  console.log('Personas a eliminar:', personas);*/
  if(document.getElementById('id-'+id).checked)
    profesores.push(id);
  else
    profesores.splice(profesores.indexOf(id), 1);

  document.querySelector(`form[name=eliminacion2]`)["ids"].setAttribute('value', profesores.join(','));
  console.log(document.querySelector(`form[name=eliminacion2]`)["ids"]);
}

function ConfirmarEliminacionProfes(){
  if(profesores.length == 0) return false;
  return confirm(`¿Eliminar a los profesores seleccionados (id= ${profesores.join(', id= ')})?`);
}
function checkDate(campo, fld) {
  var mo, day, yr;
  var entry = fld;
  var reLong = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{4}\b/;
  var reShort = /\b\d{1,2}[\/-]\d{1,2}[\/-]\d{2}\b/;
  var valid = (reLong.test(entry)) || (reShort.test(entry));
  if (valid) {
      var delimChar = (entry.indexOf("/") != -1) ? "/" : "-";
      var delim1 = entry.indexOf(delimChar);
      var delim2 = entry.lastIndexOf(delimChar);
      day = parseInt(entry.substring(0, delim1), 10);
      mo = parseInt(entry.substring(delim1+1, delim2), 10);
      yr = parseInt(entry.substring(delim2+1), 10);
      // handle two-digit year
      if (yr < 100) {
          var today = new Date();
          // get current century floor (e.g., 2000)
          var currCent = parseInt(today.getFullYear( ) / 100) * 100;
          // two digits up to this year + 15 expands to current century
          var threshold = (today.getFullYear() + 15) - currCent;
          if (yr > threshold) {
              yr += currCent - 100;
          } else {
              yr += currCent;
          }
      }
      var testDate = new Date(yr, mo-1, day);
      if (testDate.getDate() == day) {
          if (testDate.getMonth( ) + 1 == mo) {
              if (testDate.getFullYear() == yr) {
                  // fill field with database-friendly format
                  fld.value = mo + "/" + day + "/" + yr;
                  return true;
              } else {
                  alert("El año es incorrecto");
                  campo.focus();
              }
          } else {
              alert("El mes es incorrecto");
              campo.focus();
          }
      } else {
          alert("El día es incorrecto");
          campo.focus();
      }
  } else {
      alert("El formato de fecha es incorrecto. Formato: mm/dd/aaaa.");
      campo.focus();
  }
  return false;
}


function initializeContractScript() {
  var variables = {
    "Titre de l'utilisateur": "user.title",
    "Nom de famille de l'utilisateur": "user.last_name",
    "Prénom de l'utilisateur": "user.first_name",
    "E-mail de l'utilisateur": "user.email",
    "Téléphone de l'utilisateur": "user.phone",
    "Adresse de l'utilisateur": "user.address",
    "Code postal de l'utilisateur": "user.postal_code",
    "Ville de l'utilisateur": "user.city",
    "Numéro SIRET de l'utilisateur": "user.siret_number",
    "Numéro de licence de l'utilisateur": "user.license_number",
    "Titre du médecin": "doctor.title",
    "Prénom du médecin": "doctor.first_name",
    "Nom de famille du médecin": "doctor.last_name",
    "RPPS du médecin": "doctor.rpps",
    "Email du médecin": "doctor.email",
    "Téléphone du médecin": "doctor.phone",
    "Nom du site de remplacement": "site.name",
    "Adresse du site de remplacement": "site.address",
    "Code postal du site de remplacement": "site.postal_code",
    "Ville du site de remplacement": "site.city",
    "Date de début de l'événement (JJ/MM/AAAA)": "event.start_time.strftime('%d/%m/%Y')",
    "Date de fin de l'événement (JJ/MM/AAAA)": "event.end_time.strftime('%d/%m/%Y')",
    "Heure de début de l'événement (HH:MM)": "event.start_time.strftime('%H:%M')",
    "Heure de fin de l'événement (HH:MM)": "event.end_time.strftime('%H:%M')",
    "Taux de reversion du remplacement": "event.reversion"
  };

  function populateVariableSelector() {
    var variableSelector = document.getElementById("variable_selector");

    for (var key in variables) {
      if (variables.hasOwnProperty(key)) {
        var option = document.createElement("option");
        option.value = variables[key];
        option.textContent = key;
        variableSelector.appendChild(option);
      }
    }
  }

  function importVariable() {
    var selectedVariable = document.getElementById("variable_selector").value;
    var contractContent = document.getElementById("contract_content").editor;

    contractContent.insertString(selectedVariable);

    clearVariableSelector();
  }

  function clearVariableSelector() {
    var variableSelector = document.getElementById("variable_selector");
    variableSelector.selectedIndex = 0;
  }

  function setup() {
    populateVariableSelector();

    document.getElementById("import_variable_btn").addEventListener("click", function() {
      importVariable();
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", setup);
  } else {
    setup();
  }

}
initializeContractScript();

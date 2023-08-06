import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["postalCode", "city", "cityHidden"]
  
    connect() {
        this.postalCodeTarget.addEventListener('change', this.updateCities.bind(this));
        this.cityTarget.addEventListener('change', this.updateHiddenCity.bind(this));
        this.updateCities();
      }

    updateHiddenCity() {
        this.cityHiddenTarget.value = this.cityTarget.value;
      }
  
      updateCities() {
        const postalCode = this.postalCodeTarget.value;
        if (postalCode) { // Ajouter cette vérification
          fetch(`/postal_codes/get_cities?postal_code=${postalCode}`)
            .then(response => response.json())
            .then(data => this.populateCitySelect(data));
        } else {
          this.cityTarget.innerHTML = '';
        }
      }
      
  
    populateCitySelect(data) {
        this.cityTarget.innerHTML = '';
        data.forEach(city => {
          const option = document.createElement('option');
          option.value = city.nomCommune;
          option.text = city.nomCommune;
          if (city.nomCommune === this.cityHiddenTarget.value) {
            option.selected = true;
          }
          this.cityTarget.appendChild(option);
        });
      }      
  }
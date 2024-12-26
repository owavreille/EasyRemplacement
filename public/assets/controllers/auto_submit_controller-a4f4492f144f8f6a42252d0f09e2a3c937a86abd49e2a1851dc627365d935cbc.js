import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"]

  connect() {
    this.fieldTargets.forEach((element) => {
      element.addEventListener('change', () => {
        this.element.submit();
      });
    });
  }
};

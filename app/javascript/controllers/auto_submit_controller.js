import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"]

  connect() {
    this.fieldTarget.addEventListener('change', () => {
      this.element.submit();
    });
  }
}

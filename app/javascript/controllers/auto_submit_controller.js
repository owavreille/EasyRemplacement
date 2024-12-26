import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"]

  connect() {
    this.submitForm = this.submitForm.bind(this)
  }

  submitForm() {
    this.element.requestSubmit()
  }

  toggleAllDoctors(event) {
    const checked = event.target.checked
    this.element.querySelectorAll('.doctor-checkbox').forEach(checkbox => {
      checkbox.checked = checked
    })
    this.submitForm()
  }

  fieldTargetConnected(field) {
    field.addEventListener('change', this.submitForm)
  }

  fieldTargetDisconnected(field) {
    field.removeEventListener('change', this.submitForm)
  }
}

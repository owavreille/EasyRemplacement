import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "table" ]

  sort(event) {
    const table = this.tableTarget;
    const tbody = table.tBodies[0];
    const column = event.target.cellIndex;
    const direction = parseInt(event.target.dataset.direction) || 1;

    const rows = Array.from(tbody.rows)
      .sort((rowA, rowB) => {
        const cellA = rowA.cells[column].innerText;
        const cellB = rowB.cells[column].innerText;
        
        return cellA.localeCompare(cellB) * direction;
      });

    rows.forEach(row => tbody.appendChild(row));
    event.target.dataset.direction = -direction;
  }
};

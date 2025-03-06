import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  confirm(event) {
    event.preventDefault();
    const confirmed = confirm("Are you sure you want to proceed?");

    if (confirmed) {
      this.element.parentElement.submit();
    }
  }
}

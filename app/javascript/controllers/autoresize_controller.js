import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.style.height = "1px";
    this.element.style.height = (25+this.element.scrollHeight)+"px";
  } 
}

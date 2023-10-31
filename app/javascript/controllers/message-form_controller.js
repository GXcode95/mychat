import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'form']

  inputTargetConnected() {
    this.inputTarget.focus()
  }

  keydown(event) {
    console.log()
    if (event.key === 'Enter' && !event.shiftKey){
      event.preventDefault()
      this.formTarget.requestSubmit()
    }
  }

  submit(event) {
    if (this.inputTarget.value !== "") return
    
    event.preventDefault()
  }
}

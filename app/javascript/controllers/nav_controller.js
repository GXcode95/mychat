import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.body.addEventListener('keydown', (e)=> {
      if(e.key === 'n' && e.ctrlKey) {
        this.element.classList.toggle('hidden')
      }
    })
  } 
}

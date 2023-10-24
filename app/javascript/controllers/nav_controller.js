import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.body.addEventListener('keydown', (e)=> {
      console.log(e.key)
    })
  }
}

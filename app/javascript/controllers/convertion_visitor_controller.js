import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="convertion-visitor"
export default class extends Controller {
  static values = {
    donatorUrl: String
  }

  static targets = ['cta']

  disconnect() {
    localStorage.clear()
  }

  initialize(){
    const visitorInfo = JSON.parse(localStorage.getItem('visitorInfo'))

    if (!visitorInfo) {
      return
    }

    for (const data in visitorInfo.donator) {
      const input = document.getElementsByName(`user[${data}]`)

      if (input[0]) {
        input[0].value = visitorInfo['donator'][data]
      }
    }

  }

  updateDonator(){

    const visitorInfo = JSON.parse(localStorage.getItem('visitorInfo'))

    const donatorForm = new FormData

    for (const data in visitorInfo.donator) {
      if ((data !== 'first_name') && (data !== 'last_name') && (data !== 'email')) {
        donatorForm.set(`donator[${data}]`, visitorInfo['donator'][data])
      }
    }

    // donatorForm.set('authenticity_token', document.querySelector('meta[name="csrf-token"]').getAttribute("content"))

    const details = {
      method: 'PATCH',
      headers: {
        "Accept": "application/json",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
      body: donatorForm
    }

    fetch(this.donatorUrlValue, details)
    .then(response => {
      if (response.ok) {
        return response
      }
      return Promise.reject(response)
    })
    .then((data) => {
      console.log('data', data)
      localStorage.clear()
    })
    .catch((response) => {
      response.json().then((errors) => {
        for (const key in errors) {
          console.log(`${key}: ${errors[key]}`)
        }
      })
    })
  }

  newUser(event) {
    event.preventDefault()

    // retrive new user form
    const newUserForm = new FormData(event.target)

    // retrieve url of signup route
    const url = event.target.action

    // build user payload
    const userDetails = {
      method: 'post',
      headers: {
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content")
      },
      body: newUserForm
    }

    // fetch create new user
    fetch(url, userDetails)
    .then(response => {
      if (response.ok) {
        return response
      }
      return Promise.reject(response)
    })
    .then((data) => {
      // success path => update the user.donator address if present in localstorage
      const visitorInfo = JSON.parse(localStorage.getItem('visitorInfo'))
      if (visitorInfo) {
        this.updateDonator()
      }

      // display msg to user 'welcome and thank you...' & hide form
      this.displayWelcome(newUserForm)
    })
    .catch((response) => {
      console.log('response', response)

      // failure path: unprocessable entity
      const password = newUserForm.get('user[password]')
      const confirmPassword = newUserForm.get('user[password_confirmation]')

      const div = document.createElement('div')
      div.setAttribute('id', 'alert')

      if (password != confirmPassword) {
        div.innerText = 'Le mot de passe doit être identique.'
      }

      div.classList.add('bg-yellow-200', 'text-red-500', 'text-sm', 'tracking-wide')
      div.classList.add('mx-4', 'flex', 'justify-start', 'items-center', 'gap-x-2', 'px-3', 'py-2', 'rounded-lg')
      div.insertAdjacentHTML("afterbegin", '<i class="fa-solid fa-circle-exclamation", style:"color: black;"></i>')

      const alert = document.getElementById('alert')
      const alertExist = this.element.contains(alert)

      if (alertExist) {
        alert.replaceWith(div)

        div.classList.add('animate-bounce')
        setTimeout(() => {
          div.classList.remove('animate-bounce')
        }, 1000);
      } else {
        event.target.insertAdjacentElement('beforebegin', div)
      }

    })

  }

  displayWelcome(userForm){

    // replace link 'create account' by 'home' manually instead of a window refresh (it cause to concurrency with successDiv)
    // const oldLink = document.getElementById('link')
    // oldLink.outerHTML = `<a id="link" class="flex-auto px-3 py-2 rounded-lg bg-black w-full " href="/donator">Home</a>`

    // get username from the form and create the message
    const username = userForm.get('user[first_name]')
    const usernameCap = username.charAt(0).toUpperCase() + username.slice(1)
    const line_one = document.createElement('p')
    const line_two = document.createElement('p')
    line_one.innerText = `${usernameCap}, votre compte a été crée avec succès ! Vous pouvez dès maintenant éditer un reçu fiscal pour votre don.`
    line_two.innerText = "Utiliser Goodify pour vos bonnes actions ! Suivez et gérez vos dons depuis votre tabelau de bord."

    // create the container of the message
    const successDiv = document.createElement('div')
    // class list for the text mainly
    successDiv.classList.add('mb-2', 'flex', 'flex-col', 'gap-y-3', 'text-center', 'text-sm', 'text-inherit', 'roboto-regular', 'tracking-wider')
    // class list for the container
    successDiv.classList.add('bg-green-400', 'rounded-lg', 'px-3', 'py-2', 'w-fit')

    // appending message to container
    successDiv.append(line_one)
    successDiv.append(line_two)

    // replacing controller element by the message container. could have also been done with insertadjacenthtml()
    this.ctaTarget.replaceWith(successDiv)
  }

  scrollTo(event) {
    event.preventDefault()
    // const form = document.getElementById('CTA-conversion')
    // form.scrollIntoView({behavior: "smooth"})
    this.ctaTarget.scrollIntoView({behavior: "smooth"})
  }
}

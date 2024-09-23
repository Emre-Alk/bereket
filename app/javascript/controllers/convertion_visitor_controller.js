import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="convertion-visitor"
export default class extends Controller {
  static targets = ['form']
  static values = {
    userEmail: String
  }

  connect() {
    console.log('hello convertion-visitor');
    this.loginUser()
  }

  loginUser() {

    const loginForm = new FormData()
    loginForm.append("user[email]", this.userEmailValue)
    loginForm.append("user[password]", '654321')

    const payloadLogin = {
      method: 'POST',
      headers: {
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content")
      },
      body: loginForm
    }

    fetch('/users/sign_in', payloadLogin)
    .then(response => {
      if (response.ok) {
        console.log('login ok');
      } else {
        console.log('login nok');
      }
    })

  }

  newUser(event) {
    event.preventDefault()

    const userForm = new FormData(event.target)

    const payload = {
      method: 'PUT',
      headers: {
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content")
      },
      body: userForm
    }

    fetch("/users", payload)
    .then(response => {
      if (response.ok) {
        // success path: display msg to user 'welcome and thank you...' & hide form
        // replace link 'create account' by 'home' manually instead of a window refresh (it cause to concurrency with successDiv)
        const oldLink = document.getElementById('link')
        oldLink.outerHTML = `<a id="link" class="flex-auto px-3 py-2 rounded-lg bg-black w-full " href="/donator">Home</a>`

        // get username from the form and create the message
        const username = userForm.get('user[first_name]')
        const line_one = document.createElement('p')
        const line_two = document.createElement('p')
        line_one.innerText = `${username}, votre compte a été crée avec succès ! Vous pouvez dès maintenant éditer un reçu fiscal pour votre don.`
        line_two.innerText = "Utiliser DoGood pour vos bonnes actions ! Suivez et gérez vos dons depuis votre tabelau de bord."

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
        this.element.replaceWith(successDiv)

        // TODO(optional): create a <templace> tag arround the favori container to insert it also once new user

      } else {
        // failure path: display validation to fullfil before submitting
        // test which entry is wrong and display the correction to perform
        const password = userForm.get('user[password]')
        const confirmPassword = userForm.get('user[password_confirmation]')
        const email = userForm.get('user[email]')

        const div = document.createElement('div')
        div.setAttribute('id', 'alert')

        // test password only. rely on pattern attribut for the rest. and if email exist cannot check with response from back
        // unless, modify the controller devise to respond to json (with header json in ajax)
        // anyway, aside of password, only email could be false.
        // can redirect to devise view but need to modify it then because of current passeword required and field visible
        if (password != confirmPassword) {
          div.innerText = 'Le mot de passe doit être identique.'
        } else {
          div.innerText = "Adresse mail déjà enregistrée. Merci d'indiquer une adresse mail valide."
        }

        div.classList.add('bg-yellow-200', 'text-red-500', 'text-sm', 'tracking-wide')
        div.classList.add('mx-4', 'flex', 'justify-start', 'items-center', 'gap-x-2', 'px-3', 'py-2', 'rounded-lg')
        div.insertAdjacentHTML("afterbegin", '<i class="fa-solid fa-circle-exclamation", style:"color: black;"></i>')

        const alert = document.getElementById('alert')
        const alertExist = this.element.contains(alert)
        console.log(alertExist);
        if (alertExist) {
          alert.replaceWith(div)

          div.classList.add('animate-bounce')
          setTimeout(() => {
            div.classList.remove('animate-bounce')
          }, 1000);
        } else {
          this.formTarget.insertAdjacentElement('beforebegin', div)
        }
      }
    })

  }
}

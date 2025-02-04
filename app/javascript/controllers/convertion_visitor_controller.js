import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="convertion-visitor"
export default class extends Controller {
  static targets = ['form']
  static values = {
    userEmail: String
  }

  connect() {
    console.log('hello convertion-visitor')
    // test new feature
    // const newForm = document.getElementById("form-new-user")
    // console.log('newform', newForm)
    // newForm.addEventListener('submit', (e) => this.newUser(e))

    // login works but without a reload after ajax done, the update ajax don't work. an error "can't verify csrf token" pops.
    // when e session is create, rails save a token in the session as well as in the back. so, when user navigate, rails compare session token with back token.
    // I suppose without the reload, the token previously in the DOM is not the same as the one just created in the session after login ajax
    // try if generate token via rails helper after login ajax can work ?
    // try if from the login ajax response can get a session token ?
    // this.loginUser()
  }
  // test new feature
  // disconnect(){
    // const newForm = document.getElementById("form-new-user")
    // newForm.removeEventListener('submit', (e) => this.newUser(e))
  // }

  scrollTo(event) {
    event.preventDefault()
    // const form = document.getElementById('conversionForm')
    const form = document.getElementById('form-new-user')
    form.scrollIntoView({behavior: "smooth"})
  }


  loginUser() {
    //create a new form object to send to back for login
    const loginForm = new FormData()
    // needed entries are email and password.
    // Use Value because need the email use to create visitor (from checkoutsession) whereas user can change his email in the form
    loginForm.append("user[email]", this.userEmailValue)
    loginForm.append("user[password]", '654321')

    // build the payload. No accept needed since did not custom devise controller
    // and only response.ok is of interest
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
    //retrieve the filled form by visitor to convert him
    const userForm = new FormData(event.target)

    // build the payload for the call
    const payload = {
      method: 'PUT',
      headers: {
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content")
      },
      body: userForm
    }

    // test new feature
    // const payload = {
    //   method: 'POST',
    //   headers: {
    //     "X-CSRF-Token": document
    //       .querySelector('meta[name="csrf-token"]')
    //       .getAttribute("content")
    //   },
    //   body: userForm
    // }

    // perform call and success/failure paths responses
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
        if (password != confirmPassword || password == '') {
          div.innerText = 'Le mot de passe doit être identique.'
        } else {
          div.innerText = "Adresse mail déjà enregistrée. Merci d'indiquer une adresse mail valide."
        }

        div.classList.add('bg-yellow-200', 'text-red-500', 'text-sm', 'tracking-wide')
        div.classList.add('mx-4', 'flex', 'justify-start', 'items-center', 'gap-x-2', 'px-3', 'py-2', 'rounded-lg')
        div.insertAdjacentHTML("afterbegin", '<i class="fa-solid fa-circle-exclamation", style:"color: black;"></i>')

        const alert = document.getElementById('alert')
        const alertExist = this.element.contains(alert)
        console.log('alert exist', alertExist);
        if (alertExist) {
          alert.replaceWith(div)

          div.classList.add('animate-bounce')
          setTimeout(() => {
            div.classList.remove('animate-bounce')
          }, 1000);
        } else {
          this.formTarget.insertAdjacentElement('beforebegin', div)

          // test new feature
          // const myForm = document.getElementById("form-new-user")
          // myForm.insertAdjacentElement('beforebegin', div)
        }
      }
    })

  }
}

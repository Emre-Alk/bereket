import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="convertion-visitor"
export default class extends Controller {
  static targets = ['submitBtn', 'names', 'email', 'passwords']

  connect() {
    console.log('hello convertion-visitor');
  }

  newUser(event) {
    event.preventDefault()
    console.log('event', event.target);

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
          const username = userForm.get('user[first_name]')
          const line_one = document.createElement('p')
          const line_two = document.createElement('p')
          line_one.innerText = `${username}, votre compte a été crée avec succès ! Vous pouvez dès maintenant éditer un reçu fiscal pour votre don.`
          line_two.innerText = "Utiliser DoGood pour vos bonnes actions ! Suivez et gérez vos dons depuis votre tabelau de bord."

          const successDiv = document.createElement('div')
          successDiv.classList.add('mb-2', 'p-2', 'flex', 'flex-col', 'gap-y-3', 'text-center', 'text-sm', 'text-inherit', 'opacity-80', 'roboto-regular', 'tracking-wider')
          successDiv.classList.add('bg-green-400', 'rounded-lg', 'px-3', 'py-2', 'w-fit')

          successDiv.append(line_one)
          successDiv.append(line_two)

          this.element.replaceWith(successDiv)

          // setTimeout(() => {
          //   successDiv.outerHTML = ''
          // }, 7000)

        } else {
          // failure path: display validation to fullfil before submitting
        }
      })




    // get the data of the form into a FormData(source) to work with
    // const formData = new FormData(this.element)

    // retrieve old credentials to sign in
    // const old_email = formData.get('current_email')
    // const old_password = '654321' // to be the same as set in jobs > handle_event_job > handleCheckOutSessionComplete()


    // retrive new credentials to update visitor (user model) account
    // const new_email = formData.get('email')
    // const new_password = formData.get('password')
    // const new_password_confirmation = formData.get('password_confirmation')
    // const new_first_name = formData.get('first_name')
    // const new_last_name = formData.get('last_name')

    // const newForm = new FormData({
    //   user: {
    //     email: new_email,
    //     password: new_password,
    //     remember_me: "0",
    //   },
    //   commit: "Log in"
    // })

    // request for log in
    // try {
    //   const loginResponse = fetch('/users/sign_in', {
    //     method: 'POST',
    //     headers: {
    //       "X-CSRF-Token": document
    //         .querySelector('meta[name="csrf-token"]')
    //         .getAttribute("content")
    //     },
    //     body:  loginForm // something is wrong here. keep looking to solve
    //   })
    //   .then(response => {
    //     if (response.ok) {
    //       response.json()
    //       .then((data) => {
    //         console.log('login successful:', data);
    //       })
    //     } else {
    //       throw new Error('login failed:', data)
    //     }
    //   })

    // } catch (error) {
    // }
  }
}

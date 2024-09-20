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

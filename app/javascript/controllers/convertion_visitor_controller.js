import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="convertion-visitor"
export default class extends Controller {
  static targets = ['submitBtn', 'names', 'email', 'passwords']

  connect() {
    console.log('hello convertion-visitor');
    // console.log(this.submitBtnTarget);
    // console.log(this.namesTargets);
    // console.log(this.emailTarget);
    // console.log(this.passwordsTarget);


    const regexNames = /\A[A-Za-z]+(\s?[A-Za-z]+)*\z/
    const regexEmail = new RegExp(/\A[^@\s]+@[^@\s]+\z/)
    const name = "vdghjk"

    console.log(regexNames.test(name));



    this.namesTargets.forEach(name => {
      const testColor = regexNames.test(name.value)

      if (testColor) {
        name.classList.add("border-green-500")
      } else {
        name.classList.add("border-red-500")
      }

    })


  }
  // Started POST "/users/sign_in" for ::1 at 2024-09-12 23:31:37 +0200
  // Processing by Devise::SessionsController#create as TURBO_STREAM
  // Parameters: {"authenticity_token"=>"[FILTERED]",
  //   "user"=>{"email"=>"donator2@donator2.com", "password"=>"[FILTERED]", "remember_me"=>"0"},
  //   "commit"=>"Log in"}


  newUser(event) {
    event.preventDefault()
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

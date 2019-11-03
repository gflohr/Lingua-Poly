import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { PasswordValidator } from 'src/app/core/validators/passwordValidator';

@Component({
	selector: 'app-register',
	templateUrl: './register.component.html',
	styleUrls: ['./register.component.css']
})
export class RegisterComponent {

	constructor(private fb: FormBuilder) { }

	registerForm = this.fb.group ({
		username: ['', Validators.required],
		email: ['', [Validators.required, Validators.email]],
		password: ['', Validators.required],
		password2: ['', Validators.required ]]
	}, { validator: PasswordValidator.passwordMatch });

	onSubmit() {
		console.log(this.registerForm.value);
	}

	get password() { return this.registerForm.get('password'); }
	get password2() { return this.registerForm.get('password'); }
}

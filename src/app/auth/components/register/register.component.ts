import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { PasswordValidator } from 'src/app/core/validators/passwordValidator';
import { UsersService, UserDraft } from 'src/app/core/openapi/lingua-poly';

@Component({
	selector: 'app-register',
	templateUrl: './register.component.html',
	styleUrls: ['./register.component.css']
})
export class RegisterComponent {

	constructor(private fb: FormBuilder,
		        private usersService: UsersService) { }

	registerForm = this.fb.group ({
		username: ['', Validators.required],
		email: ['', [Validators.required, Validators.email]],
		password: ['', Validators.required],
		passwordStrength: [ null ],
		password2: ['', Validators.required ]
	}, { validators: [ PasswordValidator.passwordMatch, PasswordValidator.passwordStrength ] });

	onSubmit() {
		const user = {
			username: this.registerForm.get('username').value,
			email: this.registerForm.get('email').value,
			password: this.registerForm.get('password').value,
		} as UserDraft;
		this.usersService.usersPost(user).subscribe(data => {
			console.log(data);
		});
		console.log(this.registerForm);
	}

	get password() { return this.registerForm.get('password'); }
	get password2() { return this.registerForm.get('password'); }
}

import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { PasswordValidator } from 'src/app/core/validators/passwordValidator';
import { UsersService, UserDraft } from 'src/app/core/openapi/lingua-poly';
import { Router } from '@angular/router';

@Component({
	selector: 'app-registration',
	templateUrl: './registration.component.html',
	styleUrls: ['./registration.component.css']
})
export class RegistrationComponent {
	constructor(private fb: FormBuilder,
	            private router: Router,
	            private usersService: UsersService) { }

	registrationForm = this.fb.group ({
		email: ['', [Validators.required, Validators.email]],
		password: ['', Validators.required],
		passwordStrength: [ null ],
		password2: ['', Validators.required ]
	}, { validators: [ PasswordValidator.passwordMatch, PasswordValidator.passwordStrength ] });

	onSubmit() {
		const user = {
			email: this.registrationForm.get('email').value,
			password: this.registrationForm.get('password').value,
		} as UserDraft;
		this.usersService.usersPost(user).subscribe(data => {
			this.router.navigate(['../registration-received', user.email]);
		});
	}

	get password() { return this.registrationForm.get('password'); }
	get password2() { return this.registrationForm.get('password'); }
}

import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { UsersService } from '../../../core/openapi/lingua-poly';
import { PasswordValidator } from '../../../core/validators/passwordValidator';

@Component({
	selector: 'app-change-password',
	templateUrl: './change-password.component.html',
	styleUrls: ['./change-password.component.css']
})
export class ChangePasswordComponent {
	constructor(private fb: FormBuilder,
		private router: Router,
		private usersService: UsersService) { }

		changePasswordForm = this.fb.group ({
			email: [ null ],
			oldPassword: ['', [Validators.required ]],
			password: ['', Validators.required],
			passwordStrength: [ null ],
			password2: ['', Validators.required ]
		}, {
			validators:
				[
					PasswordValidator.passwordMatch,
					PasswordValidator.passwordStrength
				]
			}
		);

	onSubmit() {
		//const user = {
		//	email: this.registrationForm.get('email').value,
		//	password: this.registrationForm.get('password').value,
		//} as UserDraft;
		//this.usersService.usersPost(user).subscribe(() =>
		//	this.router.navigate(['../registration/received', user.email])
		//);
	}

	get oldPassword() { return this.changePasswordForm.get('oldPassword'); }
	get password() { return this.changePasswordForm.get('password'); }
	get password2() { return this.changePasswordForm.get('password'); }
}

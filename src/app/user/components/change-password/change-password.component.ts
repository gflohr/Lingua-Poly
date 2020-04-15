import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { PasswordValidator } from 'src/app/core/validators/passwordValidator';
import * as fromAuth from '../../../auth/reducers';
import { Store, select } from '@ngrx/store';
import { Observable } from 'rxjs';
import { User } from 'src/app/core/openapi/lingua-poly';
import { tap } from 'rxjs/operators';

@Component({
	selector: 'app-change-password',
	templateUrl: './change-password.component.html',
	styleUrls: ['./change-password.component.css']
})
export class ChangePasswordComponent {
	user$: Observable<User>;

	constructor(
		private fb: FormBuilder,
		private authStore: Store<fromAuth.State>
	) {
		this.user$ = this.authStore.pipe(
			select(fromAuth.selectUser),
			tap(user => {
				const email = user ? user.email : '';
				const username = user ? user.username : '';
				this.changePasswordForm.patchValue({
					email: email,
					username: username,
				});
			})
		);
	}

	changePasswordForm = this.fb.group ({
		email: [ null ],
		username: [ null ],
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

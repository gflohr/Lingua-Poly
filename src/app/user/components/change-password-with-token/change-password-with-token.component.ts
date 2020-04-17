import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { PasswordValidator } from 'src/app/core/validators/passwordValidator';
import * as fromAuth from '../../../auth/reducers';
import { Store, select } from '@ngrx/store';
import { Observable } from 'rxjs';
import { User, PasswordChange, Token } from 'src/app/core/openapi/lingua-poly';
import { tap } from 'rxjs/operators';
import { UserActions } from '../../../core/actions';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-change-password-with-token',
  templateUrl: './change-password-with-token.component.html',
  styleUrls: ['./change-password-with-token.component.css']
})
export class ChangePasswordWithTokenComponent implements OnInit {
	user$: Observable<User>;

	constructor(
		private route: ActivatedRoute,
		private fb: FormBuilder,
		private authStore: Store<fromAuth.State>,
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

	ngOnInit() {
		const token = this.route.snapshot.paramMap.get('token');
		this.changePasswordForm.patchValue({
			token: token
		});
	}

	changePasswordForm = this.fb.group ({
		email: [ null ],
		username: [ null ],
		password: ['', Validators.required],
		passwordStrength: [ null ],
		password2: ['', Validators.required ],
		token: ['', Validators.required ]
	}, {
		validators:
			[
				PasswordValidator.passwordMatch,
				PasswordValidator.passwordStrength
			]
		}
	);

	onSubmit() {
		const changeSet = {
			password: this.changePasswordForm.get('password').value,
			token: this.changePasswordForm.get('token').value,
		} as PasswordChange;
		this.authStore.dispatch(UserActions.changePassword({ payload: changeSet }));
	}

	get token() { return this.changePasswordForm.get('token'); }
	get password() { return this.changePasswordForm.get('password'); }
	get password2() { return this.changePasswordForm.get('password'); }
}

import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { UserLogin } from '../../../../app/core/openapi/lingua-poly';
import { Store, select } from '@ngrx/store';
import * as fromAuth from '../../reducers';
import { LoginPageActions } from '../../actions';

@Component({
	selector: 'app-login',
	templateUrl: './login.component.html',
	styleUrls: ['./login.component.css']
})
export class LoginComponent {
	pending$ = this.authStore.pipe(select(fromAuth.selectLoginPagePending));
	error$ = this.authStore.pipe(select(fromAuth.selectLoginPageError));

	@Input()
	set pending(isPending: boolean) {
		if (isPending) {
			this.loginForm.disable();
		} else {
			this.loginForm.enable();
		}
	}

	@Input()
	errorMessage: null;

	@Output()
	submitted = new EventEmitter<UserLogin>();

	constructor(
		private fb: FormBuilder,
		private authStore: Store<fromAuth.State>
	) {
	}

	loginForm = this.fb.group({
		id: ['', Validators.required],
		password: ['', Validators.required],
		persistant: [false]
	});

	submit() {
		const userLogin = {
			id: this.loginForm.get('id').value,
			password: this.loginForm.get('password').value,
			persistant: this.loginForm.get('persistant').value
		} as UserLogin;

		this.submitted.emit(userLogin);
		this.authStore.dispatch(LoginPageActions.login({ credentials: userLogin }));
	}
}

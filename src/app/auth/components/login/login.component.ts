import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { UserLogin } from '../../../../app/core/openapi/lingua-poly';
import { Store, select } from '@ngrx/store';
import * as fromAuth from '../../reducers';
import * as fromConfig from '../../../core/reducers';
import { LoginPageActions } from '../../actions';
import { Observable } from 'rxjs';

@Component({
	selector: 'app-login',
	templateUrl: './login.component.html',
	styleUrls: ['./login.component.css']
})
export class LoginComponent {
	pending$ = this.authStore.pipe(select(fromAuth.selectLoginPagePending));
	error$ = this.authStore.pipe(select(fromAuth.selectLoginPageError));
	hasOAuth$: Observable<boolean>;
	hasOAuthFacebook$: Observable<boolean>;
	hasOAuthGoogle$: Observable<boolean>;

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
		private authStore: Store<fromAuth.State>,
		private configStore: Store<fromConfig.State>,
	) {
		this.hasOAuth$ =
			this.configStore.pipe(select(fromConfig.selectHasOAuth));
		this.hasOAuthFacebook$ =
			this.configStore.pipe(select(fromConfig.selectHasOAuthFacebook));
		this.hasOAuthGoogle$ =
			this.configStore.pipe(select(fromConfig.selectHasOAuthGoogle));
	}

	signInWithFacebook(): void {
		this.authStore.dispatch(LoginPageActions.socialLoginRequest(
			{
				provider: 'facebook'
			}
		));


	}

	signInWithGoogle(): void {
		this.authStore.dispatch(LoginPageActions.socialLoginRequest(
			{
				provider: 'google'
			}
		));
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

import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import * as fromAuth from '../../../auth/reducers';
import { Store } from '@ngrx/store';
import { UserActions } from '../../../core/actions';
import { PasswordReset } from '../../../core/openapi/lingua-poly';

@Component({
	selector: 'app-reset-password',
	templateUrl: './reset-password.component.html',
	styleUrls: ['./reset-password.component.css']
})
export class ResetPasswordComponent {
	constructor(
		private fb: FormBuilder,
		private authStore: Store<fromAuth.State>,
	) {}

	resetPasswordForm = this.fb.group({
		id: ['', [ Validators.required ]],
	});

	onSubmit() {
		const request = {
			id: this.resetPasswordForm.get('id').value,
		} as PasswordReset;
		this.authStore.dispatch(UserActions.resetPasswordRequest({ payload: request }));
	}
}

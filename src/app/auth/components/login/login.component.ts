import { Component, Input, Output, EventEmitter } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { UserLogin } from 'src/app/core/openapi/lingua-poly';
import { Store } from '@ngrx/store';
import { AppState } from 'src/app/app.interfaces';

@Component({
	selector: 'app-login',
	templateUrl: './login.component.html',
	styleUrls: ['./login.component.css']
})
export class LoginComponent {
	@Input()
	set pendig(isPending: boolean) {
		if (isPending) {
			this.loginForm.disable();
		} else {
			this.loginForm.enable();
		}
	}

	@Input()
	errorMessage: string | null;

	@Output()
	submitted = new EventEmitter<UserLogin>();

	constructor(
		private fb: FormBuilder,
		private store: Store<AppState>
	) { }

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
	}
}

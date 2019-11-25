import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { UserLogin, UsersService } from 'src/app/core/openapi/lingua-poly';
import { Router } from '@angular/router';
import { Store } from '@ngrx/store';
import { AppState } from 'src/app/app.interfaces';

@Component({
	selector: 'app-login',
	templateUrl: './login.component.html',
	styleUrls: ['./login.component.css']
})
export class LoginComponent {
	failed: boolean = false;

	constructor(
		private fb: FormBuilder,
		private store: Store<AppState>,
		private usersService: UsersService,
		private router: Router
	) { }

	loginForm = this.fb.group({
		id: ['', Validators.required],
		password: ['', Validators.required],
		persistant: [false]
	});

	onSubmit() {
		const user = {
			id: this.loginForm.get('id').value,
			password: this.loginForm.get('password').value,
			persistant: this.loginForm.get('persistant').value
		} as UserLogin;

		this.usersService.userLogin(user).subscribe(
			(user) => {
				console.log('User: ', user);
				this.router.navigate(['/'])
			},
			() => this.failed = true
		);
	}
}

import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { UserLogin, UsersService } from 'src/app/core/openapi/lingua-poly';

@Component({
	selector: 'app-login',
	templateUrl: './login.component.html',
	styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
	failed: boolean = false;

	constructor(
		private fb: FormBuilder,
		private usersService: UsersService
	) { }

	loginForm = this.fb.group({
		id: ['', Validators.required],
		password: ['', Validators.required],
		persistant: [false]
	});

	ngOnInit() {
	}

	onSubmit() {
		console.log('login data: ', this.loginForm);
		const user = {
			id: this.loginForm.get('id').value,
			password: this.loginForm.get('password').value,
			persistant: this.loginForm.get('persistant').value
		} as UserLogin;

		this.usersService.userLogin(user).subscribe(
			(user) => {
				console.log('User: ', user);
				// this.router.navigate(['../registration/received', user.email])
			},
			() => this.failed = true
		);
	}
}

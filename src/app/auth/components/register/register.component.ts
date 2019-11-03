import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';

@Component({
	selector: 'app-register',
	templateUrl: './register.component.html',
	styleUrls: ['./register.component.css']
})
export class RegisterComponent {

	constructor(private fb: FormBuilder) { }

	registerForm = this.fb.group ({
		username: ['', Validators.required],
		email: ['', Validators.required],
		password: ['', Validators.required],
		password2: ['', Validators.required]
	});

	onSubmit() {
		console.log(this.registerForm.value);
	}
}

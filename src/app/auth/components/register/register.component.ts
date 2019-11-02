import { Component } from '@angular/core';
import { FormControl, FormGroup, FormBuilder } from '@angular/forms';

@Component({
	selector: 'app-register',
	templateUrl: './register.component.html',
	styleUrls: ['./register.component.css']
})
export class RegisterComponent {

	constructor(private fb: FormBuilder) { }

	registerForm = this.fb.group ({
		username: [''],
		email: [''],
		password: [''],
		password2: ['']
	});

	onSubmit() {
		console.log(this.registerForm.value);
	}
}

import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';

@Component({
	selector: 'app-register',
	templateUrl: './register.component.html',
	styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {

	registerForm = new FormGroup({
		username: new FormControl(''),
		email: new FormControl(''),
		password: new FormControl(''),
		password2: new FormControl('')
	});

	constructor() { }

	ngOnInit() {
	}

	onSubmit() {
		console.log(this.registerForm.value);
	}
}

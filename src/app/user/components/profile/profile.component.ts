import { Component } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { UsernameValidator } from '../../../core/validators/usernameValidator';

@Component({
	selector: 'app-profile',
	templateUrl: './profile.component.html',
	styleUrls: ['./profile.component.css']
})
export class ProfileComponent {
	constructor(
		private fb: FormBuilder
	) {
	}

	profileForm = this.fb.group({
		username: ['', UsernameValidator],
		homepage: [''],
		description: ['']
	});

	onSubmit() {
		console.log('todo');
	}

	get username() { return this.profileForm.get('username'); }
}

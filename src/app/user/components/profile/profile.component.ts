import { Component } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { UsernameValidator } from 'src/app/core/validators/usernameValidator';
import { UrlValidator } from 'src/app/core/validators/urlValidator';

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
		username: ['', UsernameValidator.username],
		homepage: ['', [UrlValidator.schema, UrlValidator.homepage]],
		description: ['']
	}, {});

	onSubmit() {
		console.log('todo');
	}
}

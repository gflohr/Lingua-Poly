import { Component, Directive, Input } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { UsernameValidator } from 'src/app/core/validators/usernameValidator';
import { UrlValidator } from 'src/app/core/validators/urlValidator';
import { UsernameAvailableValidator } from 'src/app/core/validators/usernameAvailableValidator';

import * as fromAuth from '../../../auth/reducers';
import { Store, select } from '@ngrx/store';
import { Observable } from 'rxjs';

@Component({
	selector: 'app-profile',
	templateUrl: './profile.component.html',
	styleUrls: ['./profile.component.css']
})
export class ProfileComponent {
	username$: Observable<String>;

	constructor(
		private fb: FormBuilder,
		private usernameAvailableValidator: UsernameAvailableValidator,
		private authStore:Store<fromAuth.State>
	) {
		this.username$ = this.authStore.pipe(select(fromAuth.selectUsername));
	}

	profileForm = this.fb.group({
		username: [
			'',
			UsernameValidator.username,
			this.usernameAvailableValidator.validate.bind(this.usernameAvailableValidator)
		],
		homepage: ['', [UrlValidator.schema, UrlValidator.homepage]],
		description: ['']
	}, {});

	onSubmit() {
		console.log('todo');
	}
}
